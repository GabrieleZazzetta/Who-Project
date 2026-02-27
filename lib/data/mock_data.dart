import '../models/assessment_models.dart';

// Dati statici per iniziare
class MockData {
  
  static List<MacroArea> getMpoxExistingFacilityStructure() {
    return [
      // MACRO AREA 1: INGRESSO E SCREENING
      // Basato su Fig 4 "Entry area" e Tabella 2 "Screening" [cite: 375, 473]
      MacroArea(
        name: "Entry & Screening Zone",
        subAreas: [
          MicroArea(
            id: "screen_01",
            name: "Screening Station",
            description: "Screen all persons at first point of contact.",
            designPrinciples: [
              "Visible and clearly labelled",
              "Ensure 1m distance",
              "Separate exits for suspected/non-suspected"
            ],
            questions: [
              AssessmentQuestion(
                id: "4.1.1",
                questionText: "Location: Is the screening area placed at the entrance? Do all patients pass through it?",
                citation: "Annex 2, Sec 4.1.1"
              ),
              AssessmentQuestion(
                id: "4.1.2",
                citation: "Annex 2, Sec 4.1.2",
                questionText: "Patient Pathway: Are there separated exits for suspected cases and non-suspected cases?",
              ),
              AssessmentQuestion(
                id: "4.1.3",
                citation: "Annex 2, Sec 4.1.3",
                questionText: "Physical Distance: Is there at least 1m distance between patients and staff? Are there physical barriers?",
              ),
              AssessmentQuestion(
                id: "4.1.4",
                citation: "Annex 2, Sec 4.1.4",
                questionText: "Floor Surface: Is there more than 8 m² of surface available for each screening station?",
              ),
            ],
          ),
          MicroArea(
            id: "wait_01",
            name: "Waiting Area",
            description: "Dedicated waiting area for patients waiting for triage.",
            designPrinciples: ["Avoid overcrowding", "4m² per patient"],
            questions: [
               AssessmentQuestion(
                id: "Annex 2, Sec. 4.2.1",
                questionText: "Location: Is the waiting room located between screening and triage? Is access controlled?",
                citation: "Annex 2, Sec 4.2.1"
              ),
            ]
          ),
        ],
      ),

      // MACRO AREA 2: AMMISSIONE E TRIAGE
      // Basato su Fig 4 "Admission mpox pathway" [cite: 490]
      MacroArea(
        name: "Admission & Triage",
        subAreas: [
          MicroArea(
            id: "triage_01",
            name: "Triage / Consulting Room",
            description: "Clinical assessment of suspected cases.",
            designPrinciples: ["Single patient space", "12m² minimum", "Dedicated Donning/Doffing"],
            questions: [], // Da riempire con Annex 2 Sec 4.3 [cite: 1127]
          ),
          MicroArea(
             id: "resus_01",
             name: "Resuscitation Room",
             description: "Stabilization for emergency care.",
             designPrinciples: ["Accessible by stretcher", "Hand hygiene available"],
             questions: [] 
          )
        ],
      ),

      // MACRO AREA 3: TRATTAMENTO (Cuore della Fig. 4)
      // Basato su Fig 4 "Mpox treatment area" [cite: 437]
      MacroArea(
        name: "Mpox Treatment Ward",
        subAreas: [
          MicroArea(
            id: "ward_suspect",
            name: "Suspect Cases Ward",
            description: "Individual rooms for suspected patients.",
            designPrinciples: ["Private toilet", "Dedicated pathway"],
            questions: [], // Annex 2 Sec 4.4 [cite: 1136]
          ),
          MicroArea(
            id: "ward_confirmed",
            name: "Confirmed Cases Ward",
            description: "Isolation for confirmed patients.",
            designPrinciples: ["Ideally single rooms", "Cohort if necessary"],
            questions: [],
          ),
          MicroArea(
            id: "nursing",
            name: "Nursing Station",
            description: "Area for staff monitoring.",
            designPrinciples: ["Visibility of patients", "Clean/Dirty utility separation"],
            questions: [],
          ),
          MicroArea(
            id: "donning_doffing_ward",
            name: "Donning / Doffing (Ward)",
            description: "PPE change areas.",
            designPrinciples: ["Separated areas", "Close proximity to rooms"],
            questions: [],
          ),
        ],
      ),

      // MACRO AREA 4: SERVIZI E LOGISTICA
      // Basato su Fig 4 "Administrative and service area" [cite: 419]
      MacroArea(
        name: "Logistics & Services",
        subAreas: [
          MicroArea(
            id: "waste",
            name: "Waste Management",
            description: "Collection and segregation area.",
            designPrinciples: ["Fenced area", "Incinerator downwind"],
            questions: [], // Annex 2 Sec 2.3 [cite: 1082]
          ),
          MicroArea(
            id: "morgue",
            name: "Morgue",
            description: "Holding area for deceased.",
            designPrinciples: ["Accessible but not visible to public", "Separate exit"],
            questions: [], // Annex 2 Sec 5.6 [cite: 1190]
          ),
        ],
      ),
    ];
  }
}