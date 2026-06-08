import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:assessment_tool/models/assessment_models.dart';
import 'package:assessment_tool/models/user_model.dart';
import 'package:assessment_tool/models/local_user_credential.dart';

void main() {
  group('Models Unit Tests', () {
    
    // FACILITY LAYOUT AND GENERAL INFO
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

    // ASSESSMENT QUESTION
    group('AssessmentQuestion Unit Tests', () {
      test('should initialize with correct default values', () {
        final question = AssessmentQuestion();
        expect(question.id, equals(''));
        expect(question.text, equals(''));
        expect(question.category, equals(AssessmentCategory.infectionPreventionControl));
        expect(question.recommendationText, equals(''));
        expect(question.selectedCompliance, equals(ComplianceLevel.pending));
        expect(question.mediaPaths, isNull);
        expect(question.note, isNull);
      });

      test('should correctly assign constructor parameters', () {
        final question = AssessmentQuestion(
          id: 'q_t1',
          text: 'Is the ventilation adequate?',
          category: AssessmentCategory.spatialLayout,
          recommendationText: 'Increase natural ventilation',
          selectedCompliance: ComplianceLevel.meetsTarget,
          mediaPaths: ['/temp/image.png'],
          note: 'Tested with smoke pen',
        );
        expect(question.id, equals('q_t1'));
        expect(question.text, equals('Is the ventilation adequate?'));
        expect(question.category, equals(AssessmentCategory.spatialLayout));
        expect(question.recommendationText, equals('Increase natural ventilation'));
        expect(question.selectedCompliance, equals(ComplianceLevel.meetsTarget));
        expect(question.mediaPaths, equals(['/temp/image.png']));
        expect(question.note, equals('Tested with smoke pen'));
      });

      test('should return scoreValue of 3 for meetsTarget', () {
        final question = AssessmentQuestion(selectedCompliance: ComplianceLevel.meetsTarget);
        expect(question.scoreValue, equals(3));
      });

      test('should return scoreValue of 2 for partiallyMeets', () {
        final question = AssessmentQuestion(selectedCompliance: ComplianceLevel.partiallyMeets);
        expect(question.scoreValue, equals(2));
      });

      test('should return scoreValue of 1 for doesNotMeet', () {
        final question = AssessmentQuestion(selectedCompliance: ComplianceLevel.doesNotMeet);
        expect(question.scoreValue, equals(1));
      });

      test('should return scoreValue of 0 for pending', () {
        final question = AssessmentQuestion(selectedCompliance: ComplianceLevel.pending);
        expect(question.scoreValue, equals(0));
      });

      test('should return scoreValue of 0 for notApplicable', () {
        final question = AssessmentQuestion(selectedCompliance: ComplianceLevel.notApplicable);
        expect(question.scoreValue, equals(0));
      });

      test('should set isCriticalFailure to true only when selectedCompliance is doesNotMeet', () {
        final q1 = AssessmentQuestion(selectedCompliance: ComplianceLevel.doesNotMeet);
        final q2 = AssessmentQuestion(selectedCompliance: ComplianceLevel.meetsTarget);
        final q3 = AssessmentQuestion(selectedCompliance: ComplianceLevel.partiallyMeets);
        final q4 = AssessmentQuestion(selectedCompliance: ComplianceLevel.pending);
        final q5 = AssessmentQuestion(selectedCompliance: ComplianceLevel.notApplicable);

        expect(q1.isCriticalFailure, isTrue);
        expect(q2.isCriticalFailure, isFalse);
        expect(q3.isCriticalFailure, isFalse);
        expect(q4.isCriticalFailure, isFalse);
        expect(q5.isCriticalFailure, isFalse);
      });

      test('should allow mutating all fields dynamically', () {
        final question = AssessmentQuestion();
        question.id = 'mutated_id';
        question.text = 'New Text';
        question.category = AssessmentCategory.wash;
        question.selectedCompliance = ComplianceLevel.partiallyMeets;

        expect(question.id, equals('mutated_id'));
        expect(question.text, equals('New Text'));
        expect(question.category, equals(AssessmentCategory.wash));
        expect(question.selectedCompliance, equals(ComplianceLevel.partiallyMeets));
      });
    });

    // USER SESSION AND CREDENTIALS
    group('UserSession & LocalUserCredential Unit Tests', () {
      group('UserSession Tests', () {
        test('should initialize UserSession with correct default values', () {
          final session = UserSession();
          expect(session.id, isNotNull);
          expect(session.uid, isNull);
          expect(session.email, isNull);
          expect(session.displayName, isNull);
          expect(session.lastLogin, isNull);
          expect(session.isLoggedIn, isFalse);
          expect(session.isWhoStaff, isFalse);
        });

        test('should allow setting and modifying all UserSession properties', () {
          final session = UserSession();
          final now = DateTime.now().toUtc();

          session.uid = 'firebase_uid_123';
          session.email = 'staff@who.int';
          session.displayName = 'Dr. Tedros';
          session.lastLogin = now;
          session.isLoggedIn = true;
          session.isWhoStaff = true;

          expect(session.uid, equals('firebase_uid_123'));
          expect(session.email, equals('staff@who.int'));
          expect(session.displayName, equals('Dr. Tedros'));
          expect(session.lastLogin, equals(now));
          expect(session.isLoggedIn, isTrue);
          expect(session.isWhoStaff, isTrue);
        });
      });

      group('LocalUserCredential Tests', () {
        test('should initialize LocalUserCredential with correct default values', () {
          final cred = LocalUserCredential();
          expect(cred.id, isNotNull);
          expect(cred.email, isNull);
          expect(cred.displayName, isNull);
          expect(cred.dateOfBirth, isNull);
          expect(cred.passwordHash, isNull);
          expect(cred.pendingPassword, isNull);
          expect(cred.oldPassword, isNull);
          expect(cred.passwordNeedsSync, isFalse);
          expect(cred.isWhoStaff, isFalse);
        });

        test('should allow setting password sync flags and roles independently', () {
          final cred = LocalUserCredential();
          cred.isWhoStaff = true;
          cred.passwordNeedsSync = false;

          expect(cred.isWhoStaff, isTrue);
          expect(cred.passwordNeedsSync, isFalse);

          cred.passwordNeedsSync = true;
          expect(cred.passwordNeedsSync, isTrue);
        });
      });
    });

    // SPATIAL ZONE
    group('SpatialZone Unit Tests', () {
      test('should initialize with correct default values', () {
        final zone = SpatialZone();
        expect(zone.id, equals(''));
        expect(zone.name, equals(''));
        expect(zone.coordinates.top, equals(0.0));
        expect(zone.coordinates.left, equals(0.0));
        expect(zone.coordinates.width, equals(0.0));
        expect(zone.coordinates.height, equals(0.0));
        expect(zone.touchArea.top, equals(0.0));
        expect(zone.touchArea.left, equals(0.0));
        expect(zone.touchArea.width, equals(0.0));
        expect(zone.touchArea.height, equals(0.0));
        expect(zone.checklist, isEmpty);
      });

      group('readinessScore Calculations', () {
        test('should return 0.0 when checklist is empty', () {
          final zone = SpatialZone();
          expect(zone.readinessScore, equals(0.0));
        });

        test('should return 0.0 when all questions are pending', () {
          final zone = SpatialZone(
            checklist: [
              AssessmentQuestion(id: 'q_1', selectedCompliance: ComplianceLevel.pending),
              AssessmentQuestion(id: 'q_2', selectedCompliance: ComplianceLevel.pending),
            ],
          );
          expect(zone.readinessScore, equals(0.0));
        });

        test('should calculate 100.0 score when all answered meet target', () {
          final zone = SpatialZone(
            checklist: [
              AssessmentQuestion(id: 'q_1', selectedCompliance: ComplianceLevel.meetsTarget), // 3/3
              AssessmentQuestion(id: 'q_2', selectedCompliance: ComplianceLevel.meetsTarget), // 3/3
              AssessmentQuestion(id: 'q_3', selectedCompliance: ComplianceLevel.notApplicable), // Excluded
            ],
          );
          expect(zone.readinessScore, equals(100.0));
        });

        test('should calculate correct average score with mixed compliance levels', () {
          final zone = SpatialZone(
            checklist: [
              AssessmentQuestion(id: 'q_1', selectedCompliance: ComplianceLevel.meetsTarget),      // 3
              AssessmentQuestion(id: 'q_2', selectedCompliance: ComplianceLevel.partiallyMeets),  // 2
              AssessmentQuestion(id: 'q_3', selectedCompliance: ComplianceLevel.doesNotMeet),     // 1
              AssessmentQuestion(id: 'q_4', selectedCompliance: ComplianceLevel.pending),         // Excluded
            ],
          );
          expect(zone.readinessScore, closeTo(66.67, 0.01));
        });
      });

      group('completionPercentage Calculations', () {
        test('should return 0.0 when checklist is empty', () {
          final zone = SpatialZone();
          expect(zone.completionPercentage, equals(0.0));
        });

        test('should return 100.0 when all questions are non-pending', () {
          final zone = SpatialZone(
            checklist: [
              AssessmentQuestion(id: 'q1', selectedCompliance: ComplianceLevel.meetsTarget),
              AssessmentQuestion(id: 'q2', selectedCompliance: ComplianceLevel.notApplicable),
            ],
          );
          expect(zone.completionPercentage, equals(100.0));
        });

        test('should calculate correct ratio of non-pending questions', () {
          final zone = SpatialZone(
            checklist: [
              AssessmentQuestion(id: 'q1', selectedCompliance: ComplianceLevel.meetsTarget),
              AssessmentQuestion(id: 'q2', selectedCompliance: ComplianceLevel.pending),
              AssessmentQuestion(id: 'q3', selectedCompliance: ComplianceLevel.doesNotMeet),
            ],
          );
          expect(zone.completionPercentage, closeTo(66.67, 0.01));
        });
      });

      group('statusColor Mapping', () {
        test('should return Colors.grey.shade400 when completionPercentage is 0%', () {
          final zone = SpatialZone(
            checklist: [
              AssessmentQuestion(id: 'q1', selectedCompliance: ComplianceLevel.pending),
            ],
          );
          expect(zone.statusColor, equals(Colors.grey.shade400));
        });

        test('should return Colors.red.shade600 when there is at least one critical failure', () {
          final zone1 = SpatialZone(
            checklist: [
              AssessmentQuestion(id: 'q1', selectedCompliance: ComplianceLevel.doesNotMeet), // CRITICAL
              AssessmentQuestion(id: 'q2', selectedCompliance: ComplianceLevel.pending),
            ],
          );
          expect(zone1.statusColor, equals(Colors.red.shade600));
        });

        test('should return Colors.orange.shade500 when completion is partial (< 100%) and no critical failure', () {
          final zone = SpatialZone(
            checklist: [
              AssessmentQuestion(id: 'q1', selectedCompliance: ComplianceLevel.meetsTarget),
              AssessmentQuestion(id: 'q2', selectedCompliance: ComplianceLevel.pending),
            ],
          );
          expect(zone.statusColor, equals(Colors.orange.shade500));
        });

        test('should return Colors.amber.shade500 when completed (100%) and contains partiallyMeets and no doesNotMeet', () {
          final zone = SpatialZone(
            checklist: [
              AssessmentQuestion(id: 'q1', selectedCompliance: ComplianceLevel.meetsTarget),
              AssessmentQuestion(id: 'q2', selectedCompliance: ComplianceLevel.partiallyMeets),
            ],
          );
          expect(zone.statusColor, equals(Colors.amber.shade500));
        });

        test('should return Colors.green.shade600 when completed (100%) and all meetsTarget or notApplicable', () {
          final zone = SpatialZone(
            checklist: [
              AssessmentQuestion(id: 'q1', selectedCompliance: ComplianceLevel.meetsTarget),
              AssessmentQuestion(id: 'q2', selectedCompliance: ComplianceLevel.notApplicable),
            ],
          );
          expect(zone.statusColor, equals(Colors.green.shade600));
        });
      });
    });

  });
}
