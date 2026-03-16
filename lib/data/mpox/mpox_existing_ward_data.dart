import '../../models/assessment_models.dart';
import 'package:flutter/material.dart';

class MpoxExistingWardData {
  /// Carica la struttura "Fig 4 - Existing Facility with Dedicated FVD/Mpox Ward"
  /// Basato sulle linee guida OMS (percorsi sporco/pulito e separazione flussi)
  static FacilityLayout getLayout() {
    return FacilityLayout(
      facilityName: "Existing Health Facility (Mpox Ward)",
      emergencyType: EmergencyType.mpox,
      mapImagePath: 'assets/maps/facility_map_fig4.png', 
      zones: [
        
        // ==========================================
        // 1. SCREENING (Bolla tratteggiata arancione)
        // ==========================================
        SpatialZone(
          id: 'z1',
          name: 'Screening',

          coordinates: const MapCoordinates(top: 500, left: 75),
          touchArea: const MapCoordinates(top: 450, left: 43, width: 78, height: 78),

          checklist: [
            AssessmentQuestion(
              id: 'q1_screening_flow',
              category: AssessmentCategory.infectionPreventionControl,
              text: 'Is the screening area located at the entrance of the health facility?',
              recommendationText: 'Relocate the screening area to the entrance of the facility to ensure all patients, staff, and visitors are screened before entry.',
              selectedCompliance: ComplianceLevel.pending,
            ),
            AssessmentQuestion(
              id: 'q1_screening_distance',
              category: AssessmentCategory.spatialLayout,
              text: 'Is a minimum distance of 1 metre maintained between the screener and the patient?',
              recommendationText: 'Ensure a physical barrier (e.g., table or plexiglass) is in place to maintain a 1-metre distance between screeners and individuals being screened.',
              selectedCompliance: ComplianceLevel.pending,
            ),
             AssessmentQuestion(
              id: 'q1_screening_ppe',
              category: AssessmentCategory.logistics,
              text: 'Are screening staff equipped with appropriate PPE (medical mask, eye protection)?',
              recommendationText: 'Provide medical masks and eye protection (goggles or face shield) to all screening staff.',
              selectedCompliance: ComplianceLevel.pending,
            ),
          ],
        ),

        // ==========================================
        // 2. WAITING AREA (Bolla grande rossa)
        // ==========================================
        SpatialZone(
          id: 'z2',
          name: 'Waiting Area',

          coordinates: const MapCoordinates(top: 662, left: 107),
          touchArea: const MapCoordinates(top: 653, left: 89, width: 97, height: 97),

          checklist: [
            AssessmentQuestion(
              id: 'q2_waiting_segregation',
              category: AssessmentCategory.infectionPreventionControl,
              text: 'Is there a dedicated waiting area for suspected mpox cases, separate from the general waiting area?',
              recommendationText: 'Designate a separate waiting area exclusively for suspected mpox cases to prevent cross-contamination.',
              selectedCompliance: ComplianceLevel.pending,
            ),
            AssessmentQuestion(
              id: 'q2_waiting_ventilation',
              category: AssessmentCategory.spatialLayout,
              text: 'Is the suspected case waiting area well-ventilated?',
              recommendationText: 'Ensure adequate natural ventilation (e.g., open windows) or mechanical ventilation in the waiting area.',
              selectedCompliance: ComplianceLevel.pending,
            ),
            AssessmentQuestion(
              id: 'q2_waiting_distance',
              category: AssessmentCategory.infectionPreventionControl,
              text: 'Can a minimum distance of 1 metre be maintained between suspected patients in the waiting area?',
              recommendationText: 'Arrange seating or mark floors to ensure a minimum of 1 metre distance between patients in the suspected case waiting area.',
              selectedCompliance: ComplianceLevel.pending,
            ),
          ],
        ),

        // ==========================================
        // 3. TRIAGE CONSULTING ROOM (Bolla grande rossa)
        // ==========================================
        SpatialZone(
          id: 'z3',
          name: 'Triage Consulting',

          coordinates: const MapCoordinates(top: 662, left: 243),
          touchArea: const MapCoordinates(top: 653, left: 204, width: 97, height: 97),
          
          checklist: [
             AssessmentQuestion(
              id: 'q3_triage_separation',
              category: AssessmentCategory.spatialLayout,
              text: 'Is the triage room for suspected cases separate from the general triage area?',
              recommendationText: 'Establish a dedicated triage room or area for evaluating suspected mpox cases, physically separated from general triage.',
              selectedCompliance: ComplianceLevel.pending,
            ),
            AssessmentQuestion(
              id: 'q3_triage_ventilation',
              category: AssessmentCategory.spatialLayout,
              text: 'Is the triage room adequately ventilated?',
              recommendationText: 'Ensure proper ventilation (natural or mechanical) in the dedicated triage room.',
              selectedCompliance: ComplianceLevel.pending,
            ),
            AssessmentQuestion(
              id: 'q3_triage_ppe',
              category: AssessmentCategory.infectionPreventionControl,
              text: 'Do staff in the triage room have access to and use required PPE (gloves, gown, medical mask, eye protection)?',
              recommendationText: 'Ensure staff in the suspected case triage room wear a medical mask, eye protection, gown, and gloves.',
              selectedCompliance: ComplianceLevel.pending,
            ),
          ],
        ),

        // ==========================================
        // 4. DOFFING AREA (Bolla tratteggiata azzurra)
        // ==========================================
        SpatialZone(
          id: 'z4',
          name: 'Doffing',

          coordinates: const MapCoordinates(top: 600, left: 185),
          touchArea: const MapCoordinates(top: 605, left: 194, width: 53, height: 53),
          checklist: [
             AssessmentQuestion(
              id: 'q4_doffing_location',
              category: AssessmentCategory.spatialLayout,
              text: 'Is the doffing area located at the exit of the patient care area (red zone)?',
              recommendationText: 'Ensure the doffing area is positioned immediately at the exit of the patient care zone before re-entering clean areas.',
              selectedCompliance: ComplianceLevel.pending,
            ),
            AssessmentQuestion(
              id: 'q4_doffing_supplies',
              category: AssessmentCategory.wash,
              text: 'Are there adequate supplies for hand hygiene and infectious waste disposal in the doffing area?',
              recommendationText: 'Provide alcohol-based hand rub or handwashing stations and leak-proof infectious waste bins in the doffing area.',
              selectedCompliance: ComplianceLevel.pending,
            ),
            AssessmentQuestion(
              id: 'q4_doffing_mirror',
              category: AssessmentCategory.logistics,
              text: 'Is there a mirror available in the doffing area to assist staff during PPE removal?',
              recommendationText: 'Install a full-length mirror in the doffing area to allow staff to visually guide their PPE removal process safely.',
              selectedCompliance: ComplianceLevel.pending,
            ),
          ],
        ),

        // ==========================================
        // 5. DONNING AREA (Bolla tratteggiata verde)
        // ==========================================
        SpatialZone(
          id: 'z5',
          name: 'Donning',
          coordinates: const MapCoordinates(top: 600, left: 250),
          touchArea: const MapCoordinates(top: 605, left: 256, width: 53, height: 53),
          checklist: [
             AssessmentQuestion(
              id: 'q5_donning_location',
              category: AssessmentCategory.spatialLayout,
              text: 'Is the donning area located before entering the patient care area (red zone)?',
              recommendationText: 'Ensure the donning area is positioned strictly before the entrance to the patient care zone to prevent staff from entering without PPE.',
              selectedCompliance: ComplianceLevel.pending,
            ),
            AssessmentQuestion(
              id: 'q5_donning_supplies',
              category: AssessmentCategory.logistics,
              text: 'Is the donning area fully stocked with all required sizes of PPE?',
              recommendationText: 'Maintain an adequate stock of all necessary PPE (gloves, gowns, masks, eye protection) in various sizes within the donning area.',
              selectedCompliance: ComplianceLevel.pending,
            ),
            AssessmentQuestion(
              id: 'q5_donning_mirror',
              category: AssessmentCategory.logistics,
              text: 'Is there a mirror available in the donning area to assist staff in checking their PPE?',
              recommendationText: 'Install a full-length mirror in the donning area so staff can verify correct PPE placement before entering the red zone.',
              selectedCompliance: ComplianceLevel.pending,
            ),
          ],
        ),

        // ==========================================
        // 6. STAFF AREA (Bolla grande verde)
        // ==========================================
        SpatialZone(
          id: 'z6',
          name: 'Staff Area',
          coordinates: const MapCoordinates(top: 535, left: 220),
          touchArea: const MapCoordinates(top: 470, left: 175, width: 97, height: 97),
          checklist: [
            AssessmentQuestion(
              id: 'q6_staff_rest',
              category: AssessmentCategory.spatialLayout,
              text: 'Is there a dedicated, clean rest area for staff, completely separate from patient care zones?',
              recommendationText: 'Establish a designated staff rest area in the clean zone (green zone), physically separated from all patient care and suspected case areas.',
              selectedCompliance: ComplianceLevel.pending,
            ),
             AssessmentQuestion(
              id: 'q6_staff_facilities',
              category: AssessmentCategory.wash,
              text: 'Are there dedicated toilet and handwashing facilities for staff only?',
              recommendationText: 'Provide exclusive toilet and handwashing facilities for staff use, separate from those used by patients.',
              selectedCompliance: ComplianceLevel.pending,
            ),
          ],
        ),

        // ==========================================
        // 7. RESUSCITATION ROOM (Bolla grande rossa)
        // ==========================================
        SpatialZone(
          id: 'z7',
          name: 'Resuscitation',
          coordinates: const MapCoordinates(top: 860, left: 310),
          touchArea: const MapCoordinates(top: 792, left: 252, width: 97, height: 97),
          checklist: [
            AssessmentQuestion(
              id: 'q7_resus_equipment',
              category: AssessmentCategory.logistics,
              text: 'Is the resuscitation room equipped with necessary emergency equipment (e.g., oxygen, suction, emergency drugs)?',
              recommendationText: 'Ensure the resuscitation room is fully stocked with functional emergency medical equipment and supplies.',
              selectedCompliance: ComplianceLevel.pending,
            ),
             AssessmentQuestion(
              id: 'q7_resus_space',
              category: AssessmentCategory.spatialLayout,
              text: 'Is there sufficient space in the resuscitation room for staff to move freely around the patient?',
              recommendationText: 'Clear unnecessary items to ensure 360-degree access around the patient bed for emergency interventions.',
              selectedCompliance: ComplianceLevel.pending,
            ),
          ],
        ),
      ],
    );
  }
}