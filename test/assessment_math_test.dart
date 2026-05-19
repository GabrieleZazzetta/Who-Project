import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:assessment_tool/models/assessment_models.dart';

void main() {
  group('1.1 Motore di Calcolo Compliance - Unit Tests', () {
    test('Calcolo Base e Ponderazione: Risposte miste escludendo N/A e Pending', () {
      final zone = SpatialZone(
        id: 'zone_test',
        name: 'Zone Test',
        checklist: [
          AssessmentQuestion(
            id: 'q1',
            text: 'Question 1',
            selectedCompliance: ComplianceLevel.meetsTarget, // Punteggio: 3/3
          ),
          AssessmentQuestion(
            id: 'q2',
            text: 'Question 2',
            selectedCompliance: ComplianceLevel.partiallyMeets, // Punteggio: 2/3
          ),
          AssessmentQuestion(
            id: 'q3',
            text: 'Question 3',
            selectedCompliance: ComplianceLevel.doesNotMeet, // Punteggio: 1/3
          ),
          AssessmentQuestion(
            id: 'q4',
            text: 'Question 4',
            selectedCompliance: ComplianceLevel.notApplicable, // Escluso dal calcolo
          ),
          AssessmentQuestion(
            id: 'q5',
            text: 'Question 5',
            selectedCompliance: ComplianceLevel.pending, // Escluso dal calcolo
          ),
        ],
      );

      // Punteggio effettivo: 3 (Meets) + 2 (Partially) + 1 (Does Not Meet) = 6
      // Punteggio massimo teorico: 3 domande valide * 3 = 9
      // Calcolo: (6 / 9) * 100 = 66.6666...
      expect(zone.readinessScore, closeTo(66.67, 0.01));
      
      // Percentuale di completamento: 3 valutate (meets, partially, doesNotMeet) + 1 N/A valutata = 4 risposte non pending.
      // Su 5 domande totali: (4 / 5) * 100 = 80.0%
      expect(zone.completionPercentage, equals(80.0));
    });

    test('Critical Failures: Una risposta "Does Not Meet" deve flaggare la zona in Rosso', () {
      final zone = SpatialZone(
        id: 'zone_critical_test',
        name: 'Zone Critical Test',
        checklist: [
          AssessmentQuestion(
            id: 'q1',
            text: 'Question 1',
            selectedCompliance: ComplianceLevel.meetsTarget,
          ),
          AssessmentQuestion(
            id: 'q2',
            text: 'Question 2',
            selectedCompliance: ComplianceLevel.doesNotMeet, // Violazione critica!
          ),
        ],
      );

      // Verifica che la domanda sia contrassegnata come fallimento critico
      expect(zone.checklist[1].isCriticalFailure, isTrue);
      expect(zone.checklist[0].isCriticalFailure, isFalse);

      // Colore dello stato: deve essere rosso (Colors.red.shade600)
      expect(zone.statusColor, equals(Colors.red.shade600));
    });

    test('Aggregazione: globalReadinessScore calcolato correttamente dalle sole zone compilate', () {
      final layout = FacilityLayout(
        facilityName: 'Clinic Alpha',
        zones: [
          SpatialZone(
            id: 'z1',
            name: 'Zone 1',
            checklist: [
              AssessmentQuestion(
                id: 'q1',
                text: 'Q1',
                selectedCompliance: ComplianceLevel.meetsTarget, // 3/3 = 100%
              ),
            ],
          ),
          SpatialZone(
            id: 'z2',
            name: 'Zone 2',
            checklist: [
              AssessmentQuestion(
                id: 'q2',
                text: 'Q2',
                selectedCompliance: ComplianceLevel.partiallyMeets, // 2/3 = 66.67%
              ),
            ],
          ),
          SpatialZone(
            id: 'z3',
            name: 'Zone 3', // Incompleta / non compilata (solo pending)
            checklist: [
              AssessmentQuestion(
                id: 'q3',
                text: 'Q3',
                selectedCompliance: ComplianceLevel.pending, // 0/0 = 0% completamento
              ),
            ],
          ),
        ],
      );

      // Verifica dei readinessScore delle singole zone
      expect(layout.zones[0].readinessScore, equals(100.0));
      expect(layout.zones[1].readinessScore, closeTo(66.67, 0.01));
      expect(layout.zones[2].readinessScore, equals(0.0));

      // Verifica della percentuale di completamento delle singole zone
      expect(layout.zones[0].completionPercentage, equals(100.0));
      expect(layout.zones[1].completionPercentage, equals(100.0));
      expect(layout.zones[2].completionPercentage, equals(0.0));

      // Il punteggio globale è la media dei punteggi delle sole zone compilate (con completamento > 0%)
      // Zone valide: z1 (100.0%) e z2 (66.6666%) -> Media: (100.0 + 66.6666...) / 2 = 83.333...
      expect(layout.globalReadinessScore, closeTo(83.33, 0.01));
    });

    test('Edge Case - Division By Zero: SpatialZone senza domande o solo N/A deve restituire 0.0 e non crashare', () {
      final emptyZone = SpatialZone(
        id: 'z_empty',
        name: 'Empty Zone',
        checklist: [],
      );

      expect(() => emptyZone.readinessScore, returnsNormally);
      expect(emptyZone.readinessScore, equals(0.0));
      expect(emptyZone.completionPercentage, equals(0.0));

      final naOnlyZone = SpatialZone(
        id: 'z_na',
        name: 'N/A Zone',
        checklist: [
          AssessmentQuestion(
            id: 'q1',
            text: 'Q1',
            selectedCompliance: ComplianceLevel.notApplicable,
          ),
          AssessmentQuestion(
            id: 'q2',
            text: 'Q2',
            selectedCompliance: ComplianceLevel.pending,
          ),
        ],
      );

      expect(() => naOnlyZone.readinessScore, returnsNormally);
      expect(naOnlyZone.readinessScore, equals(0.0));
      // Completamento: 1 non pending (notApplicable) su 2 totali = 50.0%
      expect(naOnlyZone.completionPercentage, equals(50.0));
    });
  });
}
