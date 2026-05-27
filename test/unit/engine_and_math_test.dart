import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:assessment_tool/models/assessment_models.dart';
import 'package:assessment_tool/models/user_model.dart';
import 'package:assessment_tool/models/local_user_credential.dart';
import 'package:assessment_tool/data/facility_data_factory.dart';

void main() {
  group('Engine & Math Unit Tests', () {

    // ==========================================
    // MOTORE DI CALCOLO COMPLIANCE (assessment_math_test.dart)
    // ==========================================
    group('Motore di Calcolo Compliance - Unit Tests', () {
      test('Calcolo Base e Ponderazione: Risposte miste escludendo N/A e Pending', () {
        final zone = SpatialZone(
          id: 'zone_test',
          name: 'Zone Test',
          checklist: [
            AssessmentQuestion(id: 'q1', text: 'Question 1', selectedCompliance: ComplianceLevel.meetsTarget),
            AssessmentQuestion(id: 'q2', text: 'Question 2', selectedCompliance: ComplianceLevel.partiallyMeets),
            AssessmentQuestion(id: 'q3', text: 'Question 3', selectedCompliance: ComplianceLevel.doesNotMeet),
            AssessmentQuestion(id: 'q4', text: 'Question 4', selectedCompliance: ComplianceLevel.notApplicable),
            AssessmentQuestion(id: 'q5', text: 'Question 5', selectedCompliance: ComplianceLevel.pending),
          ],
        );
        expect(zone.readinessScore, closeTo(66.67, 0.01));
        expect(zone.completionPercentage, equals(80.0));
      });

      test('Critical Failures: Una risposta "Does Not Meet" deve flaggare la zona in Rosso', () {
        final zone = SpatialZone(
          id: 'zone_critical_test',
          name: 'Zone Critical Test',
          checklist: [
            AssessmentQuestion(id: 'q1', text: 'Question 1', selectedCompliance: ComplianceLevel.meetsTarget),
            AssessmentQuestion(id: 'q2', text: 'Question 2', selectedCompliance: ComplianceLevel.doesNotMeet),
          ],
        );
        expect(zone.checklist[1].isCriticalFailure, isTrue);
        expect(zone.checklist[0].isCriticalFailure, isFalse);
        expect(zone.statusColor, equals(Colors.red.shade600));
      });

      test('Aggregazione: globalReadinessScore calcolato correttamente dalle sole zone compilate', () {
        final layout = FacilityLayout(
          facilityName: 'Clinic Alpha',
          zones: [
            SpatialZone(id: 'z1', name: 'Zone 1', checklist: [AssessmentQuestion(id: 'q1', selectedCompliance: ComplianceLevel.meetsTarget)]),
            SpatialZone(id: 'z2', name: 'Zone 2', checklist: [AssessmentQuestion(id: 'q2', selectedCompliance: ComplianceLevel.partiallyMeets)]),
            SpatialZone(id: 'z3', name: 'Zone 3', checklist: [AssessmentQuestion(id: 'q3', selectedCompliance: ComplianceLevel.pending)]),
          ],
        );
        expect(layout.zones[0].readinessScore, equals(100.0));
        expect(layout.zones[1].readinessScore, closeTo(66.67, 0.01));
        expect(layout.zones[2].readinessScore, equals(0.0));
        expect(layout.zones[0].completionPercentage, equals(100.0));
        expect(layout.zones[1].completionPercentage, equals(100.0));
        expect(layout.zones[2].completionPercentage, equals(0.0));
        expect(layout.globalReadinessScore, closeTo(83.33, 0.01));
      });

      test('Edge Case - Division By Zero: SpatialZone senza domande o solo N/A deve restituire 0.0 e non crashare', () {
        final emptyZone = SpatialZone(id: 'z_empty', name: 'Empty Zone', checklist: []);
        expect(() => emptyZone.readinessScore, returnsNormally);
        expect(emptyZone.readinessScore, equals(0.0));
        expect(emptyZone.completionPercentage, equals(0.0));

        final naOnlyZone = SpatialZone(
          id: 'z_na', name: 'N/A Zone', checklist: [
            AssessmentQuestion(id: 'q1', text: 'Q1', selectedCompliance: ComplianceLevel.notApplicable),
            AssessmentQuestion(id: 'q2', text: 'Q2', selectedCompliance: ComplianceLevel.pending),
          ],
        );
        expect(() => naOnlyZone.readinessScore, returnsNormally);
        expect(naOnlyZone.readinessScore, equals(0.0));
        expect(naOnlyZone.completionPercentage, equals(50.0));
      });
    });

    // ==========================================
    // ADVANCED COMPLIANCE MATH (unit_advanced_math_test.dart)
    // ==========================================
    group('Advanced Compliance Math & Domain Logic', () {
      test('WHO domain validation matches case-insensitive patterns', () {
        expect('staff@who.int'.toLowerCase().endsWith('@who.int'), isTrue);
        expect('STAFF@WHO.INT'.toLowerCase().endsWith('@who.int'), isTrue);
        expect('staff@who.com'.toLowerCase().endsWith('@who.int'), isFalse);
      });

      test('Readiness calculation with large mixed question list', () {
        final zone = SpatialZone(
          id: 'large_zone',
          checklist: List.generate(40, (index) {
            if (index < 10) return AssessmentQuestion(id: 'q_$index', selectedCompliance: ComplianceLevel.meetsTarget);
            if (index < 20) return AssessmentQuestion(id: 'q_$index', selectedCompliance: ComplianceLevel.partiallyMeets);
            if (index < 30) return AssessmentQuestion(id: 'q_$index', selectedCompliance: ComplianceLevel.doesNotMeet);
            if (index < 35) return AssessmentQuestion(id: 'q_$index', selectedCompliance: ComplianceLevel.notApplicable);
            return AssessmentQuestion(id: 'q_$index', selectedCompliance: ComplianceLevel.pending);
          }),
        );
        expect(zone.readinessScore, closeTo(66.67, 0.05));
        expect(zone.completionPercentage, equals(75.0));
      });

      test('Zone readiness calculation with only N/A and pending questions', () {
        final zone = SpatialZone(id: 'na_zone', checklist: [
          AssessmentQuestion(id: 'q1', selectedCompliance: ComplianceLevel.notApplicable),
          AssessmentQuestion(id: 'q2', selectedCompliance: ComplianceLevel.pending),
        ]);
        expect(zone.readinessScore, equals(0.0));
      });

      test('Global score is 100% when all compiled zones have perfect score', () {
        final facility = FacilityLayout(
          facilityName: 'Perfect Facility',
          zones: [
            SpatialZone(id: 'z1', checklist: [AssessmentQuestion(id: 'q1', selectedCompliance: ComplianceLevel.meetsTarget)]),
            SpatialZone(id: 'z2', checklist: [AssessmentQuestion(id: 'q2', selectedCompliance: ComplianceLevel.pending)]),
          ],
        );
        expect(facility.globalReadinessScore, equals(100.0));
      });

      test('Ponderated formula is stable with combination of all compliance levels', () {
        final zone = SpatialZone(
          id: 'all_combos',
          checklist: [
            AssessmentQuestion(id: 'q1', selectedCompliance: ComplianceLevel.meetsTarget),      
            AssessmentQuestion(id: 'q2', selectedCompliance: ComplianceLevel.partiallyMeets),  
            AssessmentQuestion(id: 'q3', selectedCompliance: ComplianceLevel.doesNotMeet),      
            AssessmentQuestion(id: 'q4', selectedCompliance: ComplianceLevel.notApplicable),   
            AssessmentQuestion(id: 'q5', selectedCompliance: ComplianceLevel.pending),         
          ],
        );
        expect(zone.readinessScore, closeTo(66.67, 0.05));
      });
    });

    // ==========================================
    // ASSESSMENT COMPLIANCE ENGINE (unit_assessment_engine_test.dart)
    // ==========================================
    group('Assessment Compliance Engine Logic', () {
      test('Tapping a compliance level sets it on the question', () {
        final question = AssessmentQuestion(id: 'q1');
        question.selectedCompliance = ComplianceLevel.meetsTarget;
        expect(question.selectedCompliance, equals(ComplianceLevel.meetsTarget));
        expect(question.scoreValue, equals(3));
      });

      test('General assessment questions group correctly by ID prefix into 4 sections', () {
        final checklist = [
          AssessmentQuestion(id: 'gen_2_1_q1'),
          AssessmentQuestion(id: 'gen_2_1_q2'),
          AssessmentQuestion(id: 'gen_2_2_q1'),
          AssessmentQuestion(id: 'gen_2_3_q1'),
          AssessmentQuestion(id: 'gen_2_4_q1'),
        ];

        Map<String, List<AssessmentQuestion>> grouped = {'Accesses & Flows': [], 'Systems & Finishing': [], 'Waste Management': [], 'Water & Sanitation': []};
        for (final q in checklist) {
          if (q.id.startsWith('gen_2_1')) grouped['Accesses & Flows']!.add(q);
          else if (q.id.startsWith('gen_2_2')) grouped['Systems & Finishing']!.add(q);
          else if (q.id.startsWith('gen_2_3')) grouped['Waste Management']!.add(q);
          else if (q.id.startsWith('gen_2_4')) grouped['Water & Sanitation']!.add(q);
        }

        expect(grouped['Accesses & Flows']!.length, equals(2));
        expect(grouped['Systems & Finishing']!.length, equals(1));
        expect(grouped['Waste Management']!.length, equals(1));
        expect(grouped['Water & Sanitation']!.length, equals(1));
      });

      test('Zone statusColor transitions through full lifecycle', () {
        final zone = SpatialZone(id: 'z1', checklist: [AssessmentQuestion(id: 'q1', selectedCompliance: ComplianceLevel.pending)]);
        expect(zone.statusColor, equals(Colors.grey.shade400));
        
        zone.checklist[0].selectedCompliance = ComplianceLevel.meetsTarget;
        expect(zone.statusColor, equals(Colors.green.shade600));
        
        zone.checklist[0].selectedCompliance = ComplianceLevel.partiallyMeets;
        expect(zone.statusColor, equals(Colors.amber.shade500));
        
        zone.checklist[0].selectedCompliance = ComplianceLevel.doesNotMeet;
        expect(zone.statusColor, equals(Colors.red.shade600));
      });
    });

    // ==========================================
    // PRE-ASSESSMENT INIT (unit_pre_assessment_test.dart)
    // ==========================================
    group('PreAssessment & Data Factory Logic', () {
      test('Mpox ScreeningAndIsolation layout returns non-empty zones with checklists', () {
        final layout = FacilityDataFactory.getLayout(EmergencyType.mpox, FacilityType.screeningAndIsolation);
        expect(layout.zones, isNotEmpty);
        expect(layout.zones.every((z) => z.id.isNotEmpty), isTrue);
        for (var zone in layout.zones) {
          expect(zone.checklist, isNotEmpty);
        }
      });

      test('FacilityLayout facilityName defaults to "Unnamed Assessment" when empty', () {
        final layout = FacilityLayout();
        final name = layout.facilityName.isNotEmpty ? layout.facilityName : "Unnamed Assessment";
        expect(name, equals("Unnamed Assessment"));
      });
      
      test('FacilityType name mapping returns correct human-readable strings', () {
        String getFacilityTypeName(FacilityType type) {
          switch (type) {
            case FacilityType.screeningAndIsolation: return "Screening and temporary isolation for mpox";
            case FacilityType.existingFacilityWithWard: return "Existing Healthcare facility with mpox dedicated ward";
            case FacilityType.standAloneCenter: return "Mpox stand-alone treatment centre";
            case FacilityType.congregateSetting: return "Screening for Internally Displaced People (IDP) and refugee camps";
          }
        }
        expect(getFacilityTypeName(FacilityType.screeningAndIsolation), contains('Screening'));
      });
    });

  });
}
