import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:assessment_tool/models/assessment_models.dart';

void main() {
  group('Project Utilities & Formatter Unit Tests', () {
    test('Date formatting using DateFormat matches expected layout', () {
      final date = DateTime(2026, 5, 18, 12, 0, 0);
      final formatted = DateFormat('dd MMM yyyy').format(date);
      expect(formatted, equals('18 May 2026'));
    });

    test('Facility Name sanitization for file system naming matches requirements', () {
      final rawName = 'Hospital / Al-Shifa * & Gaza';
      final cleanName = rawName.replaceAll(RegExp(r'[\\/:*?"<>|]'), '_');
      expect(cleanName, equals('Hospital _ Al-Shifa _ & Gaza'));
    });

    test('Compliance level translation and score values mapping', () {
      final values = ComplianceLevel.values;
      expect(values.length, equals(5));

      final scores = values.map((v) {
        switch (v) {
          case ComplianceLevel.meetsTarget:
            return 3;
          case ComplianceLevel.partiallyMeets:
            return 2;
          case ComplianceLevel.doesNotMeet:
            return 1;
          default:
            return 0;
        }
      }).toList();

      expect(scores, equals([3, 2, 1, 0, 0]));
    });

    test('Global compliance criteria checklist details recovery', () {
      final criteria = globalComplianceCriteria['q1_screening_location'];
      expect(criteria, isNotNull);
      expect(criteria![ComplianceLevel.meetsTarget], contains('A screening area is placed'));
      expect(criteria[ComplianceLevel.doesNotMeet], contains('NOT all patients pass'));
    });
  });
}
