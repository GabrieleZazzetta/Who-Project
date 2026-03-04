import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

// ==========================================
// 1. ENUMS GLOBALI
// ==========================================

enum EmergencyType { mpox, ebola, sars }

enum FacilityType { 
  screeningAndIsolation, 
  existingFacilityWithWard, 
  standAloneCenter, 
  congregateSetting 
}

// Livelli di conformità basati sugli standard WHO
enum ComplianceLevel {
  meetsTarget,      // 3 Punti (Verde)
  partiallyMeets,   // 2 Punti (Giallo/Arancio)
  doesNotMeet,      // 1 Punto (Rosso - Critico)
  notApplicable,    // 0 Punti (Escluso dal calcolo)
  pending           // Non ancora valutato
}

// Categorie di valutazione per i grafici radar futuri
enum AssessmentCategory {
  infectionPreventionControl, // IPC (es. percorsi sporco/pulito)
  wash,                       // Acqua, Servizi igienici, Rifiuti
  spatialLayout,              // Dimensionamento, aerazione, distanze
  logistics                   // Stoccaggio farmaci, DPI
}

// ==========================================
// 2. MODELLI DELLE DOMANDE E CHECKLIST
// ==========================================

class AssessmentQuestion {
  final String id;
  final String text;
  final AssessmentCategory category;
  
  // Killer Feature: Se la struttura "Does not meet", l'app suggerirà questo testo
  final String recommendationText; 
  
  // Risultato della valutazione
  ComplianceLevel selectedCompliance;
  
  // Possibilità di allegare una foto del difetto strutturale
  String? mediaPath; 
  String? note;

  AssessmentQuestion({
    required this.id,
    required this.text,
    required this.category,
    required this.recommendationText,
    this.selectedCompliance = ComplianceLevel.pending,
    this.mediaPath,
    this.note,
  });

  // Assegnazione dei pesi per il calcolo del Readiness Score
  int get scoreValue {
    switch (selectedCompliance) {
      case ComplianceLevel.meetsTarget: return 3;
      case ComplianceLevel.partiallyMeets: return 2;
      case ComplianceLevel.doesNotMeet: return 1;
      default: return 0; // pending o N/A non fanno punteggio
    }
  }

  // Identifica se c'è un "Fatal Flaw" (Criticità bloccante)
  bool get isCriticalFailure => selectedCompliance == ComplianceLevel.doesNotMeet;
}

// ==========================================
// 3. MODELLI SPAZIALI (MAPPA)
// ==========================================

class MapCoordinates {
  final double top;
  final double left;
  final double width;
  final double height;

  const MapCoordinates({
    required this.top,
    required this.left,
    required this.width,
    required this.height,
  });
}

class SpatialZone {
  final String id;
  final String name;
  final MapCoordinates coordinates;
  
  // La lista di domande specifiche per questa singola stanza/area
  final List<AssessmentQuestion> checklist;

  SpatialZone({
    required this.id,
    required this.name,
    required this.coordinates,
    required this.checklist,
  });

  // --- LOGICA PRO: CALCOLO DELLO STATO DINAMICO ---
  
  // Calcola il Readiness Score (Percentuale da 0 a 100) di questa specifica zona
  double get readinessScore {
    int totalPossibleScore = 0;
    int actualScore = 0;

    for (var q in checklist) {
      if (q.selectedCompliance != ComplianceLevel.pending && 
          q.selectedCompliance != ComplianceLevel.notApplicable) {
        totalPossibleScore += 3; // 3 è il punteggio massimo (Meets Target)
        actualScore += q.scoreValue;
      }
    }

    if (totalPossibleScore == 0) return 0.0;
    return (actualScore / totalPossibleScore) * 100;
  }

  // Verifica quanti item sono stati completati
  double get completionPercentage {
    if (checklist.isEmpty) return 0.0;
    int completed = checklist.where((q) => q.selectedCompliance != ComplianceLevel.pending).length;
    return (completed / checklist.length) * 100;
  }

  // Determina il colore della bolla sulla mappa in base allo stato delle risposte
  Color get statusColor {
    // 1. Se non ho ancora risposto a nulla, la zona è Grigia
    if (completionPercentage == 0) return Colors.grey.shade400;

    // 2. Se c'è anche solo un "Does Not Meet" (Fatal Flaw), la zona diventa Rossa
    bool hasCritical = checklist.any((q) => q.isCriticalFailure);
    if (hasCritical) return Colors.red.shade600;

    // 3. Se ho iniziato ma non ho finito, la zona è Arancione
    if (completionPercentage < 100) return Colors.orange.shade500;

    // 4. Se ho finito e non ci sono rossi, ma c'è qualche "Parziale", la zona è Gialla
    bool hasPartial = checklist.any((q) => q.selectedCompliance == ComplianceLevel.partiallyMeets);
    if (hasPartial) return Colors.amber.shade500;

    // 5. Se tutto è "Meets Target" (Perfetto), la zona è Verde
    return Colors.green.shade600;
  }
}

// ==========================================
// 4. MODELLO GLOBALE DELLA STRUTTURA
// ==========================================

class FacilityLayout {
  final String facilityName;
  final String mapImagePath;
  final List<SpatialZone> zones;

  FacilityLayout({
    required this.facilityName,
    required this.mapImagePath,
    required this.zones,
  });

  // Calcola il Readiness Score Globale di tutto l'ospedale/campo
  double get globalReadinessScore {
    double totalScore = 0;
    int validZonesCount = 0;

    for (var zone in zones) {
      if (zone.completionPercentage > 0) {
        totalScore += zone.readinessScore;
        validZonesCount++;
      }
    }

    if (validZonesCount == 0) return 0.0;
    return totalScore / validZonesCount;
  }
}