import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../models/assessment_models.dart';
import 'package:intl/intl.dart';

// REPORT EXPORT SERVICE
// Manages transformation of structured assessment data into portable text formats
// Delegates OS-level distribution
class ReportExportService {
  static Future<void> exportAssessmentToEditableWord(
      BuildContext context, FacilityLayout facility) async {
    try {
      final info = facility.generalInfo;

      // DOCUMENT STRUCTURE GENERATION
      // Leverages HTML markup with MS Office XML namespaces to force
      // text payload interpretation as an editable Word document (.doc)
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
        
        <h2>General Information</h2>
        <table>
          <tr><td width="40%"><strong>Assessor Name:</strong></td><td>${info?.assessorName ?? ''}</td></tr>
          <tr><td><strong>Assessor Email:</strong></td><td>${info?.assessorEmail ?? ''}</td></tr>
          <tr><td><strong>Assessor Phone:</strong></td><td>${info?.assessorPhone ?? ''}</td></tr>
          <tr><td><strong>Country:</strong></td><td>${info?.country ?? ''}</td></tr>
          <tr><td><strong>Region:</strong></td><td>${info?.region ?? ''}</td></tr>
          <tr><td><strong>District:</strong></td><td>${info?.district ?? ''}</td></tr>
          <tr><td><strong>City:</strong></td><td>${info?.city ?? ''}</td></tr>
          <tr><td><strong>Facility Address/GPS:</strong></td><td>${info?.facilityAddressOrGps ?? ''}</td></tr>
          <tr><td><strong>Location Record:</strong></td><td>${info?.facilityLocationRecord ?? ''}</td></tr>
          <tr><td><strong>Facility Code:</strong></td><td>${info?.facilityCode ?? ''}</td></tr>
          <tr><td><strong>Managing Authority:</strong></td><td>${info?.managingAuthority ?? ''}</td></tr>
          <tr><td><strong>Facility Director Name:</strong></td><td>${info?.facilityDirectorName ?? ''}</td></tr>
          <tr><td><strong>Facility Director Phone:</strong></td><td>${info?.facilityDirectorPhone ?? ''}</td></tr>
          <tr><td><strong>Facility Director Email:</strong></td><td>${info?.facilityDirectorEmail ?? ''}</td></tr>
          <tr><td><strong>Respondent Name:</strong></td><td>${info?.respondentName ?? ''}</td></tr>
          <tr><td><strong>Respondent Position:</strong></td><td>${info?.respondentPosition ?? ''}</td></tr>
          <tr><td><strong>Structure Type:</strong></td><td>${info?.structureType ?? ''}</td></tr>
          <tr><td><strong>Existing Healthcare Facility Type:</strong></td><td>${info?.existingHealthcareFacilityType ?? ''}</td></tr>
          <tr><td><strong>Offers Outpatient:</strong></td><td>${info?.offersOutpatient ?? ''}</td></tr>
          <tr><td><strong>Offers Inpatient:</strong></td><td>${info?.offersInpatient ?? ''}</td></tr>
          <tr><td><strong>Inpatient Beds:</strong></td><td>${info?.inpatientBeds?.toString() ?? ''}</td></tr>
          <tr><td><strong>ICU Beds:</strong></td><td>${info?.icuBeds?.toString() ?? ''}</td></tr>
          <tr><td><strong>24h Emergency:</strong></td><td>${info?.has24hEmergency ?? ''}</td></tr>
          <tr><td><strong>ICU or HDU:</strong></td><td>${info?.hasIcuOrHdu ?? ''}</td></tr>
        </table>

        <h2>Overall Readiness</h2>
        <p class="score">Global Readiness Score: ${facility.globalReadinessScore.toStringAsFixed(0)}%</p>
        
        <h2>Assessment Breakdown</h2>
        <table>
          <tr>
            <th>Zone Name</th>
            <th>Readiness Score</th>
          </tr>
      ''';

      // SPATIAL DATA COMPILATION
      // Dynamically injects evaluated zones into document structure
      for (var zone in facility.zones) {
        if (zone.completionPercentage > 0) {
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

      // Persist HTML payload as .doc file in secure temporary directory
      final directory = await getTemporaryDirectory();
      final fileName =
          "WHO_Report_${facility.facilityName.replaceAll(' ', '_')}.doc";
      final file = File('${directory.path}/$fileName');

      await file.writeAsString(htmlContent);

      // Output debug path for macOS Simulator (Cmd+Shift+G)
      debugPrint("Report generated. macOS path: ${file.path}");

      // Trigger native OS sharing interface (AirDrop, email, file system)
      if (!context.mounted) return;
      final box = context.findRenderObject() as RenderBox?;
      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Editable Assessment Report for ${facility.facilityName}',
        sharePositionOrigin:
            box != null ? box.localToGlobal(Offset.zero) & box.size : null,
      );
    } catch (e) {
      debugPrint("Editable Report generation error: $e");
      rethrow;
    }
  }
}
