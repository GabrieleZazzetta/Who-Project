import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/assessment_models.dart';
import '../services/database_service.dart';
import '../providers/database_provider.dart';
import '../helpers/global_map_helper.dart';
import 'interactive_map_screen.dart';
import '../l10n/app_localizations.dart';

const String _mapboxPublicToken = String.fromEnvironment('MAPBOX_TOKEN',
    defaultValue:
        'pk.eyJ1IjoiemF6em8zMyIsImEiOiJjbW9xdmQ0b2wxeTEzMnBwaHhzamVwaHF1In0.7cm8WazVMzTogDvB8A6WMA');

class GlobalMapScreen3D extends ConsumerStatefulWidget {
  const GlobalMapScreen3D({super.key});

  @override
  ConsumerState<GlobalMapScreen3D> createState() => _GlobalMapScreen3DState();
}

class _GlobalMapScreen3DState extends ConsumerState<GlobalMapScreen3D> {
  // STATO
  MapboxMap? _mapboxMap;
  PointAnnotationManager? _pointAnnotationManager;
  bool _isLoading = true;

  List<FacilityLayout> _loadedFacilities = [];
  List<Point> _allCoordinates = [];

  Uint8List? _pinRed;
  Uint8List? _pinAmber;
  Uint8List? _pinGreen;

  @override
  void initState() {
    super.initState();
    if (!Platform.environment.containsKey('FLUTTER_TEST')) {
      try {
        MapboxOptions.setAccessToken(_mapboxPublicToken);
      } catch (_) {}
    }
    _loadData();
  }

  // CARICAMENTO DATI
  // Genera gli asset grafici dei pin, recupera gli assessment e geocodifica le strutture
  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    _pinRed = await _generatePinImage(Colors.red.shade600);
    _pinAmber = await _generatePinImage(Colors.amber.shade500);
    _pinGreen = await _generatePinImage(Colors.green.shade500);

    final assessments =
        await ref.read(databaseServiceProvider).getAllAssessments();
    final List<FacilityLayout> facilities = [];
    final List<Point> coords = [];

    for (final facility in assessments) {
      final point = await GlobalMapHelper.resolveLocation(facility);
      if (point != null) {
        coords.add(point);
        facilities.add(facility);
      }
    }

    if (!mounted) return;
    setState(() {
      _allCoordinates = coords;
      _loadedFacilities = facilities;
      _isLoading = false;
    });
  }

  // GENERAZIONE PIN
  // Disegno su Canvas di un marker a goccia con ombra ellittica e cerchio interno
  Future<Uint8List> _generatePinImage(Color color) async {
    const double size = 120.0;
    const double canvasSize = size * 1.2;
    const double centerX = canvasSize / 2;
    const double bottomY = canvasSize * 0.78;
    const double topRadius = size * 0.35;
    const double topCenterY = canvasSize * 0.35;

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    canvas.drawOval(
      Rect.fromCenter(
        center: const Offset(centerX, canvasSize * 0.88),
        width: size * 0.5,
        height: size * 0.18,
      ),
      Paint()..color = color,
    );

    final path = Path()
      ..moveTo(centerX, bottomY)
      ..cubicTo(centerX + topRadius * 0.4, bottomY * 0.85, centerX + topRadius,
          topCenterY + topRadius * 0.8, centerX + topRadius, topCenterY)
      ..arcToPoint(
        const Offset(centerX - topRadius, topCenterY),
        radius: const Radius.circular(topRadius),
        clockwise: false,
      )
      ..cubicTo(centerX - topRadius, topCenterY + topRadius * 0.8,
          centerX - topRadius * 0.4, bottomY * 0.85, centerX, bottomY)
      ..close();

    canvas.drawPath(path, Paint()..color = color);

    canvas.drawCircle(
      const Offset(centerX, topCenterY),
      size * 0.14,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = size * 0.07,
    );

    final image = await recorder
        .endRecording()
        .toImage(canvasSize.toInt(), canvasSize.toInt());
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  // UTILITÀ SCORE
  Uint8List _pinForScore(double score) {
    if (score >= 80) return _pinGreen!;
    if (score >= 50) return _pinAmber!;
    return _pinRed!;
  }

  // INIZIALIZZAZIONE MAPPA
  // Proiezione globe, creazione annotazioni e registrazione tap handler
  Future<void> _onMapCreated(MapboxMap mapboxMap) async {
    _mapboxMap = mapboxMap;

    try {
      await _mapboxMap?.style
          .setProjection(StyleProjection(name: StyleProjectionName.globe));
    } catch (_) {}

    if (_allCoordinates.isEmpty) return;

    _pointAnnotationManager =
        await mapboxMap.annotations.createPointAnnotationManager();

    final pins = List.generate(_loadedFacilities.length, (i) {
      final f = _loadedFacilities[i];
      bool hasCritical =
          f.zones.any((z) => z.checklist.any((q) => q.isCriticalFailure));
      final image =
          hasCritical ? _pinRed! : _pinForScore(f.globalReadinessScore);
      return PointAnnotationOptions(
        geometry: _allCoordinates[i],
        image: image,
        iconSize: 0.55,
        iconAnchor: IconAnchor.BOTTOM,
        customData: {"index": i},
      );
    });
    await _pointAnnotationManager?.createMulti(pins);

    _pointAnnotationManager?.tapEvents(
      onTap: (PointAnnotation annotation) {
        final Object? customData = annotation.customData;
        if (customData == null) return;

        try {
          final Map<String, dynamic> dataMap;
          if (customData is String) {
            dataMap = json.decode(customData) as Map<String, dynamic>;
          } else {
            dataMap = Map<String, dynamic>.from(customData as Map);
          }

          final int index = (dataMap["index"] as num).toInt();
          if (index >= 0 && index < _loadedFacilities.length) {
            _showFacilityPreview(_loadedFacilities[index]);
          }
        } catch (e) {
          debugPrint("Errore parsing pin: $e");
        }
      },
    );
  }

  // ANTEPRIMA STRUTTURA
  // BottomSheet con header informativo e sezione score + navigazione ai dettagli
  void _showFacilityPreview(FacilityLayout facility) {
    final Color color =
        GlobalMapHelper.scoreColor(facility.globalReadinessScore);
    final double score = facility.globalReadinessScore;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
              color: const Color(0xFF38BDF8).withOpacity(0.3), width: 1),
          boxShadow: const [
            BoxShadow(color: Colors.black54, blurRadius: 20, spreadRadius: 5)
          ],
        ),
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPreviewHeader(facility, color),
            const SizedBox(height: 24),
            _buildScoreBar(facility, score, color),
          ],
        ),
      ),
    );
  }

  // Header con icona, nome struttura, posizione e data assessment
  Widget _buildPreviewHeader(FacilityLayout facility, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            shape: BoxShape.circle,
            border: Border.all(color: color.withOpacity(0.5), width: 2),
          ),
          child: Icon(Icons.health_and_safety, color: color, size: 32),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                facility.facilityName.isEmpty
                    ? AppLocalizations.of(context)!.unnamedFacility
                    : facility.facilityName,
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(height: 6),
              Builder(builder: (context) {
                final bool isSmartphone =
                    MediaQuery.of(context).size.width < 600;
                final bool isPortrait =
                    MediaQuery.of(context).orientation == Orientation.portrait;
                final bool isSmartphonePortrait = isSmartphone && isPortrait;

                final locationText = Text(
                  "${facility.generalInfo?.city ?? 'Unknown'}, "
                  "${facility.generalInfo?.country ?? 'Unknown'}",
                  style: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                );

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 2.0),
                      child: Icon(Icons.location_on,
                          size: 14, color: Colors.grey.shade400),
                    ),
                    const SizedBox(width: 4),
                    if (isSmartphonePortrait)
                      Expanded(child: locationText)
                    else
                      locationText,
                  ],
                );
              }),
              const SizedBox(height: 4),
              Text(
                AppLocalizations.of(context)!.assessedOn(
                    DateFormat('dd MMM yyyy')
                        .format(facility.dateCreated ?? DateTime.now())),
                style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Barra con punteggio numerico e pulsante navigazione dettagli
  Widget _buildScoreBar(FacilityLayout facility, double score, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppLocalizations.of(context)!.readinessScoreUppercase,
                  style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0)),
              const SizedBox(height: 4),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    score.toStringAsFixed(0),
                    style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w900,
                        color: color,
                        height: 1),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6.0, left: 2),
                    child: Text("%",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: color)),
                  ),
                ],
              ),
            ],
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF38BDF8),
              foregroundColor: const Color(0xFF0F172A),
              elevation: 4,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
            ),
            onPressed: () => _navigateToDetails(facility),
            icon: const Icon(Icons.analytics_rounded, size: 20),
            label: Text(AppLocalizations.of(context)!.viewDetails,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          ),
        ],
      ),
    );
  }

  // NAVIGAZIONE
  // Mappatura tipo struttura e push verso la schermata di dettaglio interattiva
  void _navigateToDetails(FacilityLayout facility) {
    Navigator.pop(context);

    FacilityType type = FacilityType.existingFacilityWithWard;
    final String? saved = facility.generalInfo?.assessedFacilityType;

    if (saved == "Mpox stand-alone treatment centre") {
      type = FacilityType.standAloneCenter;
    } else if (saved ==
        "Screening for Internally Displaced People (IDP) and refugee camps") {
      type = FacilityType.congregateSetting;
    } else if (saved == "Screening and temporary isolation for mpox") {
      type = FacilityType.screeningAndIsolation;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => InteractiveMapScreen(
          emergencyType: facility.emergencyType,
          facilityType: type,
          assessmentId: facility.id,
        ),
      ),
    );
  }

  // GESTIONE TELECAMERA
  // Calcola i bounds geografici e anima il flyTo per inquadrare tutti i pin
  Future<void> _flyToFacilities() async {
    if (_allCoordinates.isEmpty || _mapboxMap == null) return;

    try {
      double minLat = 90, maxLat = -90, minLng = 180, maxLng = -180;

      for (final p in _allCoordinates) {
        final lat = p.coordinates.lat.toDouble();
        final lng = p.coordinates.lng.toDouble();
        minLat = math.min(minLat, lat);
        maxLat = math.max(maxLat, lat);
        minLng = math.min(minLng, lng);
        maxLng = math.max(maxLng, lng);
      }

      if (minLat == maxLat && minLng == maxLng) {
        minLat -= 0.5;
        maxLat += 0.5;
        minLng -= 0.5;
        maxLng += 0.5;
      }

      final camera = await _mapboxMap!.cameraForCoordinateBounds(
        CoordinateBounds(
          southwest: Point(coordinates: Position(minLng, minLat)),
          northeast: Point(coordinates: Position(maxLng, maxLat)),
          infiniteBounds: true,
        ),
        MbxEdgeInsets(top: 100.0, left: 100.0, bottom: 100.0, right: 100.0),
        null,
        null,
        null,
        null,
      );

      await _mapboxMap!
          .flyTo(camera, MapAnimationOptions(duration: 3000, startDelay: 0));
    } catch (e) {
      debugPrint("FlyTo error: $e");
    }
  }

  // RENDERING
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.globalAssessmentMap,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                      color: Color(0xFF38BDF8), strokeWidth: 3),
                  SizedBox(height: 24),
                  Text(AppLocalizations.of(context)!.initializing3dEngine,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                ],
              ),
            )
          : MapWidget(
              viewport: CameraViewportState(
                center: Point(coordinates: Position(20.0, 5.0)),
                zoom: 1.0,
                pitch: 0.0,
              ),
              styleUri: 'mapbox://styles/zazzo33/cmor4cj6f005s01sab89uh960',
              onMapCreated: _onMapCreated,
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: _isLoading || _allCoordinates.isEmpty
          ? null
          : FloatingActionButton.extended(
              onPressed: _flyToFacilities,
              backgroundColor: const Color(0xFF38BDF8),
              foregroundColor: const Color(0xFF0F172A),
              elevation: 6,
              icon: const Icon(Icons.my_location_rounded),
              label: Text(AppLocalizations.of(context)!.fitToExtent,
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
    );
  }
}
