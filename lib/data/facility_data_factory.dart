// lib/data/facility_data_factory.dart
import '../models/assessment_models.dart';
import 'mpox/mpox_existing_ward_data.dart';
import 'mpox/mpox_treatment_center_data.dart';
import 'mpox/mpox_congregate_setting_data.dart';
import 'mpox/mpox_screening_triage_data.dart';

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
          return MpoxTreatmentCenterData.getLayout();

        case FacilityType.congregateSetting:
          return MpoxCongregateSettingData.getLayout();

        case FacilityType.screeningAndIsolation:
          return MpoxScreeningTriageData.getLayout();
      }
    }

    // Fallback di sicurezza
    return MpoxExistingWardData.getLayout();
  }
}
