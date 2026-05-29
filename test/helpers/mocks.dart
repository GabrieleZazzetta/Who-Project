import 'package:mocktail/mocktail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:assessment_tool/services/auth_service.dart';
import 'package:assessment_tool/services/database_service.dart';
import 'package:assessment_tool/models/user_model.dart';
import 'package:assessment_tool/models/local_user_credential.dart';
import 'package:assessment_tool/repositories/sync_repository.dart';
import 'package:assessment_tool/services/sync_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// --- MOCK DEFINITIONS ---

class MockAuthService extends Mock implements AuthService {}

class MockDatabaseService extends Mock implements DatabaseService {}

class MockSyncRepository extends Mock implements SyncRepository {}

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUser extends Mock implements User {}

class MockUserCredential extends Mock implements UserCredential {}

// --- FALLBACK CONFIGURATION ---
// Usa questo metodo in un setUpAll() se mocktail ha bisogno di registrare fallback
// per tipi personalizzati usati con 'any()'.
void registerFallbackValues() {
  registerFallbackValue(UserSession());
  registerFallbackValue(LocalUserCredential());
}

class MockSyncNotifier extends AsyncNotifier<SyncState>
    implements SyncNotifier {
  bool syncAllCalled = false;

  @override
  Future<SyncState> build() async => SyncState(status: SyncStatus.idle);

  @override
  Future<void> syncAll({int attempt = 0, bool forcePullAll = false}) async {
    syncAllCalled = true;
  }

  @override
  Future<void> pushPendingData() async {}

  @override
  set repository(SyncRepository repo) {}
}
