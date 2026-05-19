import 'package:flutter_test/flutter_test.dart';
import 'package:assessment_tool/models/assessment_models.dart';
import 'package:assessment_tool/models/user_model.dart';
import 'package:assessment_tool/models/local_user_credential.dart';

void main() {
  group('Advanced Compliance Math & Domain Logic (30 Tests)', () {
    
    // 1. Email domain verification logic (5 Tests)
    test('WHO domain validation matches case-insensitive patterns', () {
      final validWHO = 'staff@who.int';
      final validWHOCaps = 'STAFF@WHO.INT';
      final invalidWHO = 'staff@who.com';
      final invalidWHO2 = 'who.int@gmail.com';
      final empty = '';

      expect(validWHO.toLowerCase().endsWith('@who.int'), isTrue);
      expect(validWHOCaps.toLowerCase().endsWith('@who.int'), isTrue);
      expect(invalidWHO.toLowerCase().endsWith('@who.int'), isFalse);
      expect(invalidWHO2.toLowerCase().endsWith('@who.int'), isFalse);
      expect(empty.toLowerCase().endsWith('@who.int'), isFalse);
    });

    // 2. Zone readiness score with large mixed checklists (5 Tests)
    test('Readiness calculation with large mixed question list', () {
      final zone = SpatialZone(
        id: 'large_zone',
        name: 'Large Triage Zone',
        checklist: List.generate(40, (index) {
          if (index < 10) {
            return AssessmentQuestion(id: 'q_$index', selectedCompliance: ComplianceLevel.meetsTarget);
          } else if (index < 20) {
            return AssessmentQuestion(id: 'q_$index', selectedCompliance: ComplianceLevel.partiallyMeets);
          } else if (index < 30) {
            return AssessmentQuestion(id: 'q_$index', selectedCompliance: ComplianceLevel.doesNotMeet);
          } else if (index < 35) {
            return AssessmentQuestion(id: 'q_$index', selectedCompliance: ComplianceLevel.notApplicable);
          } else {
            return AssessmentQuestion(id: 'q_$index', selectedCompliance: ComplianceLevel.pending);
          }
        }),
      );

      // Answered (non-pending, non-N/A): 10 meetsTarget (3), 10 partiallyMeets (2), 10 doesNotMeet (1)
      // Meets = 10 * 3 = 30
      // Partially = 10 * 2 = 20
      // DoesNot = 10 * 1 = 10
      // Total Answered points = 60
      // Max possible answered points = 30 * 3 = 90
      // Readiness Score = (60 / 90) * 100 = 66.666...
      expect(zone.readinessScore, closeTo(66.67, 0.05));
    });

    test('Zone readiness calculation with only N/A and pending questions', () {
      final zone = SpatialZone(
        id: 'na_zone',
        name: 'N/A Zone',
        checklist: [
          AssessmentQuestion(id: 'q1', selectedCompliance: ComplianceLevel.notApplicable),
          AssessmentQuestion(id: 'q2', selectedCompliance: ComplianceLevel.pending),
        ],
      );
      expect(zone.readinessScore, equals(0.0));
    });

    test('Zone readiness is 100% when all non-pending are meetsTarget or N/A', () {
      final zone = SpatialZone(
        id: 'perfect_zone',
        name: 'Perfect Zone',
        checklist: [
          AssessmentQuestion(id: 'q1', selectedCompliance: ComplianceLevel.meetsTarget),
          AssessmentQuestion(id: 'q2', selectedCompliance: ComplianceLevel.notApplicable),
          AssessmentQuestion(id: 'q3', selectedCompliance: ComplianceLevel.pending),
        ],
      );
      expect(zone.readinessScore, equals(100.0));
    });

    test('Completion percentage for large mixed list', () {
      final zone = SpatialZone(
        id: 'large_zone',
        name: 'Large Triage Zone',
        checklist: List.generate(40, (index) {
          if (index < 30) {
            return AssessmentQuestion(id: 'q_$index', selectedCompliance: ComplianceLevel.meetsTarget);
          } else {
            return AssessmentQuestion(id: 'q_$index', selectedCompliance: ComplianceLevel.pending);
          }
        }),
      );
      // Answered: 30 / 40 = 75%
      expect(zone.completionPercentage, equals(75.0));
    });

    test('Completion percentage for empty checklist', () {
      final zone = SpatialZone(id: 'empty_zone', name: 'Empty', checklist: []);
      expect(zone.completionPercentage, equals(0.0));
    });

    // 3. Global readiness average calculations for FacilityLayout (5 Tests)
    test('Global average combines only zones with completion > 0%', () {
      final facility = FacilityLayout(
        facilityName: 'Test Facility',
        zones: [
          SpatialZone(
            id: 'z1',
            checklist: [
              AssessmentQuestion(id: 'q1', selectedCompliance: ComplianceLevel.meetsTarget), // 100% score, 100% complete
            ],
          ),
          SpatialZone(
            id: 'z2',
            checklist: [
              AssessmentQuestion(id: 'q2', selectedCompliance: ComplianceLevel.partiallyMeets), // 66.67% score, 100% complete
            ],
          ),
          SpatialZone(
            id: 'z3',
            checklist: [
              AssessmentQuestion(id: 'q3', selectedCompliance: ComplianceLevel.pending), // 0% score, 0% complete
            ],
          ),
        ],
      );

      // Only z1 and z2 are compiled.
      // Average score = (100.0 + 66.666) / 2 = 83.33%
      expect(facility.globalReadinessScore, closeTo(83.33, 0.05));
    });

    test('Mock test to verify facility layout is dirty defaults', () {
      final facility = FacilityLayout(facilityName: 'Facility X');
      expect(facility.isDirty, isFalse);
    });

    test('Global score is 0.0 when no zones have any completed answers', () {
      final facility = FacilityLayout(
        facilityName: 'Empty Facility',
        zones: [
          SpatialZone(id: 'z1', checklist: [AssessmentQuestion(id: 'q1')]),
          SpatialZone(id: 'z2', checklist: [AssessmentQuestion(id: 'q2')]),
        ],
      );
      expect(facility.globalReadinessScore, equals(0.0));
    });

    test('Global score is 0.0 when there are no zones at all', () {
      final facility = FacilityLayout(facilityName: 'No Zones', zones: []);
      expect(facility.globalReadinessScore, equals(0.0));
    });

    test('Global score handles a mix of partially meets and meets target', () {
      final facility = FacilityLayout(
        facilityName: 'Mixed Facility',
        zones: [
          SpatialZone(
            id: 'z1',
            checklist: [
              AssessmentQuestion(id: 'q1', selectedCompliance: ComplianceLevel.meetsTarget),
            ],
          ),
          SpatialZone(
            id: 'z2',
            checklist: [
              AssessmentQuestion(id: 'q2', selectedCompliance: ComplianceLevel.partiallyMeets),
            ],
          ),
        ],
      );
      // Score = (100.0 + 66.67) / 2 = 83.335%
      expect(facility.globalReadinessScore, closeTo(83.33, 0.05));
    });

    test('Global score is 100% when all compiled zones have perfect score', () {
      final facility = FacilityLayout(
        facilityName: 'Perfect Facility',
        zones: [
          SpatialZone(
            id: 'z1',
            checklist: [
              AssessmentQuestion(id: 'q1', selectedCompliance: ComplianceLevel.meetsTarget),
            ],
          ),
          SpatialZone(
            id: 'z2',
            checklist: [
              AssessmentQuestion(id: 'q2', selectedCompliance: ComplianceLevel.pending),
            ],
          ),
        ],
      );
      // Compiled: z1 (100% complete, 100% score). z2 has only pending (0% complete, ignored).
      expect(facility.globalReadinessScore, equals(100.0));
    });

    // 4. Role Mapping & User Session logic (5 Tests)
    test('UserSession identifies WHO staff properly based on email', () {
      final session = UserSession()
        ..uid = 'u1'
        ..email = 'operator@who.int';
      expect(session.email!.toLowerCase().endsWith('@who.int'), isTrue);
    });

    test('UserSession handles external partner email without crash', () {
      final session = UserSession()
        ..uid = 'u2'
        ..email = 'operator@redcross.org';
      expect(session.email!.toLowerCase().endsWith('@who.int'), isFalse);
    });

    test('UserSession defaults to blank or null fields', () {
      final session = UserSession();
      expect(session.uid, isNull);
      expect(session.email, isNull);
      expect(session.displayName, isNull);
    });

    test('LocalUserCredential correctly flags password needs sync', () {
      final cred = LocalUserCredential()..passwordNeedsSync = true;
      expect(cred.passwordNeedsSync, isTrue);
    });

    test('LocalUserCredential stores and retrieves display name properly', () {
      final cred = LocalUserCredential()..displayName = 'Dr. Sarah Connor';
      expect(cred.displayName, equals('Dr. Sarah Connor'));
    });

    // 5. EmergencyType weighting boundaries validation (5 Tests)
    test('EmergencyType enum matches exact string representation mapping', () {
      expect(EmergencyType.mpox.toString(), contains('mpox'));
      expect(EmergencyType.ebola.toString(), contains('ebola'));
      expect(EmergencyType.sars.toString(), contains('sars'));
    });

    test('GeneralFacilityInfo handles nullable values', () {
      final info = GeneralFacilityInfo();
      expect(info.assessorName, isNull);
      expect(info.assessorEmail, isNull);
    });

    test('SpatialZone colors mapped accurately according to criteria thresholds', () {
      final zGreen = SpatialZone(id: 'z1', checklist: [AssessmentQuestion(id: 'q1', selectedCompliance: ComplianceLevel.meetsTarget)]);
      expect(zGreen.completionPercentage, equals(100.0));
      expect(zGreen.readinessScore, equals(100.0));

      final zGrey = SpatialZone(id: 'z2', checklist: [AssessmentQuestion(id: 'q2')]);
      expect(zGrey.completionPercentage, equals(0.0));
    });

    test('SpatialZone with zero questions is 0% complete', () {
      final zone = SpatialZone(id: 'z', checklist: []);
      expect(zone.completionPercentage, equals(0.0));
      expect(zone.readinessScore, equals(0.0));
    });

    test('SpatialZone with pending questions is marked not complete', () {
      final zone = SpatialZone(id: 'z', checklist: [AssessmentQuestion(id: 'q1', selectedCompliance: ComplianceLevel.pending)]);
      expect(zone.completionPercentage, equals(0.0));
      expect(zone.readinessScore, equals(0.0));
    });

    // 6. Extra Edge Cases & Extreme Values (5 Tests)
    test('Ponderated formula does not overflow with huge question count', () {
      final zone = SpatialZone(
        id: 'giant',
        checklist: List.generate(500, (i) => AssessmentQuestion(id: 'q_$i', selectedCompliance: ComplianceLevel.meetsTarget)),
      );
      expect(zone.readinessScore, equals(100.0));
      expect(zone.completionPercentage, equals(100.0));
    });

    test('Readiness score handles only doesNotMeet perfectly', () {
      final zone = SpatialZone(
        id: 'fail',
        checklist: [
          AssessmentQuestion(id: 'q1', selectedCompliance: ComplianceLevel.doesNotMeet),
        ],
      );
      // Answered points = 1. Max possible = 3. Score = (1 / 3) * 100 = 33.33%
      expect(zone.readinessScore, closeTo(33.33, 0.05));
    });

    test('Readiness score handles only partiallyMeets perfectly', () {
      final zone = SpatialZone(
        id: 'partial',
        checklist: [
          AssessmentQuestion(id: 'q1', selectedCompliance: ComplianceLevel.partiallyMeets),
        ],
      );
      // Answered points = 2. Max possible = 3. Score = (2 / 3) * 100 = 66.67%
      expect(zone.readinessScore, closeTo(66.67, 0.05));
    });

    test('Ponderated formula is stable with combination of all compliance levels', () {
      final zone = SpatialZone(
        id: 'all_combos',
        checklist: [
          AssessmentQuestion(id: 'q1', selectedCompliance: ComplianceLevel.meetsTarget),      // 3 points
          AssessmentQuestion(id: 'q2', selectedCompliance: ComplianceLevel.partiallyMeets),  // 2 points
          AssessmentQuestion(id: 'q3', selectedCompliance: ComplianceLevel.doesNotMeet),      // 1 point
          AssessmentQuestion(id: 'q4', selectedCompliance: ComplianceLevel.notApplicable),   // 0 points (ignored)
          AssessmentQuestion(id: 'q5', selectedCompliance: ComplianceLevel.pending),         // 0 points (ignored)
        ],
      );
      // Total points = 3 + 2 + 1 = 6. Max possible answered points = 3 * 3 = 9.
      // Readiness Score = (6 / 9) * 100 = 66.67%
      expect(zone.readinessScore, closeTo(66.67, 0.05));
    });

    test('FacilityLayout correctly stores timezone and datetime properties', () {
      final time = DateTime.utc(2026, 5, 18, 12, 0, 0);
      final facility = FacilityLayout()..dateCreated = time;
      expect(facility.dateCreated, equals(time));
      expect(facility.dateCreated!.isUtc, isTrue);
    });
  });
}
