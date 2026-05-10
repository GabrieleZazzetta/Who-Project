import '../../models/assessment_models.dart';

class MpoxScreeningTriageData {
  static FacilityLayout getLayout() {
    return FacilityLayout(
      facilityName: "Screening, Triage & Temporary Isolation",
      emergencyType: EmergencyType.mpox,
      mapImagePath: 'assets/maps/facility_map_fig2.png', 
      zones: [
        
        // ==========================================
        // 1. SCREENING / RECEPTION (Fig. 2 - Screening Facility)
        // ==========================================
        SpatialZone(
          id: 'z1_screening_reception',
          name: 'Screening & Reception',
          coordinates: const MapCoordinates(top: 270, left: 236), 
          touchArea: const MapCoordinates(top: 265, left: 236, width: 156, height: 156),
          checklist: [
            AssessmentQuestion(
              id: 'q1_screening_location',
              category: AssessmentCategory.spatialLayout,
              text: 'Is the screening area placed at the entrance of the facility and clearly labelled with wayfinding?',
              recommendationText: 'Ensure the screening area is highly visible at the entrance to immediately guide the flow of incoming patients.',
              selectedCompliance: ComplianceLevel.pending,
            ),
            AssessmentQuestion(
              id: 'q1_screening_distance',
              category: AssessmentCategory.infectionPreventionControl,
              text: 'Is a minimum distance of 1 metre maintained between patients and staff using physical barriers or ground marks?',
              recommendationText: 'Install fences, furniture, or clear floor markings to enforce a 1-metre physical distance during the screening process.',
              selectedCompliance: ComplianceLevel.pending,
            ),
            AssessmentQuestion(
              id: 'q1_screening_exits',
              category: AssessmentCategory.spatialLayout,
              text: 'Are there separate exits for patients who meet the mpox case definition and those who do not?',
              recommendationText: 'Establish distinct exit pathways to immediately separate suspected mpox cases (red pathway) from general patients (grey pathway).',
              selectedCompliance: ComplianceLevel.pending,
            ),
            AssessmentQuestion(
              id: 'q1_screening_hygiene',
              category: AssessmentCategory.wash,
              text: 'Is a hand hygiene station available before entering the screening area?',
              recommendationText: 'Provide a functional handwashing or alcohol-based hand rub station strictly before the screening entrance.',
              selectedCompliance: ComplianceLevel.pending,
            ),
          ],
        ),
        
        // ==========================================
        // 2. OTHER STAFF FUNCTIONS (Fig. 2 - Screening Facility)
        // ==========================================
        SpatialZone(
          id: 'z2_staff_functions',
          name: 'Other Staff Functions',
          coordinates: const MapCoordinates(top: 182, left: 522), 
          touchArea: const MapCoordinates(top: 179, left: 519, width: 156, height: 156),
          checklist: [
            AssessmentQuestion(
              id: 'q2_staff_area_division',
              category: AssessmentCategory.infectionPreventionControl,
              text: 'Is there a clear physical division between the staff-only area and the areas accessed by patients or staff in PPE?',
              recommendationText: 'Maintain a strict separation between the "clean" staff functions and the diagnostic/isolation zones to prevent cross-contamination[cite: 1069].',
              selectedCompliance: ComplianceLevel.pending,
            ),
            AssessmentQuestion(
              id: 'q2_staff_entrance',
              category: AssessmentCategory.spatialLayout,
              text: 'Does the staff area have a dedicated entrance that is clearly labelled and separate from the patient entrance?',
              recommendationText: 'Ensure health workers can access their dedicated offices and service areas through a staff-only entrance to maintain controlled flows[cite: 1069].',
              selectedCompliance: ComplianceLevel.pending,
            ),
            AssessmentQuestion(
              id: 'q2_staff_wayfinding',
              category: AssessmentCategory.spatialLayout,
              text: 'Is the staff area distribution logical and easy to follow for service providers?',
              recommendationText: 'Organize administrative and service spaces to facilitate a logical flow that minimizes unnecessary movement into patient areas[cite: 1069].',
              selectedCompliance: ComplianceLevel.pending,
            ),
          ],
        ),

        // ==========================================
        // 3. DONNING AREA (Triage - Fig. 2)
        // ==========================================
        SpatialZone(
          id: 'z3_donning_triage',
          name: 'Donning (Triage)',
          coordinates: const MapCoordinates(top: 423, left: 335), 
          touchArea: const MapCoordinates(top: 423, left: 335, width: 70, height: 70),
          checklist: [
            AssessmentQuestion(
              id: 'q3_donning_space_triage',
              category: AssessmentCategory.spatialLayout,
              text: 'Is the donning area large enough (at least 4 m²) to allow staff to dress safely before entering the triage room?',
              recommendationText: 'Ensure a minimum of 4 m² of free space for staff to put on PPE without touching contaminated surfaces.',
              selectedCompliance: ComplianceLevel.pending,
            ),
            AssessmentQuestion(
              id: 'q3_donning_hygiene_triage',
              category: AssessmentCategory.wash,
              text: 'Is there a hand hygiene station available for use before starting the donning process?',
              recommendationText: 'Install an alcohol-based hand rub dispenser or a sink at the entrance of the donning area.',
              selectedCompliance: ComplianceLevel.pending,
            ),
          ],
        ),

        // ==========================================
        // 4. DOFFING AREA (Triage - Fig. 2)
        // ==========================================
        SpatialZone(
          id: 'z4_doffing_triage',
          name: 'Doffing (Triage)',
          coordinates: const MapCoordinates(top: 423, left: 416), 
          touchArea: const MapCoordinates(top: 423, left: 416, width: 70, height: 70),
          checklist: [
            AssessmentQuestion(
              id: 'q4_doffing_waste_triage',
              category: AssessmentCategory.wash,
              text: 'Are there separate, large-capacity bins for infectious waste and reusable PPE items?',
              recommendationText: 'Provide clearly labelled bins (e.g., 100-litre bags) for immediate disposal of used PPE to prevent environmental contamination.',
              selectedCompliance: ComplianceLevel.pending,
            ),
            AssessmentQuestion(
              id: 'q4_doffing_hygiene_triage',
              category: AssessmentCategory.infectionPreventionControl,
              text: 'Is a hand hygiene station readily accessible for use during and after the doffing steps?',
              recommendationText: 'Ensure staff can perform hand hygiene between each step of PPE removal to avoid self-contamination.',
              selectedCompliance: ComplianceLevel.pending,
            ),
          ],
        ),

        // ==========================================
        // 5. DONNING AREA (Temporary Isolation - Fig. 2)
        // ==========================================
        SpatialZone(
          id: 'z5_donning_isolation',
          name: 'Donning (Isolation)',
          coordinates: const MapCoordinates(top: 421, left: 526), 
          touchArea: const MapCoordinates(top: 421, left: 526, width: 70, height: 70),
          checklist: [
            AssessmentQuestion(
              id: 'q5_donning_supplies_isolation',
              category: AssessmentCategory.logistics,
              text: 'Are PPE supplies stored in a clean, covered area on shelves off the floor?',
              recommendationText: 'Maintain a stock of gowns, gloves, and respirators in a protected area to ensure they remain sterile and dry before use.',
              selectedCompliance: ComplianceLevel.pending,
            ),
            AssessmentQuestion(
              id: 'q5_donning_space_isolation',
              category: AssessmentCategory.spatialLayout,
              text: 'Does the donning space allow for physical distancing if multiple staff members are dressing?',
              recommendationText: 'Organize the flow to ensure staff can maintain distance while preparing to enter the isolation zone.',
              selectedCompliance: ComplianceLevel.pending,
            ),
          ],
        ),

        // ==========================================
        // 6. DOFFING AREA (Temporary Isolation - Fig. 2)
        // ==========================================
        SpatialZone(
          id: 'z6_doffing_isolation',
          name: 'Doffing (Isolation)',
          coordinates: const MapCoordinates(top: 421, left: 608), 
          touchArea: const MapCoordinates(top: 421, left: 608, width: 70, height: 70),
          checklist: [
            AssessmentQuestion(
              id: 'q6_doffing_protocol_isolation',
              category: AssessmentCategory.infectionPreventionControl,
              text: 'Is the doffing area located immediately after the exit of the isolation room?',
              recommendationText: 'The doffing station must be placed at the exit boundary to ensure no contaminated PPE is carried into the clean staff corridors.',
              selectedCompliance: ComplianceLevel.pending,
            ),
            AssessmentQuestion(
              id: 'q6_doffing_wash_isolation',
              category: AssessmentCategory.wash,
              text: 'Is there a functional hand hygiene station with water and soap or alcohol-based rub?',
              recommendationText: 'Verify that the hand hygiene station is always stocked and functional for staff exiting the isolation area.',
              selectedCompliance: ComplianceLevel.pending,
            ),
          ],
        ),

        // ==========================================
        // 7. TEMPORARY ISOLATION ROOM (Fig. 2 - Screening Facility)
        // ==========================================
        SpatialZone(
          id: 'z7_temporary_isolation',
          name: 'Temporary Isolation Room',
          coordinates: const MapCoordinates(top: 495, left: 525), 
          touchArea: const MapCoordinates(top: 490, left: 519, width: 154, height: 154),
          checklist: [
            AssessmentQuestion(
              id: 'q7_isolation_space',
              category: AssessmentCategory.spatialLayout,
              text: 'Is the temporary isolation room a single-patient space with a minimum floor surface of 8 square metres?',
              recommendationText: 'Ensure each isolation room provides at least 8 m² of space to accommodate the patient and necessary equipment while allowing staff to move safely.',
              selectedCompliance: ComplianceLevel.pending,
            ),
            AssessmentQuestion(
              id: 'q7_isolation_wash',
              category: AssessmentCategory.wash,
              text: 'Are there dedicated toilets and a hand hygiene station strictly available for the isolated patient?',
              recommendationText: 'Provide exclusive WASH facilities (toilet and hand hygiene) within or immediately adjacent to the isolation room to prevent cross-contamination of public areas.',
              selectedCompliance: ComplianceLevel.pending,
            ),
            AssessmentQuestion(
              id: 'q7_isolation_ventilation',
              category: AssessmentCategory.spatialLayout,
              text: 'Is the room adequately ventilated, preferably using natural ventilation with open windows?',
              recommendationText: 'Maximize natural airflow by keeping windows open or ensuring the ventilation system meets the required air exchange rates for infectious disease isolation.',
              selectedCompliance: ComplianceLevel.pending,
            ),
            AssessmentQuestion(
              id: 'q7_isolation_furniture',
              category: AssessmentCategory.logistics,
              text: 'Is the room equipped with essential furniture including a bed, a table, and a chair?',
              recommendationText: 'Ensure the isolation space is appropriately furnished to provide basic comfort for the patient during the temporary holding period.',
              selectedCompliance: ComplianceLevel.pending,
            ),
          ],
        ),

        // ==========================================
        // 8. TOILET (Temporary Isolation - Fig. 2)
        // ==========================================
        SpatialZone(
          id: 'z8_toilet_isolation',
          name: 'Toilet (Isolation)',
          coordinates: const MapCoordinates(top: 578, left: 614),
          touchArea: const MapCoordinates(top: 581, left: 618, width: 42, height: 42),
          checklist: [
            AssessmentQuestion(
              id: 'q8_toilet_exclusive',
              category: AssessmentCategory.infectionPreventionControl,
              text: 'Is the toilet exclusively dedicated to the patient in the temporary isolation room?',
              recommendationText: 'Ensure the toilet is strictly for the isolated patient and is not shared with staff or general patients to prevent cross-contamination.',
              selectedCompliance: ComplianceLevel.pending,
            ),
            AssessmentQuestion(
              id: 'q8_toilet_handhygiene',
              category: AssessmentCategory.wash,
              text: 'Is a functional hand hygiene station readily available inside or immediately outside this toilet?',
              recommendationText: 'Provide soap and clean water or an alcohol-based hand rub specifically for the isolated patient to perform hand hygiene.',
              selectedCompliance: ComplianceLevel.pending,
            ),
            AssessmentQuestion(
              id: 'q8_toilet_cleaning',
              category: AssessmentCategory.wash,
              text: 'Are there strict protocols in place for the safe cleaning and disinfection of this specific toilet?',
              recommendationText: 'Ensure cleaning staff use appropriate PPE and follow established protocols to disinfect this toilet with hospital-grade disinfectants.',
              selectedCompliance: ComplianceLevel.pending,
            ),
          ],
        ),

        // ==========================================
        // 10. TRIAGE / CONSULTING ROOM (Fig. 2 - Screening Facility)
        // ==========================================
        SpatialZone(
          id: 'z10_triage_consulting',
          name: 'Triage / Consulting Room',
          coordinates: const MapCoordinates(top: 495, left: 338), 
          touchArea: const MapCoordinates(top: 490, left: 332, width: 154, height: 154),
          checklist: [
            AssessmentQuestion(
              id: 'q10_triage_location',
              category: AssessmentCategory.spatialLayout,
              text: 'Is the consultation room located in proximity to the screening and the isolation room, ensuring suspected cases pass through it before isolation?',
              recommendationText: 'Position the triage room so that it is easily accessible from screening and directly connected to the isolation area to maintain a clear patient flow.',
              selectedCompliance: ComplianceLevel.pending,
            ),
            AssessmentQuestion(
              id: 'q10_triage_surface',
              category: AssessmentCategory.spatialLayout,
              text: 'Does the consultation room have a floor surface of at least 12 m² and provide privacy for the patient?',
              recommendationText: 'Ensure the room is at least 12 m² and includes a changing area separated by curtains to maintain patient dignity.',
              selectedCompliance: ComplianceLevel.pending,
            ),
            AssessmentQuestion(
              id: 'q10_triage_equipment',
              category: AssessmentCategory.logistics,
              text: 'Is the room equipped with a table, chairs, patient couch, and a supply trolley for clinical assessment?',
              recommendationText: 'Provide all essential furniture and a clinical supply trolley to allow for thorough patient evaluations.',
              selectedCompliance: ComplianceLevel.pending,
            ),
            AssessmentQuestion(
              id: 'q10_triage_wash',
              category: AssessmentCategory.wash,
              text: 'Are a hand hygiene station, waste segregation bins, and sharps containers available inside the room?',
              recommendationText: 'Ensure immediate access to hand hygiene and proper waste management (3-bin system and sharps containers) within the consultation space.',
              selectedCompliance: ComplianceLevel.pending,
            ),
            AssessmentQuestion(
              id: 'q10_triage_ppe_flow',
              category: AssessmentCategory.infectionPreventionControl,
              text: 'Are there dedicated donning and doffing spaces strategically located to facilitate PPE changes between each patient?',
              recommendationText: 'Establish separated donning and doffing areas between the staff zone and the patient area to allow health workers to change PPE safely after every visit.',
              selectedCompliance: ComplianceLevel.pending,
            ),
            AssessmentQuestion(
              id: 'q10_triage_toilets',
              category: AssessmentCategory.wash,
              text: 'Are there dedicated functional toilets for patients directly accessible from the triage area?',
              recommendationText: 'Ensure patients have direct access to dedicated toilets from the triage/consultation room to prevent movement through clean areas.',
              selectedCompliance: ComplianceLevel.pending,
            ),
          ],
        ),

        // ==========================================
        // 11. ANY OTHER HEALTH SERVICES (Fig. 2 - Screening Facility)
        // ==========================================
        SpatialZone(
          id: 'z11_other_health_services',
          name: 'Any Other Health Services',
          coordinates: const MapCoordinates(top: 20, left: 43), 
          touchArea: const MapCoordinates(top: 18, left: 37, width: 154, height: 154),
          checklist: [
            AssessmentQuestion(
              id: 'q11_non_mpox_pathway',
              category: AssessmentCategory.spatialLayout,
              text: 'Is there a clearly identified "non-mpox pathway" that directs patients who do not meet the case definition to other health services?',
              recommendationText: 'Establish clear wayfinding and a dedicated path to lead non-suspected patients directly to general health services, preventing them from entering the mpox diagnostic area.',
              selectedCompliance: ComplianceLevel.pending,
            ),
            AssessmentQuestion(
              id: 'q11_separate_exits',
              category: AssessmentCategory.infectionPreventionControl,
              text: 'Are there separate exits in the screening area for patients who meet the case definition and those who do not?',
              recommendationText: 'Ensure the screening facility design includes at least two distinct exits to immediately separate the flows of suspected mpox cases and general patients.',
              selectedCompliance: ComplianceLevel.pending,
            ),
            AssessmentQuestion(
              id: 'q11_facility_integration',
              category: AssessmentCategory.spatialLayout,
              text: 'Is the screening station positioned to prevent patients from accessing other facility services before being screened?',
              recommendationText: 'Place the screening station at the absolute entrance of the facility compound so that every person is evaluated before proceeding to any other health services.',
              selectedCompliance: ComplianceLevel.pending,
            ),
          ],
        ),
      ],
    );
  }
}