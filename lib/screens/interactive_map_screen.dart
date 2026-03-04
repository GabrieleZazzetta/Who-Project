// interactive_map_screen.dart - File completo modificato

import 'package:flutter/material.dart';
import 'dart:ui';
import '../models/assessment_models.dart';
import '../data/mock_data.dart';
import 'assessment_screen.dart'; 

class InteractiveMapScreen extends StatefulWidget {
  final FacilityType facilityType;

  const InteractiveMapScreen({super.key, required this.facilityType});

  @override
  State<InteractiveMapScreen> createState() => _InteractiveMapScreenState();
}

class _InteractiveMapScreenState extends State<InteractiveMapScreen> with SingleTickerProviderStateMixin {
  late FacilityLayout layoutData;
  final bool _showOverlayBoxes = true;
  
  late AnimationController _pulseController;
  final TransformationController _mapController = TransformationController();

  @override
  void initState() {
    super.initState();
    if (widget.facilityType == FacilityType.existingFacilityWithWard) {
      layoutData = MockData.getMpoxExistingFacilityLayout();
    } else {
      layoutData = MockData.getMpoxExistingFacilityLayout();
    }

    // Inizializza l'animazione: un ciclo continuo di 1.5 secondi avanti e indietro
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true); // Ripete all'infinito
  }

  @override
  void dispose() {
    // IMPORTANTE: Distruggere il controller quando si chiude la pagina
    _pulseController.dispose();
    _mapController.dispose();
    super.dispose();
  }

  void _refreshMap() {
    setState(() {}); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        toolbarHeight: 70, 
        backgroundColor: Colors.white, 
        surfaceTintColor: Colors.transparent, // <-- Sfondo bianco puro!
        scrolledUnderElevation: 0, // Previene cambi di colore strani su Android
        elevation: 1, // Leggerissima ombra per separare l'AppBar dal resto
        shadowColor: Colors.black.withOpacity(0.2),
        // Coloriamo il testo e la freccia di blu scuro WHO per un super contrasto
        iconTheme: const IconThemeData(color: Color(0xFF003D73)), 
        title: Text("Spatial Assessment", style: const TextStyle(color: Color(0xFF003D73), fontWeight: FontWeight.bold, fontSize: 20)),
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
          // Banner Informativo Elegante
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

          // Area Mappa
          Expanded(
            child: ClipRRect(
              child: InteractiveViewer(
                transformationController: _mapController,
                minScale: 0.1, 
                maxScale: 4.0,
                constrained: false, 
                boundaryMargin: const EdgeInsets.all(double.infinity), 
                child: SizedBox(
                  // --- TRUCCO DELLE PROPORZIONI CORRETTE ---
                  // Mappa verticale (Portrait) per adattarsi al tuo PDF!
                  width: 800, 
                  height: 1150, 
                  // ------------------------------------------
                  child: Stack(
                    children: [
                      // 1. Immagine di Sfondo incastrata nella tela verticale
                      Positioned.fill(
                        child: Image.asset(
                          layoutData.mapImagePath,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: Colors.grey.shade200,
                            child: const Center(child: Text("Waiting for map asset...")),
                          ),
                        ),
                      ),
                      
                      // 2. Generazione dinamica dei Pin
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

    return Positioned(
      top: zone.coordinates.top,
      left: zone.coordinates.left,
      width: zone.coordinates.width,
      height: zone.coordinates.height,
      child: GestureDetector(
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AssessmentScreen(zone: zone)),
          );
          _refreshMap();
        },
        // Area cliccabile invisibile
        child: Container(
          color: Colors.transparent, 
          child: Center(
            child: AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                double scale = isCritical ? 1.0 + (_pulseController.value * 0.3) : 1.0;
                
                // SOLO IL PIN PULSANTE - NESSUN TESTO E NESSUN OVERFLOW!
                return Transform.scale(
                  scale: scale,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: zone.statusColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: zone.statusColor.withOpacity(isCritical ? 0.8 : 0.4),
                          blurRadius: isCritical ? 15 : 8,
                          spreadRadius: isCritical ? 4 : 1,
                        )
                      ],
                    ),
                    child: isCritical 
                      ? const Icon(Icons.priority_high, size: 14, color: Colors.white)
                      : const Icon(Icons.check, size: 14, color: Colors.white),
                  ),
                );
              }
            ),
          ),
        ),
      ),
    );
  }
}