import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

// Questa riga dirà a Flutter di generare il codice del database
part 'assessment_models.g.dart';

// ==========================================
// 1. ENUMS GLOBALI
// ==========================================

enum EmergencyType { mpox, ebola, sars }

enum FacilityType { 
  screeningAndIsolation, 
  existingFacilityWithWard, 
  standAloneCenter, 
  congregateSetting 
}

enum ComplianceLevel { meetsTarget, partiallyMeets, doesNotMeet, notApplicable, pending }

enum AssessmentCategory { infectionPreventionControl, wash, spatialLayout, logistics }

// ==========================================
// 2. MODELLI DELLE DOMANDE E CHECKLIST
// ==========================================

@embedded
class AssessmentQuestion {
  String id;
  String text;
  
  @enumerated
  AssessmentCategory category;
  
  String recommendationText; 
  
  @enumerated
  ComplianceLevel selectedCompliance;
  
  String? mediaPath; 
  String? note;

  AssessmentQuestion({
    this.id = '',
    this.text = '',
    this.category = AssessmentCategory.infectionPreventionControl,
    this.recommendationText = '',
    this.selectedCompliance = ComplianceLevel.pending,
    this.mediaPath,
    this.note,
  });

  @ignore
  int get scoreValue {
    switch (selectedCompliance) {
      case ComplianceLevel.meetsTarget: return 3;
      case ComplianceLevel.partiallyMeets: return 2;
      case ComplianceLevel.doesNotMeet: return 1;
      default: return 0; 
    }
  }

  @ignore
  bool get isCriticalFailure => selectedCompliance == ComplianceLevel.doesNotMeet;
}

// ==========================================
// 3. MODELLI SPAZIALI (MAPPA)
// ==========================================

@embedded
class MapCoordinates {
  final double top;
  final double left;
  final double width;
  final double height;

  const MapCoordinates({
    this.top = 0.0,
    this.left = 0.0,
    this.width = 0.0,
    this.height = 0.0,
  });
}

@embedded
class SpatialZone {
  String id;
  String name;
  MapCoordinates coordinates;
  MapCoordinates touchArea; // <--- Il touchArea inserito dal tuo collega
  List<AssessmentQuestion> checklist;

  SpatialZone({
    this.id = '',
    this.name = '',
    this.coordinates = const MapCoordinates(), 
    this.touchArea = const MapCoordinates(),
    this.checklist = const [],
  });

  @ignore
  double get readinessScore {
    int totalPossibleScore = 0;
    int actualScore = 0;

    for (var q in checklist) {
      if (q.selectedCompliance != ComplianceLevel.pending && 
          q.selectedCompliance != ComplianceLevel.notApplicable) {
        totalPossibleScore += 3; 
        actualScore += q.scoreValue;
      }
    }

    if (totalPossibleScore == 0) return 0.0;
    return (actualScore / totalPossibleScore) * 100;
  }

  @ignore
  double get completionPercentage { 
    if (checklist.isEmpty) return 0.0;
    int completed = checklist.where((q) => q.selectedCompliance != ComplianceLevel.pending).length;
    return (completed / checklist.length) * 100;
  }

  @ignore
  Color get statusColor {
    if (completionPercentage == 0) return Colors.grey.shade400;
    bool hasCritical = checklist.any((q) => q.isCriticalFailure);
    if (hasCritical) return Colors.red.shade600;
    if (completionPercentage < 100) return Colors.orange.shade500;
    bool hasPartial = checklist.any((q) => q.selectedCompliance == ComplianceLevel.partiallyMeets);
    if (hasPartial) return Colors.amber.shade500;
    return Colors.green.shade600;
  }
}

// ==========================================
// 4. MODELLO GLOBALE DELLA STRUTTURA
// ==========================================

@collection
class FacilityLayout {
  Id id = Isar.autoIncrement; // L'ID necessario al database Isar
  
  String facilityName;
  String mapImagePath;
  DateTime? dateCreated;
  
  @enumerated
  EmergencyType emergencyType;
  
  List<SpatialZone> zones;

  FacilityLayout({
    this.facilityName = '',
    this.mapImagePath = '',
    this.dateCreated,
    this.emergencyType = EmergencyType.mpox,
    this.zones = const [], 
  });

  @ignore
  double get globalReadinessScore {
    double totalScore = 0;
    int validZonesCount = 0;
    for (var zone in zones) {
      if (zone.completionPercentage > 0) {
        totalScore += zone.readinessScore;
        validZonesCount++;
      }
    }
    if (validZonesCount == 0) return 0.0;
    return totalScore / validZonesCount;
  }
}