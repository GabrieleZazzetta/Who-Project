import '../../models/assessment_models.dart';

class MpoxTreatmentCenterData {
  /// Carica la struttura "Stand-alone Mpox Treatment Centre"
  /// Basato sui criteri OMS (Sezione 2 e Sezione 4)
  static FacilityLayout getLayout() {
    return FacilityLayout(
      facilityName: "Mpox Treatment Center",
      emergencyType: EmergencyType.mpox,
      mapImagePath: 'assets/maps/facility_map_treatment_center.png',
      zones: [
        // ==========================================
        // 1. SCREENING
        // ==========================================
        SpatialZone(
          id: 'z1_screening',
          name: 'Screening',
          coordinates: const MapCoordinates(top: 464, left: 97),
          touchArea:
              const MapCoordinates(top: 449, left: 82, width: 30, height: 30),
          checklist: [
            AssessmentQuestion(
                id: 'tc_2_1_1',
                category: AssessmentCategory.spatialLayout,
                text:
                    'Do patients and staff have dedicated and clearly labeled entrances?',
                recommendationText:
                    'Ensure entrances are distinct and clearly signposted to prevent cross-contamination.',
                selectedCompliance: ComplianceLevel.pending),
            AssessmentQuestion(
                id: 'tc_2_1_3',
                category: AssessmentCategory.infectionPreventionControl,
                text:
                    'Is the patient flow logical, clear, well signposted, and does it facilitate the sequential path (from screening to isolation wards)?',
                recommendationText:
                    'Reorganize physical barriers and signage to force a strict, unidirectional patient flow.',
                selectedCompliance: ComplianceLevel.pending),
            AssessmentQuestion(
                id: 'tc_4_1_1',
                category: AssessmentCategory.spatialLayout,
                text:
                    'Is the screening area located at the entrance, is it clearly marked with guiding paths, and do all patients pass through it?',
                recommendationText:
                    'Move screening to the absolute perimeter of the facility so no patient bypasses it.',
                selectedCompliance: ComplianceLevel.pending),
            AssessmentQuestion(
                id: 'tc_4_1_2',
                category: AssessmentCategory.infectionPreventionControl,
                text:
                    'In the screening area, are there separate exits to ensure a divided flow between patients who meet the case definition (suspects) and non-suspect patients?',
                recommendationText:
                    'Create a physical divergence immediately after the screening desk for suspect vs non-suspect cases.',
                selectedCompliance: ComplianceLevel.pending),
            AssessmentQuestion(
                id: 'tc_4_1_3',
                category: AssessmentCategory.spatialLayout,
                text:
                    'Is a distance of at least 1 meter maintained between patients and staff during screening through physical barriers, furniture, or floor markings?',
                recommendationText:
                    'Install plexiglass or place tables to guarantee a 1m safety buffer.',
                selectedCompliance: ComplianceLevel.pending),
            AssessmentQuestion(
                id: 'tc_4_1_4',
                category: AssessmentCategory.spatialLayout,
                text:
                    'Is a surface area greater than 8 m² available for each screening station?',
                recommendationText:
                    'Expand the screening station footprint to avoid unsafe crowding.',
                selectedCompliance: ComplianceLevel.pending),
          ],
        ),

        // ==========================================
        // 2. WAITING AREA
        // ==========================================
        SpatialZone(
          id: 'z2_waiting',
          name: 'Waiting Area',
          coordinates: const MapCoordinates(top: 615, left: 135),
          touchArea:
              const MapCoordinates(top: 600, left: 120, width: 30, height: 30),
          checklist: [
            AssessmentQuestion(
                id: 'tc_4_2_1',
                category: AssessmentCategory.spatialLayout,
                text:
                    'Is the waiting room located between the screening and triage areas, with controlled access and with patients visible from the triage area or staff area?',
                recommendationText:
                    'Relocate the waiting area to ensure staff have constant visual monitoring of suspected cases.',
                selectedCompliance: ComplianceLevel.pending),
            AssessmentQuestion(
                id: 'tc_4_2_2',
                category: AssessmentCategory.infectionPreventionControl,
                text:
                    'Is the waiting room dedicated only to suspected Mpox cases (while non-suspects follow a different path after screening)?',
                recommendationText:
                    'Ensure strictly separate waiting zones; do not mix suspected cases with general patients.',
                selectedCompliance: ComplianceLevel.pending),
            AssessmentQuestion(
                id: 'tc_4_2_3',
                category: AssessmentCategory.spatialLayout,
                text:
                    'Does the waiting room furniture (chairs, barriers, floor markings) ensure at least 2 meters of distance between patients?',
                recommendationText:
                    'Remove or tape off chairs to enforce the 2-metre physical distancing rule.',
                selectedCompliance: ComplianceLevel.pending),
            AssessmentQuestion(
                id: 'tc_4_2_4',
                category: AssessmentCategory.spatialLayout,
                text:
                    'Is a space of at least 4 m² ensured for each individual patient in the waiting room?',
                recommendationText:
                    'Reduce the maximum occupancy of the waiting room to guarantee 4 m² per patient.',
                selectedCompliance: ComplianceLevel.pending),
            AssessmentQuestion(
                id: 'tc_4_2_5',
                category: AssessmentCategory.logistics,
                text:
                    'Can the waiting area be expanded in case of patient surge to avoid overcrowding and is it already equipped and ready for use?',
                recommendationText:
                    'Prepare an overflow area (e.g., an adjacent tent or room) with basic seating and ventilation.',
                selectedCompliance: ComplianceLevel.pending),
          ],
        ),

        // ==========================================
        // 3. TRIAGE CONSULTING ROOM
        // ==========================================
        SpatialZone(
          id: 'z3_triage',
          name: 'Triage Room',
          coordinates: const MapCoordinates(top: 615, left: 208),
          touchArea:
              const MapCoordinates(top: 600, left: 193, width: 30, height: 30),
          checklist: [
            AssessmentQuestion(
                id: 'tc_4_3_1',
                category: AssessmentCategory.spatialLayout,
                text:
                    'Is the triage located near the waiting room, does it provide a controlled path to the ward, and can staff access it directly from their own area?',
                recommendationText:
                    'Optimize the layout so staff and patients do not cross paths unnecessarily to reach triage.',
                selectedCompliance: ComplianceLevel.pending),
            AssessmentQuestion(
                id: 'tc_4_3_4',
                category: AssessmentCategory.spatialLayout,
                text:
                    'Does the triage measure at least 12 m² and is it equipped with a table, chairs, changing area with curtains for privacy, an examination couch, and a clinical supplies cart?',
                recommendationText:
                    'Ensure the triage room meets the 12 m² minimum and is fully furnished for clinical assessment.',
                selectedCompliance: ComplianceLevel.pending),
            AssessmentQuestion(
                id: 'tc_4_3_5',
                category: AssessmentCategory.spatialLayout,
                text:
                    'Is there at least one triage station for every 15 seats in the waiting room?',
                recommendationText:
                    'Set up additional triage stations to prevent bottlenecks from the waiting room.',
                selectedCompliance: ComplianceLevel.pending),
            AssessmentQuestion(
                id: 'tc_4_3_6',
                category: AssessmentCategory.logistics,
                text:
                    'Is there an additional room dedicated to triage in case of patient overflow, fully equipped and ready for use at any time?',
                recommendationText:
                    'Designate and equip a backup triage room for surge capacity.',
                selectedCompliance: ComplianceLevel.pending),
          ],
        ),

        // ==========================================
        // 4 & 5. TRIAGE DONNING & DOFFING
        // ==========================================
        SpatialZone(
          id: 'z4_triage_donning',
          name: 'Triage Donning',
          coordinates: const MapCoordinates(top: 565, left: 188),
          touchArea:
              const MapCoordinates(top: 550, left: 173, width: 30, height: 30),
          checklist: _getTriagePPEChecklist(),
        ),
        SpatialZone(
          id: 'z5_triage_doffing',
          name: 'Triage Doffing',
          coordinates: const MapCoordinates(top: 565, left: 231),
          touchArea:
              const MapCoordinates(top: 550, left: 216, width: 30, height: 30),
          checklist: _getTriagePPEChecklist(),
        ),

        // ==========================================
        // 6. STAFF AREA & ADMIN (Changing Room)
        // ==========================================
        SpatialZone(
          id: 'z6_staff_admin',
          name: 'Staff & Admin Area',
          coordinates: const MapCoordinates(top: 212, left: 141),
          touchArea:
              const MapCoordinates(top: 197, left: 126, width: 30, height: 30),
          checklist: [
            AssessmentQuestion(
                id: 'tc_2_1_2',
                category: AssessmentCategory.spatialLayout,
                text:
                    'Are the areas clearly divided between space for patients/staff in PPE and space exclusively for staff?',
                recommendationText:
                    'Install physical barriers (e.g., doors, fencing) to separate staff zones from PPE/patient zones.',
                selectedCompliance: ComplianceLevel.pending),
            AssessmentQuestion(
                id: 'tc_2_1_5',
                category: AssessmentCategory.spatialLayout,
                text:
                    'Is the facility perimeter enclosed by a single fence and are all available accesses controlled?',
                recommendationText:
                    'Repair perimeter fencing and ensure security guards control all entry points.',
                selectedCompliance: ComplianceLevel.pending),
            AssessmentQuestion(
                id: 'tc_2_2_1',
                category: AssessmentCategory.logistics,
                text:
                    'Is the electrical system compliant with national regulations and equipped with a functioning emergency power supply system?',
                recommendationText:
                    'Install a backup generator or solar system to guarantee continuous power.',
                selectedCompliance: ComplianceLevel.pending),
            AssessmentQuestion(
                id: 'tc_2_2_2',
                category: AssessmentCategory.logistics,
                text:
                    'Is the fire safety system compliant with regulations and is there an evacuation plan known to staff and patients?',
                recommendationText:
                    'Install fire extinguishers and display clear evacuation maps.',
                selectedCompliance: ComplianceLevel.pending),
            AssessmentQuestion(
                id: 'tc_2_2_4',
                category: AssessmentCategory.logistics,
                text:
                    'Is the mechanical ventilation system (if present) perfectly functioning and maintained according to the manufacturer\'s recommendations?',
                recommendationText:
                    'Schedule immediate maintenance for the mechanical ventilation HVAC system.',
                selectedCompliance: ComplianceLevel.pending),
            AssessmentQuestion(
                id: 'tc_2_4_1',
                category: AssessmentCategory.wash,
                text:
                    'Is water available within the facility, does it come from a safe (improved) source, and is it in sufficient quantity?',
                recommendationText:
                    'Secure a reliable, continuous source of safe water for the entire facility.',
                selectedCompliance: ComplianceLevel.pending),
            AssessmentQuestion(
                id: 'tc_2_4_3',
                category: AssessmentCategory.wash,
                text:
                    'Does the quality of drinking water comply with regulations (e.g., residual chlorine 0.2-0.5 mg/L or 0 E. coli and turbidity <5 NTU)?',
                recommendationText:
                    'Implement daily water chlorination and testing protocols.',
                selectedCompliance: ComplianceLevel.pending),
          ],
        ),

        // ==========================================
        // 7. STORAGE
        // ==========================================
        SpatialZone(
          id: 'z7_storage',
          name: 'Storage & Pharmacy',
          coordinates: const MapCoordinates(top: 72, left: 137),
          touchArea:
              const MapCoordinates(top: 57, left: 122, width: 30, height: 30),
          checklist: [
            AssessmentQuestion(
                id: 'tc_2_4_2',
                category: AssessmentCategory.wash,
                text:
                    'Is there a water storage system that is protected and sufficient to cover the needs for at least two days?',
                recommendationText:
                    'Install high-capacity, covered water tanks to ensure a 48-hour reserve.',
                selectedCompliance: ComplianceLevel.pending),
            AssessmentQuestion(
                id: 'tc_4_5_6',
                category: AssessmentCategory.logistics,
                text:
                    'Is sterile storage easily accessible, does it have sufficient surface area for the processed equipment, and does it have humidity and temperature control?',
                recommendationText:
                    'Install AC or dehumidifiers in the sterile store to protect processed equipment.',
                selectedCompliance: ComplianceLevel.pending),
            AssessmentQuestion(
                id: 'tc_4_5_7',
                category: AssessmentCategory.logistics,
                text:
                    'Is the storage of devices, chemicals, and packaging clearly organized, does it have separate areas for raw materials/finished products, and does it comply with safety regulations?',
                recommendationText:
                    'Segregate chemicals from sterile packaging using clear shelving and labels.',
                selectedCompliance: ComplianceLevel.pending),
          ],
        ),

        // ==========================================
        // 8. WASTE AREA
        // ==========================================
        SpatialZone(
          id: 'z8_waste',
          name: 'Waste Area',
          coordinates: const MapCoordinates(top: 57, left: 216),
          touchArea:
              const MapCoordinates(top: 42, left: 201, width: 30, height: 30),
          checklist: [
            AssessmentQuestion(
                id: 'tc_2_3_1',
                category: AssessmentCategory.wash,
                text:
                    'Is there a dedicated waste management area that is fenced, of sufficient capacity, and equipped with a cleaning and disinfection area with running water?',
                recommendationText:
                    'Fence off the waste zone and install a dedicated water point for cleaning bins.',
                selectedCompliance: ComplianceLevel.pending),
            AssessmentQuestion(
                id: 'tc_2_3_2',
                category: AssessmentCategory.wash,
                text:
                    'Is a functional 3-bin system in place to correctly segregate waste at all generation points?',
                recommendationText:
                    'Distribute color-coded 3-bin systems (infectious, sharps, general) across all facility zones.',
                selectedCompliance: ComplianceLevel.pending),
            AssessmentQuestion(
                id: 'tc_2_3_3',
                category: AssessmentCategory.wash,
                text:
                    'Is hazardous waste treated safely or disposed of safely inside or outside the facility?',
                recommendationText:
                    'Ensure an incinerator or safe burial pit is active and used exclusively for hazardous waste.',
                selectedCompliance: ComplianceLevel.pending),
            AssessmentQuestion(
                id: 'tc_2_4_4',
                category: AssessmentCategory.wash,
                text:
                    'Are wastewater managed safely, preventing any discharge of sewage and faecal sludge into the environment?',
                recommendationText:
                    'Check septic tanks and soak pits to ensure no overflow into the surrounding environment.',
                selectedCompliance: ComplianceLevel.pending),
          ],
        ),

        // ==========================================
        // 9. REPROCESSING EQUIPMENT
        // ==========================================
        SpatialZone(
          id: 'z9_reprocessing',
          name: 'Reprocessing',
          coordinates: const MapCoordinates(top: 201, left: 216),
          touchArea:
              const MapCoordinates(top: 186, left: 201, width: 30, height: 30),
          checklist: [
            AssessmentQuestion(
                id: 'tc_4_5_1',
                category: AssessmentCategory.infectionPreventionControl,
                text:
                    'Is the equipment reprocessing area present, well marked, clean, easily navigable, and with sufficient space to prevent crowding?',
                recommendationText:
                    'Reorganize the reprocessing room to create a clear, spacious, and safe workflow.',
                selectedCompliance: ComplianceLevel.pending),
            AssessmentQuestion(
                id: 'tc_4_5_2',
                category: AssessmentCategory.infectionPreventionControl,
                text:
                    'Are there dedicated gowning points in the reprocessing area, fully equipped with appropriate PPE, clear signage, and ample space for staff?',
                recommendationText:
                    'Install a dedicated PPE donning station at the entrance of the reprocessing area.',
                selectedCompliance: ComplianceLevel.pending),
            AssessmentQuestion(
                id: 'tc_4_5_3',
                category: AssessmentCategory.infectionPreventionControl,
                text:
                    'Is there a dirty medical device receiving area that is dedicated, clearly marked, provided with containment measures, well-ventilated, and with immediate access to decontamination resources?',
                recommendationText:
                    'Establish a strictly "dirty" receiving bench with strong ventilation.',
                selectedCompliance: ComplianceLevel.pending),
            AssessmentQuestion(
                id: 'tc_4_5_4',
                category: AssessmentCategory.infectionPreventionControl,
                text:
                    'Is the Inspection, Assembly, and Packaging (IAP) area clean, well-organized, equipped with the necessary tools, and with a clear flow of work from dirty to clean?',
                recommendationText:
                    'Enforce a strict unidirectional workflow from the dirty zone to the clean IAP zone.',
                selectedCompliance: ComplianceLevel.pending),
            AssessmentQuestion(
                id: 'tc_4_5_5',
                category: AssessmentCategory.infectionPreventionControl,
                text:
                    'Is the sterilization area designed to minimize the risk of contamination and provided with adequate ventilation and monitoring systems?',
                recommendationText:
                    'Ensure autoclaves are functioning in a well-ventilated space with temperature monitoring.',
                selectedCompliance: ComplianceLevel.pending),
          ],
        ),

        // ==========================================
        // 10. LAUNDRY
        // ==========================================
        SpatialZone(
          id: 'z10_laundry',
          name: 'Laundry',
          coordinates: const MapCoordinates(top: 124, left: 216),
          touchArea:
              const MapCoordinates(top: 109, left: 201, width: 30, height: 30),
          checklist: [
            AssessmentQuestion(
                id: 'tc_4_6_1',
                category: AssessmentCategory.infectionPreventionControl,
                text:
                    'Does the facility have a laundry service capable of managing the needs, and is Mpox linen machine washed with hot water (>60°C) or hypochlorite solution?',
                recommendationText:
                    'Ensure industrial washing machines reach >60°C or implement strict chlorine washing protocols.',
                selectedCompliance: ComplianceLevel.pending),
          ],
        ),

        // ==========================================
        // 11. MORGUE
        // ==========================================
        SpatialZone(
          id: 'z11_morgue',
          name: 'Morgue',
          coordinates: const MapCoordinates(top: 744, left: 325),
          touchArea:
              const MapCoordinates(top: 729, left: 310, width: 30, height: 30),
          checklist: [
            AssessmentQuestion(
                id: 'tc_2_1_4',
                category: AssessmentCategory.spatialLayout,
                text:
                    'Do all visitors enter through a designated, controlled entrance equipped with a hand hygiene station and screening?',
                recommendationText:
                    'Set up a guarded checkpoint with handwashing facilities specifically for relative/visitor access to the morgue.',
                selectedCompliance: ComplianceLevel.pending),
          ],
        ),

        // ==========================================
        // 12. GENERAL TOILETS
        // ==========================================
        SpatialZone(
          id: 'z12_toilets',
          name: 'General Toilets',
          coordinates: const MapCoordinates(top: 580, left: 135),
          touchArea:
              const MapCoordinates(top: 565, left: 120, width: 30, height: 30),
          checklist: [
            AssessmentQuestion(
                id: 'tc_2_4_5',
                category: AssessmentCategory.wash,
                text:
                    'Do all toilets have functioning handwashing stations within a 5-meter radius?',
                recommendationText:
                    'Install functional handwashing stations with soap and water immediately outside all toilets.',
                selectedCompliance: ComplianceLevel.pending),
            AssessmentQuestion(
                id: 'tc_2_4_6',
                category: AssessmentCategory.wash,
                text:
                    'Are there at least two usable and sex-separated toilets available for patients?',
                recommendationText:
                    'Ensure male and female toilets are distinctly separated and functional.',
                selectedCompliance: ComplianceLevel.pending),
            AssessmentQuestion(
                id: 'tc_2_4_7',
                category: AssessmentCategory.wash,
                text:
                    'Is there at least one improved and usable toilet facility that meets the needs for menstrual hygiene management (MHM)?',
                recommendationText:
                    'Provide a private MHM toilet with a washing area and proper disposal bins.',
                selectedCompliance: ComplianceLevel.pending),
            AssessmentQuestion(
                id: 'tc_2_4_8',
                category: AssessmentCategory.wash,
                text:
                    'Is there at least one improved and usable toilet designed to meet the needs of people with reduced mobility?',
                recommendationText:
                    'Install ramps and handrails in at least one toilet for disabled access.',
                selectedCompliance: ComplianceLevel.pending),
            AssessmentQuestion(
                id: 'tc_2_4_9',
                category: AssessmentCategory.wash,
                text:
                    'In pediatric wards (if applicable), are the hand hygiene station and toilets designed according to children\'s needs?',
                recommendationText:
                    'Lower the height of handwashing stations and toilets in the pediatric area.',
                selectedCompliance: ComplianceLevel.pending),
            AssessmentQuestion(
                id: 'tc_2_4_10',
                category: AssessmentCategory.wash,
                text:
                    'Is the presence of at least one toilet for every 20 users guaranteed?',
                recommendationText:
                    'Construct additional latrines or toilets to meet the 1:20 ratio.',
                selectedCompliance: ComplianceLevel.pending),
            AssessmentQuestion(
                id: 'tc_4_2_6',
                category: AssessmentCategory.wash,
                text:
                    'Are there dedicated toilets directly accessible from the waiting room that meet the general criteria?',
                recommendationText:
                    'Assign specific toilets solely for the use of patients in the waiting room.',
                selectedCompliance: ComplianceLevel.pending),
          ],
        ),

        // ******************************************
        // CLUSTER 1: MPOX SUSPECT
        // ******************************************
        SpatialZone(
            id: 'c1_room',
            name: 'Suspect Room',
            coordinates: const MapCoordinates(top: 635, left: 409),
            touchArea: const MapCoordinates(
                top: 620, left: 394, width: 30, height: 30),
            checklist: _getWardRoomChecklist()),
        SpatialZone(
            id: 'c1_donning',
            name: 'Suspect Donning',
            coordinates: const MapCoordinates(top: 610, left: 355),
            touchArea: const MapCoordinates(
                top: 595, left: 340, width: 30, height: 30),
            checklist: _getWardPPEChecklist()),
        SpatialZone(
            id: 'c1_doffing',
            name: 'Suspect Doffing',
            coordinates: const MapCoordinates(top: 658, left: 355),
            touchArea: const MapCoordinates(
                top: 643, left: 340, width: 30, height: 30),
            checklist: _getWardPPEChecklist()),
        SpatialZone(
            id: 'c1_nursing',
            name: 'Suspect Nursing St.',
            coordinates: const MapCoordinates(top: 632, left: 323),
            touchArea: const MapCoordinates(
                top: 617, left: 308, width: 30, height: 30),
            checklist: _getWardNursingChecklist()),

        // ******************************************
        // CLUSTER 2: MPOX PROBABLE
        // ******************************************
        SpatialZone(
            id: 'c2_room',
            name: 'Probable Room',
            coordinates: const MapCoordinates(top: 482, left: 488),
            touchArea: const MapCoordinates(
                top: 467, left: 473, width: 30, height: 30),
            checklist: _getWardRoomChecklist()),
        SpatialZone(
            id: 'c2_donning',
            name: 'Probable Donning',
            coordinates: const MapCoordinates(top: 460, left: 433),
            touchArea: const MapCoordinates(
                top: 445, left: 418, width: 30, height: 30),
            checklist: _getWardPPEChecklist()),
        SpatialZone(
            id: 'c2_doffing',
            name: 'Probable Doffing',
            coordinates: const MapCoordinates(top: 503, left: 433),
            touchArea: const MapCoordinates(
                top: 488, left: 418, width: 30, height: 30),
            checklist: _getWardPPEChecklist()),
        SpatialZone(
            id: 'c2_nursing',
            name: 'Probable Nursing St.',
            coordinates: const MapCoordinates(top: 479, left: 403),
            touchArea: const MapCoordinates(
                top: 464, left: 388, width: 30, height: 30),
            checklist: _getWardNursingChecklist()),

        // ******************************************
        // CLUSTER 3: MPOX CONFIRMED
        // ******************************************
        SpatialZone(
            id: 'c3_room',
            name: 'Confirmed Room',
            coordinates: const MapCoordinates(top: 321, left: 412),
            touchArea: const MapCoordinates(
                top: 306, left: 397, width: 30, height: 30),
            checklist: _getWardRoomChecklist()),
        SpatialZone(
            id: 'c3_donning',
            name: 'Confirmed Donning',
            coordinates: const MapCoordinates(top: 299, left: 358),
            touchArea: const MapCoordinates(
                top: 284, left: 343, width: 30, height: 30),
            checklist: _getWardPPEChecklist()),
        SpatialZone(
            id: 'c3_doffing',
            name: 'Confirmed Doffing',
            coordinates: const MapCoordinates(top: 344, left: 358),
            touchArea: const MapCoordinates(
                top: 329, left: 343, width: 30, height: 30),
            checklist: _getWardPPEChecklist()),
        SpatialZone(
            id: 'c3_nursing',
            name: 'Confirmed Nursing St.',
            coordinates: const MapCoordinates(top: 321, left: 325),
            touchArea: const MapCoordinates(
                top: 306, left: 310, width: 30, height: 30),
            checklist: _getWardNursingChecklist()),
      ],
    );
  }

  // ==========================================
  // METODI HELPER PER I CLUSTER
  // ==========================================

  static List<AssessmentQuestion> _getTriagePPEChecklist() {
    return [
      AssessmentQuestion(
          id: 'tc_4_3_2',
          category: AssessmentCategory.spatialLayout,
          text:
              'Are there dedicated and separate donning and doffing spaces, strategically located between the staff area and the patient area at triage?',
          recommendationText:
              'Establish strict donning and doffing zones at the boundary of the triage red zone.',
          selectedCompliance: ComplianceLevel.pending),
      AssessmentQuestion(
          id: 'tc_4_3_3',
          category: AssessmentCategory.logistics,
          text:
              'Are the donning/doffing areas separate, large enough (at least 4 m²), and equipped with shelves for PPE, mirrors, bins, and handwashing stations?',
          recommendationText:
              'Upgrade the triage PPE areas to meet the 4 m² requirement and install necessary mirrors and bins.',
          selectedCompliance: ComplianceLevel.pending),
    ];
  }

  static List<AssessmentQuestion> _getWardRoomChecklist() {
    return [
      AssessmentQuestion(
          id: 'tc_2_2_3',
          category: AssessmentCategory.spatialLayout,
          text:
              'In areas with suspected or confirmed Mpox cases, is a minimum indoor ventilation of 60 l/s/person (natural or mechanical) guaranteed, or are they outdoor spaces?',
          recommendationText:
              'Improve ventilation by opening windows or installing mechanical extractors to reach 60 l/s/person.',
          selectedCompliance: ComplianceLevel.pending),
      AssessmentQuestion(
          id: 'tc_2_2_5',
          category: AssessmentCategory.infectionPreventionControl,
          text:
              'Are the building finishing materials and furniture smooth, non-porous, easy to maintain, and resistant to microbial growth?',
          recommendationText:
              'Replace porous furniture and seal surfaces to allow for effective chemical disinfection.',
          selectedCompliance: ComplianceLevel.pending),
      AssessmentQuestion(
          id: 'tc_4_4_1',
          category: AssessmentCategory.infectionPreventionControl,
          text:
              'Is the ward clearly identified and does the path lead patients from triage to the ward without crossing staff or non-Mpox areas?',
          recommendationText:
              'Mark the ward boundaries clearly and fence off the patient pathway from clean zones.',
          selectedCompliance: ComplianceLevel.pending),
      AssessmentQuestion(
          id: 'tc_4_4_5',
          category: AssessmentCategory.infectionPreventionControl,
          text:
              'Do suspected patients have single rooms, and if probable/confirmed cases are placed in shared rooms (cohorts), is there at least 2 meters of distance between beds?',
          recommendationText:
              'Ensure suspect cases are strictly isolated. Space cohorted beds at least 2 meters apart.',
          selectedCompliance: ComplianceLevel.pending),
      AssessmentQuestion(
          id: 'tc_4_4_6',
          category: AssessmentCategory.spatialLayout,
          text:
              'Are some of the rooms equipped (or easily adaptable) to accommodate patients with special needs (pregnant women, pediatrics, people with disabilities)?',
          recommendationText:
              'Prepare at least one room with appropriate child-friendly or accessible furniture.',
          selectedCompliance: ComplianceLevel.pending),
      AssessmentQuestion(
          id: 'tc_4_4_7',
          category: AssessmentCategory.spatialLayout,
          text:
              'Are the dimensions of the single room (or bed compartment) at least 3.45 x 3.6 m, without any obstacles around the bed for staff access?',
          recommendationText:
              'Ensure a minimum 3.45 x 3.6 m footprint per bed to allow 360-degree clinical access.',
          selectedCompliance: ComplianceLevel.pending),
      AssessmentQuestion(
          id: 'tc_4_4_8',
          category: AssessmentCategory.logistics,
          text:
              'Are there extra rooms equipped and ready for immediate use in case of a sudden increase in bed demand?',
          recommendationText:
              'Identify and prepare an overflow ward area for immediate activation.',
          selectedCompliance: ComplianceLevel.pending),
      AssessmentQuestion(
          id: 'tc_4_4_9',
          category: AssessmentCategory.wash,
          text:
              'Do both suspected and confirmed cases have private toilets (OR, if confirmed cases share them, do suspected cases maintain an absolutely private and non-mixed bathroom)?',
          recommendationText:
              'Ensure suspected cases NEVER share a toilet with confirmed cases or other suspects.',
          selectedCompliance: ComplianceLevel.pending),
    ];
  }

  static List<AssessmentQuestion> _getWardPPEChecklist() {
    return [
      AssessmentQuestion(
          id: 'tc_4_4_3',
          category: AssessmentCategory.spatialLayout,
          text:
              'Are the donning and doffing areas of the ward separate, in close proximity to each patient room, and allow direct passage from the staff area to the patient room and vice versa?',
          recommendationText:
              'Relocate PPE stations closer to patient rooms to prevent staff walking through corridors without PPE.',
          selectedCompliance: ComplianceLevel.pending),
      AssessmentQuestion(
          id: 'tc_4_4_4',
          category: AssessmentCategory.logistics,
          text:
              'Do the donning and doffing areas measure at least 4 m² each to allow free movement, and do they have space for shelves, mirrors, bins, and hand hygiene stations?',
          recommendationText:
              'Expand the ward PPE areas and ensure all mirrors and waste bins are correctly positioned.',
          selectedCompliance: ComplianceLevel.pending),
    ];
  }

  static List<AssessmentQuestion> _getWardNursingChecklist() {
    return [
      AssessmentQuestion(
          id: 'tc_4_4_2',
          category: AssessmentCategory.spatialLayout,
          text:
              'Is there an area dedicated exclusively to staff (e.g., Nursing station) from which visibility of the patient ward is guaranteed?',
          recommendationText:
              'Position the nursing station so staff can visually monitor patients without entering the red zone.',
          selectedCompliance: ComplianceLevel.pending),
    ];
  }
}
