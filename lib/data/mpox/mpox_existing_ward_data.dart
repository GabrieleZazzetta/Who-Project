import '../../models/assessment_models.dart';

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

        // ==========================================
        // 8. OFFICES (Administrative and service area)
        // ==========================================
        SpatialZone(
          id: 'z8',
          name: 'Offices',
          // NOTA: Dovrai aggiustare 'top' e 'left' in base alla posizione esatta sull'immagine
          coordinates: const MapCoordinates(top: 415, left: 226),
          touchArea: const MapCoordinates(top: 357, left: 177, width: 97, height: 97),
          checklist: [
            AssessmentQuestion(
              id: 'q8_office_separation',
              category: AssessmentCategory.spatialLayout,
              text: 'Are the administrative offices strictly separated from the clinical and patient areas?',
              recommendationText: 'Ensure that administrative staff not involved in direct patient care operate in a designated green zone to minimize exposure risk.',
              selectedCompliance: ComplianceLevel.pending,
            ),
          ],
        ),

        // ==========================================
        // 9. CHANGING ROOM (Administrative and service area)
        // ==========================================
        SpatialZone(
          id: 'z9',
          name: 'Changing Room',
          coordinates: const MapCoordinates(top: 360, left: 150), 
          touchArea: const MapCoordinates(top: 299, left: 95, width: 97, height: 97),
          checklist: [
            AssessmentQuestion(
              id: 'q9_changing_location',
              category: AssessmentCategory.spatialLayout,
              text: 'Is the changing room located exclusively in the "green zone" (clean area) for staff?',
              recommendationText: 'Ensure the changing room is accessible only from the administrative area or dedicated staff entrance, avoiding any crossover with patient pathways.',
              selectedCompliance: ComplianceLevel.pending,
            ),
            AssessmentQuestion(
              id: 'q9_changing_storage',
              category: AssessmentCategory.logistics,
              text: 'Are lockers or separate storage spaces available for storing civilian clothes and clean uniforms?',
              recommendationText: 'Provide secure storage spaces to prevent cross-contamination between civilian clothes and workwear.',
              selectedCompliance: ComplianceLevel.pending,
            ),
            AssessmentQuestion(
              id: 'q9_changing_hygiene',
              category: AssessmentCategory.wash,
              text: 'Is there a hand hygiene station or an alcohol-based hand rub dispenser inside the changing room?',
              recommendationText: 'Install alcohol-based hand rub dispensers to allow staff to sanitize their hands before putting on their uniform or after removing it.',
              selectedCompliance: ComplianceLevel.pending,
            ),
          ],
        ),

        // ==========================================
        // 10. PHARMACY (Administrative and service area)
        // ==========================================
        SpatialZone(
          id: 'z10',
          name: 'Pharmacy',
          // NOTA: Usa il GestureDetector sulla mappa per trovare i valori esatti.
          // In genere si trova nell'area servizi vicino allo Storage.
          coordinates: const MapCoordinates(top: 249, left: 150), 
          touchArea: const MapCoordinates(top: 188, left: 95, width: 97, height: 97),
          checklist: [
            AssessmentQuestion(
              id: 'q10_pharmacy_access',
              category: AssessmentCategory.spatialLayout,
              text: 'Is the pharmacy easily accessible from the exterior for drug deliveries without crossing patient areas?',
              recommendationText: 'Ensure the pharmacy has a delivery access point that does not require suppliers to enter the treatment or patient zones.',
              selectedCompliance: ComplianceLevel.pending,
            ),
            AssessmentQuestion(
              id: 'q10_pharmacy_environment',
              category: AssessmentCategory.logistics,
              text: 'Are temperature and humidity levels monitored and controlled according to drug storage requirements?',
              recommendationText: 'Install monitoring systems (thermometers/hygrometers) and ensure climate control to maintain drug efficacy as per national protocols.',
              selectedCompliance: ComplianceLevel.pending,
            ),
            AssessmentQuestion(
              id: 'q10_pharmacy_security',
              category: AssessmentCategory.infectionPreventionControl,
              text: 'Is the pharmacy located in a secure, controlled-access area within the administrative zone?',
              recommendationText: 'Restrict access to authorized personnel only and ensure the location allows for efficient supply to the ward while maintaining security.',
              selectedCompliance: ComplianceLevel.pending,
            ),
          ],
        ),

        // ==========================================
        // 11. STORAGE (Administrative and service area)
        // ==========================================
        SpatialZone(
          id: 'z11',
          name: 'Storage',
          // NOTA: Usa il trucco del GestureDetector per trovare i valori esatti.
          // Nel diagramma OMS, si trova solitamente nell'angolo in alto a sinistra dell'area servizi.
          coordinates: const MapCoordinates(top: 142, left: 150), 
          touchArea: const MapCoordinates(top: 81, left: 95, width: 97, height: 97),
          checklist: [
            AssessmentQuestion(
              id: 'q11_storage_access',
              category: AssessmentCategory.spatialLayout,
              text: 'Is the storage area easily accessible from both the exterior (for deliveries) and the interior of the facility?',
              recommendationText: 'Ensure the logistics store is positioned to allow goods to be received from outside without crossing clinical zones, while remaining accessible for internal distribution.',
              selectedCompliance: ComplianceLevel.pending,
            ),
            AssessmentQuestion(
              id: 'q11_storage_dimensions',
              category: AssessmentCategory.spatialLayout,
              text: 'Are openings and corridors leading to the storage area wide enough for the movement of goods using mechanical means (e.g., trolleys)?',
              recommendationText: 'Verify that all doorways and pathways are wide enough to accommodate the transport of bulky consumables and equipment via trolleys.',
              selectedCompliance: ComplianceLevel.pending,
            ),
            AssessmentQuestion(
              id: 'q11_storage_organization',
              category: AssessmentCategory.logistics,
              text: 'Is the storage organized to keep consumables off the ground and protected from environmental elements?',
              recommendationText: 'Maintain a clean, dry environment with shelving to keep medical supplies and consumables off the floor and organized for easy inventory management.',
              selectedCompliance: ComplianceLevel.pending,
            ),
          ],
        ),

        // ==========================================
        // 12. WASTE AREA (Administrative and service area)
        // ==========================================
        SpatialZone(
          id: 'z12',
          name: 'Waste Area',
          // NOTA: Usa il GestureDetector per calibrare la posizione. 
          // Nel diagramma OMS (Fig. 4), si trova solitamente nel settore 
          // amministrativo, vicino all'area di stoccaggio o sul perimetro esterno.
          coordinates: const MapCoordinates(top: 142, left: 320), 
          touchArea: const MapCoordinates(top: 81, left: 259, width: 97, height: 97),
          checklist: [
            AssessmentQuestion(
              id: 'q12_waste_security',
              category: AssessmentCategory.wash,
              text: 'Is the waste area fenced, secured with a lock, and protected from weather elements by a roof?',
              recommendationText: 'Ensure the waste management area is dedicated, fenced to prevent animal access, and has a roof and a lockable door to prevent unauthorized entry.',
              selectedCompliance: ComplianceLevel.pending,
            ),
            AssessmentQuestion(
              id: 'q12_waste_segregation',
              category: AssessmentCategory.wash,
              text: 'Is a functional 3-bin waste system in place with waste correctly segregated at all generation points?',
              recommendationText: 'Implement and maintain a 3-bin system for segregating general, infectious, and sharp waste at all points where waste is generated within the facility.',
              selectedCompliance: ComplianceLevel.pending,
            ),
            AssessmentQuestion(
              id: 'q12_waste_infrastructure',
              category: AssessmentCategory.spatialLayout,
              text: 'Is the floor hard and non-porous, and is waste stored off the ground?',
              recommendationText: 'The waste area must have a hard, non-porous floor, and all waste should be lifted from the ground to prevent environmental contamination.',
              selectedCompliance: ComplianceLevel.pending,
            ),
            AssessmentQuestion(
              id: 'q12_waste_hygiene',
              category: AssessmentCategory.wash,
              text: 'Is there a dedicated cleaning and disinfection area with running water available within the waste area?',
              recommendationText: 'Provide a functional cleaning station with running water to ensure proper disinfection of waste containers and the area itself.',
              selectedCompliance: ComplianceLevel.pending,
            ),
          ],
        ),

        // ==========================================
        // 13. LAUNDRY (Administrative and service area)
        // ==========================================
        SpatialZone(
          id: 'z13',
          name: 'Laundry',
          // NOTA: Usa il trucco del GestureDetector nel simulatore per trovare le coordinate esatte.
          // Spesso si trova accanto all'area di stoccaggio o di decontaminazione.
          coordinates: const MapCoordinates(top: 249, left: 320), 
          touchArea: const MapCoordinates(top: 192, left: 259, width: 97, height: 97),
          checklist: [
            AssessmentQuestion(
              id: 'q13_laundry_capacity',
              category: AssessmentCategory.logistics,
              text: 'Is there a dedicated, functioning laundry service properly sized for the facility\'s capacity, or is it outsourced to an authorized company?',
              recommendationText: 'Ensure the laundry service can handle the daily volume of the mpox facility, or secure a contract with a reliable external service that meets safety standards.',
              selectedCompliance: ComplianceLevel.pending,
            ),
            AssessmentQuestion(
              id: 'q13_laundry_protocol',
              category: AssessmentCategory.infectionPreventionControl,
              text: 'Are bed linens from the mpox ward machine washed with hot water (>60°C) or with a hypochlorite (bleach) solution?',
              recommendationText: 'Implement strict washing protocols using hot water (above 60°C) and detergent, or an appropriate bleach solution, to ensure complete disinfection of linens.',
              selectedCompliance: ComplianceLevel.pending,
            ),
            AssessmentQuestion(
              id: 'q13_laundry_flow',
              category: AssessmentCategory.spatialLayout,
              text: 'Are there separate areas and temporary storage for dirty linen and clean linen to prevent cross-contamination?',
              recommendationText: 'Establish a clear physical separation—ideally with separate entrances and exits—between the soiled linen intake/washing area and the clean linen drying/storage area.',
              selectedCompliance: ComplianceLevel.pending,
            ),
            AssessmentQuestion(
              id: 'q13_laundry_hygiene',
              category: AssessmentCategory.wash,
              text: 'Is a hand hygiene station readily available within the laundry area?',
              recommendationText: 'Install handwashing facilities or alcohol-based hand rub stations for laundry staff to use immediately after handling soiled linens.',
              selectedCompliance: ComplianceLevel.pending,
            ),
          ],
        ),

        // ==========================================
        // 14. REPROCESSING EQUIPMENT (Administrative and service area)
        // ==========================================
        SpatialZone(
          id: 'z14',
          name: 'Reprocessing Equipment',
          // NOTA: Usa il trucco del GestureDetector nel simulatore per trovare le coordinate esatte.
          // Nel diagramma si trova solitamente vicino all'area clinica ma in un blocco dedicato.
          coordinates: const MapCoordinates(top: 360, left: 320), 
          touchArea: const MapCoordinates(top: 296, left: 257, width: 97, height: 97),
          checklist: [
            AssessmentQuestion(
              id: 'q14_reprocessing_flow',
              category: AssessmentCategory.infectionPreventionControl,
              text: 'Is there a clear, unidirectional flow from the "dirty" receiving area to the "clean" sterilization and storage area?',
              recommendationText: 'Establish a strict one-way workflow to prevent cross-contamination between contaminated instruments and sterilized equipment.',
              selectedCompliance: ComplianceLevel.pending,
            ),
            AssessmentQuestion(
              id: 'q14_reprocessing_ventilation',
              category: AssessmentCategory.spatialLayout,
              text: 'Is the reprocessing area adequately ventilated to manage heat, moisture, and chemical fumes?',
              recommendationText: 'Ensure sufficient mechanical or natural ventilation to safely dissipate heat from autoclaves and fumes from chemical disinfectants.',
              selectedCompliance: ComplianceLevel.pending,
            ),
            AssessmentQuestion(
              id: 'q14_reprocessing_ppe',
              category: AssessmentCategory.infectionPreventionControl,
              text: 'Do staff handling contaminated equipment have access to and use heavy-duty PPE (e.g., thick gloves, waterproof aprons, face protection)?',
              recommendationText: 'Provide heavy-duty utility gloves, waterproof aprons, and eye/face protection for staff working in the decontamination (dirty) area.',
              selectedCompliance: ComplianceLevel.pending,
            ),
            AssessmentQuestion(
              id: 'q14_reprocessing_hygiene',
              category: AssessmentCategory.wash,
              text: 'Are there dedicated sinks for cleaning instruments, strictly separated from handwashing sinks?',
              recommendationText: 'Ensure deep sinks are available exclusively for instrument cleaning, physically separated from dedicated hand hygiene stations.',
              selectedCompliance: ComplianceLevel.pending,
            ),
          ],
        ),

        // ==========================================
        // 15. CLEAN UTILITY (Mpox Confirmed Ward)
        // ==========================================
        SpatialZone(
          id: 'z15_clean_utility_confirmed',
          name: 'Clean Utility Confirmed',
          // NOTA: Usa il trucco del GestureDetector nel simulatore per trovare le coordinate esatte.
          // Nel diagramma, si trova solitamente adiacente alla Nursing Station.
          coordinates: const MapCoordinates(top: 130, left: 400), 
          // NOTA: Ho impostato un'area di tocco (width/height) più piccola (40x40 o 50x50),
          // ideale per stanze singole. Ricorda di calibrare top e left di conseguenza!
          touchArea: const MapCoordinates(top: 133, left: 401, width: 58, height: 58),
          checklist: [
            AssessmentQuestion(
              id: 'q15_clean_utility_separation_confirmed',
              category: AssessmentCategory.spatialLayout,
              text: 'Is the clean utility room located in a completely separate area from the dirty (soiled) utility room?',
              recommendationText: 'Ensure that the clean utility room is physically separated from the soiled utility room to prevent cross-contamination of clean medical supplies and linens.',
              selectedCompliance: ComplianceLevel.pending,
            ),
            AssessmentQuestion(
              id: 'q15_clean_utility_accessibility_confirmed',
              category: AssessmentCategory.logistics,
              text: 'Is the clean utility room directly accessible from circulation areas and are doors wide enough for supply trolleys?',
              recommendationText: 'Ensure the room opens directly into circulation areas and that doorways are wide enough to easily accommodate the movement of exchange trolleys for restocking.',
              selectedCompliance: ComplianceLevel.pending,
            ),
            AssessmentQuestion(
              id: 'q15_clean_utility_water_confirmed',
              category: AssessmentCategory.wash,
              text: 'Is there access to clean, running water within the clean utility room?',
              recommendationText: 'Provide a functional clean water supply and sink in the clean utility room, which is essential for preparing clean equipment and medications.',
              selectedCompliance: ComplianceLevel.pending,
            ),
          ],
        ),

        // ==========================================
        // 16. CLEAN UTILITY (Mpox Probable Ward)
        // ==========================================
        SpatialZone(
          id: 'z16_clean_utility_probable',
          name: 'Clean Utility Probable',
          // NOTA: Usa il trucco del GestureDetector nel simulatore per trovare le coordinate esatte.
          // Nel diagramma, si trova solitamente adiacente alla Nursing Station.
          coordinates: const MapCoordinates(top: 315, left: 585), 
          // NOTA: Ho impostato un'area di tocco (width/height) più piccola (40x40 o 50x50),
          // ideale per stanze singole. Ricorda di calibrare top e left di conseguenza!
          touchArea: const MapCoordinates(top: 317, left: 589, width: 58, height: 58),
          checklist: [
            AssessmentQuestion(
              id: 'q16_clean_utility_separation_probable',
              category: AssessmentCategory.spatialLayout,
              text: 'Is the clean utility room located in a completely separate area from the dirty (soiled) utility room?',
              recommendationText: 'Ensure that the clean utility room is physically separated from the soiled utility room to prevent cross-contamination of clean medical supplies and linens.',
              selectedCompliance: ComplianceLevel.pending,
            ),
            AssessmentQuestion(
              id: 'q16_clean_utility_accessibility_probable',
              category: AssessmentCategory.logistics,
              text: 'Is the clean utility room directly accessible from circulation areas and are doors wide enough for supply trolleys?',
              recommendationText: 'Ensure the room opens directly into circulation areas and that doorways are wide enough to easily accommodate the movement of exchange trolleys for restocking.',
              selectedCompliance: ComplianceLevel.pending,
            ),
            AssessmentQuestion(
              id: 'q16_clean_utility_water_probable',
              category: AssessmentCategory.wash,
              text: 'Is there access to clean, running water within the clean utility room?',
              recommendationText: 'Provide a functional clean water supply and sink in the clean utility room, which is essential for preparing clean equipment and medications.',
              selectedCompliance: ComplianceLevel.pending,
            ),
          ],
        ),

        // ==========================================
        // 17. CLEAN UTILITY (Mpox Suspect Ward)
        // ==========================================
        SpatialZone(
          id: 'z17_clean_utility_suspect',
          name: 'Clean Utility Suspect',
          // NOTA: Usa il trucco del GestureDetector nel simulatore per trovare le coordinate esatte.
          // Nel diagramma, si trova solitamente adiacente alla Nursing Station.
          coordinates: const MapCoordinates(top: 656, left: 400), 
          // NOTA: Ho impostato un'area di tocco (width/height) più piccola (40x40 o 50x50),
          // ideale per stanze singole. Ricorda di calibrare top e left di conseguenza!
          touchArea: const MapCoordinates(top: 659, left: 406, width: 58, height: 58),
          checklist: [
            AssessmentQuestion(
              id: 'q17_clean_utility_separation_suspect',
              category: AssessmentCategory.spatialLayout,
              text: 'Is the clean utility room located in a completely separate area from the dirty (soiled) utility room?',
              recommendationText: 'Ensure that the clean utility room is physically separated from the soiled utility room to prevent cross-contamination of clean medical supplies and linens.',
              selectedCompliance: ComplianceLevel.pending,
            ),
            AssessmentQuestion(
              id: 'q17_clean_utility_accessibility_suspect',
              category: AssessmentCategory.logistics,
              text: 'Is the clean utility room directly accessible from circulation areas and are doors wide enough for supply trolleys?',
              recommendationText: 'Ensure the room opens directly into circulation areas and that doorways are wide enough to easily accommodate the movement of exchange trolleys for restocking.',
              selectedCompliance: ComplianceLevel.pending,
            ),
            AssessmentQuestion(
              id: 'q17_clean_utility_water_suspect',
              category: AssessmentCategory.wash,
              text: 'Is there access to clean, running water within the clean utility room?',
              recommendationText: 'Provide a functional clean water supply and sink in the clean utility room, which is essential for preparing clean equipment and medications.',
              selectedCompliance: ComplianceLevel.pending,
            ),
          ],
        ),

        // ==========================================
        // 18. DONNING AREA (Mpox Ward)
        // ==========================================
        SpatialZone(
          id: 'z18_donning_confirmed',
          name: 'Donning (Confirmed)',
          coordinates: const MapCoordinates(top: 182, left: 425), 
          touchArea: const MapCoordinates(top: 186, left: 431, width: 52, height: 52),
          checklist: [
            AssessmentQuestion(
              id: 'q18_donning_space_confirmed',
              category: AssessmentCategory.spatialLayout,
              text: 'Is the donning area large enough to ensure free movement of staff (at least 4 square metres of free space)?',
              recommendationText: 'Ensure the donning area provides a minimum of 4m² of free space, increasing surface according to the number of people putting on PPE simultaneously, to allow staff to dress safely.',
              selectedCompliance: ComplianceLevel.pending,
            ),
            AssessmentQuestion(
              id: 'q18_donning_storage_confirmed',
              category: AssessmentCategory.logistics,
              text: 'Are Personal Protective Equipment (PPE) stored in a clean, covered area on shelves off the floor?',
              recommendationText: 'Provide dedicated shelving to keep all PPE clean, dry, covered, and strictly elevated from the floor to prevent contamination before use.',
              selectedCompliance: ComplianceLevel.pending,
            ),
            AssessmentQuestion(
              id: 'q18_donning_hygiene_confirmed',
              category: AssessmentCategory.wash,
              text: 'Is a hand hygiene station and a waste bin readily available in the donning area?',
              recommendationText: 'Install a hand hygiene station (sink or alcohol-based hand rub dispenser) and a waste bin strictly within the donning area for immediate use.',
              selectedCompliance: ComplianceLevel.pending,
            ),
          ],
        ),

        // ==========================================
        // 19. DONNING AREA (Mpox Ward)
        // ==========================================
        SpatialZone(
          id: 'z19_donning_probable',
          name: 'Donning (Probable)',
          coordinates: const MapCoordinates(top: 362, left: 557), 
          touchArea: const MapCoordinates(top: 366, left: 561, width: 52, height: 52),
          checklist: [
            AssessmentQuestion(
              id: 'q19_donning_space_probable',
              category: AssessmentCategory.spatialLayout,
              text: 'Is the donning area large enough to ensure free movement of staff (at least 4 square metres of free space)?',
              recommendationText: 'Ensure the donning area provides a minimum of 4m² of free space, increasing surface according to the number of people putting on PPE simultaneously, to allow staff to dress safely.',
              selectedCompliance: ComplianceLevel.pending,
            ),
            AssessmentQuestion(
              id: 'q19_donning_storage_probable',
              category: AssessmentCategory.logistics,
              text: 'Are Personal Protective Equipment (PPE) stored in a clean, covered area on shelves off the floor?',
              recommendationText: 'Provide dedicated shelving to keep all PPE clean, dry, covered, and strictly elevated from the floor to prevent contamination before use.',
              selectedCompliance: ComplianceLevel.pending,
            ),
            AssessmentQuestion(
              id: 'q19_donning_hygiene_probable',
              category: AssessmentCategory.wash,
              text: 'Is a hand hygiene station and a waste bin readily available in the donning area?',
              recommendationText: 'Install a hand hygiene station (sink or alcohol-based hand rub dispenser) and a waste bin strictly within the donning area for immediate use.',
              selectedCompliance: ComplianceLevel.pending,
            ),
          ],
        ),

        // ==========================================
        // 20. DONNING AREA (Mpox Ward)
        // ==========================================
        SpatialZone(
          id: 'z20_donning_suspect',
          name: 'Donning (Suspect)',
          coordinates: const MapCoordinates(top: 602, left: 425), 
          touchArea: const MapCoordinates(top: 606, left: 429, width: 52, height: 52),
          checklist: [
            AssessmentQuestion(
              id: 'q20_donning_space_suspect',
              category: AssessmentCategory.spatialLayout,
              text: 'Is the donning area large enough to ensure free movement of staff (at least 4 square metres of free space)?',
              recommendationText: 'Ensure the donning area provides a minimum of 4m² of free space, increasing surface according to the number of people putting on PPE simultaneously, to allow staff to dress safely.',
              selectedCompliance: ComplianceLevel.pending,
            ),
            AssessmentQuestion(
              id: 'q20_donning_storage_suspect',
              category: AssessmentCategory.logistics,
              text: 'Are Personal Protective Equipment (PPE) stored in a clean, covered area on shelves off the floor?',
              recommendationText: 'Provide dedicated shelving to keep all PPE clean, dry, covered, and strictly elevated from the floor to prevent contamination before use.',
              selectedCompliance: ComplianceLevel.pending,
            ),
            AssessmentQuestion(
              id: 'q20_donning_hygiene_suspect',
              category: AssessmentCategory.wash,
              text: 'Is a hand hygiene station and a waste bin readily available in the donning area?',
              recommendationText: 'Install a hand hygiene station (sink or alcohol-based hand rub dispenser) and a waste bin strictly within the donning area for immediate use.',
              selectedCompliance: ComplianceLevel.pending,
            ),
          ],
        ),

        // ==========================================
        // 21. NURSING STATION (Confirmed Mpox Ward)
        // ==========================================
        SpatialZone(
          id: 'z21_nursing_confirmed',
          name: 'Nursing Station (Confirmed)',
          coordinates: const MapCoordinates(top: 236, left: 433), 
          touchArea: const MapCoordinates(top: 238, left: 436, width: 62, height: 62),
          checklist: [
            AssessmentQuestion(
              id: 'q21_nursing_visibility_confirmed',
              category: AssessmentCategory.spatialLayout,
              text: 'Is there a dedicated area for staff only, with clear visibility of the patients\' ward?',
              recommendationText: 'Ensure the nursing station is strategically located to maintain a direct line of sight to patients for continuous monitoring.',
              selectedCompliance: ComplianceLevel.pending,
            ),
            AssessmentQuestion(
              id: 'q21_nursing_zoning_confirmed',
              category: AssessmentCategory.infectionPreventionControl,
              text: 'Is the nursing station clearly designated as a clean staff area, physically separated from the contaminated patient zones?',
              recommendationText: 'Maintain strict IPC measures by demarcating the nursing station as a clean zone within the ward, preventing cross-contamination.',
              selectedCompliance: ComplianceLevel.pending,
            ),
          ],
        ),
        
        // ==========================================
        // 22. NURSING STATION (Probable Mpox Ward)
        // ==========================================
        SpatialZone(
          id: 'z22_nursing_probable',
          name: 'Nursing Station (Probable)',
          coordinates: const MapCoordinates(top: 387, left: 502), 
          touchArea: const MapCoordinates(top: 391, left: 507, width: 62, height: 62),
          checklist: [
            AssessmentQuestion(
              id: 'q22_nursing_visibility_probable',
              category: AssessmentCategory.spatialLayout,
              text: 'Is there a dedicated area for staff only, with clear visibility of the patients\' ward?',
              recommendationText: 'Ensure the nursing station is strategically located to maintain a direct line of sight to patients for continuous monitoring.',
              selectedCompliance: ComplianceLevel.pending,
            ),
            AssessmentQuestion(
              id: 'q22_nursing_zoning_probable',
              category: AssessmentCategory.infectionPreventionControl,
              text: 'Is the nursing station clearly designated as a clean staff area, physically separated from the contaminated patient zones?',
              recommendationText: 'Maintain strict IPC measures by demarcating the nursing station as a clean zone within the ward, preventing cross-contamination.',
              selectedCompliance: ComplianceLevel.pending,
            ),
          ],
        ),

        // ==========================================
        // 23. NURSING STATION (Suspected Mpox Ward)
        // ==========================================
        SpatialZone(
          id: 'z23_nursing_suspect',
          name: 'Nursing Station (Suspect)',
          // Usa il trucco del GestureDetector nel simulatore per calibrare le coordinate esatte.
          coordinates: const MapCoordinates(top: 539, left: 421), 
          touchArea: const MapCoordinates(top: 543, left: 425, width: 62, height: 62),
          checklist: [
            AssessmentQuestion(
              id: 'q23_nursing_visibility_suspect',
              category: AssessmentCategory.spatialLayout,
              text: 'Is there a dedicated area for staff only, with clear visibility of the patients\' ward?',
              recommendationText: 'Ensure the nursing station is strategically located to maintain a direct line of sight to patients for continuous monitoring.',
              selectedCompliance: ComplianceLevel.pending,
            ),
            AssessmentQuestion(
              id: 'q23_nursing_zoning_suspect',
              category: AssessmentCategory.infectionPreventionControl,
              text: 'Is the nursing station clearly designated as a clean staff area, physically separated from the contaminated patient zones?',
              recommendationText: 'Maintain strict IPC measures by demarcating the nursing station as a clean zone within the ward, preventing cross-contamination.',
              selectedCompliance: ComplianceLevel.pending,
            ),
          ],
        ),

        // ==========================================
        // 24. SOILED UTILITY (Confirmed Mpox Ward)
        // ==========================================
        SpatialZone(
          id: 'z24_soiled_confirmed',
          name: 'Soiled Utility (Confirmed)',
          // Usa il GestureDetector per calibrare la posizione esatta.
          // Nel diagramma OMS è solitamente opposta alla Clean Utility.
          coordinates: const MapCoordinates(top: 198, left: 544), 
          touchArea: const MapCoordinates(top: 202, left: 548, width: 58, height: 58),
          checklist: [
            AssessmentQuestion(
              id: 'q24_soiled_separation_confirmed',
              category: AssessmentCategory.infectionPreventionControl,
              text: 'Is the soiled utility room physically separated from the clean utility and nursing station?',
              recommendationText: 'Ensure complete physical separation to prevent cross-contamination. The soiled utility must open directly into circulation areas for waste movement.',
              selectedCompliance: ComplianceLevel.pending,
            ),
            AssessmentQuestion(
              id: 'q24_soiled_equipment_confirmed',
              category: AssessmentCategory.wash,
              text: 'Are a sluice sink and bedpan processing equipment available and functional?',
              recommendationText: 'Install a dedicated sluice sink and bedpan washer/disinfector to safely manage and dispose of patient excreta and liquid waste.',
              selectedCompliance: ComplianceLevel.pending,
            ),
            AssessmentQuestion(
              id: 'q24_soiled_access_confirmed',
              category: AssessmentCategory.logistics,
              text: 'Is the room accessible by trolleys for the safe movement of waste bags and soiled items?',
              recommendationText: 'Ensure the entrance and internal layout allow for the unhindered movement of waste trolleys to the designated waste management area.',
              selectedCompliance: ComplianceLevel.pending,
            ),
          ],
        ),

        // ==========================================
        // 25. SOILED UTILITY (Probable Mpox Ward)
        // ==========================================
        SpatialZone(
          id: 'z25_soiled_probable',
          name: 'Soiled Utility (Probable)',
          coordinates: const MapCoordinates(top: 473, left: 585), 
          touchArea: const MapCoordinates(top: 477, left: 590, width: 58, height: 58),
          checklist: [
            AssessmentQuestion(
              id: 'q25_soiled_separation_probable',
              category: AssessmentCategory.infectionPreventionControl,
              text: 'Is the soiled utility room physically separated from the clean utility and nursing station?',
              recommendationText: 'Ensure complete physical separation to prevent cross-contamination. The soiled utility must open directly into circulation areas for waste movement.',
              selectedCompliance: ComplianceLevel.pending,
            ),
            AssessmentQuestion(
              id: 'q25_soiled_equipment_probable',
              category: AssessmentCategory.wash,
              text: 'Are a sluice sink and bedpan processing equipment available and functional?',
              recommendationText: 'Install a dedicated sluice sink and bedpan washer/disinfector to safely manage and dispose of patient excreta and liquid waste.',
              selectedCompliance: ComplianceLevel.pending,
            ),
            AssessmentQuestion(
              id: 'q25_soiled_access_probable',
              category: AssessmentCategory.logistics,
              text: 'Is the room accessible by trolleys for the safe movement of waste bags and soiled items?',
              recommendationText: 'Ensure the entrance and internal layout allow for the unhindered movement of waste trolleys to the designated waste management area.',
              selectedCompliance: ComplianceLevel.pending,
            ),
          ],
        ),

        // ==========================================
        // 26. SOILED UTILITY (Suspected Mpox Ward)
        // ==========================================
        SpatialZone(
          id: 'z26_soiled_suspect',
          name: 'Soiled Utility (Suspect)',
          coordinates: const MapCoordinates(top: 564, left: 537), 
          touchArea: const MapCoordinates(top: 569, left: 541, width: 58, height: 58),
          checklist: [
            AssessmentQuestion(
              id: 'q26_soiled_separation_suspect',
              category: AssessmentCategory.infectionPreventionControl,
              text: 'Is the soiled utility room physically separated from the clean utility and nursing station?',
              recommendationText: 'Ensure complete physical separation to prevent cross-contamination. The soiled utility must open directly into circulation areas for waste movement.',
              selectedCompliance: ComplianceLevel.pending,
            ),
            AssessmentQuestion(
              id: 'q26_soiled_equipment_suspect',
              category: AssessmentCategory.wash,
              text: 'Are a sluice sink and bedpan processing equipment available and functional?',
              recommendationText: 'Install a dedicated sluice sink and bedpan washer/disinfector to safely manage and dispose of patient excreta and liquid waste.',
              selectedCompliance: ComplianceLevel.pending,
            ),
            AssessmentQuestion(
              id: 'q26_soiled_access_suspect',
              category: AssessmentCategory.logistics,
              text: 'Is the room accessible by trolleys for the safe movement of waste bags and soiled items?',
              recommendationText: 'Ensure the entrance and internal layout allow for the unhindered movement of waste trolleys to the designated waste management area.',
              selectedCompliance: ComplianceLevel.pending,
            ),
          ],
        ),

        // ==========================================
        // 27. DOFFING AREA (Confirmed Mpox Ward)
        // ==========================================
        SpatialZone(
          id: 'z27_doffing_confirmed',
          name: 'Doffing (Confirmed)',
          // Usa il trucco del GestureDetector nel simulatore per calibrare le coordinate.
          // Il Doffing si trova all'uscita del reparto pazienti, prima di rientrare nell'area pulita.
          coordinates: const MapCoordinates(top: 211, left: 488), 
          touchArea: const MapCoordinates(top: 216, left: 493, width: 52, height: 52),
          checklist: [
            AssessmentQuestion(
              id: 'q27_doffing_space_confirmed',
              category: AssessmentCategory.spatialLayout,
              text: 'Is the doffing area large enough to ensure free movement of staff (at least 4 square metres) and located immediately after exiting the patient area?',
              recommendationText: 'Ensure the doffing area provides a minimum of 4m² of free space and is strategically positioned to facilitate immediate PPE removal after patient care.',
              selectedCompliance: ComplianceLevel.pending,
            ),
            AssessmentQuestion(
              id: 'q27_doffing_waste_confirmed',
              category: AssessmentCategory.wash,
              text: 'Are there adequate waste segregation bins (e.g., 100-litre bags) for collecting both disposable and reusable PPE?',
              recommendationText: 'Provide clearly labeled, large-capacity waste bins for the safe disposal or collection of used PPE to prevent environmental contamination.',
              selectedCompliance: ComplianceLevel.pending,
            ),
            AssessmentQuestion(
              id: 'q27_doffing_hygiene_confirmed',
              category: AssessmentCategory.infectionPreventionControl,
              text: 'Is a hand hygiene station readily available within the doffing area?',
              recommendationText: 'Install a hand hygiene station (sink with water and soap or alcohol-based hand rub) to allow staff to perform hand hygiene immediately upon removing PPE.',
              selectedCompliance: ComplianceLevel.pending,
            ),
          ],
        ),

        // ==========================================
        // 28. DOFFING AREA (Probable Mpox Ward)
        // ==========================================
        SpatialZone(
          id: 'z28_doffing_probable',
          name: 'Doffing (Probable)',
          coordinates: const MapCoordinates(top: 426, left: 553), 
          touchArea: const MapCoordinates(top: 430, left: 558, width: 52, height: 52),
          checklist: [
            AssessmentQuestion(
              id: 'q28_doffing_space_probable',
              category: AssessmentCategory.spatialLayout,
              text: 'Is the doffing area large enough to ensure free movement of staff (at least 4 square metres) and located immediately after exiting the patient area?',
              recommendationText: 'Ensure the doffing area provides a minimum of 4m² of free space and is strategically positioned to facilitate immediate PPE removal after patient care.',
              selectedCompliance: ComplianceLevel.pending,
            ),
            AssessmentQuestion(
              id: 'q28_doffing_waste_probable',
              category: AssessmentCategory.wash,
              text: 'Are there adequate waste segregation bins (e.g., 100-litre bags) for collecting both disposable and reusable PPE?',
              recommendationText: 'Provide clearly labeled, large-capacity waste bins for the safe disposal or collection of used PPE to prevent environmental contamination.',
              selectedCompliance: ComplianceLevel.pending,
            ),
            AssessmentQuestion(
              id: 'q28_doffing_hygiene_probable',
              category: AssessmentCategory.infectionPreventionControl,
              text: 'Is a hand hygiene station readily available within the doffing area?',
              recommendationText: 'Install a hand hygiene station (sink with water and soap or alcohol-based hand rub) to allow staff to perform hand hygiene immediately upon removing PPE.',
              selectedCompliance: ComplianceLevel.pending,
            ),
          ],
        ),

        // ==========================================
        // 29. DOFFING AREA (Suspected Mpox Ward)
        // ==========================================
        SpatialZone(
          id: 'z29_doffing_suspect',
          name: 'Doffing (Suspect)',
          coordinates: const MapCoordinates(top: 563, left: 481), 
          touchArea: const MapCoordinates(top: 569, left: 485, width: 52, height: 52),
          checklist: [
            AssessmentQuestion(
              id: 'q29_doffing_space_suspect',
              category: AssessmentCategory.spatialLayout,
              text: 'Is the doffing area large enough to ensure free movement of staff (at least 4 square metres) and located immediately after exiting the patient area?',
              recommendationText: 'Ensure the doffing area provides a minimum of 4m² of free space and is strategically positioned to facilitate immediate PPE removal after patient care.',
              selectedCompliance: ComplianceLevel.pending,
            ),
            AssessmentQuestion(
              id: 'q29_doffing_waste_suspect',
              category: AssessmentCategory.wash,
              text: 'Are there adequate waste segregation bins (e.g., 100-litre bags) for collecting both disposable and reusable PPE?',
              recommendationText: 'Provide clearly labeled, large-capacity waste bins for the safe disposal or collection of used PPE to prevent environmental contamination.',
              selectedCompliance: ComplianceLevel.pending,
            ),
            AssessmentQuestion(
              id: 'q29_doffing_hygiene_suspect',
              category: AssessmentCategory.infectionPreventionControl,
              text: 'Is a hand hygiene station readily available within the doffing area?',
              recommendationText: 'Install a hand hygiene station (sink with water and soap or alcohol-based hand rub) to allow staff to perform hand hygiene immediately upon removing PPE.',
              selectedCompliance: ComplianceLevel.pending,
            ),
          ],
        ),

        // ==========================================
        // 30. MPOX CONFIRMED CASE ROOM (Treatment Area)
        // ==========================================
        SpatialZone(
          id: 'z30_case_room_confirmed',
          name: 'Confirmed Case Room',
          // Posizionata al centro del reparto pazienti confermati.
          coordinates: const MapCoordinates(top: 96, left: 465), 
          touchArea: const MapCoordinates(top: 95, left: 463, width: 120, height: 120),
          checklist: [
            AssessmentQuestion(
              id: 'q30_confirmed_placement_confirmed',
              category: AssessmentCategory.infectionPreventionControl,
              text: 'Are confirmed cases hospitalized in individual rooms, or if cohorted, is there at least 2 metres distance between beds?',
              recommendationText: 'Preferably use individual rooms. If cohorting is necessary, ensure 2m spacing (1m for IPC + 1m for movement) and adequate ventilation.',
              selectedCompliance: ComplianceLevel.pending,
            ),
            AssessmentQuestion(
              id: 'q30_confirmed_dimensions_confirmed',
              category: AssessmentCategory.spatialLayout,
              text: 'Does each bed bay meet the minimum dimensions of 3.45 x 3.6 metres without obstacles for staff access?',
              recommendationText: 'Ensure each patient space is large enough (approx. 12m²) to allow 360-degree access to the patient bed.',
              selectedCompliance: ComplianceLevel.pending,
            ),
            AssessmentQuestion(
              id: 'q30_confirmed_toilet_confirmed',
              category: AssessmentCategory.wash,
              text: 'Are there private or dedicated toilets and hand hygiene stations available for the confirmed ward?',
              recommendationText: 'Provide dedicated toilets (preferably private) and ensure functional hand hygiene stations are available within each room or bay.',
              selectedCompliance: ComplianceLevel.pending,
            ),
          ],
        ),

        // ==========================================
        // 31. MPOX PROBABLE CASE ROOM (Treatment Area)
        // ==========================================
        SpatialZone(
          id: 'z31_case_room_probable',
          name: 'Probable Case Room',
          coordinates: const MapCoordinates(top: 370, left: 612), 
          touchArea: const MapCoordinates(top: 366, left: 606, width: 120, height: 120),
          checklist: [
            AssessmentQuestion(
              id: 'q31_probable_isolation_probable',
              category: AssessmentCategory.infectionPreventionControl,
              text: 'Are probable cases isolated in individual rooms with private toilets while waiting for laboratory confirmation?',
              recommendationText: 'To prevent cross-infection between different patients, probable cases should ideally be kept in single rooms with private toilets.',
              selectedCompliance: ComplianceLevel.pending,
            ),
            AssessmentQuestion(
              id: 'q31_probable_spacing_probable',
              category: AssessmentCategory.spatialLayout,
              text: 'If cohorting is used for probable cases, is a 2-metre distance between beds and proper ventilation strictly ensured?',
              recommendationText: 'Only cohort probable cases if single rooms are unavailable, ensuring strict 2m bed spacing and high air exchange rates.',
              selectedCompliance: ComplianceLevel.pending,
            ),
          ],
        ),

        // ==========================================
        // 32. MPOX SUSPECT CASE ROOM (Treatment Area)
        // ==========================================
        SpatialZone(
          id: 'z32_case_room_suspect',
          name: 'Suspect Case Room',
          coordinates: const MapCoordinates(top: 624, left: 477), 
          touchArea: const MapCoordinates(top: 618, left: 469, width: 120, height: 120),
          checklist: [
            AssessmentQuestion(
              id: 'q32_suspect_placement_suspect',
              category: AssessmentCategory.infectionPreventionControl,
              text: 'Are suspected cases accommodated in individual rooms with private toilets and hand hygiene stations?',
              recommendationText: 'Suspected cases must be isolated individually to prevent transmission while meeting the case definition and waiting for triage/testing.',
              selectedCompliance: ComplianceLevel.pending,
            ),
            AssessmentQuestion(
              id: 'q32_suspect_surface_suspect',
              category: AssessmentCategory.spatialLayout,
              text: 'Does the individual isolation room have a minimum floor surface of 8 square metres?',
              recommendationText: 'Ensure the isolation room is large enough (8m²) to accommodate a single bed and necessary biomedical devices for patient care.',
              selectedCompliance: ComplianceLevel.pending,
            ),
          ],
        ),

        // ==========================================
        // 33. TOILET (Confirmed Case Room)
        // ==========================================
        SpatialZone(
          id: 'z33_toilet_confirmed',
          name: 'Toilet (Confirmed Room)',
          // Posiziona la bolla sopra l'icona del bagno nella stanza "Confirmed"
          coordinates: const MapCoordinates(top: 108, left: 508), 
          touchArea: const MapCoordinates(top: 108, left: 478, width: 30, height: 30),
          checklist: [
            AssessmentQuestion(
              id: 'q33_toilet_private_confirmed',
              category: AssessmentCategory.wash,
              text: 'Are confirmed case rooms equipped with private, dedicated toilets to prevent cross-contamination?',
              recommendationText: 'Provide dedicated toilets for confirmed patients. If shared, ensure they are strictly separated by gender and cleaned after each use.',
              selectedCompliance: ComplianceLevel.pending,
            ),
            AssessmentQuestion(
              id: 'q33_toilet_handhygiene_confirmed',
              category: AssessmentCategory.wash,
              text: 'Is there a functional hand hygiene station (water and soap or alcohol-based rub) within or immediately adjacent to the toilet?',
              recommendationText: 'Ensure hand washing facilities are available within 5 metres of the toilet to facilitate immediate hygiene.',
              selectedCompliance: ComplianceLevel.pending,
            ),
            AssessmentQuestion(
              id: 'q33_toilet_surfaces_confirmed',
              category: AssessmentCategory.infectionPreventionControl,
              text: 'Are toilet surfaces smooth, non-porous, and resistant to hospital-grade disinfectants?',
              recommendationText: 'Use non-porous materials for all surfaces to ensure they can be effectively disinfected at least twice daily and after each use if shared.',
              selectedCompliance: ComplianceLevel.pending,
            ),
          ],
        ),

        // ==========================================
        // 34. TOILET (Probable Case Room)
        // ==========================================
        SpatialZone(
          id: 'z34_toilet_probable',
          name: 'Toilet (Probable Room)',
          coordinates: const MapCoordinates(top: 370, left: 697), 
          touchArea: const MapCoordinates(top: 370, left: 667, width: 30, height: 30),
          checklist: [
            AssessmentQuestion(
              id: 'q34_toilet_private_probable',
              category: AssessmentCategory.wash,
              text: 'Is the probable case room equipped with a private toilet to maintain strict isolation while waiting for confirmation?',
              recommendationText: 'Maintain single-patient toilet access for probable cases to prevent infection spread before laboratory results are confirmed.',
              selectedCompliance: ComplianceLevel.pending,
            ),
            AssessmentQuestion(
              id: 'q34_toilet_handhygiene_probable',
              category: AssessmentCategory.wash,
              text: 'Is a functional hand hygiene station available for the patient within the isolation space?',
              recommendationText: 'Provide soap and clean water or alcohol-based hand rub specifically for the use of the patient in the probable ward.',
              selectedCompliance: ComplianceLevel.pending,
            ),
          ],
        ),

        // ==========================================
        // 35. TOILET (Suspect Case Room)
        // ==========================================
        SpatialZone(
          id: 'z35_toilet_suspect',
          name: 'Toilet (Suspect Room)',
          coordinates: const MapCoordinates(top: 662, left: 586), 
          touchArea: const MapCoordinates(top: 662, left: 556, width: 30, height: 30),
          checklist: [
            AssessmentQuestion(
              id: 'q35_toilet_private_suspect',
              category: AssessmentCategory.wash,
              text: 'Does the suspect case room include a private toilet and dedicated hand hygiene station?',
              recommendationText: 'To meet IPC standards, suspect cases must have access to private toilets to avoid any risk of transmission at the entry point of the facility.',
              selectedCompliance: ComplianceLevel.pending,
            ),
            AssessmentQuestion(
              id: 'q35_toilet_cleaning_suspect',
              category: AssessmentCategory.wash,
              text: 'Are there clear protocols for the cleaning and disinfection of the suspect case toilet after use?',
              recommendationText: 'Ensure that the cleaning staff follows specific protocols for disinfecting suspected case isolation facilities using appropriate chemicals.',
              selectedCompliance: ComplianceLevel.pending,
            ),
          ],
        ),

        // ==========================================
        // 36. MORGUE (Administrative and Service Area / External)
        // ==========================================
        SpatialZone(
          id: 'z36_morgue',
          name: 'Morgue',
          // Usa il trucco del GestureDetector. Nel diagramma è spesso isolata e posizionata
          // in un'area esterna accessibile direttamente dai veicoli o dai parenti.
          coordinates: const MapCoordinates(top: 781, left: 397), 
          touchArea: const MapCoordinates(top: 785, left: 401, width: 58, height: 58),
          checklist: [
            AssessmentQuestion(
              id: 'q36_morgue_location',
              category: AssessmentCategory.spatialLayout,
              text: 'Is the morgue easily accessible from all the wards but completely completely out of sight from patients?',
              recommendationText: 'Ensure the morgue is positioned so that the movement of deceased patients is discreet and not visible from the patient wards or general waiting areas.',
              selectedCompliance: ComplianceLevel.pending,
            ),
            AssessmentQuestion(
              id: 'q36_morgue_visitors',
              category: AssessmentCategory.infectionPreventionControl,
              text: 'If visitors are allowed, can they access the morgue directly from outside the centre with a dedicated exit?',
              recommendationText: 'Provide a direct external access route for relatives to visit the morgue without needing to enter any of the treatment centre\'s clinical or staff areas.',
              selectedCompliance: ComplianceLevel.pending,
            ),
            AssessmentQuestion(
              id: 'q36_morgue_barrier',
              category: AssessmentCategory.spatialLayout,
              text: 'Is there a physical barrier ensuring a 1-metre distance or a transparent window to allow visitors to safely see the body?',
              recommendationText: 'Install a physical barrier to maintain at least 1 metre of distance, or use a transparent viewing window, to protect relatives from potential exposure.',
              selectedCompliance: ComplianceLevel.pending,
            ),
          ],
        ),

        // ==========================================
        // 37. DISCHARGE AREA (Exit Pathway)
        // ==========================================
        SpatialZone(
          id: 'z37_discharge',
          name: 'Discharge Area',
          // Spesso raffigurata come uscita dedicata vicino all'area dei casi confermati/sospetti
          coordinates: const MapCoordinates(top: 782, left: 688), 
          touchArea: const MapCoordinates(top: 786, left: 692, width: 58, height: 58),
          checklist: [
            AssessmentQuestion(
              id: 'q37_discharge_pathway',
              category: AssessmentCategory.infectionPreventionControl,
              text: 'Is there a dedicated, clearly marked discharge pathway for patients who test negative or have recovered?',
              recommendationText: 'Establish a specific exit route for discharged patients to leave the facility directly, ensuring they do not cross paths with incoming suspected cases or contaminated areas.',
              selectedCompliance: ComplianceLevel.pending,
            ),
            AssessmentQuestion(
              id: 'q37_discharge_hygiene',
              category: AssessmentCategory.wash,
              text: 'Is a hand hygiene station available at the final exit point before patients re-enter the community?',
              recommendationText: 'Provide a final handwashing or sanitizing station at the discharge point to ensure patients perform hand hygiene right before leaving the facility.',
              selectedCompliance: ComplianceLevel.pending,
            ),
          ],
        ),
      ],
    );
  }
}