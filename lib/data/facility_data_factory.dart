// lib/data/facility_data_factory.dart
import '../models/assessment_models.dart';
import 'mpox/mpox_existing_ward_data.dart';
import 'mpox/mpox_treatment_center_data.dart'; // <-- NUOVO IMPORT
import 'mpox/mpox_congregate_setting_data.dart'; // <-- NUOVO IMPORT

class FacilityDataFactory {
  // Genera il layout in base alla malattia e alla struttura scelta
  static FacilityLayout getLayout(
      EmergencyType emergency, FacilityType facility) {
    // --- MPOX ---
    if (emergency == EmergencyType.mpox) {
      switch (facility) {
        case FacilityType.existingFacilityWithWard:
          return MpoxExistingWardData.getLayout();

        case FacilityType.standAloneCenter:
          return MpoxTreatmentCenterData.getLayout(); // <-- ORA E' COLLEGATO!

        case FacilityType.congregateSetting:
          return MpoxCongregateSettingData.getLayout(); // <-- ORA E' COLLEGATO!

        case FacilityType.screeningAndIsolation:
          // Questa la faremo in futuro, per ora restituiamo la base come sicurezza
          return MpoxExistingWardData.getLayout();
      }
    }

    // Fallback di sicurezza (Ebola e SARI sono ancora bloccate nella UI)
    return MpoxExistingWardData.getLayout();
  }
}
