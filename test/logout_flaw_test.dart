import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:assessment_tool/models/assessment_models.dart';
import 'package:assessment_tool/models/user_model.dart';
import 'package:assessment_tool/models/local_user_credential.dart';
import 'package:assessment_tool/services/database_service.dart';

void main() {
  test('clearAllLocalData wipes LocalUserCredential breaking offline login', () async {
    await Isar.initializeIsarCore(download: true);
    final isar = await Isar.open(
      [FacilityLayoutSchema, UserSessionSchema, LocalUserCredentialSchema],
      directory: '',
    );
    
    DatabaseService.instance.setTestIsar(isar);

    // 1. Create a local user credential
    final cred = LocalUserCredential()
      ..email = 'test@who.int'
      ..passwordHash = 'hash123'
      ..displayName = 'Test User';
    
    await DatabaseService.instance.saveLocalCredential(cred);
    
    // Verify it exists
    var savedCred = await DatabaseService.instance.getLocalCredential('test@who.int');
    expect(savedCred, isNotNull);

    // 2. Call clearAllLocalData (simulating logout)
    await DatabaseService.instance.clearAllLocalData();

    // 3. Verify if credential still exists
    savedCred = await DatabaseService.instance.getLocalCredential('test@who.int');
    
    // We expect it to be NOT null because we fixed clearAllLocalData to preserve credentials
    expect(savedCred, isNotNull, reason: "LocalUserCredential was preserved, offline login works!");
    
    await isar.close(deleteFromDisk: true);
  });
}
