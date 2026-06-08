import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/assessment_models.dart';
import '../repositories/sync_repository.dart';
import '../services/database_service.dart';
import '../services/auth_service.dart';

// SYNCHRONIZATION STATE
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

// GLOBAL SYNCHRONIZATION PROVIDER
// Manages state and data alignment logic between local Isar DB and remote API
final syncProvider = AsyncNotifierProvider<SyncNotifier, SyncState>(() {
  return SyncNotifier();
});

class SyncNotifier extends AsyncNotifier<SyncState> {
  SyncRepository _repository = SyncRepository();
  final _db = DatabaseService.instance;
  StreamSubscription? _connectivitySubscription;

  // Inject simulated repository for integration testing
  set repository(SyncRepository repo) => _repository = repo;

  @override
  Future<SyncState> build() async {
    // INITIALIZATION
    // Monitor network connectivity for automated background sync (production only)
    if (!Platform.environment.containsKey('FLUTTER_TEST')) {
      _connectivitySubscription = Connectivity().onConnectivityChanged.listen((result) {
        if (result.isNotEmpty && result.first != ConnectivityResult.none) {
          syncAll(); // Trigger synchronization upon connectivity restoration
        }
      });
    }


    ref.onDispose(() => _connectivitySubscription?.cancel());

    return SyncState(status: SyncStatus.idle);
  }

  // SELECTIVE PUSH EXECUTION
  // Pre-logout operation to prevent unnecessary data pulls before local clear
  Future<void> pushPendingData() async {
    final current = state.value ?? SyncState(status: SyncStatus.idle);
    if (current.status == SyncStatus.syncing) {
      // Await completion of ongoing synchronization processes
      await Future.delayed(const Duration(seconds: 2));
    }

    state = AsyncData(current.copyWith(status: SyncStatus.syncing));

    try {
      try {
        await ref.read(authServiceProvider).syncPendingPasswordChanges();
      } catch (pwErr) {
        print("Background password sync error: $pwErr");
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
      throw e; // Bubble exception to notify caller UI
    }
  }

  // RESILIENT SYNCHRONIZATION LOGIC
  // Executes bidirectional Push/Pull with Exponential Backoff retry system
  Future<void> syncAll({int attempt = 0, bool forcePullAll = false}) async {
    final current = state.value ?? SyncState(status: SyncStatus.idle);
    if (current.status == SyncStatus.syncing && attempt == 0) return;

    state = AsyncData(current.copyWith(status: SyncStatus.syncing));

    try {
      // STAGE 0: OFFLINE PASSWORD SYNCHRONIZATION
      try {
        await ref.read(authServiceProvider).syncPendingPasswordChanges();
      } catch (pwErr) {
        print("Background password sync error: $pwErr");
      }

      // STAGE 1: OUTGOING DATA (PUSH)
      final dirtyAssessments = await _db.getDirtyAssessments();
      for (var facility in dirtyAssessments) {
        final remoteId = await _repository.pushAssessment(facility);
        if (remoteId != null) {
          facility.remoteId = remoteId;
          facility.isDirty = false;
          facility.lastSyncedAt = DateTime.now().toUtc();
          await _db.saveFromSync(facility);
        } else if (attempt < 3) {
          // Trigger retry on transmission failure
          throw Exception("Network failure during push");
        }
      }

      // STAGE 2: INCOMING DATA (PULL)
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
      // EXPONENTIAL BACKOFF RETRY HANDLER
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

  // CONFLICT RESOLUTION (LAST WRITE WINS)
  // Validate remote record recency before local overwrite
  Future<void> _handleIncomingAssessment(Map<String, dynamic> json) async {
    final remoteId = json['remoteId'] as String;
    final remoteUpdatedAt = DateTime.parse(json['updatedAt']);
    
    final local = await _db.getAssessmentByRemoteId(remoteId);
    
    if (local == null || remoteUpdatedAt.isAfter(local.updatedAt ?? DateTime(0))) {
      // Apply LWW strategy to update local DB on missing or outdated records
      final facility = local ?? FacilityLayout(
        facilityName: json['facilityName'] ?? 'Remote Facility',
        emergencyType: EmergencyType.values.firstWhere(
          (e) => e.name == json['emergencyType'],
          orElse: () => EmergencyType.mpox,
        ),
      );
      
      facility.remoteId = remoteId;
      facility.facilityName = json['facilityName'] ?? facility.facilityName;
      facility.dateCreated = json['dateCreated'] != null ? DateTime.tryParse(json['dateCreated']) : facility.dateCreated;
      facility.updatedAt = remoteUpdatedAt;
      facility.isDirty = false;
      facility.lastSyncedAt = DateTime.now().toUtc();
      
      if (json['mapImagePath'] != null) {
        facility.mapImagePath = json['mapImagePath'];
      }
      if (json['generalInfo'] != null) {
        final g = json['generalInfo'];
        facility.generalInfo ??= GeneralFacilityInfo();
        facility.generalInfo!.facilityLocationRecord = g['facilityLocationRecord'];
        facility.generalInfo!.facilityAddressOrGps = g['facilityAddressOrGps'];
        facility.generalInfo!.country = g['country'];
        facility.generalInfo!.city = g['city'];
        facility.generalInfo!.assessedDisease = g['assessedDisease'];
        facility.generalInfo!.assessedFacilityType = g['assessedFacilityType'];
      }
      if (json['zones'] != null) {
        final zonesList = json['zones'] as List;
        facility.zones = zonesList.map((z) {
          final c = z['coordinates'] ?? {};
          final t = z['touchArea'] ?? {};
          return SpatialZone(
            id: z['id'] ?? '',
            name: z['name'] ?? '',
            coordinates: MapCoordinates(
              top: (c['top'] ?? 0).toDouble(),
              left: (c['left'] ?? 0).toDouble(),
              width: (c['width'] ?? 0).toDouble(),
              height: (c['height'] ?? 0).toDouble(),
            ),
            touchArea: MapCoordinates(
              top: (t['top'] ?? 0).toDouble(),
              left: (t['left'] ?? 0).toDouble(),
              width: (t['width'] ?? 0).toDouble(),
              height: (t['height'] ?? 0).toDouble(),
            ),
            checklist: (z['checklist'] as List?)?.map((q) {
              return AssessmentQuestion(
                id: q['id'] ?? '',
                text: q['text'] ?? '',
                category: AssessmentCategory.values.firstWhere((e) => e.name == q['category'], orElse: () => AssessmentCategory.infectionPreventionControl),
                recommendationText: q['recommendationText'] ?? '',
                selectedCompliance: ComplianceLevel.values.firstWhere((e) => e.name == q['selectedCompliance'], orElse: () => ComplianceLevel.pending),
                mediaPaths: (q['mediaPaths'] as List?)?.cast<String>(),
                note: q['note'],
              );
            }).toList() ?? [],
          );
        }).toList();
      }
      
      await _db.saveFromSync(facility);
    }
  }
}
