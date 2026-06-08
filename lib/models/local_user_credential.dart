import 'package:isar/isar.dart';

part 'local_user_credential.g.dart';

@Collection()
class LocalUserCredential {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  String? email;

  String? displayName;
  
  DateTime? dateOfBirth;

  // Password hash for secure offline verification
  String? passwordHash;

  // Pending password awaiting Firebase synchronization (cleared post-sync)
  String? pendingPassword;

  // Temporary previous password for re-authentication on expired Firebase session (cleared post-sync)
  String? oldPassword;

  // Synchronization requirement flag
  bool passwordNeedsSync = false;

  bool isWhoStaff = false;
}
