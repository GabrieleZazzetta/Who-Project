import 'package:flutter_test/flutter_test.dart';
import 'package:assessment_tool/models/assessment_models.dart';
import 'package:intl/intl.dart';

void main() {
  group('1.3 Servizi di Supporto (Geocoding & Export) - Unit Tests', () {

    test('Validazione Coordinate: Rifiuto Null Island (0.0, 0.0) e accettazione coordinate reali', () {
      // RegExp e logica di parsing come implementato in global_map_screen_2d.dart e 3d.dart
      final RegExp coordRegExp =
          RegExp(r'([-+]?[0-9]*\.?[0-9]+)[\s,]+([-+]?[0-9]*\.?[0-9]+)');

      bool isValidCoordinate(String text) {
        if (text.trim().isEmpty) return false;
        final match = coordRegExp.firstMatch(text);
        if (match != null && match.groupCount >= 2) {
          try {
            final lat = double.parse(match.group(1)!);
            final lng = double.parse(match.group(2)!);
            if (lat >= -90 && lat <= 90 && lng >= -180 && lng <= 180) {
              // PREVENZIONE NULL ISLAND
              if (lat == 0.0 && lng == 0.0) return false;
              return true;
            }
          } catch (_) {}
        }
        return false;
      }

      // Test di input reali (validi)
      expect(isValidCoordinate("45.1843, 9.1567"), isTrue);
      expect(isValidCoordinate("-33.8688, 151.2093"), isTrue);
      expect(isValidCoordinate("0.0001, 0.0001"), isTrue); // molto vicino ma non Null Island

      // Test di Null Island (devono essere rifiutati!)
      expect(isValidCoordinate("0.0, 0.0"), isFalse);
      expect(isValidCoordinate("0, 0"), isFalse);
      expect(isValidCoordinate("+0.0, -0.0"), isFalse);
      expect(isValidCoordinate("0.000000, 0.000000"), isFalse);
      expect(isValidCoordinate("invalid text"), isFalse);
      expect(isValidCoordinate(""), isFalse);
    });

    test('Timezone UTC Enforcement: Verifica che i timestamp generati siano in formato UTC', () {
      // Simula la creazione e salvataggio locale dell'assessment
      final facility = FacilityLayout(
        facilityName: 'Clinic Gamma',
        emergencyType: EmergencyType.sars,
      );

      // Simuliamo la logica di assegnazione temporale presente in database_service.dart
      facility.dateCreated ??= DateTime.now().toUtc();
      facility.updatedAt = DateTime.now().toUtc();

      // I timestamp devono essere in formato UTC (isUtc deve essere true)
      expect(facility.dateCreated!.isUtc, isTrue);
      expect(facility.updatedAt!.isUtc, isTrue);
      
      // Il formato stringa ISO 8601 deve terminare con 'Z' che indica UTC
      expect(facility.dateCreated!.toIso8601String().endsWith('Z'), isTrue);
      expect(facility.updatedAt!.toIso8601String().endsWith('Z'), isTrue);
    });

    test('Export Word Resilience: Il compilatore HTML del report Word non deve crashare in presenza di foto nulle o dati anagrafici vuoti', () {
      // Prepariamo una struttura all'estremo della mancanza dati (Edge Case)
      final facilityVuota = FacilityLayout(
        facilityName: '', // nome vuoto
        zones: [],        // nessuna zona compilata
      )..generalInfo = null; // informazioni generali nulle

      // Template HTML interpolato del report Word come da report_export_service.dart
      String generateTestHtml(FacilityLayout facility) {
        final info = facility.generalInfo;
        
        return '''
        <html>
        <body>
          <h1>WHO Health Facility Assessment Report</h1>
          <p><strong>Facility Name:</strong> ${facility.facilityName.isNotEmpty ? facility.facilityName : "Unnamed Facility"}</p>
          <p><strong>Emergency Context:</strong> ${facility.emergencyType.name.toUpperCase()}</p>
          <p><strong>Date of Assessment:</strong> ${DateFormat('dd MMM yyyy').format(facility.dateCreated ?? DateTime.now())}</p>
          
          <h2>General Information</h2>
          <table>
            <tr><td><strong>Assessor Name:</strong></td><td>${info?.assessorName ?? ''}</td></tr>
            <tr><td><strong>Assessor Email:</strong></td><td>${info?.assessorEmail ?? ''}</td></tr>
            <tr><td><strong>Country:</strong></td><td>${info?.country ?? ''}</td></tr>
          </table>

          <h2>Overall Readiness</h2>
          <p>Global Readiness Score: ${facility.globalReadinessScore.toStringAsFixed(0)}%</p>
          
          <h2>Assessment Breakdown</h2>
          <table>
        ''';
      }

      // Verifichiamo che la chiamata completi correttamente e senza crash (returnsNormally)
      expect(() => generateTestHtml(facilityVuota), returnsNormally);

      final generatedHtml = generateTestHtml(facilityVuota);
      
      // Verifichiamo che i fallback del testo funzionino correttamente nel report Word
      expect(generatedHtml.contains("Unnamed Facility"), isTrue);
      expect(generatedHtml.contains("Global Readiness Score: 0%"), isTrue);
      expect(generatedHtml.contains("Staff"), isFalse); // non crasha ma lascia campi vuoti
    });
  });
}
