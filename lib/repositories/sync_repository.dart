import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/assessment_models.dart';
import '../main.dart'; // Importa isFirebaseInitialized

// REPOSITORY DI SINCRONIZZAZIONE (FIREBASE)
// Gestisce l'allineamento dei dati tra Isar (locale) e Cloud Firestore (remoto).

class SyncRepository {
  // GESTIONE SICURA ISTANZA FIRESTORE
  // Evita eccezioni letali (e disconnessioni del device) se Firebase non si è inizializzato a causa di errori GMS
  FirebaseFirestore? get _firestore {
    if (isFirebaseInitialized) {
      try {
        return FirebaseFirestore.instance;
      } catch (e) {
        print("FirebaseFirestore.instance failed: $e");
        return null;
      }
    }
    return null;
  }

  
  static const String _collectionName = 'assessments';

  // INVIO DATI A CLOUD FIRESTORE (PUSH)
  // Crea o aggiorna un documento su Firestore. Ritorna l'ID remoto.
  Future<String?> pushAssessment(FacilityLayout facility) async {
    final firestore = _firestore;
    if (firestore == null) {
      print("Firebase Push Aborted: Firebase not initialized. Using local only.");
      return null;
    }

    try {
      final data = _facilityToMap(facility);

      
      if (facility.remoteId != null) {
        // Aggiorna record esistente
        await firestore
            .collection(_collectionName)
            .doc(facility.remoteId)
            .set(data, SetOptions(merge: true));
        return facility.remoteId;
      } else {
        // Crea nuovo record
        final docRef = await firestore.collection(_collectionName).add(data);
        return docRef.id;
      }

    } catch (e) {
      print("Firebase Push Error: $e");
      return null;
    }
  }

  // DOWNLOAD DATI DA CLOUD FIRESTORE (PULL)
  // Recupera record modificati dall'ultima sincronizzazione.
  Future<List<Map<String, dynamic>>> pullAssessments(DateTime? lastSync) async {
    final firestore = _firestore;
    if (firestore == null) {
      print("Firebase Pull Aborted: Firebase not initialized. Using local only.");
      return [];
    }

    try {
      Query query = firestore.collection(_collectionName);
      
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
        query = query.where('ownerId', isEqualTo: uid);
      }
      
      if (lastSync != null) {
        query = query.where('updatedAt', isGreaterThan: Timestamp.fromDate(lastSync));
      }
      
      final snapshot = await query.get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['remoteId'] = doc.id;
        
        // Convertiamo i Timestamp nativi di Firestore in stringhe ISO8601 
        // per compatibilità con il parsing nel SyncService
        if (data['updatedAt'] is Timestamp) {
          data['updatedAt'] = (data['updatedAt'] as Timestamp).toDate().toUtc().toIso8601String();
        }
        if (data['dateCreated'] is Timestamp) {
          data['dateCreated'] = (data['dateCreated'] as Timestamp).toDate().toUtc().toIso8601String();
        }
        
        return data;
      }).toList();
    } catch (e) {
      print("Firebase Pull Error: $e");
      return [];
    }
  }

  // MAPPATURA PER FIRESTORE
  // Converte l'oggetto FacilityLayout in un formato compatibile con Firestore.
  Map<String, dynamic> _facilityToMap(FacilityLayout facility) {
    final uid = FirebaseAuth.instance.currentUser?.uid ?? 'unknown';
    return {
      'ownerId': uid,
      'facilityName': facility.facilityName,
      'emergencyType': facility.emergencyType.name,
      'updatedAt': Timestamp.fromDate(facility.updatedAt ?? DateTime.now().toUtc()),
      'dateCreated': Timestamp.fromDate(facility.dateCreated ?? DateTime.now().toUtc()),
      'zonesCount': facility.zones.length,
      'readinessScore': facility.globalReadinessScore,
      'mapImagePath': facility.mapImagePath,
      'generalInfo': facility.generalInfo != null ? {
        'facilityLocationRecord': facility.generalInfo!.facilityLocationRecord,
        'facilityAddressOrGps': facility.generalInfo!.facilityAddressOrGps,
        'country': facility.generalInfo!.country,
        'city': facility.generalInfo!.city,
        'assessedDisease': facility.generalInfo!.assessedDisease,
        'assessedFacilityType': facility.generalInfo!.assessedFacilityType,
      } : null,
      'zones': facility.zones.map((z) => {
        'id': z.id,
        'name': z.name,
        'coordinates': {
          'top': z.coordinates.top, 'left': z.coordinates.left,
          'width': z.coordinates.width, 'height': z.coordinates.height
        },
        'touchArea': {
          'top': z.touchArea.top, 'left': z.touchArea.left,
          'width': z.touchArea.width, 'height': z.touchArea.height
        },
        'checklist': z.checklist.map((q) => {
          'id': q.id,
          'text': q.text,
          'category': q.category.name,
          'recommendationText': q.recommendationText,
          'selectedCompliance': q.selectedCompliance.name,
          'mediaPaths': q.mediaPaths,
          'note': q.note,
        }).toList()
      }).toList(),
    };
  }
}
