import 'package:isar/isar.dart';

part 'local_user_credential.g.dart';

@Collection()
class LocalUserCredential {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  String? email;

  String? displayName;
  
  DateTime? dateOfBirth;

  // Hashing della password per la verifica offline sicura
  String? passwordHash;

  // Nuova password in attesa di sincronizzazione con Firebase (temporanea, azzerata dopo la sync)
  String? pendingPassword;

  // Vecchia password temporanea per re-autenticare in caso di sessione Firebase scaduta (temporanea, azzerata dopo la sync)
  String? oldPassword;

  // Flag che indica se è richiesta la sincronizzazione con Firebase
  bool passwordNeedsSync = false;

  bool isWhoStaff = false;
}
