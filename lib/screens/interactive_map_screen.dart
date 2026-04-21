import 'package:flutter/material.dart';
import 'dart:ui';
import '../models/assessment_models.dart';
import '../data/mpox/mpox_existing_ward_data.dart';
import '../services/database_service.dart'; // <-- IMPORTANTE: Il nostro database!
import 'assessment_screen.dart'; // Assicurati che questo file sia nella stessa cartella!
import '../data/facility_data_factory.dart'; // <-- IMPORTANTE: La factory per i dati delle strutture
import '../data/general_facility_data.dart'; // Assicurati che il file si chiami esattamente così!

class InteractiveMapScreen extends StatefulWidget {
  final EmergencyType emergencyType;
  final FacilityType facilityType;
  final int?
      assessmentId; // <-- Se nullo = nuova ispezione. Se ha un ID = carica l'esistente.

  const InteractiveMapScreen(
      {super.key,
      required this.emergencyType,
      required this.facilityType,
      this.assessmentId});

  @override
  State<InteractiveMapScreen> createState() => _InteractiveMapScreenState();
}

class _InteractiveMapScreenState extends State<InteractiveMapScreen>
    with SingleTickerProviderStateMixin {
  late FacilityLayout layoutData;
  bool _isLoading =
      true; // Mostra un caricamento mentre Isar legge/scrive i dati

  late AnimationController _pulseController;
  final TransformationController _mapController = TransformationController();

  @override
  void initState() {
    super.initState();
    _initDatabase(); // <-- Avvia il flusso del database

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  // --- LOGICA DATABASE CORRETTA (CON FIX LISTA BLOCCATA) ---
  Future<void> _initDatabase() async {
    try {
      if (widget.assessmentId != null) {
        // 1. CARICA ISPEZIONE ESISTENTE
        final existing = await DatabaseService.instance
            .getAssessmentById(widget.assessmentId!);
        if (existing != null) {
          layoutData = existing;

          // --- FIX BUG CLICK E MEMORIA ---
          // Se la vecchia ispezione non ha la valutazione generale, la aggiungiamo!
          bool hasGeneralZone = layoutData.zones
              .any((z) => z.id == 'general_facility_assessment');
          if (!hasGeneralZone) {
            // SBLOCCHIAMO LA LISTA PRIMA DI AGGIUNGERE LA BOLLA FANTASMA
            layoutData.zones = List<SpatialZone>.from(layoutData.zones);
            layoutData.zones.add(getGeneralFacilityZone());
          }
        } else {
          await _createNewAssessment();
        }
      } else {
        // 2. CREA NUOVA ISPEZIONE IN MEMORIA (Senza salvare)
        await _createNewAssessment();
      }
    } catch (e) {
      print("Errore caricamento database: $e");
    }

    // Ferma il caricamento e mostra la mappa
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _createNewAssessment() async {
    // CHIEDIAMO ALLA FACTORY I DATI CORRETTI!
    layoutData = FacilityDataFactory.getLayout(
        widget.emergencyType, widget.facilityType);
    layoutData.dateCreated = DateTime.now();

    // SBLOCCHIAMO LA LISTA PRIMA DI AGGIUNGERE LA BOLLA FANTASMA
    layoutData.zones = List<SpatialZone>.from(layoutData.zones);
    layoutData.zones.add(getGeneralFacilityZone());
  }
  // -------------------------

  @override
  void dispose() {
    _pulseController.dispose();
    _mapController.dispose();
    super.dispose();
  }

  void _refreshMap() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // Se stiamo leggendo/scrivendo sul db, mostra un loader
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body:
            Center(child: CircularProgressIndicator(color: Color(0xFF005DA8))),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        elevation: 1,
        shadowColor: Colors.black.withOpacity(0.2),
        iconTheme: const IconThemeData(color: Color(0xFF003D73)),

        // --- I 3 TRUCCHI PRO PER EVITARE IL TRONCAMENTO ---
        centerTitle: false, // Allinea a sinistra anziché centrare
        titleSpacing: 0, // Avvicina il testo alla freccia indietro
        title: const Text(
          "Spatial Assessment",
          style: TextStyle(
            color: Color(0xFF003D73),
            fontWeight: FontWeight.bold,
            fontSize: 18, // Leggermente ridotto per schermi piccoli
          ),
        ),

        actions: [
          // --- IL NUOVO BOTTONE PRO (COMPATTO E MODERNO) ---
          Container(
            margin: const EdgeInsets.only(
                right: 4), // Margine ridotto per recuperare spazio
            decoration: BoxDecoration(
              color: const Color(0xFF005DA8).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              tooltip: 'General Facility Assessment',
              icon: const Icon(Icons.domain_verification,
                  color: Color(0xFF005DA8),
                  size: 24), // Icona leggermente più compatta
              onPressed: () async {
                final generalZone = layoutData.zones
                    .firstWhere((z) => z.id == 'general_facility_assessment');

                await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          AssessmentScreen(zone: generalZone)),
                );

                bool hasAnsweredAtLeastOne = false;
                for (var z in layoutData.zones) {
                  for (var q in z.checklist) {
                    if (q.selectedCompliance != ComplianceLevel.pending) {
                      hasAnsweredAtLeastOne = true;
                      break;
                    }
                  }
                  if (hasAnsweredAtLeastOne) break;
                }

                if (hasAnsweredAtLeastOne) {
                  final savedId =
                      await DatabaseService.instance.saveAssessment(layoutData);
                  layoutData.id = savedId;
                }
                _refreshMap();
              },
            ),
          ),

          // --- LOGO WHO ---
          Padding(
            padding: const EdgeInsets.only(
                right: 12.0), // Padding ridotto per dare respiro al titolo
            child: Image.asset(
              'assets/images/who_logo_info.png',
              height: 45, // Leggermente scalato
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.public, color: Color(0xFF005DA8)),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade50, Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.pinch_outlined,
                    color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "Pinch to explore. Tap highlighted pins to evaluate.",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ClipRRect(
              child: InteractiveViewer(
                transformationController: _mapController,
                panEnabled: true,
                minScale: 0.1,
                maxScale: 4.0,
                constrained: false,
                boundaryMargin: const EdgeInsets.all(double.infinity),
                child: SizedBox(
                  width: 800,
                  height: 1150,
                  child: Stack(
                    children: [
                      // --- INIZIO TRUCCO COORDINATE PRO ---
                      GestureDetector(
                        onTapDown: (TapDownDetails details) {
                          // Questo stamperà le coordinate esatte nella tua console!
                          final int x = details.localPosition.dx.toInt();
                          final int y = details.localPosition.dy.toInt();
                          print("📍 PIXEL ESATTI -> top (Y): $y, left (X): $x");
                        },
                        child: Image.asset(
                          layoutData.mapImagePath,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                            color: Colors.grey.shade200,
                            child: const Center(
                                child: Text("Waiting for map asset...")),
                          ),
                        ),
                      ),
                      // --- FINE TRUCCO COORDINATE PRO ---

                      // Filtriamo la zona "fantasma" per non disegnarla!
                      ...layoutData.zones
                          .where((zone) =>
                              zone.id !=
                              'general_facility_assessment') // <-- IL FILTRO MAGICO
                          .map((zone) => _buildTappableZone(zone)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTappableZone(SpatialZone zone) {
    bool isCritical = zone.statusColor == Colors.red.shade600;

    return Positioned.fill(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // 1. IL CERCHIO CLICCABILE
          Positioned(
            top: zone.touchArea.top,
            left: zone.touchArea.left,
            width: zone.touchArea.width,
            height: zone.touchArea.height,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () async {
                // Vai alla schermata delle domande
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AssessmentScreen(zone: zone)),
                );

                // Verifica se l'utente ha risposto ad almeno UNA domanda
                bool hasAnsweredAtLeastOne = false;
                for (var z in layoutData.zones) {
                  for (var q in z.checklist) {
                    if (q.selectedCompliance != ComplianceLevel.pending) {
                      hasAnsweredAtLeastOne = true;
                      break;
                    }
                  }
                  if (hasAnsweredAtLeastOne) break;
                }

                // Salva nel database SOLO se l'utente ha iniziato l'ispezione
                if (hasAnsweredAtLeastOne) {
                  final savedId =
                      await DatabaseService.instance.saveAssessment(layoutData);
                  layoutData.id = savedId;
                }

                _refreshMap();
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.lightBlue.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),

          // 2. IL TICK GRAFICO
          Positioned(
            top: zone.coordinates.top,
            left: zone.coordinates.left,
            child: IgnorePointer(
              child: AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, child) {
                    double scale =
                        isCritical ? 1.0 + (_pulseController.value * 0.3) : 1.0;

                    return Transform.scale(
                      scale: scale,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: zone.statusColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2.5),
                          boxShadow: [
                            BoxShadow(
                              color: zone.statusColor
                                  .withOpacity(isCritical ? 0.8 : 0.4),
                              blurRadius: isCritical ? 15 : 8,
                              spreadRadius: isCritical ? 4 : 1,
                            )
                          ],
                        ),
                        child: isCritical
                            ? const Icon(Icons.priority_high,
                                size: 16, color: Colors.white)
                            : const Icon(Icons.check,
                                size: 16, color: Colors.white),
                      ),
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
