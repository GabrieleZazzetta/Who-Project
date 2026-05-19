import 'package:flutter_test/flutter_test.dart';
import 'package:assessment_tool/models/user_model.dart';
import 'package:assessment_tool/models/local_user_credential.dart';

void main() {
  group('UserSession & LocalUserCredential Unit Tests', () {
    group('UserSession Tests', () {
      test('should initialize UserSession with correct default values', () {
        final session = UserSession();
        expect(session.id, isNotNull);
        expect(session.uid, isNull);
        expect(session.email, isNull);
        expect(session.displayName, isNull);
        expect(session.lastLogin, isNull);
        expect(session.isLoggedIn, isFalse);
        expect(session.isWhoStaff, isFalse);
      });

      test('should allow setting and modifying all UserSession properties', () {
        final session = UserSession();
        final now = DateTime.now().toUtc();

        session.uid = 'firebase_uid_123';
        session.email = 'staff@who.int';
        session.displayName = 'Dr. Tedros';
        session.lastLogin = now;
        session.isLoggedIn = true;
        session.isWhoStaff = true;

        expect(session.uid, equals('firebase_uid_123'));
        expect(session.email, equals('staff@who.int'));
        expect(session.displayName, equals('Dr. Tedros'));
        expect(session.lastLogin, equals(now));
        expect(session.isLoggedIn, isTrue);
        expect(session.isWhoStaff, isTrue);
      });
    });

    group('LocalUserCredential Tests', () {
      test('should initialize LocalUserCredential with correct default values', () {
        final cred = LocalUserCredential();
        expect(cred.id, isNotNull);
        expect(cred.email, isNull);
        expect(cred.displayName, isNull);
        expect(cred.dateOfBirth, isNull);
        expect(cred.passwordHash, isNull);
        expect(cred.pendingPassword, isNull);
        expect(cred.oldPassword, isNull);
        expect(cred.passwordNeedsSync, isFalse);
        expect(cred.isWhoStaff, isFalse);
      });

      test('should allow setting and modifying all LocalUserCredential properties', () {
        final cred = LocalUserCredential();
        final dob = DateTime(1980, 5, 12);

        cred.email = 'partner@domain.com';
        cred.displayName = 'John Partner';
        cred.dateOfBirth = dob;
        cred.passwordHash = 'hashed_sha256_representation';
        cred.pendingPassword = 'pending_plain_password';
        cred.oldPassword = 'old_plain_password';
        cred.passwordNeedsSync = true;
        cred.isWhoStaff = false;

        expect(cred.email, equals('partner@domain.com'));
        expect(cred.displayName, equals('John Partner'));
        expect(cred.dateOfBirth, equals(dob));
        expect(cred.passwordHash, equals('hashed_sha256_representation'));
        expect(cred.pendingPassword, equals('pending_plain_password'));
        expect(cred.oldPassword, equals('old_plain_password'));
        expect(cred.passwordNeedsSync, isTrue);
        expect(cred.isWhoStaff, isFalse);
      });

      test('should allow setting password sync flags and roles independently', () {
        final cred = LocalUserCredential();
        cred.isWhoStaff = true;
        cred.passwordNeedsSync = false;

        expect(cred.isWhoStaff, isTrue);
        expect(cred.passwordNeedsSync, isFalse);

        cred.passwordNeedsSync = true;
        expect(cred.passwordNeedsSync, isTrue);
      });
    });
  });
}
