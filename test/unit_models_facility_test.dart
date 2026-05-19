import 'package:flutter_test/flutter_test.dart';
import 'package:assessment_tool/models/assessment_models.dart';

void main() {
  group('FacilityLayout & GeneralFacilityInfo Unit Tests', () {
    test('should initialize FacilityLayout with correct default values', () {
      final facility = FacilityLayout();
      expect(facility.facilityName, equals(''));
      expect(facility.mapImagePath, equals(''));
      expect(facility.dateCreated, isNull);
      expect(facility.generalInfo, isNull);
      expect(facility.emergencyType, equals(EmergencyType.mpox));
      expect(facility.zones, isEmpty);
      expect(facility.remoteId, isNull);
      expect(facility.isDirty, isFalse);
      expect(facility.lastSyncedAt, isNull);
      expect(facility.updatedAt, isNull);
    });

    test('should correctly assign FacilityLayout constructor parameters', () {
      final date = DateTime.now().toUtc();
      final syncDate = DateTime.now().toUtc();
      final updateDate = DateTime.now().toUtc();
      final info = GeneralFacilityInfo();

      final facility = FacilityLayout(
        facilityName: 'Al-Shifa',
        mapImagePath: '/assets/map.png',
        dateCreated: date,
        emergencyType: EmergencyType.sars,
        zones: [
          SpatialZone(id: 'z_1'),
        ],
        remoteId: 'remote_123',
        isDirty: true,
        lastSyncedAt: syncDate,
        updatedAt: updateDate,
      );
      facility.generalInfo = info;

      expect(facility.facilityName, equals('Al-Shifa'));
      expect(facility.mapImagePath, equals('/assets/map.png'));
      expect(facility.dateCreated, equals(date));
      expect(facility.generalInfo, equals(info));
      expect(facility.emergencyType, equals(EmergencyType.sars));
      expect(facility.zones.length, equals(1));
      expect(facility.zones.first.id, equals('z_1'));
      expect(facility.remoteId, equals('remote_123'));
      expect(facility.isDirty, isTrue);
      expect(facility.lastSyncedAt, equals(syncDate));
      expect(facility.updatedAt, equals(updateDate));
    });

    group('globalReadinessScore Calculations', () {
      test('should return 0.0 when zones is empty', () {
        final facility = FacilityLayout();
        expect(facility.globalReadinessScore, equals(0.0));
      });

      test('should return 0.0 when all zones are empty or have 0% completionPercentage', () {
        final facility = FacilityLayout(
          zones: [
            SpatialZone(
              id: 'z1',
              checklist: [
                AssessmentQuestion(id: 'q1', selectedCompliance: ComplianceLevel.pending),
              ],
            ),
          ],
        );
        expect(facility.globalReadinessScore, equals(0.0));
      });

      test('should return correct mathematical average of only zones with completion > 0%', () {
        final facility = FacilityLayout(
          zones: [
            SpatialZone(
              id: 'z1',
              checklist: [
                AssessmentQuestion(id: 'q1', selectedCompliance: ComplianceLevel.meetsTarget), // 100%
              ],
            ),
            SpatialZone(
              id: 'z2',
              checklist: [
                AssessmentQuestion(id: 'q2', selectedCompliance: ComplianceLevel.partiallyMeets), // 66.67%
              ],
            ),
            SpatialZone(
              id: 'z3',
              checklist: [
                AssessmentQuestion(id: 'q3', selectedCompliance: ComplianceLevel.pending), // 0% - Excluded!
              ],
            ),
          ],
        );

        // Media ponderata = (100.0 + 66.6666...) / 2 = 83.333...
        expect(facility.globalReadinessScore, closeTo(83.33, 0.01));
      });
    });

    test('should allow setting GeneralFacilityInfo parameters correctly', () {
      final info = GeneralFacilityInfo();
      info.assessorName = 'John Doe';
      info.assessorEmail = 'john@who.int';
      info.country = 'Switzerland';
      info.city = 'Geneva';
      info.inpatientBeds = 150;
      info.icuBeds = 20;

      expect(info.assessorName, equals('John Doe'));
      expect(info.assessorEmail, equals('john@who.int'));
      expect(info.country, equals('Switzerland'));
      expect(info.city, equals('Geneva'));
      expect(info.inpatientBeds, equals(150));
      expect(info.icuBeds, equals(20));
    });

    test('should enforce UTC timezones on all timestamps', () {
      final nowLocal = DateTime.now(); // Local time
      final nowUtc = nowLocal.toUtc();

      final facility = FacilityLayout(
        dateCreated: nowUtc,
        lastSyncedAt: nowUtc,
        updatedAt: nowUtc,
      );

      expect(facility.dateCreated!.isUtc, isTrue);
      expect(facility.lastSyncedAt!.isUtc, isTrue);
      expect(facility.updatedAt!.isUtc, isTrue);
    });

    test('should handle all EmergencyType and FacilityType enums', () {
      expect(EmergencyType.values.length, equals(3));
      expect(EmergencyType.values, contains(EmergencyType.mpox));
      expect(EmergencyType.values, contains(EmergencyType.ebola));
      expect(EmergencyType.values, contains(EmergencyType.sars));

      expect(FacilityType.values.length, equals(4));
      expect(FacilityType.values, contains(FacilityType.screeningAndIsolation));
      expect(FacilityType.values, contains(FacilityType.existingFacilityWithWard));
      expect(FacilityType.values, contains(FacilityType.standAloneCenter));
      expect(FacilityType.values, contains(FacilityType.congregateSetting));
    });
  });
}
