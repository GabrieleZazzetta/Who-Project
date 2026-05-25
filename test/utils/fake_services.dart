import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:assessment_tool/models/assessment_models.dart';
import 'package:assessment_tool/models/user_model.dart';
import 'package:assessment_tool/services/auth_service.dart';
import 'package:assessment_tool/repositories/sync_repository.dart';

// REPOSITORY SIMULATO PER I TEST
class FakeSyncRepository extends SyncRepository {
  bool failPush = false;
  int pushCount = 0;
  int pullCount = 0;

  final List<Map<String, dynamic>> pulledAssessments = [];
  final List<FacilityLayout> pushedAssessments = [];

  @override
  Future<String?> pushAssessment(FacilityLayout facility) async {
    pushCount++;
    if (failPush) {
      throw Exception('Server unreachable');
    }
    pushedAssessments.add(facility);
    return facility.remoteId ?? 'remote_${facility.id}';
  }

  @override
  Future<List<Map<String, dynamic>>> pullAssessments(DateTime? lastSync) async {
    pullCount++;
    return pulledAssessments;
  }
}

// AUTH SERVICE SIMULATO PER I TEST
class FakeAuthService implements AuthService {
  bool isStaff = true;
  String currentEmail = "test@who.int";
  String currentDisplayName = "Test User";

  @override
  Stream<User?> get authStateChanges => const Stream.empty();

  @override
  User? get currentUser => null;

  @override
  Future<UserCredential?> register(String email, String password, {bool isWhoStaff = false, String? displayName}) async {
    return null;
  }

  @override
  Future<UserCredential?> login(String email, String password) async {
    return null;
  }

  @override
  Future<void> logout() async {}

  @override
  Future<void> syncPendingPasswordChanges() async {}

  @override
  Future<UserSession?> getLocalSession() async {
    final session = UserSession();
    session.email = currentEmail;
    session.isWhoStaff = isStaff;
    session.displayName = currentDisplayName;
    session.lastLogin = DateTime.now();
    return session;
  }
}
