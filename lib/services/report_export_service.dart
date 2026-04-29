import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../models/assessment_models.dart';
import 'package:intl/intl.dart';

class ReportExportService {
  /// Genera e condivide un file Word editabile (.doc) tramite HTML Formattato
  static Future<void> exportAssessmentToEditableWord(BuildContext context, FacilityLayout facility) async {
    try {
      // 1. Generiamo una stringa HTML con i meta-tag di Microsoft Office.
      // Questo trucco permette a Word di interpretare l'HTML come un vero documento editabile!
      String htmlContent = '''
      <html xmlns:o="urn:schemas-microsoft-com:office:office"
            xmlns:w="urn:schemas-microsoft-com:office:word"
            xmlns="http://www.w3.org/TR/REC-html40">
      <head>
        <meta charset="utf-8">
        <title>WHO Assessment Report</title>
        <style>
          body { font-family: Arial, sans-serif; color: #333; }
          h1 { color: #005DA8; }
          h2 { color: #003D73; border-bottom: 1px solid #ccc; padding-bottom: 5px; }
          .score { font-size: 20px; font-weight: bold; color: ${facility.globalReadinessScore >= 80 ? 'green' : 'red'}; }
          table { width: 100%; border-collapse: collapse; margin-top: 20px; }
          th, td { border: 1px solid #ddd; padding: 10px; text-align: left; }
          th { background-color: #f2f2f2; }
        </style>
      </head>
      <body>
        <h1>WHO Health Facility Assessment Report</h1>
        <p><strong>Facility Name:</strong> ${facility.facilityName.isNotEmpty ? facility.facilityName : "Unnamed Facility"}</p>
        <p><strong>Emergency Context:</strong> ${facility.emergencyType.name.toUpperCase()}</p>
        <p><strong>Date of Assessment:</strong> ${DateFormat('dd MMM yyyy').format(facility.dateCreated ?? DateTime.now())}</p>
        
        <h2>Overall Readiness</h2>
        <p class="score">Global Readiness Score: ${facility.globalReadinessScore.toStringAsFixed(0)}%</p>
        
        <h2>Assessment Breakdown</h2>
        <table>
          <tr>
            <th>Zone Name</th>
            <th>Readiness Score</th>
          </tr>
      ''';

      // Aggiungiamo dinamicamente tutte le zone valutate
      for (var zone in facility.zones) {
        if(zone.completionPercentage > 0) {
          htmlContent += '''
            <tr>
              <td>${zone.name}</td>
              <td><b>${zone.readinessScore.toStringAsFixed(0)}%</b></td>
            </tr>
          ''';
        }
      }

      htmlContent += '''
        </table>
        <br><br>
        <p><em>* This document was generated automatically by the WHO Tool and is fully editable.</em></p>
      </body>
      </html>
      ''';

      // 2. Salviamo il file nella directory temporanea usando l'estensione .doc
      final directory = await getTemporaryDirectory();
      final fileName = "WHO_Report_${facility.facilityName.replaceAll(' ', '_')}.doc";
      final file = File('${directory.path}/$fileName');
      
      await file.writeAsString(htmlContent);

      // --- TRUCCO PER SVILUPPATORI: Stampa il percorso del file ---
      // Puoi copiare questo percorso e incollarlo in "Vai alla cartella" del Finder (Cmd+Shift+G)
      debugPrint("✅ Report generato! Percorso su Mac: ${file.path}");
      // -----------------------------------------------------------

      // 3. Apriamo il foglio di condivisione nativo
      final box = context.findRenderObject() as RenderBox?;
      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Editable Assessment Report for ${facility.facilityName}',
        sharePositionOrigin: box != null 
            ? box.localToGlobal(Offset.zero) & box.size 
            : null,
      );
    } catch (e) {
      print("Errore generazione Report Editabile: $e");
      rethrow;
    }
  }
}