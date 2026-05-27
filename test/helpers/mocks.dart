import 'package:mocktail/mocktail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:assessment_tool/services/auth_service.dart';
import 'package:assessment_tool/repositories/sync_repository.dart';

// --- MOCK DEFINITIONS ---

class MockAuthService extends Mock implements AuthService {}

class MockSyncRepository extends Mock implements SyncRepository {}

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUser extends Mock implements User {}

class MockUserCredential extends Mock implements UserCredential {}

// --- FALLBACK CONFIGURATION ---
// Usa questo metodo in un setUpAll() se mocktail ha bisogno di registrare fallback 
// per tipi personalizzati usati con 'any()'.
void registerFallbackValues() {
  // Esempio: registerFallbackValue(DummyFacility());
}
