import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../models/assessment_models.dart';
import '../models/user_model.dart';
import '../models/local_user_credential.dart';

// DATABASE SERVICE
// Singleton managing Isar lifecycle and assessment CRUD operations

class DatabaseService {
  static final DatabaseService instance = DatabaseService._internal();
  DatabaseService._internal();

  late Isar _isar;
  bool _isInitialized = false;

  // INITIALIZATION
  Future<void> init() async {
    if (_isInitialized) return;

    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open(
      [FacilityLayoutSchema, UserSessionSchema, LocalUserCredentialSchema],
      directory: dir.path,
    );
    _isInitialized = true;
  }

  // Inject in-memory Isar instance for testing purposes
  void setTestIsar(Isar testIsar) {
    _isar = testIsar;
    _isInitialized = true;
  }

  // CRUD OPERATIONS

  // Isar overwrites on ID match
  // Zone list cloning required to enforce embedded object modification detection
  Future<Id> saveAssessment(FacilityLayout facility) async {
    facility.dateCreated ??= DateTime.now().toUtc();
    facility.zones = List.from(facility.zones);
    
    // DIRTY FLAG LOGIC
    // Mark local saves as pending synchronization
    facility.isDirty = true;
    facility.updatedAt = DateTime.now().toUtc();

    return await _isar.writeTxn(() async {
      final newId = await _isar.facilityLayouts.put(facility);
      facility.id = newId;
      return newId;
    });
  }

  // Direct persist without dirty flag allocation
  Future<void> saveFromSync(FacilityLayout facility) async {
    await _isar.writeTxn(() async {
      await _isar.facilityLayouts.put(facility);
    });
  }

  Future<List<FacilityLayout>> getAllAssessments() async {
    return await _isar.facilityLayouts.where().findAll();
  }

  // Retrieve all records with pending local modifications
  Future<List<FacilityLayout>> getDirtyAssessments() async {
    return await _isar.facilityLayouts.filter().isDirtyEqualTo(true).findAll();
  }

  Future<FacilityLayout?> getAssessmentById(Id id) async {
    return await _isar.facilityLayouts.get(id);
  }

  Future<FacilityLayout?> getAssessmentByRemoteId(String remoteId) async {
    return await _isar.facilityLayouts.filter().remoteIdEqualTo(remoteId).findFirst();
  }

  Future<void> deleteAssessment(Id id) async {
    await _isar.writeTxn(() async {
      await _isar.facilityLayouts.delete(id);
    });
  }

  // SESSION MANAGEMENT

  Future<void> saveSession(UserSession session) async {
    await _isar.writeTxn(() async {
      await _isar.userSessions.put(session);
    });
  }

  Future<UserSession?> getCurrentSession() async {
    return await _isar.userSessions.filter().isLoggedInEqualTo(true).findFirst();
  }

  Future<void> clearSession() async {
    await _isar.writeTxn(() async {
      await _isar.userSessions.clear();
    });
  }

  Future<void> clearAllLocalData() async {
    await _isar.writeTxn(() async {
      await _isar.facilityLayouts.clear();
      await _isar.userSessions.clear();
      // Preserve localUserCredentials to maintain offline capabilities
    });
  }

  // LOCAL USER CREDENTIALS (Offline Password Recovery)

  Future<void> saveLocalCredential(LocalUserCredential credential) async {
    if (credential.email != null) {
      credential.email = credential.email!.toLowerCase().trim();
    }
    await _isar.writeTxn(() async {
      await _isar.localUserCredentials.put(credential);
    });
  }

  Future<LocalUserCredential?> getLocalCredential(String email) async {
    return await _isar.localUserCredentials
        .filter()
        .emailEqualTo(email.toLowerCase().trim())
        .findFirst();
  }

  Future<List<LocalUserCredential>> getPendingPasswordSyncs() async {
    return await _isar.localUserCredentials
        .filter()
        .passwordNeedsSyncEqualTo(true)
        .findAll();
  }
}