import 'package:flutter_test/flutter_test.dart';
import 'package:assessment_tool/models/assessment_models.dart';

void main() {
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

    test('should handle optional mediaPaths lists', () {
      final question = AssessmentQuestion();
      expect(question.mediaPaths, isNull);

      question.mediaPaths = [];
      expect(question.mediaPaths, isEmpty);

      question.mediaPaths!.add('path_1');
      expect(question.mediaPaths, contains('path_1'));
    });

    test('should handle optional notes strings', () {
      final question = AssessmentQuestion();
      expect(question.note, isNull);

      question.note = 'Initial note';
      expect(question.note, equals('Initial note'));
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

    test('should handle all AssessmentCategory enums correctly', () {
      final categories = AssessmentCategory.values;
      expect(categories.length, equals(4));
      expect(categories, contains(AssessmentCategory.infectionPreventionControl));
      expect(categories, contains(AssessmentCategory.wash));
      expect(categories, contains(AssessmentCategory.spatialLayout));
      expect(categories, contains(AssessmentCategory.logistics));
    });
  });
}
