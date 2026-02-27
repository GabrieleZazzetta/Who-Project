// Enum per le malattie (Punto 1 del tuo flusso)
enum EmergencyType {
  mpox,
  ebola,
  sars,
}

// Enum per i tipi di Facility (Punto 2 del tuo flusso)
// Basato sulle figure del PDF [cite: 255, 268, 331, 514, 650]
enum FacilityType {
  screeningAndIsolation, // Fig 2
  existingFacilityWithWard, // Fig 4 (Il nostro focus attuale)
  standAloneCenter, // Fig 5
  congregateSetting, // Fig 6
}

// Classe per una singola Domanda di valutazione (Annex 2 del PDF)
class AssessmentQuestion {
  final String id;
  final String questionText;
  final String citation; // Riferimento al PDF es: "Section 4.4.1"
  int score; // 0 = non valutato, 1 = Does not meet, 2 = Partial, 3 = Meets
  String? comment;

  AssessmentQuestion({
    required this.id,
    required this.questionText,
    required this.citation,
    this.score = 0,
    this.comment,
  });
}

// La "Bolla" specifica (Livello Micro) - es. "Triage", "Donning", "Patient Room"
class MicroArea {
  final String id;
  final String name;
  final String description; // "Main purpose and activities" dalle tabelle
  final List<String> designPrinciples; // "Design principles" dalle tabelle
  final List<AssessmentQuestion> questions; // Domande specifiche per questa area

  MicroArea({
    required this.id,
    required this.name,
    required this.description,
    required this.designPrinciples,
    required this.questions,
  });
}

// Il "Box Rettangolare" (Livello Macro) - es. "Admission Area", "Treatment Ward"
class MacroArea {
  final String name;
  final List<MicroArea> subAreas; // Le bolle contenute in questo box

  MacroArea({required this.name, required this.subAreas});
}