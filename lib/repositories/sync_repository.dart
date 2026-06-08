import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/assessment_models.dart';
import '../main.dart'; // Importa isFirebaseInitialized

// REMOTE SYNCHRONIZATION REPOSITORY (FIREBASE)
// Manages data alignment between local Isar storage and Cloud Firestore

class SyncRepository {
  final FirebaseFirestore? _firestoreInstance;
  final FirebaseStorage? _storageInstance;
  final FirebaseAuth? _authInstance;

  SyncRepository({
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
    FirebaseAuth? auth,
  })  : _firestoreInstance = firestore,
        _storageInstance = storage,
        _authInstance = auth;

  // FIRESTORE INSTANCE MANAGEMENT
  // Prevents fatal exceptions on devices lacking Google Mobile Services (GMS)
  FirebaseFirestore? get _firestore {
    if (_firestoreInstance != null) return _firestoreInstance;
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
  
  FirebaseStorage? get _storage {
    if (_storageInstance != null) return _storageInstance;
    if (isFirebaseInitialized) {
      try {
        return FirebaseStorage.instance;
      } catch (e) {
        return null;
      }
    }
    return null;
  }
  
  FirebaseAuth get _auth {
    return _authInstance ?? FirebaseAuth.instance;
  }

  
  static const String _collectionName = 'assessments';

  // OUTGOING SYNCHRONIZATION (PUSH)
  // Upserts document to Firestore and returns the generated remote identifier
  Future<String?> pushAssessment(FacilityLayout facility) async {
    final firestore = _firestore;
    if (firestore == null) {
      print("Firebase Push Aborted: Firebase not initialized. Using local only.");
      return null;
    }

    try {
      // Provision remote identifier if absent for Storage association
      facility.remoteId ??= firestore.collection(_collectionName).doc().id;

      // Upload local media assets to Firebase Storage
      await _uploadLocalImages(facility);

      // Serialize updated FacilityLayout to Firestore-compatible Map
      final data = _facilityToMap(facility);

      // Persist document to Firestore using assigned identifier
      await firestore
          .collection(_collectionName)
          .doc(facility.remoteId)
          .set(data, SetOptions(merge: true));
          
      return facility.remoteId;
    } catch (e) {
      print("Firebase Push Error: $e");
      return null;
    }
  }

  // MEDIA UPLOAD LOGIC
  // Scans for local paths, uploads to Storage, and replaces with remote URLs
  Future<void> _uploadLocalImages(FacilityLayout facility) async {
    if (!isFirebaseInitialized && _storageInstance == null) return;
    
    try {
      final storage = _storage;
      if (storage == null) return;
      final remoteId = facility.remoteId!;
      
      for (var zone in facility.zones) {
        for (var question in zone.checklist) {
          if (question.mediaPaths != null && question.mediaPaths!.isNotEmpty) {
            List<String> updatedPaths = [];
            
            for (var path in question.mediaPaths!) {
              if (path.startsWith('http')) {
                // Skip existing remote URL
                updatedPaths.add(path);
              } else {
                try {
                  final file = File(path);
                  if (await file.exists()) {
                    final fileName = path.split('/').last;
                    final timestamp = DateTime.now().millisecondsSinceEpoch;
                    final ref = storage.ref().child('assessments/$remoteId/images/${timestamp}_$fileName');
                    
                    final uploadTask = await ref.putFile(file);
                    final downloadUrl = await uploadTask.ref.getDownloadURL();
                    updatedPaths.add(downloadUrl);
                  } else {
                    print("Local file not found, skipping upload: $path");
                  }
                } catch (e) {
                  print("Failed to upload image $path: $e");
                  updatedPaths.add(path); // Retain original path on upload failure
                }
              }
            }
            question.mediaPaths = updatedPaths;
          }
        }
      }
    } catch (e) {
      print("Firebase Storage error: $e");
    }
  }

  // INCOMING SYNCHRONIZATION (PULL)
  // Retrieves modified records since last synchronization timestamp
  Future<List<Map<String, dynamic>>> pullAssessments(DateTime? lastSync) async {
    final firestore = _firestore;
    if (firestore == null) {
      print("Firebase Pull Aborted: Firebase not initialized. Using local only.");
      return [];
    }

    try {
      Query query = firestore.collection(_collectionName);
      
      final uid = _auth.currentUser?.uid;
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
        
        // Convert native Firestore Timestamps to ISO8601 strings
        // Ensures parsing compatibility with SyncService
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

  // FIRESTORE SERIALIZATION
  // Converts FacilityLayout entity to Firestore-compatible payload
  Map<String, dynamic> _facilityToMap(FacilityLayout facility) {
    final uid = _auth.currentUser?.uid ?? 'unknown';
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
