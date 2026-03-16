// interactive_map_screen.dart - File completo modificato con Database Isar
import 'package:flutter/material.dart';
import 'dart:ui';
import '../models/assessment_models.dart';
import '../data/mpox/mpox_existing_ward_data.dart';
import '../services/database_service.dart'; // <-- IMPORTANTE: Il nostro database!
import 'assessment_screen.dart'; 
import '../data/facility_data_factory.dart'; // <-- IMPORTANTE: La factory per i dati delle strutture

class InteractiveMapScreen extends StatefulWidget {
  final EmergencyType emergencyType;
  final FacilityType facilityType;
  final int? assessmentId; // <-- Se nullo = nuova ispezione. Se ha un ID = carica l'esistente.

  const InteractiveMapScreen({super.key, required this.emergencyType, required this.facilityType, this.assessmentId});

  @override
  State<InteractiveMapScreen> createState() => _InteractiveMapScreenState();
}

class _InteractiveMapScreenState extends State<InteractiveMapScreen> with SingleTickerProviderStateMixin {
  late FacilityLayout layoutData;
  bool _isLoading = true; // Mostra un caricamento mentre Isar legge/scrive i dati
  
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

  // --- LOGICA DATABASE ---
  Future<void> _initDatabase() async {
    if (widget.assessmentId != null) {
      // 1. CARICA ISPEZIONE ESISTENTE
      final existing = await DatabaseService.instance.getAssessmentById(widget.assessmentId!);
      if (existing != null) {
        layoutData = existing;
      } else {
        await _createNewAssessment();
      }
    } else {
      // 2. CREA NUOVA ISPEZIONE E SALVALA SUBITO
      await _createNewAssessment();
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
    layoutData = FacilityDataFactory.getLayout(widget.emergencyType, widget.facilityType);
    layoutData.dateCreated = DateTime.now(); 
    
    final generatedId = await DatabaseService.instance.saveAssessment(layoutData);
    layoutData.id = generatedId; 
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
        body: Center(child: CircularProgressIndicator(color: Color(0xFF005DA8))),
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
        title: const Text("Spatial Assessment", style: TextStyle(color: Color(0xFF003D73), fontWeight: FontWeight.bold, fontSize: 20)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 24.0),
            child: Image.asset(
              'assets/images/who_logo_info.png', 
              height: 50, 
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.public, color: Color(0xFF005DA8)),
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
                Icon(Icons.pinch_outlined, color: Theme.of(context).colorScheme.primary),
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
                      Image.asset(
                        layoutData.mapImagePath,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Colors.grey.shade200,
                          child: const Center(child: Text("Waiting for map asset...")),
                        ),
                      ),
                      ...layoutData.zones.map((zone) => _buildTappableZone(zone)),
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
          // 1. IL CERCHIO CLICCABILE (Ora visibile in azzurro per debug/mapping)
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
                  MaterialPageRoute(builder: (context) => AssessmentScreen(zone: zone)),
                );
                
                // --- MAGIA DATABASE ---
                // Appena torni dalla schermata delle domande, SALVA l'intera ispezione!
                // Tutte le modifiche fatte in memoria (punteggi, status) diventeranno permanenti.
                await DatabaseService.instance.saveAssessment(layoutData);
                
                // Ridisegna i pin sulla mappa con i nuovi colori!
                _refreshMap();
              },
              child: Container(
                decoration: BoxDecoration( // <-- Rimosso const
                  color: Colors.lightBlue.withOpacity(0.5), // <-- Azzurro semi-trasparente!
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
                  double scale = isCritical ? 1.0 + (_pulseController.value * 0.3) : 1.0;
                  
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
                            color: zone.statusColor.withOpacity(isCritical ? 0.8 : 0.4),
                            blurRadius: isCritical ? 15 : 8,
                            spreadRadius: isCritical ? 4 : 1,
                          )
                        ],
                      ),
                      child: isCritical 
                        ? const Icon(Icons.priority_high, size: 16, color: Colors.white)
                        : const Icon(Icons.check, size: 16, color: Colors.white),
                    ),
                  );
                }
              ),
            ),
          ),
          
        ],
      ),
    );
  }
}