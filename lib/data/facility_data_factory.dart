import '../models/assessment_models.dart';
import 'mpox/mpox_existing_ward_data.dart';
import 'mpox/mpox_treatment_center_data.dart';
import 'mpox/mpox_congregate_setting_data.dart';
import 'mpox/mpox_screening_triage_data.dart';

// GESTORE SELEZIONE MAPPA
// Sceglie quale mappa e quali domande caricare nell'app a seconda dell'emergenza sanitaria e del tipo di edificio selezionato.
class FacilityDataFactory {
  static FacilityLayout getLayout(
      EmergencyType emergency, FacilityType facility) {
    // LOGICA DI SELEZIONE MPOX
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

    // Fallback di sicurezza: carica un layout di base per evitare che la schermata rimanga vuota
    return MpoxExistingWardData.getLayout();
  }
}
