import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../models/assessment_models.dart';

// SERVIZIO DATABASE
// Singleton che gestisce il ciclo di vita di Isar e le operazioni CRUD sugli assessment

class DatabaseService {
  static final DatabaseService instance = DatabaseService._internal();
  DatabaseService._internal();

  late Isar _isar;
  bool _isInitialized = false;

  // Inizializzazione
  Future<void> init() async {
    if (_isInitialized) return;

    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open(
      [FacilityLayoutSchema],
      directory: dir.path,
    );
    _isInitialized = true;
  }

  // OPERAZIONI CRUD

  // Isar sovrascrive automaticamente se l'ID esiste, clone della lista zones
  // necessario per forzare la rilevazione delle modifiche agli oggetti embedded
  Future<Id> saveAssessment(FacilityLayout facility) async {
    facility.dateCreated ??= DateTime.now();
    facility.zones = List.from(facility.zones);

    return await _isar.writeTxn(() async {
      final newId = await _isar.facilityLayouts.put(facility);
      facility.id = newId;
      return newId;
    });
  }

  Future<List<FacilityLayout>> getAllAssessments() async {
    return await _isar.facilityLayouts.where().findAll();
  }

  Future<FacilityLayout?> getAssessmentById(Id id) async {
    return await _isar.facilityLayouts.get(id);
  }

  Future<void> deleteAssessment(Id id) async {
    await _isar.writeTxn(() async {
      await _isar.facilityLayouts.delete(id);
    });
  }
}