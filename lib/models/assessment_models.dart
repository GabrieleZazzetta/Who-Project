import 'package:flutter/material.dart';
import 'package:isar/isar.dart';

part 'assessment_models.g.dart';

// CORE ENUMERATIONS
enum EmergencyType { mpox, ebola, sars }

enum FacilityType {
  screeningAndIsolation,
  existingFacilityWithWard,
  standAloneCenter,
  congregateSetting
}

enum ComplianceLevel {
  meetsTarget,
  partiallyMeets,
  doesNotMeet,
  notApplicable,
  pending
}

enum AssessmentCategory {
  infectionPreventionControl,
  wash,
  spatialLayout,
  logistics
}

// ASSESSMENT QUESTION ENTITY
// Represents a single checklist item with compliance level and derived scoring

@embedded
class AssessmentQuestion {
  String id;
  String text;

  @enumerated
  AssessmentCategory category;

  String recommendationText;

  @enumerated
  ComplianceLevel selectedCompliance;

  List<String>? mediaPaths;
  String? note;

  AssessmentQuestion({
    this.id = '',
    this.text = '',
    this.category = AssessmentCategory.infectionPreventionControl,
    this.recommendationText = '',
    this.selectedCompliance = ComplianceLevel.pending,
    this.mediaPaths,
    this.note,
  });

  @ignore
  int get scoreValue {
    switch (selectedCompliance) {
      case ComplianceLevel.meetsTarget:
        return 3;
      case ComplianceLevel.partiallyMeets:
        return 2;
      case ComplianceLevel.doesNotMeet:
        return 1;
      default:
        return 0;
    }
  }

  @ignore
  bool get isCriticalFailure =>
      selectedCompliance == ComplianceLevel.doesNotMeet;
}

// SPATIAL MODELS
// Positional coordinates and touch areas for interactive map zones

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
  MapCoordinates touchArea;
  List<AssessmentQuestion> checklist;

  SpatialZone({
    this.id = '',
    this.name = '',
    this.coordinates = const MapCoordinates(),
    this.touchArea = const MapCoordinates(),
    this.checklist = const [],
  });

  // Calculate readiness score based on completed questions (excluding pending and N/A)
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
    int completed = checklist
        .where((q) => q.selectedCompliance != ComplianceLevel.pending)
        .length;
    return (completed / checklist.length) * 100;
  }

  // Determine status color based on criticality and completion
  @ignore
  Color get statusColor {
    if (completionPercentage == 0) return Colors.grey.shade400;
    bool hasCritical = checklist.any((q) => q.isCriticalFailure);
    if (hasCritical) return Colors.red.shade600;
    if (completionPercentage < 100) return Colors.orange.shade500;
    bool hasPartial = checklist
        .any((q) => q.selectedCompliance == ComplianceLevel.partiallyMeets);
    if (hasPartial) return Colors.amber.shade500;
    return Colors.green.shade600;
  }
}

// FACILITY LAYOUT ENTITY
// Represents a complete health facility with spatial zones and metadata

@collection
class FacilityLayout {
  Id id = Isar.autoIncrement;

  String facilityName;
  String mapImagePath;
  DateTime? dateCreated;
  GeneralFacilityInfo? generalInfo;

  @enumerated
  EmergencyType emergencyType;

  List<SpatialZone> zones;

  // SYNCHRONIZATION METADATA
  // Fields required for data alignment between local and remote storage
  String? remoteId;       // Unique remote server identifier
  bool isDirty;           // Unsynchronized local modifications flag
  DateTime? lastSyncedAt; // Last successful synchronization timestamp
  DateTime? updatedAt;    // Last local modification timestamp

  FacilityLayout({
    this.facilityName = '',
    this.mapImagePath = '',
    this.dateCreated,
    this.emergencyType = EmergencyType.mpox,
    this.zones = const [],
    this.remoteId,
    this.isDirty = false,
    this.lastSyncedAt,
    this.updatedAt,
  });

  // Weighted average of completed zone readiness scores
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

// GENERAL FACILITY INFORMATION
// Demographic, geographic, and organizational data collected during profiling

@embedded
class GeneralFacilityInfo {
  String? assessedDisease;
  String? assessedFacilityType;

  DateTime? assessmentDate;
  String? assessorName;
  String? assessorEmail;
  String? assessorPhone;

  String? country;
  String? region;
  String? district;
  String? city;
  String? facilityAddressOrGps;
  String? facilityLocationRecord;

  String? facilityCode;
  String? facilityName;
  String? managingAuthority;
  String? facilityDirectorName;
  String? facilityDirectorPhone;
  String? facilityDirectorEmail;
  String? respondentName;
  String? respondentPosition;
  String? structureType;
  String? existingHealthcareFacilityType;

  String? offersOutpatient;
  String? offersInpatient;
  int? inpatientBeds;
  int? icuBeds;
  String? has24hEmergency;
  String? hasIcuOrHdu;
}

// COMPLIANCE CRITERIA DICTIONARY
// Static dictionary for educational button explanations mapping without altering Isar schema
final Map<String, Map<ComplianceLevel, String>> globalComplianceCriteria = {
  'q1_screening_location': {
    ComplianceLevel.meetsTarget: 'A screening area is placed at the entrance of the facility. All patients pass through the screening before accessing the facility. The screening is visible, clearly labelled and proper wayfinding guides the flow of patients.',
    ComplianceLevel.partiallyMeets: 'A screening area is placed at the entrance of the facility. All patients pass through the screening before accessing the facility. However, it is not clearly labelled AND no dedicate wayfinding is in place to guide the flow of patients.',
    ComplianceLevel.doesNotMeet: 'NOT all patients pass by the screening before accessing the facility.',
  },
  'q1_screening_distance': {
    ComplianceLevel.meetsTarget: 'There is at least 1 m distance, between patients and staff when conducting screening. Physical barrier (fence or furniture) or marks on the ground support keeping the distance.',
    ComplianceLevel.partiallyMeets: 'There is LESS than 1 m distance between patients and staff OR no marks on the ground or physical barriers helps in keeping the physical distance.',
    ComplianceLevel.doesNotMeet: 'There is NO distance between patients and staff.',
  },
  'q1_screening_exits': {
    ComplianceLevel.meetsTarget: 'In the screening area, there are separated exits for patient who meet the case definition (suspected cases) and patient who does not meet the case the definition (non-suspected cases) to ensure separate patients’ flows. Suspected cases access the screening facility while non-suspected cases proceed with their path.',
    ComplianceLevel.partiallyMeets: 'In the screening area, there is only one exit for patient who meet the case definition (suspected cases) and patient who does not meet the case the definition (non-suspected cases), however the shared path is short, and suspected cases access the screening facility while non-suspected cases proceed with their path.',
    ComplianceLevel.doesNotMeet: 'In the screening area, there is only one exit for patient who meet the case definition (suspected cases) and patient who does not meet the case the definition (non-suspected cases). Non-suspected cases may access by accident the screening facility rather proceeding with their path.',
  },
  'q1_screening_hygiene': {
    ComplianceLevel.meetsTarget: 'For each screening station there is more than 8 m2 of surface available.',
    ComplianceLevel.partiallyMeets: 'For each screening station, there is between 7.9 m2 and 6 m2 of surface available.',
    ComplianceLevel.doesNotMeet: 'For each screening station, there is less than 6 m2 of surface available.',
  },
};
