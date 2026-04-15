import '../../models/assessment_models.dart';

class MpoxCongregateSettingData {
  /// Carica la struttura "Fig. 6 - Flow diagram in a screening and isolation area in congregate setting"
  /// Basato sui criteri OMS (Sezione 2 e Sezione 6)
  static FacilityLayout getLayout() {
    return FacilityLayout(
      facilityName: "Screening & Isolation in Congregate Setting",
      emergencyType: EmergencyType.mpox,
      // Assicurati che il nome corrisponda all'immagine salvata in assets/maps/
      mapImagePath: 'assets/maps/facility_map_congregate.png',
      zones: [
        // ==========================================
        // 1. SCREENING RECEPTION
        // ==========================================
        SpatialZone(
          id: 'cs_z1_screening_reception',
          name: 'Screening Reception',
          coordinates: const MapCoordinates(top: 464, left: 564),
          touchArea:
              const MapCoordinates(top: 449, left: 549, width: 30, height: 30),
          checklist: _getScreeningChecklist(),
        ),

        // ==========================================
        // 2. SCREENING SETTLEMENT
        // ==========================================
        SpatialZone(
          id: 'cs_z2_screening_settlement',
          name: 'Screening',
          coordinates: const MapCoordinates(top: 468, left: 349),
          touchArea:
              const MapCoordinates(top: 453, left: 334, width: 30, height: 30),
          checklist: _getScreeningChecklist(),
        ),

        // ==========================================
        // 3. WAITING ROOM
        // ==========================================
        SpatialZone(
          id: 'cs_z3_waiting',
          name: 'Waiting Room',
          coordinates: const MapCoordinates(top: 471, left: 263),
          touchArea:
              const MapCoordinates(top: 456, left: 248, width: 30, height: 30),
          checklist: [
            AssessmentQuestion(
                id: 'cs_6_2_1',
                category: AssessmentCategory.spatialLayout,
                text:
                    'Is the waiting room located close (less than 5 meters) to the screening areas and the consulting room?',
                recommendationText:
                    'Relocate the waiting tent to be within a 5-meter radius of screening and consulting to minimize walking distance for suspects.',
                selectedCompliance: ComplianceLevel.pending),
            AssessmentQuestion(
                id: 'cs_6_2_3',
                category: AssessmentCategory.spatialLayout,
                text:
                    'Do the furniture and floor markings in the waiting room ensure at least 2 meters of distance between patients?',
                recommendationText:
                    'Place chairs or visual markers exactly 2 meters apart to enforce physical distancing.',
                selectedCompliance: ComplianceLevel.pending),
            AssessmentQuestion(
                id: 'cs_6_2_4',
                category: AssessmentCategory.spatialLayout,
                text:
                    'Is at least 4 m² of space guaranteed for each patient in the waiting room?',
                recommendationText:
                    'Limit the number of people allowed inside the waiting tent simultaneously to guarantee 4 m² per person.',
                selectedCompliance: ComplianceLevel.pending),
            AssessmentQuestion(
                id: 'cs_6_2_5',
                category: AssessmentCategory.logistics,
                text:
                    'Can the waiting area be expanded and is it already equipped in case of access peaks to avoid overcrowding?',
                recommendationText:
                    'Have a backup tent or shaded outdoor area with pre-positioned seating ready for immediate deployment.',
                selectedCompliance: ComplianceLevel.pending),
            AssessmentQuestion(
                id: 'cs_6_2_6',
                category: AssessmentCategory.wash,
                text:
                    'Are there dedicated toilets directly accessible from the waiting area and equipped with a hand hygiene station?',
                recommendationText:
                    'Install portable latrines and handwashing stations exclusively for the use of patients in the waiting area.',
                selectedCompliance: ComplianceLevel.pending),
          ],
        ),

        // ==========================================
        // 4. CONSULTING ROOM
        // ==========================================
        SpatialZone(
          id: 'cs_z4_consulting',
          name: 'Consulting Room',
          coordinates: const MapCoordinates(top: 484, left: 126),
          touchArea:
              const MapCoordinates(top: 469, left: 111, width: 30, height: 30),
          checklist: [
            AssessmentQuestion(
                id: 'cs_6_3_1',
                category: AssessmentCategory.spatialLayout,
                text:
                    'Is the consulting room located near the waiting room and the temporary isolation room, so that all suspected cases are required to pass through it?',
                recommendationText:
                    'Ensure the facility flow forces all individuals from the waiting area directly into the consulting room.',
                selectedCompliance: ComplianceLevel.pending),
            AssessmentQuestion(
                id: 'cs_6_3_4',
                category: AssessmentCategory.spatialLayout,
                text:
                    'Does the consulting room measure at least 12 m² and is it equipped with a table, chairs, a changing area with privacy curtains, a bed, and a clinical trolley?',
                recommendationText:
                    'Ensure the consulting tent is large enough (≥12 m²) and fully furnished for clinical examinations with privacy.',
                selectedCompliance: ComplianceLevel.pending),
            AssessmentQuestion(
                id: 'cs_6_3_5',
                category: AssessmentCategory.logistics,
                text:
                    'Is an additional room equipped and ready for use for triage/consultation available in case of excessive patient influx?',
                recommendationText:
                    'Set up a secondary consulting tent fully equipped to handle surges in suspected cases.',
                selectedCompliance: ComplianceLevel.pending),
            AssessmentQuestion(
                id: 'cs_2_2_5',
                category: AssessmentCategory.infectionPreventionControl,
                text:
                    'Are the building finishing materials and furniture smooth, non-porous, easy to maintain/repair, and resistant to microbial growth?',
                recommendationText:
                    'Replace difficult-to-clean canvas or wood furniture with smooth, wipeable plastic or metal.',
                selectedCompliance: ComplianceLevel.pending),
          ],
        ),

        // ------------------------------------------
        // 4A. CONSULTING DONNING
        // ------------------------------------------
        SpatialZone(
          id: 'cs_z4a_consulting_donning',
          name: 'Consulting Donning',
          coordinates: const MapCoordinates(top: 488, left: 188),
          touchArea:
              const MapCoordinates(top: 473, left: 173, width: 30, height: 30),
          checklist: _getConsultingPPEChecklist(),
        ),

        // ------------------------------------------
        // 4B. CONSULTING DOFFING
        // ------------------------------------------
        SpatialZone(
          id: 'cs_z4b_consulting_doffing',
          name: 'Consulting Doffing',
          coordinates: const MapCoordinates(top: 525, left: 175),
          touchArea:
              const MapCoordinates(top: 510, left: 160, width: 30, height: 30),
          checklist: _getConsultingPPEChecklist(),
        ),

        // ==========================================
        // 5. TEMPORARY ISOLATION
        // ==========================================
        SpatialZone(
          id: 'cs_z5_temp_isolation',
          name: 'Temporary Isolation',
          coordinates: const MapCoordinates(top: 592, left: 126),
          touchArea:
              const MapCoordinates(top: 577, left: 111, width: 30, height: 30),
          checklist: [
            AssessmentQuestion(
                id: 'cs_6_4_1',
                category: AssessmentCategory.spatialLayout,
                text:
                    'Is the temporary isolation room clearly identified, with dedicated paths without staff crossing, and does it have a dedicated exit towards the ambulance bay for transfers?',
                recommendationText:
                    'Ensure the isolation tent has a direct, secure path to the ambulance bay that avoids all clean zones.',
                selectedCompliance: ComplianceLevel.pending),
            AssessmentQuestion(
                id: 'cs_6_4_4',
                category: AssessmentCategory.infectionPreventionControl,
                text:
                    'Are the temporary isolation rooms individual and equipped with private toilets compliant with the basic criteria?',
                recommendationText:
                    'Provide a dedicated, non-shared portable toilet for each individual in temporary isolation.',
                selectedCompliance: ComplianceLevel.pending),
            AssessmentQuestion(
                id: 'cs_6_4_5',
                category: AssessmentCategory.spatialLayout,
                text:
                    'Does the single temporary isolation room for suspected cases measure at least 8 m² and have a private bathroom?',
                recommendationText:
                    'Ensure the isolation tent provides at least 8 m² of space per suspected patient.',
                selectedCompliance: ComplianceLevel.pending),
            AssessmentQuestion(
                id: 'cs_6_4_6',
                category: AssessmentCategory.logistics,
                text:
                    'Are extra temporary isolation rooms available, equipped and ready for use in case of increased bed demand?',
                recommendationText:
                    'Maintain standby isolation tents that can be immediately activated if suspected cases increase.',
                selectedCompliance: ComplianceLevel.pending),
            AssessmentQuestion(
                id: 'cs_2_2_3',
                category: AssessmentCategory.spatialLayout,
                text:
                    'In all areas with suspected or confirmed Mpox cases, is a minimum indoor ventilation of 60 l/s/person guaranteed (through natural or mechanical ventilation) or are they outdoor spaces?',
                recommendationText:
                    'Open tent flaps/windows to ensure maximum natural cross-ventilation.',
                selectedCompliance: ComplianceLevel.pending),
          ],
        ),

        // ------------------------------------------
        // 5A. TEMPORARY ISOLATION DONNING
        // ------------------------------------------
        SpatialZone(
          id: 'cs_z5a_temp_iso_donning',
          name: 'Temp Iso Donning',
          coordinates: const MapCoordinates(top: 569, left: 188),
          touchArea:
              const MapCoordinates(top: 554, left: 173, width: 30, height: 30),
          checklist: _getTempIsolationPPEChecklist(),
        ),

        // ------------------------------------------
        // 5B. TEMPORARY ISOLATION DOFFING
        // ------------------------------------------
        SpatialZone(
          id: 'cs_z5b_temp_iso_doffing',
          name: 'Temp Iso Doffing',
          coordinates: const MapCoordinates(top: 610, left: 188),
          touchArea:
              const MapCoordinates(top: 595, left: 173, width: 30, height: 30),
          checklist: _getTempIsolationPPEChecklist(),
        ),

        // ==========================================
        // 6. TREATMENT AREA
        // ==========================================
        SpatialZone(
          id: 'cs_z6_treatment_area',
          name: 'Treatment Area',
          coordinates: const MapCoordinates(top: 688, left: 179),
          touchArea:
              const MapCoordinates(top: 673, left: 164, width: 30, height: 30),
          checklist: [
            AssessmentQuestion(
                id: 'cs_6_5_1',
                category: AssessmentCategory.spatialLayout,
                text:
                    'Is the isolation area for mild cases available and positioned close to the consulting room and the ambulance bay?',
                recommendationText:
                    'Locate the mild isolation area in a secure perimeter close to the exit/ambulance bay for safe management.',
                selectedCompliance: ComplianceLevel.pending),
            AssessmentQuestion(
                id: 'cs_6_5_2',
                category: AssessmentCategory.infectionPreventionControl,
                text:
                    'In the isolation area, are mild cases placed in individual rooms with private bathrooms (OR are members of the same household safely cohorted)?',
                recommendationText:
                    'Provide individual tents for mild cases, or cohort strict household groups only.',
                selectedCompliance: ComplianceLevel.pending),
            AssessmentQuestion(
                id: 'cs_2_4_5',
                category: AssessmentCategory.wash,
                text:
                    'Do all toilets have functional handwashing stations within a 5-meter radius?',
                recommendationText:
                    'Install handwashing stations with soap and water immediately outside all latrine blocks.',
                selectedCompliance: ComplianceLevel.pending),
            AssessmentQuestion(
                id: 'cs_2_4_6',
                category: AssessmentCategory.wash,
                text:
                    'Are at least two improved, usable, and strictly gender-separated toilets available for patients?',
                recommendationText:
                    'Construct distinct male and female latrine blocks with clear signage.',
                selectedCompliance: ComplianceLevel.pending),
            AssessmentQuestion(
                id: 'cs_2_4_7',
                category: AssessmentCategory.wash,
                text:
                    'Is at least one improved and usable toilet present that meets the needs for Menstrual Hygiene Management (MHM)?',
                recommendationText:
                    'Upgrade at least one female latrine to include a washing area and safe disposal for MHM.',
                selectedCompliance: ComplianceLevel.pending),
            AssessmentQuestion(
                id: 'cs_2_4_8',
                category: AssessmentCategory.wash,
                text:
                    'Is at least one usable and improved toilet present that meets the needs of people with reduced mobility?',
                recommendationText:
                    'Install a ramp and support rails in at least one latrine.',
                selectedCompliance: ComplianceLevel.pending),
            AssessmentQuestion(
                id: 'cs_2_4_9',
                category: AssessmentCategory.wash,
                text:
                    '(If applicable) Are hand hygiene stations and toilets designed to meet children\'s needs?',
                recommendationText:
                    'Provide steps or lower handwashing stations for pediatric use.',
                selectedCompliance: ComplianceLevel.pending),
            AssessmentQuestion(
                id: 'cs_2_4_10',
                category: AssessmentCategory.wash,
                text:
                    'Is the presence of at least one toilet guaranteed for every 20 users?',
                recommendationText:
                    'Calculate the total camp occupancy and construct additional latrines to meet the 1:20 ratio.',
                selectedCompliance: ComplianceLevel.pending),
          ],
        ),

        // ------------------------------------------
        // 6A. TREATMENT AREA DONNING
        // ------------------------------------------
        SpatialZone(
          id: 'cs_z6a_treatment_donning',
          name: 'Treatment Donning',
          coordinates: const MapCoordinates(top: 641, left: 220),
          touchArea:
              const MapCoordinates(top: 626, left: 205, width: 30, height: 30),
          checklist: _getTreatmentPPEChecklist(),
        ),

        // ------------------------------------------
        // 6B. TREATMENT AREA DOFFING
        // ------------------------------------------
        SpatialZone(
          id: 'cs_z6b_treatment_doffing',
          name: 'Treatment Doffing',
          coordinates: const MapCoordinates(top: 672, left: 239),
          touchArea:
              const MapCoordinates(top: 657, left: 224, width: 30, height: 30),
          checklist: _getTreatmentPPEChecklist(),
        ),

        // ==========================================
        // 7. STAFF AREA
        // ==========================================
        SpatialZone(
          id: 'cs_z7_staff_area',
          name: 'Staff Area',
          coordinates: const MapCoordinates(top: 565, left: 464),
          touchArea:
              const MapCoordinates(top: 550, left: 449, width: 30, height: 30),
          checklist: [
            AssessmentQuestion(
                id: 'cs_2_1_2',
                category: AssessmentCategory.spatialLayout,
                text:
                    'Are the areas clearly divided and identified between an area for personnel in PPE/patients and an area exclusively for staff?',
                recommendationText:
                    'Install physical barriers (e.g., fencing) to strictly separate the clean staff area from all patient zones.',
                selectedCompliance: ComplianceLevel.pending),
            AssessmentQuestion(
                id: 'cs_2_1_5',
                category: AssessmentCategory.spatialLayout,
                text:
                    'Is the facility perimeter defined by a single fence with limited and all controlled access points?',
                recommendationText:
                    'Secure the entire camp facility with a single continuous fence and guard the entry points.',
                selectedCompliance: ComplianceLevel.pending),
            AssessmentQuestion(
                id: 'cs_2_2_1',
                category: AssessmentCategory.logistics,
                text:
                    'Does the electrical system comply with national regulations and is it equipped with a functioning emergency power system?',
                recommendationText:
                    'Provide a backup generator or solar panels to ensure continuous power supply to the camp facility.',
                selectedCompliance: ComplianceLevel.pending),
            AssessmentQuestion(
                id: 'cs_2_2_2',
                category: AssessmentCategory.logistics,
                text:
                    'Does the fire safety system comply with national regulations and is an evacuation plan available and known to staff and patients?',
                recommendationText:
                    'Distribute fire extinguishers and establish a clear evacuation assembly point for the camp.',
                selectedCompliance: ComplianceLevel.pending),
            AssessmentQuestion(
                id: 'cs_2_2_4',
                category: AssessmentCategory.logistics,
                text:
                    'If present, is the mechanical ventilation system fully functional and subject to regular maintenance according to the manufacturer\'s instructions?',
                recommendationText:
                    'Schedule immediate maintenance for any mechanical fans or extractors used in the tents.',
                selectedCompliance: ComplianceLevel.pending),
          ],
        ),

        // ==========================================
        // 8. STORAGE
        // ==========================================
        SpatialZone(
          id: 'cs_z8_storage',
          name: 'Storage',
          coordinates: const MapCoordinates(top: 670, left: 423),
          touchArea:
              const MapCoordinates(top: 655, left: 408, width: 30, height: 30),
          checklist: [
            AssessmentQuestion(
                id: 'cs_2_4_1',
                category: AssessmentCategory.wash,
                text:
                    'Is water available within the facility, does it come from a safe (improved) source, and is it in sufficient quantity?',
                recommendationText:
                    'Establish a reliable water trucking schedule or connection to an improved water source.',
                selectedCompliance: ComplianceLevel.pending),
            AssessmentQuestion(
                id: 'cs_2_4_2',
                category: AssessmentCategory.wash,
                text:
                    'Is there a protected water storage system sufficient to cover needs for at least two days?',
                recommendationText:
                    'Install large covered water bladders or tanks to hold a 48-hour reserve.',
                selectedCompliance: ComplianceLevel.pending),
            AssessmentQuestion(
                id: 'cs_2_4_3',
                category: AssessmentCategory.wash,
                text:
                    'Does the quality of drinking water comply with national regulations (e.g., residual chlorine 0.2-0.5 mg/L at the point of use, 0 E. coli, and turbidity <5 NTU)?',
                recommendationText:
                    'Implement daily chlorination and testing of the stored water.',
                selectedCompliance: ComplianceLevel.pending),
          ],
        ),

        // ==========================================
        // 9. WASTE AREA
        // ==========================================
        SpatialZone(
          id: 'cs_z9_waste',
          name: 'Waste Area',
          coordinates: const MapCoordinates(top: 689, left: 325),
          touchArea:
              const MapCoordinates(top: 674, left: 310, width: 30, height: 30),
          checklist: [
            AssessmentQuestion(
                id: 'cs_2_3_1',
                category: AssessmentCategory.wash,
                text:
                    'Is a fenced waste management area available, with sufficient capacity to treat ash, organic and sharp waste, equipped with a cleaning area with running water?',
                recommendationText:
                    'Construct a fenced waste pit/incinerator area safely distanced from the main patient tents.',
                selectedCompliance: ComplianceLevel.pending),
            AssessmentQuestion(
                id: 'cs_2_3_2',
                category: AssessmentCategory.wash,
                text:
                    'Is there a functional 3-bin system for waste segregation and is it sorted correctly at all points of generation?',
                recommendationText:
                    'Ensure 3 color-coded bins are present in every single tent and area of the camp.',
                selectedCompliance: ComplianceLevel.pending),
            AssessmentQuestion(
                id: 'cs_2_3_3',
                category: AssessmentCategory.wash,
                text:
                    'Is hazardous waste treated or disposed of safely inside or outside the facility?',
                recommendationText:
                    'Ensure hazardous/infectious waste is incinerated or safely buried in a lined pit.',
                selectedCompliance: ComplianceLevel.pending),
            AssessmentQuestion(
                id: 'cs_2_4_4',
                category: AssessmentCategory.wash,
                text:
                    'Is wastewater safely managed, preventing the discharge of sewage and faecal sludge into the environment?',
                recommendationText:
                    'Ensure latrines and greywater from washing stations drain into safely sealed soak pits.',
                selectedCompliance: ComplianceLevel.pending),
          ],
        ),
      ],
    );
  }

  // ==========================================
  // METODI HELPER PER I BLOCCHI RIPETUTI
  // ==========================================

  static List<AssessmentQuestion> _getScreeningChecklist() {
    return [
      AssessmentQuestion(
          id: 'cs_2_1_1',
          category: AssessmentCategory.spatialLayout,
          text:
              'Do patients and staff have dedicated, clearly labelled entrances?',
          recommendationText:
              'Ensure entrances to the screening area are distinct for staff and patients.',
          selectedCompliance: ComplianceLevel.pending),
      AssessmentQuestion(
          id: 'cs_2_1_3',
          category: AssessmentCategory.infectionPreventionControl,
          text:
              'Is the patient flow logical, clear, well-signposted, and easy to follow (e.g., screening > waiting room > consulting room > isolation)?',
          recommendationText:
              'Set up clear ropes/fencing and signage to direct the patient flow strictly in one direction.',
          selectedCompliance: ComplianceLevel.pending),
      AssessmentQuestion(
          id: 'cs_2_1_4',
          category: AssessmentCategory.infectionPreventionControl,
          text:
              'Do all visitors enter through a designated and controlled entrance, equipped with a hand hygiene station and screening area?',
          recommendationText:
              'Make sure no individual can bypass the handwashing and temperature/symptom check.',
          selectedCompliance: ComplianceLevel.pending),
      AssessmentQuestion(
          id: 'cs_6_1_1',
          category: AssessmentCategory.spatialLayout,
          text:
              'Are screening stations present at the entrance for new arrivals (Station 1) and screening stations accessible from within the settlement for those who develop symptoms (Station 2), all clearly signposted with guiding paths?',
          recommendationText:
              'Set up two distinct screening points: one for outside arrivals and one for internal camp residents.',
          selectedCompliance: ComplianceLevel.pending),
      AssessmentQuestion(
          id: 'cs_6_1_2',
          category: AssessmentCategory.infectionPreventionControl,
          text:
              'In the screening area, are there separate exits and flows so that suspected patients access the isolated facility and non-suspected patients return to the settlement without crossing paths?',
          recommendationText:
              'Create a hard physical split after the screening desk to immediately separate suspect cases from others.',
          selectedCompliance: ComplianceLevel.pending),
      AssessmentQuestion(
          id: 'cs_6_1_3',
          category: AssessmentCategory.spatialLayout,
          text:
              'In screening, is a distance of at least 1 meter guaranteed between patients and staff through physical barriers or floor markings?',
          recommendationText:
              'Place a table or physical barrier to maintain the 1m distance between screener and patient.',
          selectedCompliance: ComplianceLevel.pending),
      AssessmentQuestion(
          id: 'cs_6_1_4',
          category: AssessmentCategory.spatialLayout,
          text:
              'Does each individual screening station have more than 8 m² of surface area?',
          recommendationText:
              'Increase the footprint of the screening tent to avoid crowding.',
          selectedCompliance: ComplianceLevel.pending),
    ];
  }

  static List<AssessmentQuestion> _getConsultingPPEChecklist() {
    return [
      AssessmentQuestion(
          id: 'cs_6_3_2',
          category: AssessmentCategory.spatialLayout,
          text:
              'Are there separate donning and doffing spaces strategically positioned between the staff area and the patient area to facilitate PPE change?',
          recommendationText:
              'Establish strict donning and doffing zones at the perimeter of the consulting room.',
          selectedCompliance: ComplianceLevel.pending),
      AssessmentQuestion(
          id: 'cs_6_3_3',
          category: AssessmentCategory.logistics,
          text:
              'Do the donning and doffing areas ensure a space of at least 4 m² (to allow free movement), and are they equipped with PPE shelves, bins, a mirror, and a handwashing station?',
          recommendationText:
              'Expand the PPE changing areas to 4 m² minimum and ensure all necessary equipment is present.',
          selectedCompliance: ComplianceLevel.pending),
    ];
  }

  static List<AssessmentQuestion> _getTempIsolationPPEChecklist() {
    return [
      AssessmentQuestion(
          id: 'cs_6_4_2',
          category: AssessmentCategory.spatialLayout,
          text:
              'Does the temporary isolation area have separate donning and doffing spaces, directly accessible from the staff area and very close to the isolation room?',
          recommendationText:
              'Position the PPE stations immediately adjacent to the isolation tent to prevent staff from moving un-protected.',
          selectedCompliance: ComplianceLevel.pending),
      AssessmentQuestion(
          id: 'cs_6_4_3',
          category: AssessmentCategory.logistics,
          text:
              'Do the donning and doffing spaces near temporary isolation measure at least 4 m², are they separate and equipped with basic furniture (shelves, bins, handwashing station, and mirror)?',
          recommendationText:
              'Ensure PPE areas for isolation staff meet the 4 m² size requirement and are fully stocked.',
          selectedCompliance: ComplianceLevel.pending),
    ];
  }

  static List<AssessmentQuestion> _getTreatmentPPEChecklist() {
    return [
      AssessmentQuestion(
          id: 'cs_6_5_3',
          category: AssessmentCategory.spatialLayout,
          text:
              'Does the treatment/isolation area have separate donning and doffing spaces, directly accessible from the staff area?',
          recommendationText:
              'Establish dedicated PPE stations immediately adjacent to the treatment tents.',
          selectedCompliance: ComplianceLevel.pending),
      AssessmentQuestion(
          id: 'cs_6_5_4',
          category: AssessmentCategory.logistics,
          text:
              'Do the donning and doffing spaces near the treatment area measure at least 4 m², are they separate and equipped with basic furniture (shelves, bins, handwashing station, and mirror)?',
          recommendationText:
              'Ensure PPE areas for treatment staff meet the 4 m² size requirement and are fully stocked.',
          selectedCompliance: ComplianceLevel.pending),
    ];
  }
}
