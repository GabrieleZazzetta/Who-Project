import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:assessment_tool/models/assessment_models.dart';

void main() {
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

    test('should correctly assign constructor parameters', () {
      final zone = SpatialZone(
        id: 'z_1',
        name: 'Screening',
        coordinates: const MapCoordinates(top: 10, left: 20, width: 30, height: 40),
        touchArea: const MapCoordinates(top: 12, left: 22, width: 28, height: 38),
        checklist: [
          AssessmentQuestion(id: 'q_1', text: 'Q1'),
        ],
      );
      expect(zone.id, equals('z_1'));
      expect(zone.name, equals('Screening'));
      expect(zone.coordinates.top, equals(10.0));
      expect(zone.coordinates.left, equals(20.0));
      expect(zone.coordinates.width, equals(30.0));
      expect(zone.coordinates.height, equals(40.0));
      expect(zone.touchArea.top, equals(12.0));
      expect(zone.touchArea.left, equals(22.0));
      expect(zone.touchArea.width, equals(28.0));
      expect(zone.touchArea.height, equals(38.0));
      expect(zone.checklist.length, equals(1));
      expect(zone.checklist.first.id, equals('q_1'));
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

      test('should return 0.0 when all questions are notApplicable', () {
        final zone = SpatialZone(
          checklist: [
            AssessmentQuestion(id: 'q_1', selectedCompliance: ComplianceLevel.notApplicable),
            AssessmentQuestion(id: 'q_2', selectedCompliance: ComplianceLevel.notApplicable),
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
        // Punteggio: 3 + 2 + 1 = 6. Max: 3 * 3 = 9. Score: (6 / 9) * 100 = 66.666...
        expect(zone.readinessScore, closeTo(66.67, 0.01));
      });
    });

    group('completionPercentage Calculations', () {
      test('should return 0.0 when checklist is empty', () {
        final zone = SpatialZone();
        expect(zone.completionPercentage, equals(0.0));
      });

      test('should return 0.0 when all questions are pending', () {
        final zone = SpatialZone(
          checklist: [
            AssessmentQuestion(id: 'q1', selectedCompliance: ComplianceLevel.pending),
          ],
        );
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
        // 2 non-pending su 3 totali = 66.666...
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
        final zone2 = SpatialZone(
          checklist: [
            AssessmentQuestion(id: 'q1', selectedCompliance: ComplianceLevel.doesNotMeet), // CRITICAL
            AssessmentQuestion(id: 'q2', selectedCompliance: ComplianceLevel.meetsTarget),
          ],
        );
        expect(zone1.statusColor, equals(Colors.red.shade600));
        expect(zone2.statusColor, equals(Colors.red.shade600));
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
}
