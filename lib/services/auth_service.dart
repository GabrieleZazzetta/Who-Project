import 'package:firebase_auth/firebase_auth.dart';
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

  // Stream per ascoltare i cambiamenti dello stato auth di Firebase
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Utente attuale Firebase
  User? get currentUser => _auth.currentUser;

  // Registrazione
  Future<UserCredential?> register(String email, String password, {bool isWhoStaff = false, String? displayName}) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      
      if (credential.user != null) {
        // Aggiorna il profilo Firebase (opzionale, asincrono)
        if (displayName != null) {
          credential.user!.updateDisplayName(displayName);
        }
        
        // Salva sessione locale in Isar IMMEDIATAMENTE con i dati certi della registrazione
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

  // Login
  Future<UserCredential?> login(String email, String password) async {
    final cleanEmail = email.toLowerCase().trim();
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: cleanEmail, 
        password: password
      ).timeout(const Duration(seconds: 8));
      
      if (credential.user != null) {
        // Determina se è WHO Staff dall'email (come logica attuale nella UI)
        bool isWho = cleanEmail.endsWith("@who.int");
        
        // Salva/Aggiorna sessione locale
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
      // OFFLINE OR FALLBACK LOCAL AUTHENTICATION
      // Se Firebase fallisce per problemi di rete, tentiamo l'accesso locale sicuro
      final LocalUserCredential? localCred = await _db.getLocalCredential(cleanEmail);
      if (localCred != null) {
        final bytes = utf8.encode(password);
        final inputHash = sha256.convert(bytes).toString();
        
        if (localCred.passwordHash == inputHash) {
          // Password locale corretta! Creiamo una sessione offline
          await _db.saveSession(UserSession()
            ..uid = "local_${localCred.id}"
            ..email = cleanEmail
            ..displayName = localCred.displayName
            ..isLoggedIn = true
            ..isWhoStaff = localCred.isWhoStaff
            ..lastLogin = DateTime.now().toUtc()
          );
          return null; // Ritorna null per indicare successo offline
        }
      }
      rethrow;
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      // Anche se il logout firebase fallisce (es. no internet), puliamo locale
    } finally {
      await _db.clearAllLocalData();
    }
  }

  // Sincronizza qualsiasi cambio password effettuato offline
  Future<void> syncPendingPasswordChanges() async {
    final pendingSyncs = await _db.getPendingPasswordSyncs();
    if (pendingSyncs.isEmpty) return;

    for (var cred in pendingSyncs) {
      if (cred.pendingPassword == null || cred.email == null) continue;
      
      try {
        // Scenario 1: Utente Firebase è già loggato e corrisponde
        if (currentUser != null && currentUser!.email?.toLowerCase() == cred.email!.toLowerCase()) {
          await currentUser!.updatePassword(cred.pendingPassword!);
        } else {
          // Scenario 2: Utente Firebase non è loggato o sessione scaduta
          // Proviamo ad autenticare con la nuova password (se fosse già sincronizzata)
          try {
            await _auth.signInWithEmailAndPassword(
              email: cred.email!,
              password: cred.pendingPassword!,
            );
          } on FirebaseAuthException catch (e) {
            if (e.code == 'wrong-password' && cred.oldPassword != null) {
              // Se fallisce per password errata, proviamo con la vecchia password
              await _auth.signInWithEmailAndPassword(
                email: cred.email!,
                password: cred.oldPassword!,
              );
              // Aggiorniamo alla nuova password
              await _auth.currentUser!.updatePassword(cred.pendingPassword!);
            } else {
              rethrow;
            }
          }
        }

        // Sincronizzazione riuscita! Puliamo i dati temporanei in chiaro per sicurezza
        cred.passwordNeedsSync = false;
        cred.pendingPassword = null;
        cred.oldPassword = null;
        await _db.saveLocalCredential(cred);
        
        print("Sincronizzazione password riuscita con successo per: ${cred.email}");
      } catch (e) {
        print("Errore durante la sincronizzazione password per ${cred.email}: $e");
      }
    }
  }

  // Verifica se esiste una sessione valida locale (Offline mode)
  Future<UserSession?> getLocalSession() async {
    return await _db.getCurrentSession();
  }
}
