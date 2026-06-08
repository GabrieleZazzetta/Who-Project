import 'package:isar/isar.dart';

part 'user_model.g.dart';

@Collection()
class UserSession {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  String? uid; // Remote Firebase Identifier

  String? email;
  String? displayName;
  
  // Session metadata
  DateTime? lastLogin;
  bool isLoggedIn = false;

  // Role-based access control flags
  bool isWhoStaff = false;
}
