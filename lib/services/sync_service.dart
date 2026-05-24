import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/assessment_models.dart';
import '../repositories/sync_repository.dart';
import '../services/database_service.dart';
import '../services/auth_service.dart';

// STATO DELLA SINCRONIZZAZIONE
enum SyncStatus { idle, syncing, success, error }

class SyncState {
  final SyncStatus status;
  final DateTime? lastSyncedAt;
  final String? errorMessage;

  SyncState({
    required this.status,
    this.lastSyncedAt,
    this.errorMessage,
  });

  SyncState copyWith({
    SyncStatus? status,
    DateTime? lastSyncedAt,
    String? errorMessage,
  }) {
    return SyncState(
      status: status ?? this.status,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

// PROVIDER GLOBALE DI SINCRONIZZAZIONE
// Gestisce lo stato e la logica di allineamento dati tra Isar e l'API remota.
final syncProvider = AsyncNotifierProvider<SyncNotifier, SyncState>(() {
  return SyncNotifier();
});

class SyncNotifier extends AsyncNotifier<SyncState> {
  SyncRepository _repository = SyncRepository();
  final _db = DatabaseService.instance;
  StreamSubscription? _connectivitySubscription;

  // Consente di iniettare un repository simulato nei test di integrazione
  set repository(SyncRepository repo) => _repository = repo;

  @override
  Future<SyncState> build() async {
    // Inizializzazione: monitoraggio della connettività per sync automatica (solo in produzione)
    if (!Platform.environment.containsKey('FLUTTER_TEST')) {
      _connectivitySubscription = Connectivity().onConnectivityChanged.listen((result) {
        if (result.isNotEmpty && result.first != ConnectivityResult.none) {
          syncAll(); // Tenta la sincronizzazione quando torna il segnale
        }
      });
    }


    ref.onDispose(() => _connectivitySubscription?.cancel());

    return SyncState(status: SyncStatus.idle);
  }

  // PUSH SELETTIVO (Usato prima del logout per evitare pull di dati che verranno subito cancellati)
  Future<void> pushPendingData() async {
    final current = state.value ?? SyncState(status: SyncStatus.idle);
    if (current.status == SyncStatus.syncing) {
      // Se c'è già una sync in corso, attendiamo un istante per permetterle di finire
      await Future.delayed(const Duration(seconds: 2));
    }

    state = AsyncData(current.copyWith(status: SyncStatus.syncing));

    try {
      try {
        await ref.read(authServiceProvider).syncPendingPasswordChanges();
      } catch (pwErr) {
        print("Errore sync password in background: $pwErr");
      }

      final dirtyAssessments = await _db.getDirtyAssessments();
      for (var facility in dirtyAssessments) {
        final remoteId = await _repository.pushAssessment(facility);
        if (remoteId != null) {
          facility.remoteId = remoteId;
          facility.isDirty = false;
          facility.lastSyncedAt = DateTime.now().toUtc();
          await _db.saveFromSync(facility);
        } else {
          throw Exception("Network failure during push");
        }
      }

      state = AsyncData(SyncState(
        status: SyncStatus.success,
        lastSyncedAt: DateTime.now().toUtc(),
      ));
    } catch (e) {
      state = AsyncData(state.value!.copyWith(
        status: SyncStatus.error,
        errorMessage: "Sync failed. Please check connection.",
      ));
      throw e; // Rilancia per notificare il chiamante (es. SettingsScreen)
    }
  }

  // LOGICA DI SINCRONIZZAZIONE GLOBALE CON RESILIENZA
  // Esegue Push e Pull con sistema di retry automatico (Exponential Backoff)
  Future<void> syncAll({int attempt = 0, bool forcePullAll = false}) async {
    final current = state.value ?? SyncState(status: SyncStatus.idle);
    if (current.status == SyncStatus.syncing && attempt == 0) return;

    state = AsyncData(current.copyWith(status: SyncStatus.syncing));

    try {
      // 0. SYNC PENDING PASSWORDS (OFFLINE RESETS)
      try {
        await ref.read(authServiceProvider).syncPendingPasswordChanges();
      } catch (pwErr) {
        print("Errore sync password in background: $pwErr");
      }

      // 1. OUTGOING SYNC (PUSH)
      final dirtyAssessments = await _db.getDirtyAssessments();
      for (var facility in dirtyAssessments) {
        final remoteId = await _repository.pushAssessment(facility);
        if (remoteId != null) {
          facility.remoteId = remoteId;
          facility.isDirty = false;
          facility.lastSyncedAt = DateTime.now().toUtc();
          await _db.saveFromSync(facility);
        } else if (attempt < 3) {
          // Innesca retry se fallisce l'invio
          throw Exception("Network failure during push");
        }
      }

      // 2. INCOMING SYNC (PULL)
      final lastSync = forcePullAll ? null : state.value?.lastSyncedAt;
      final remoteData = await _repository.pullAssessments(lastSync);
      
      for (var json in remoteData) {
        await _handleIncomingAssessment(json);
      }

      state = AsyncData(SyncState(
        status: SyncStatus.success,
        lastSyncedAt: DateTime.now().toUtc(),
      ));
    } catch (e) {
      // GESTIONE RETRY CON EXPONENTIAL BACKOFF
      if (attempt < 3) {
        final delay = Platform.environment.containsKey('FLUTTER_TEST')
            ? const Duration(milliseconds: 1)
            : Duration(seconds: pow(2, attempt).toInt() * 2);
        Future.delayed(delay, () => syncAll(attempt: attempt + 1, forcePullAll: forcePullAll));
      } else {

        state = AsyncData(state.value!.copyWith(
          status: SyncStatus.error,
          errorMessage: "Sync failed after multiple attempts. Please check connection.",
        ));
      }
    }
  }

  // GESTIONE CONFLITTI (LAST WRITE WINS)
  // Verifica se il record remoto è più recente di quello locale prima di sovrascrivere
  Future<void> _handleIncomingAssessment(Map<String, dynamic> json) async {
    final remoteId = json['remoteId'] as String;
    final remoteUpdatedAt = DateTime.parse(json['updatedAt']);
    
    final local = await _db.getAssessmentByRemoteId(remoteId);
    
    if (local == null || remoteUpdatedAt.isAfter(local.updatedAt ?? DateTime(0))) {
      // Se il record non esiste o il remoto è più recente, aggiorna il database locale (LWW)
      final facility = local ?? FacilityLayout(
        facilityName: json['facilityName'] ?? 'Remote Facility',
        emergencyType: EmergencyType.values.firstWhere(
          (e) => e.name == json['emergencyType'],
          orElse: () => EmergencyType.mpox,
        ),
      );
      
      facility.remoteId = remoteId;
      facility.facilityName = json['facilityName'] ?? facility.facilityName;
      facility.updatedAt = remoteUpdatedAt;
      facility.isDirty = false;
      facility.lastSyncedAt = DateTime.now().toUtc();
      
      await _db.saveFromSync(facility);
    }
  }
}
