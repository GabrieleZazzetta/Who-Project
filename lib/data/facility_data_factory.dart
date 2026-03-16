// lib/data/facility_data_factory.dart
import '../models/assessment_models.dart';
import 'mpox/mpox_existing_ward_data.dart';

class FacilityDataFactory {
  // Genera il layout in base alla malattia e alla struttura scelta
  static FacilityLayout getLayout(EmergencyType emergency, FacilityType facility) {
    
    // --- MPOX ---
    if (emergency == EmergencyType.mpox) {
      switch (facility) {
        case FacilityType.existingFacilityWithWard:
          return MpoxExistingWardData.getLayout(); // L'unica attualmente pronta!
          
        case FacilityType.screeningAndIsolation:
        case FacilityType.standAloneCenter:
        case FacilityType.congregateSetting:
          // Le faremo in futuro, per ora restituiamo la base come sicurezza
          return MpoxExistingWardData.getLayout(); 
      }
    }

    // Fallback di sicurezza (Ebola e SARI sono ancora bloccate nella UI)
    return MpoxExistingWardData.getLayout();
  }
}