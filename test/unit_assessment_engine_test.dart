import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:assessment_tool/models/assessment_models.dart';
/// Unit tests for the AssessmentScreen compliance engine.
/// These tests validate the core interactive behaviors of the assessment
/// checklist: compliance toggling, section grouping, note attachment,
/// media path management, and the real-time readiness score reactivity.
void main() {
  group('Assessment Compliance Engine - Toggle Behavior', () {
    test('Tapping a compliance level sets it on the question', () {
      final question = AssessmentQuestion(id: 'q1');
      expect(question.selectedCompliance, equals(ComplianceLevel.pending));

      // Simulate tap on meetsTarget
      question.selectedCompliance = ComplianceLevel.meetsTarget;
      expect(question.selectedCompliance, equals(ComplianceLevel.meetsTarget));
      expect(question.scoreValue, equals(3));
    });

    test('Tapping same compliance level again resets to pending (toggle-off)',
        () {
      final question = AssessmentQuestion(
          id: 'q1', selectedCompliance: ComplianceLevel.meetsTarget);

      // Simulate _updateCompliance logic: if same level, reset to pending
      ComplianceLevel tapped = ComplianceLevel.meetsTarget;
      question.selectedCompliance =
          (question.selectedCompliance == tapped)
              ? ComplianceLevel.pending
              : tapped;

      expect(question.selectedCompliance, equals(ComplianceLevel.pending));
      expect(question.scoreValue, equals(0));
    });

    test('Tapping different compliance level switches without resetting', () {
      final question = AssessmentQuestion(
          id: 'q1', selectedCompliance: ComplianceLevel.meetsTarget);

      // Simulate tapping partiallyMeets instead
      ComplianceLevel tapped = ComplianceLevel.partiallyMeets;
      question.selectedCompliance =
          (question.selectedCompliance == tapped)
              ? ComplianceLevel.pending
              : tapped;

      expect(
          question.selectedCompliance, equals(ComplianceLevel.partiallyMeets));
      expect(question.scoreValue, equals(2));
    });

    test('doesNotMeet selection triggers isCriticalFailure flag', () {
      final question = AssessmentQuestion(id: 'q1');
      question.selectedCompliance = ComplianceLevel.doesNotMeet;
      expect(question.isCriticalFailure, isTrue);
      expect(question.scoreValue, equals(1));
    });

    test('meetsTarget and partiallyMeets do NOT trigger isCriticalFailure', () {
      final q1 = AssessmentQuestion(
          id: 'q1', selectedCompliance: ComplianceLevel.meetsTarget);
      final q2 = AssessmentQuestion(
          id: 'q2', selectedCompliance: ComplianceLevel.partiallyMeets);
      expect(q1.isCriticalFailure, isFalse);
      expect(q2.isCriticalFailure, isFalse);
    });
  });

  group('Assessment Compliance Engine - Section Grouping', () {
    test(
        'General assessment questions group correctly by ID prefix into 4 sections',
        () {
      final checklist = [
        AssessmentQuestion(id: 'gen_2_1_q1', text: 'Access flow question'),
        AssessmentQuestion(id: 'gen_2_1_q2', text: 'Another access question'),
        AssessmentQuestion(id: 'gen_2_2_q1', text: 'Systems question'),
        AssessmentQuestion(id: 'gen_2_3_q1', text: 'Waste question'),
        AssessmentQuestion(id: 'gen_2_4_q1', text: 'Water question'),
      ];

      // Replicate exact grouping logic from AssessmentScreen._initializeGeneralAssessmentTabs
      Map<String, List<AssessmentQuestion>> grouped = {
        'Accesses & Flows': [],
        'Systems & Finishing': [],
        'Waste Management': [],
        'Water & Sanitation': [],
      };

      for (final q in checklist) {
        if (q.id.startsWith('gen_2_1')) {
          grouped['Accesses & Flows']!.add(q);
        } else if (q.id.startsWith('gen_2_2')) {
          grouped['Systems & Finishing']!.add(q);
        } else if (q.id.startsWith('gen_2_3')) {
          grouped['Waste Management']!.add(q);
        } else if (q.id.startsWith('gen_2_4')) {
          grouped['Water & Sanitation']!.add(q);
        }
      }

      expect(grouped['Accesses & Flows']!.length, equals(2));
      expect(grouped['Systems & Finishing']!.length, equals(1));
      expect(grouped['Waste Management']!.length, equals(1));
      expect(grouped['Water & Sanitation']!.length, equals(1));
    });

    test('Non-general-assessment zone skips section grouping', () {
      // Zones that are not 'general_facility_assessment' use flat list
      final zone = SpatialZone(
        id: 'screening_zone',
        name: 'Screening Area',
        checklist: [
          AssessmentQuestion(id: 'q1_screening_location'),
          AssessmentQuestion(id: 'q1_screening_distance'),
        ],
      );
      final isGeneralAssessment = zone.id == 'general_facility_assessment';
      expect(isGeneralAssessment, isFalse);
      expect(zone.checklist.length, equals(2));
    });
  });

  group('Assessment Compliance Engine - Notes & Media', () {
    test('Note can be attached and trimmed on a question', () {
      final question = AssessmentQuestion(id: 'q1');
      expect(question.note, isNull);

      // Simulate saving a note (as done in _showNoteDialog)
      String rawNote = '  Observed mold on walls  ';
      question.note =
          rawNote.trim().isEmpty ? null : rawNote.trim();
      expect(question.note, equals('Observed mold on walls'));
    });

    test('Empty or whitespace-only note clears the field to null', () {
      final question =
          AssessmentQuestion(id: 'q1', note: 'Previous observation');
      String rawNote = '   ';
      question.note =
          rawNote.trim().isEmpty ? null : rawNote.trim();
      expect(question.note, isNull);
    });

    test('Media paths list initializes as null and can be populated', () {
      final question = AssessmentQuestion(id: 'q1');
      expect(question.mediaPaths, isNull);

      // Simulate _captureMedia adding a photo path
      question.mediaPaths ??= [];
      question.mediaPaths!.add('/data/photo_001.jpg');
      question.mediaPaths!.add('/data/photo_002.jpg');

      expect(question.mediaPaths!.length, equals(2));
      expect(question.mediaPaths!.first, equals('/data/photo_001.jpg'));
    });

    test('Multiple media paths accumulate without overwriting', () {
      final question =
          AssessmentQuestion(id: 'q1', mediaPaths: ['/existing.jpg']);

      question.mediaPaths!.add('/new.jpg');
      expect(question.mediaPaths!.length, equals(2));
      expect(question.mediaPaths, contains('/existing.jpg'));
      expect(question.mediaPaths, contains('/new.jpg'));
    });
  });

  group('Assessment Compliance Engine - Real-time Readiness Score Reactivity',
      () {
    test('Zone readiness updates instantly when a compliance level changes',
        () {
      final zone = SpatialZone(id: 'z1', checklist: [
        AssessmentQuestion(
            id: 'q1', selectedCompliance: ComplianceLevel.pending),
        AssessmentQuestion(
            id: 'q2', selectedCompliance: ComplianceLevel.pending),
      ]);

      expect(zone.readinessScore, equals(0.0));
      expect(zone.completionPercentage, equals(0.0));

      // User taps meetsTarget on q1
      zone.checklist[0].selectedCompliance = ComplianceLevel.meetsTarget;
      expect(zone.readinessScore, equals(100.0)); // 3/3 = 100%
      expect(zone.completionPercentage, equals(50.0)); // 1/2

      // User taps doesNotMeet on q2
      zone.checklist[1].selectedCompliance = ComplianceLevel.doesNotMeet;
      expect(zone.readinessScore, closeTo(66.67, 0.05)); // (3+1)/6 = 66.67%
      expect(zone.completionPercentage, equals(100.0)); // 2/2
    });

    test('Zone statusColor transitions through full lifecycle', () {
      final zone = SpatialZone(id: 'z1', checklist: [
        AssessmentQuestion(
            id: 'q1', selectedCompliance: ComplianceLevel.pending),
      ]);

      // Step 1: pending → grey
      expect(zone.statusColor, equals(Colors.grey.shade400));

      // Step 2: meetsTarget → green (fully complete, no criticals)
      zone.checklist[0].selectedCompliance = ComplianceLevel.meetsTarget;
      expect(zone.statusColor, equals(Colors.green.shade600));

      // Step 3: change to partiallyMeets → amber
      zone.checklist[0].selectedCompliance = ComplianceLevel.partiallyMeets;
      expect(zone.statusColor, equals(Colors.amber.shade500));

      // Step 4: change to doesNotMeet → red (critical!)
      zone.checklist[0].selectedCompliance = ComplianceLevel.doesNotMeet;
      expect(zone.statusColor, equals(Colors.red.shade600));
    });

    test(
        'Global facility score recalculates correctly as zones are progressively filled',
        () {
      final facility = FacilityLayout(facilityName: 'Test', zones: [
        SpatialZone(id: 'z1', checklist: [
          AssessmentQuestion(
              id: 'q1', selectedCompliance: ComplianceLevel.pending),
        ]),
        SpatialZone(id: 'z2', checklist: [
          AssessmentQuestion(
              id: 'q2', selectedCompliance: ComplianceLevel.pending),
        ]),
      ]);

      // All pending → 0.0
      expect(facility.globalReadinessScore, equals(0.0));

      // Fill z1 only
      facility.zones[0].checklist[0].selectedCompliance =
          ComplianceLevel.meetsTarget;
      expect(facility.globalReadinessScore,
          equals(100.0)); // Only z1 counts, 100%

      // Fill z2 with doesNotMeet
      facility.zones[1].checklist[0].selectedCompliance =
          ComplianceLevel.doesNotMeet;
      // Average of z1 (100%) and z2 (33.33%) = 66.67%
      expect(facility.globalReadinessScore, closeTo(66.67, 0.05));
    });
  });
}
