import 'package:isar/isar.dart';

part 'user_model.g.dart';

@Collection()
class UserSession {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  String? uid; // Firebase UID

  String? email;
  String? displayName;
  
  // Informazioni di sessione
  DateTime? lastLogin;
  bool isLoggedIn = false;

  // Ruoli o permessi (opzionale)
  bool isWhoStaff = false;
}
