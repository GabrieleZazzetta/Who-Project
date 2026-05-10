import '../models/assessment_models.dart';

// ZONA VIRTUALE: VALUTAZIONE GENERALE STRUTTURA
// Zona con coordinate fuori viewport, non renderizzata sulla mappa.
// Raccoglie i requisiti trasversali applicabili all'intera struttura sanitaria.

SpatialZone getGeneralFacilityZone() {
  return SpatialZone(
      id: 'general_facility_assessment',
      name: 'General Facility Assessment',
      coordinates: const MapCoordinates(top: -1000, left: -1000),
      touchArea:
          const MapCoordinates(top: -1000, left: -1000, width: 0, height: 0),
      checklist: [
        // Accessi e flussi
        AssessmentQuestion(
          id: 'gen_2_1_1',
          category: AssessmentCategory.spatialLayout,
          text:
              'Healthcare facility entrances\n\nAre there dedicated and clearly labelled entrances separated for both patients and staff?',
          recommendationText:
              'Ensure dedicated and clearly labelled entrances for patients and staff to minimize cross-contamination.',
        ),
        AssessmentQuestion(
          id: 'gen_2_1_2',
          category: AssessmentCategory.spatialLayout,
          text:
              'Area distribution\n\nAre the areas clearly divided and identified into one zone for staff in PPE and patients, and another strictly for staff only?',
          recommendationText:
              'Clearly divide and identify the staff-only areas from the PPE/patient areas.',
        ),
        AssessmentQuestion(
          id: 'gen_2_1_3',
          category: AssessmentCategory.spatialLayout,
          text:
              'Patient flow\n\nIs the patient flow logical, clearly labelled, and easy to follow (e.g., sequentially from screening to waiting room, then triage, then treatment/isolation)?',
          recommendationText:
              'Organize patient flow logically with clear signs (screening > waiting > triage > treatment).',
        ),
        AssessmentQuestion(
          id: 'gen_2_1_4',
          category: AssessmentCategory.spatialLayout,
          text:
              'Visitor access\n\nDo all visitors enter the facility through a strictly designated and controlled entrance equipped with a hand hygiene station and a screening point?',
          recommendationText:
              'Set up a controlled visitor entrance with mandatory hand hygiene and screening stations.',
        ),
        AssessmentQuestion(
          id: 'gen_2_1_5',
          category: AssessmentCategory.spatialLayout,
          text:
              'Facility delimitation\n\nIs the facility compound delimited by a continuous single fence, with a limited number of access points that are all strictly controlled?',
          recommendationText:
              'Install a continuous perimeter fence and control all access points to the facility.',
        ),

        // Impianti e finiture
        AssessmentQuestion(
          id: 'gen_2_2_1',
          category: AssessmentCategory.logistics,
          text:
              'Electricity\n\nIs the electrical system fully compliant with national regulations and equipped with a functional back-up energy supply system for critical services?',
          recommendationText:
              'Ensure the electrical system meets regulations and critical services are on back-up power.',
        ),
        AssessmentQuestion(
          id: 'gen_2_2_2',
          category: AssessmentCategory.logistics,
          text:
              'Fire safety\n\nIs the facility\'s fire safety system compliant with national regulations, and is an evacuation plan available and known by both staff and patients?',
          recommendationText:
              'Update fire safety systems to regulations and display a clear evacuation plan.',
        ),
        AssessmentQuestion(
          id: 'gen_2_2_3',
          category: AssessmentCategory.logistics,
          text:
              'Ventilation, airflow rate\n\nAre all areas with suspected or confirmed mpox cases located outdoors, or do they have a minimum indoor ventilation rate of 60 l/s/person (via natural or mechanical ventilation)?',
          recommendationText:
              'Ensure adequate ventilation in all mpox areas (at least 60 l/s/person or constantly open windows).',
        ),
        AssessmentQuestion(
          id: 'gen_2_2_4',
          category: AssessmentCategory.logistics,
          text:
              'Ventilation system maintenance\n\nIf a mechanical ventilation system is present, is it perfectly functioning and properly maintained according to the manufacturer\'s recommendations?',
          recommendationText:
              'Establish a regular maintenance schedule for mechanical ventilation systems.',
        ),
        AssessmentQuestion(
          id: 'gen_2_2_5',
          category: AssessmentCategory.logistics,
          text:
              'Finishing materials and furniture\n\nAre the building finishing materials and furniture completely smooth, non-porous, easy to maintain and repair, and resistant to microbial growth?',
          recommendationText:
              'Replace surfaces with smooth, non-porous materials that are easy to clean and resist microbial growth.',
        ),

        // Gestione rifiuti
        AssessmentQuestion(
          id: 'gen_2_3_1',
          category: AssessmentCategory.wash,
          text:
              'Waste area\n\nIs there a dedicated, fenced waste management area of sufficient capacity that includes a cleaning and disinfection station with running water?',
          recommendationText:
              'Create a fenced, dedicated waste area with sufficient capacity and a cleaning station with running water.',
        ),
        AssessmentQuestion(
          id: 'gen_2_3_2',
          category: AssessmentCategory.wash,
          text:
              'Waste segregation\n\nIs a functional 3-bin waste system in place, and is the waste correctly segregated at ALL waste generation points?',
          recommendationText:
              'Implement a strict 3-bin waste segregation system at every single waste generation point.',
        ),
        AssessmentQuestion(
          id: 'gen_2_3_3',
          category: AssessmentCategory.wash,
          text:
              'Hazardous waste\n\nIs all hazardous waste safely and appropriately treated or disposed of, either systematically on-site or off-site?',
          recommendationText:
              'Ensure hazardous waste is strictly separated and safely treated/disposed of on-site or regularly collected.',
        ),

        // Acqua e servizi igienici
        AssessmentQuestion(
          id: 'gen_2_4_1',
          category: AssessmentCategory.wash,
          text:
              'Water availability\n\nIs water of sufficient quantity available directly on the premises from an improved and safe water source?',
          recommendationText:
              'Ensure sufficient water is available directly on the premises from an improved source.',
        ),
        AssessmentQuestion(
          id: 'gen_2_4_2',
          category: AssessmentCategory.wash,
          text:
              'Water storage\n\nIs there protected water storage available that holds a sufficient quantity to safely meet the facility\'s needs for at least two days?',
          recommendationText:
              'Install protected water storage tanks with a capacity covering at least two days of facility needs.',
        ),
        AssessmentQuestion(
          id: 'gen_2_4_3',
          category: AssessmentCategory.wash,
          text:
              'Water quality\n\nIs the drinking-water quality strictly compliant with national regulations (e.g., appropriate chlorine residual at point of use, 0 E. coli, and turbidity <5 NTU)?',
          recommendationText:
              'Monitor and treat water to ensure it meets strict quality and chlorination standards.',
        ),
        AssessmentQuestion(
          id: 'gen_2_4_4',
          category: AssessmentCategory.wash,
          text:
              'Waste water\n\nIs wastewater safely managed to strictly prevent any discharge of wastewater and faecal sludge into the surrounding environment?',
          recommendationText:
              'Repair leakages and ensure wastewater/faecal sludge is safely managed and contained.',
        ),
        AssessmentQuestion(
          id: 'gen_2_4_5',
          category: AssessmentCategory.wash,
          text:
              'Hand washing\n\nDo ALL toilets in the facility have a functional hand washing station located within 5 meters?',
          recommendationText:
              'Install functional hand washing stations within 5 meters of every toilet facility.',
        ),
        AssessmentQuestion(
          id: 'gen_2_4_6',
          category: AssessmentCategory.wash,
          text:
              'Shared toilets gender separation\n\nAre there at least two clearly gender-separated, improved, and fully usable toilets available for the patients?',
          recommendationText:
              'Provide clearly marked, separate, and improved usable toilets for men and women.',
        ),
        AssessmentQuestion(
          id: 'gen_2_4_7',
          category: AssessmentCategory.wash,
          text:
              'Improved toilet for MHM\n\nIs there at least one usable, improved toilet that fully meets Menstrual Hygiene Management (MHM) needs (including space to wash, water, cleanliness, and a disposal bin)?',
          recommendationText:
              'Ensure at least one clean, functional MHM toilet with water and disposal bins is available.',
        ),
        AssessmentQuestion(
          id: 'gen_2_4_8',
          category: AssessmentCategory.wash,
          text:
              'Toilet for people with reduced mobility\n\nIs there at least one improved and fully usable toilet that is explicitly designed to meet the needs of people with reduced mobility?',
          recommendationText:
              'Upgrade or build at least one fully accessible and usable toilet for people with reduced mobility.',
        ),
        AssessmentQuestion(
          id: 'gen_2_4_9',
          category: AssessmentCategory.wash,
          text:
              'Toilet for children (paediatric ward)\n\nIf there is a paediatric ward, are the hand hygiene stations and toilets specifically designed and appropriately sized for children\'s needs?',
          recommendationText:
              'Install child-friendly toilets and hand hygiene stations in paediatric areas.',
        ),
        AssessmentQuestion(
          id: 'gen_2_4_10',
          category: AssessmentCategory.wash,
          text:
              'Number of toilets\n\nIs there at least one fully functional toilet available for every 20 users present in the facility?',
          recommendationText:
              'Increase the number of functional toilets to ensure a ratio of at least 1 per 20 users.',
        ),
      ]);
}
