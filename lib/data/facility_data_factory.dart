import '../models/assessment_models.dart';
import 'mpox/mpox_existing_ward_data.dart';
import 'mpox/mpox_treatment_center_data.dart';
import 'mpox/mpox_congregate_setting_data.dart';
import 'mpox/mpox_screening_triage_data.dart';

// MAP SELECTION MANAGER
// Routes map and question loading based on emergency context and facility type
class FacilityDataFactory {
  static FacilityLayout getLayout(
      EmergencyType emergency, FacilityType facility) {
    // MPOX SELECTION LOGIC
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

    // SAFETY FALLBACK
    // Loads base layout to prevent empty screen rendering
    return MpoxExistingWardData.getLayout();
  }
}
