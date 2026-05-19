import 'package:flutter_test/flutter_test.dart';
import 'package:assessment_tool/models/assessment_models.dart';

/// Unit tests for the analytics aggregation engine.
/// These tests validate the data-layer computations behind
/// AdvancedAnalyticsScreen (radar chart category scores, trend
/// line data points, and facility distribution buckets) WITHOUT
/// requiring any GPU or fl_chart rendering — pure math only.
void main() {
  group('Analytics Aggregation Engine - Category Radar Scores', () {
    // Helper: replicates the exact getPct logic from AdvancedAnalyticsScreen
    double getCategoryPercentage(
        List<FacilityLayout> data, AssessmentCategory category) {
      int earned = 0;
      int possible = 0;
      for (var facility in data) {
        for (var zone in facility.zones) {
          for (var q in zone.checklist) {
            if (q.category == category &&
                q.selectedCompliance != ComplianceLevel.pending &&
                q.selectedCompliance != ComplianceLevel.notApplicable) {
              possible += 3;
              earned += q.scoreValue;
            }
          }
        }
      }
      if (possible == 0) return 0;
      return (earned / possible) * 100;
    }

    test('IPC category score is 100% when all questions meetsTarget', () {
      final data = [
        FacilityLayout(zones: [
          SpatialZone(id: 'z1', checklist: [
            AssessmentQuestion(
                id: 'q1',
                category: AssessmentCategory.infectionPreventionControl,
                selectedCompliance: ComplianceLevel.meetsTarget),
            AssessmentQuestion(
                id: 'q2',
                category: AssessmentCategory.infectionPreventionControl,
                selectedCompliance: ComplianceLevel.meetsTarget),
          ]),
        ]),
      ];
      expect(
          getCategoryPercentage(
              data, AssessmentCategory.infectionPreventionControl),
          equals(100.0));
    });

    test('WASH category score is 0% when no WASH questions answered', () {
      final data = [
        FacilityLayout(zones: [
          SpatialZone(id: 'z1', checklist: [
            AssessmentQuestion(
                id: 'q1',
                category: AssessmentCategory.wash,
                selectedCompliance: ComplianceLevel.pending),
          ]),
        ]),
      ];
      expect(getCategoryPercentage(data, AssessmentCategory.wash), equals(0.0));
    });

    test(
        'Logistics category score reflects mixed doesNotMeet and meetsTarget correctly',
        () {
      final data = [
        FacilityLayout(zones: [
          SpatialZone(id: 'z1', checklist: [
            AssessmentQuestion(
                id: 'q1',
                category: AssessmentCategory.logistics,
                selectedCompliance: ComplianceLevel.meetsTarget), // 3/3
            AssessmentQuestion(
                id: 'q2',
                category: AssessmentCategory.logistics,
                selectedCompliance: ComplianceLevel.doesNotMeet), // 1/3
          ]),
        ]),
      ];
      // earned = 4, possible = 6, pct = 66.67%
      expect(getCategoryPercentage(data, AssessmentCategory.logistics),
          closeTo(66.67, 0.05));
    });

    test('SpatialLayout category score handles notApplicable exclusion', () {
      final data = [
        FacilityLayout(zones: [
          SpatialZone(id: 'z1', checklist: [
            AssessmentQuestion(
                id: 'q1',
                category: AssessmentCategory.spatialLayout,
                selectedCompliance: ComplianceLevel.meetsTarget), // 3/3
            AssessmentQuestion(
                id: 'q2',
                category: AssessmentCategory.spatialLayout,
                selectedCompliance: ComplianceLevel.notApplicable), // ignored
          ]),
        ]),
      ];
      // Only q1 counts: 3/3 = 100%
      expect(getCategoryPercentage(data, AssessmentCategory.spatialLayout),
          equals(100.0));
    });

    test(
        'Radar aggregation across multiple facilities sums correctly across all zones',
        () {
      final data = [
        FacilityLayout(zones: [
          SpatialZone(id: 'z1', checklist: [
            AssessmentQuestion(
                id: 'q1',
                category: AssessmentCategory.wash,
                selectedCompliance: ComplianceLevel.meetsTarget), // 3
          ]),
        ]),
        FacilityLayout(zones: [
          SpatialZone(id: 'z2', checklist: [
            AssessmentQuestion(
                id: 'q2',
                category: AssessmentCategory.wash,
                selectedCompliance: ComplianceLevel.doesNotMeet), // 1
          ]),
        ]),
      ];
      // Total earned = 4, possible = 6, pct = 66.67%
      expect(getCategoryPercentage(data, AssessmentCategory.wash),
          closeTo(66.67, 0.05));
    });

    test('Empty facility list returns 0% for all categories', () {
      final List<FacilityLayout> data = [];
      expect(
          getCategoryPercentage(
              data, AssessmentCategory.infectionPreventionControl),
          equals(0.0));
      expect(getCategoryPercentage(data, AssessmentCategory.wash), equals(0.0));
      expect(getCategoryPercentage(data, AssessmentCategory.spatialLayout),
          equals(0.0));
      expect(getCategoryPercentage(data, AssessmentCategory.logistics),
          equals(0.0));
    });
  });

  group('Analytics Aggregation Engine - Trend Line Data Points', () {
    test(
        'Trend line sorts facilities chronologically by dateCreated ascending',
        () {
      final facilities = [
        FacilityLayout(
            facilityName: 'Third',
            dateCreated: DateTime.utc(2026, 3, 1),
            zones: []),
        FacilityLayout(
            facilityName: 'First',
            dateCreated: DateTime.utc(2026, 1, 1),
            zones: []),
        FacilityLayout(
            facilityName: 'Second',
            dateCreated: DateTime.utc(2026, 2, 1),
            zones: []),
      ];

      final sorted = List<FacilityLayout>.from(facilities)
        ..sort((a, b) {
          if (a.dateCreated == null) return 1;
          if (b.dateCreated == null) return -1;
          return a.dateCreated!.compareTo(b.dateCreated!);
        });

      expect(sorted[0].facilityName, equals('First'));
      expect(sorted[1].facilityName, equals('Second'));
      expect(sorted[2].facilityName, equals('Third'));
    });

    test('Null dateCreated facilities sort to end of trend line', () {
      final facilities = [
        FacilityLayout(facilityName: 'NoDate', dateCreated: null, zones: []),
        FacilityLayout(
            facilityName: 'HasDate',
            dateCreated: DateTime.utc(2026, 1, 1),
            zones: []),
      ];

      final sorted = List<FacilityLayout>.from(facilities)
        ..sort((a, b) {
          if (a.dateCreated == null) return 1;
          if (b.dateCreated == null) return -1;
          return a.dateCreated!.compareTo(b.dateCreated!);
        });

      expect(sorted[0].facilityName, equals('HasDate'));
      expect(sorted[1].facilityName, equals('NoDate'));
    });

    test(
        'Trend line data points map globalReadinessScore to FlSpot-compatible (index, value) pairs',
        () {
      final facilities = [
        FacilityLayout(
            facilityName: 'F1',
            dateCreated: DateTime.utc(2026, 1, 1),
            zones: [
              SpatialZone(id: 'z1', checklist: [
                AssessmentQuestion(
                    id: 'q1',
                    selectedCompliance: ComplianceLevel.meetsTarget),
              ]),
            ]),
        FacilityLayout(
            facilityName: 'F2',
            dateCreated: DateTime.utc(2026, 2, 1),
            zones: [
              SpatialZone(id: 'z2', checklist: [
                AssessmentQuestion(
                    id: 'q2',
                    selectedCompliance: ComplianceLevel.doesNotMeet),
              ]),
            ]),
      ];

      final spots = <Map<String, double>>[];
      for (int i = 0; i < facilities.length; i++) {
        spots.add({
          'x': i.toDouble(),
          'y': facilities[i].globalReadinessScore,
        });
      }

      expect(spots[0]['x'], equals(0.0));
      expect(spots[0]['y'], equals(100.0));
      expect(spots[1]['x'], equals(1.0));
      expect(spots[1]['y'], closeTo(33.33, 0.05));
    });
  });

  group('Analytics Aggregation Engine - Facility Distribution Buckets', () {
    // Helper: categorize facilities by color status for pie charts
    Map<String, int> distributeFacilities(List<FacilityLayout> facilities) {
      int green = 0, amber = 0, red = 0, grey = 0;
      for (var f in facilities) {
        bool anyComplete = f.zones.any((z) => z.completionPercentage > 0);
        if (!anyComplete) {
          grey++;
          continue;
        }
        bool hasCritical = f.zones
            .any((z) => z.checklist.any((q) => q.isCriticalFailure));
        if (hasCritical) {
          red++;
        } else if (f.globalReadinessScore >= 80) {
          green++;
        } else {
          amber++;
        }
      }
      return {'green': green, 'amber': amber, 'red': red, 'grey': grey};
    }

    test('All-green facilities when every zone is meetsTarget', () {
      final facilities = List.generate(
        5,
        (i) => FacilityLayout(facilityName: 'F$i', zones: [
          SpatialZone(id: 'z$i', checklist: [
            AssessmentQuestion(
                id: 'q$i', selectedCompliance: ComplianceLevel.meetsTarget),
          ]),
        ]),
      );
      final dist = distributeFacilities(facilities);
      expect(dist['green'], equals(5));
      expect(dist['red'], equals(0));
      expect(dist['amber'], equals(0));
      expect(dist['grey'], equals(0));
    });

    test('Facilities with doesNotMeet always classified as red', () {
      final facilities = [
        FacilityLayout(facilityName: 'CritFacility', zones: [
          SpatialZone(id: 'z1', checklist: [
            AssessmentQuestion(
                id: 'q1', selectedCompliance: ComplianceLevel.meetsTarget),
            AssessmentQuestion(
                id: 'q2', selectedCompliance: ComplianceLevel.doesNotMeet),
          ]),
        ]),
      ];
      final dist = distributeFacilities(facilities);
      expect(dist['red'], equals(1));
      expect(dist['green'], equals(0));
    });

    test('Facilities with only pending questions classified as grey', () {
      final facilities = [
        FacilityLayout(facilityName: 'Empty', zones: [
          SpatialZone(id: 'z1', checklist: [
            AssessmentQuestion(
                id: 'q1', selectedCompliance: ComplianceLevel.pending),
          ]),
        ]),
      ];
      final dist = distributeFacilities(facilities);
      expect(dist['grey'], equals(1));
    });

    test('Facilities with low score and no criticals classified as amber', () {
      final facilities = [
        FacilityLayout(facilityName: 'LowScore', zones: [
          SpatialZone(id: 'z1', checklist: [
            AssessmentQuestion(
                id: 'q1',
                selectedCompliance: ComplianceLevel.partiallyMeets), // 66.67%
          ]),
        ]),
      ];
      final dist = distributeFacilities(facilities);
      expect(dist['amber'], equals(1));
    });

    test(
        'Mixed portfolio distribution counts correctly across 10 diverse facilities',
        () {
      final facilities = <FacilityLayout>[
        // 3 GREEN (100% meetsTarget, score >= 80%)
        ...List.generate(
          3,
          (i) => FacilityLayout(facilityName: 'Green$i', zones: [
            SpatialZone(id: 'zg$i', checklist: [
              AssessmentQuestion(
                  id: 'qg$i', selectedCompliance: ComplianceLevel.meetsTarget),
            ]),
          ]),
        ),
        // 2 RED (have doesNotMeet)
        ...List.generate(
          2,
          (i) => FacilityLayout(facilityName: 'Red$i', zones: [
            SpatialZone(id: 'zr$i', checklist: [
              AssessmentQuestion(
                  id: 'qr$i',
                  selectedCompliance: ComplianceLevel.doesNotMeet),
            ]),
          ]),
        ),
        // 3 AMBER (low score, no criticals)
        ...List.generate(
          3,
          (i) => FacilityLayout(facilityName: 'Amber$i', zones: [
            SpatialZone(id: 'za$i', checklist: [
              AssessmentQuestion(
                  id: 'qa$i',
                  selectedCompliance: ComplianceLevel.partiallyMeets),
            ]),
          ]),
        ),
        // 2 GREY (all pending)
        ...List.generate(
          2,
          (i) => FacilityLayout(facilityName: 'Grey$i', zones: [
            SpatialZone(id: 'zgr$i', checklist: [
              AssessmentQuestion(
                  id: 'qgr$i', selectedCompliance: ComplianceLevel.pending),
            ]),
          ]),
        ),
      ];

      final dist = distributeFacilities(facilities);
      expect(dist['green'], equals(3));
      expect(dist['red'], equals(2));
      expect(dist['amber'], equals(3));
      expect(dist['grey'], equals(2));
    });
  });

  group('Analytics Aggregation Engine - GeneralFacilityInfo Completeness', () {
    test(
        'GeneralFacilityInfo fields are all nullable and default to null on empty init',
        () {
      final info = GeneralFacilityInfo();
      expect(info.assessorName, isNull);
      expect(info.assessorEmail, isNull);
      expect(info.assessorPhone, isNull);
      expect(info.country, isNull);
      expect(info.region, isNull);
      expect(info.district, isNull);
      expect(info.city, isNull);
      expect(info.facilityCode, isNull);
      expect(info.facilityName, isNull);
      expect(info.managingAuthority, isNull);
      expect(info.inpatientBeds, isNull);
      expect(info.icuBeds, isNull);
    });

    test('GeneralFacilityInfo stores and retrieves all demographic fields', () {
      final info = GeneralFacilityInfo()
        ..assessedDisease = 'MPOX'
        ..assessedFacilityType = 'Screening and temporary isolation'
        ..assessorName = 'Dr. WHO Inspector'
        ..assessorEmail = 'inspector@who.int'
        ..assessorPhone = '+41 22 791 2111'
        ..country = 'Democratic Republic of Congo'
        ..region = 'North Kivu'
        ..district = 'Goma'
        ..city = 'Goma'
        ..facilityCode = 'DRC-NK-001'
        ..facilityName = 'Centre de Santé de Goma'
        ..managingAuthority = 'Ministry of Health'
        ..inpatientBeds = 120
        ..icuBeds = 8
        ..has24hEmergency = 'Yes'
        ..hasIcuOrHdu = 'Yes';

      expect(info.assessedDisease, equals('MPOX'));
      expect(info.country, equals('Democratic Republic of Congo'));
      expect(info.inpatientBeds, equals(120));
      expect(info.icuBeds, equals(8));
      expect(info.has24hEmergency, equals('Yes'));
    });

    test(
        'FacilityLayout with generalInfo preserves all fields through assignment',
        () {
      final info = GeneralFacilityInfo()
        ..assessorName = 'Test'
        ..country = 'Italy';

      final facility = FacilityLayout(facilityName: 'TestFacility')
        ..generalInfo = info;

      expect(facility.generalInfo, isNotNull);
      expect(facility.generalInfo!.assessorName, equals('Test'));
      expect(facility.generalInfo!.country, equals('Italy'));
    });
  });
}
