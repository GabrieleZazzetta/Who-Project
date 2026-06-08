import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import '../models/user_model.dart';
import '../models/local_user_credential.dart';
import 'database_service.dart';

final authServiceProvider = Provider((ref) => AuthService());

class AuthService {
  final FirebaseAuth _auth;
  final DatabaseService _db;

  AuthService({FirebaseAuth? auth, DatabaseService? db})
      : _auth = auth ?? FirebaseAuth.instance,
        _db = db ?? DatabaseService.instance;

  // Firebase authentication state stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Current authenticated user
  User? get currentUser => _auth.currentUser;

  // REGISTRATION LOGIC
  Future<UserCredential?> register(String email, String password, {bool isWhoStaff = false, String? displayName}) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      
      if (credential.user != null) {
        // Update remote user profile asynchronously
        if (displayName != null) {
          credential.user!.updateDisplayName(displayName);
        }
        
        // Persist local session immediately with confirmed registration data
        await _db.saveSession(UserSession()
          ..uid = credential.user!.uid
          ..email = email
          ..displayName = displayName
          ..isLoggedIn = true
          ..isWhoStaff = isWhoStaff
          ..lastLogin = DateTime.now().toUtc()
        );
      }
      return credential;
    } catch (e) {
      rethrow;
    }
  }

  // AUTHENTICATION LOGIC
  Future<UserCredential?> login(String email, String password) async {
    final cleanEmail = email.toLowerCase().trim();
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: cleanEmail, 
        password: password
      ).timeout(const Duration(seconds: 8));
      
      if (credential.user != null) {
        // Determine staff status based on email domain
        bool isWho = cleanEmail.endsWith("@who.int");
        
        // Persist local session
        await _db.saveSession(UserSession()
          ..uid = credential.user!.uid
          ..email = cleanEmail
          ..displayName = credential.user!.displayName
          ..isLoggedIn = true
          ..isWhoStaff = isWho
          ..lastLogin = DateTime.now().toUtc()
        );
      }
      return credential;
    } catch (e) {
      // OFFLINE AUTHENTICATION FALLBACK
      // Attempt secure local authentication when remote connection fails
      final LocalUserCredential? localCred = await _db.getLocalCredential(cleanEmail);
      if (localCred != null) {
        final bytes = utf8.encode(password);
        final inputHash = sha256.convert(bytes).toString();
        
        if (localCred.passwordHash == inputHash) {
          // Provision offline session on password match
          await _db.saveSession(UserSession()
            ..uid = "local_${localCred.id}"
            ..email = cleanEmail
            ..displayName = localCred.displayName
            ..isLoggedIn = true
            ..isWhoStaff = localCred.isWhoStaff
            ..lastLogin = DateTime.now().toUtc()
          );
          return null; // Return null to indicate offline success
        }
      }
      rethrow;
    }
  }

  // LOGOUT LOGIC
  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      // Ensure local data cleanup regardless of remote logout success
    } finally {
      await _db.clearAllLocalData();
    }
  }

  // OFFLINE PASSWORD SYNC
  Future<void> syncPendingPasswordChanges() async {
    final pendingSyncs = await _db.getPendingPasswordSyncs();
    if (pendingSyncs.isEmpty) return;

    for (var cred in pendingSyncs) {
      if (cred.pendingPassword == null || cred.email == null) continue;
      
      try {
        // Handle scenario 1: Remote user is actively authenticated
        if (currentUser != null && currentUser!.email?.toLowerCase() == cred.email!.toLowerCase()) {
          await currentUser!.updatePassword(cred.pendingPassword!);
        } else {
          // Handle scenario 2: Remote session expired or unavailable
          // Attempt authentication with pending password
          try {
            await _auth.signInWithEmailAndPassword(
              email: cred.email!,
              password: cred.pendingPassword!,
            );
          } on FirebaseAuthException catch (e) {
            if (e.code == 'wrong-password' && cred.oldPassword != null) {
              // Attempt fallback authentication with previous password
              await _auth.signInWithEmailAndPassword(
                email: cred.email!,
                password: cred.oldPassword!,
              );
              // Apply pending password update
              await _auth.currentUser!.updatePassword(cred.pendingPassword!);
            } else {
              rethrow;
            }
          }
        }

        // Cleanup sensitive temporary credentials upon successful sync
        cred.passwordNeedsSync = false;
        cred.pendingPassword = null;
        cred.oldPassword = null;
        await _db.saveLocalCredential(cred);
        
        debugPrint("Password synchronization successful for: ${cred.email}");
      } catch (e) {
        debugPrint("Error during password synchronization for ${cred.email}: $e");
      }
    }
  }

  // Validate local session for offline mode
  Future<UserSession?> getLocalSession() async {
    return await _db.getCurrentSession();
  }
}
