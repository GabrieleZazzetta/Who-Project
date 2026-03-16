import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../models/assessment_models.dart';

class DatabaseService {
  // Pattern Singleton: avremo sempre e solo un'istanza del database aperta
  static final DatabaseService instance = DatabaseService._internal();
  DatabaseService._internal();

  late Isar _isar;
  bool _isInitialized = false;

  // Inizializza il database (lo chiameremo all'avvio dell'app)
  Future<void> init() async {
    if (_isInitialized) return;
    
    // Trova la cartella sicura del telefono dove salvare i dati
    final dir = await getApplicationDocumentsDirectory();
    
    // Apri Isar e passagli lo schema della nostra struttura
    _isar = await Isar.open(
      [FacilityLayoutSchema], 
      directory: dir.path,
    );
    _isInitialized = true;
  }

  // ==========================================
  // OPERAZIONI CRUD (Create, Read, Update, Delete)
  // ==========================================

  // Salva o aggiorna un'intera ispezione (Isar sovrascrive se l'ID esiste già)
  // Salva o aggiorna un'intera ispezione
  Future<Id> saveAssessment(FacilityLayout facility) async {
    facility.dateCreated ??= DateTime.now(); 
    
    // TRUCCO ISAR: Cloniamo le liste per forzare il database a "vedere" 
    // che abbiamo modificato le domande all'interno dei pin!
    facility.zones = List.from(facility.zones);

    return await _isar.writeTxn(() async {
      final newId = await _isar.facilityLayouts.put(facility);
      facility.id = newId; // Assicuriamoci che l'ID in memoria si aggiorni
      return newId;
    });
  }

  // Recupera TUTTE le ispezioni salvate (per la lista principale)
  Future<List<FacilityLayout>> getAllAssessments() async {
    return await _isar.facilityLayouts.where().findAll();
  }

  // Recupera UNA SINGOLA ispezione tramite il suo ID (per la mappa)
  Future<FacilityLayout?> getAssessmentById(Id id) async {
    return await _isar.facilityLayouts.get(id);
  }

  // Cancella un'ispezione
  Future<void> deleteAssessment(Id id) async {
    await _isar.writeTxn(() async {
      await _isar.facilityLayouts.delete(id);
    });
  }
}