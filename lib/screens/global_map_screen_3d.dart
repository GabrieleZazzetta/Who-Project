import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../models/assessment_models.dart';
import '../services/database_service.dart';
import 'dart:math' as math;
import 'interactive_map_screen.dart';

// TODO: Inserisci qui il tuo PUBLIC Token
const String mapboxPublicToken =
    'pk.eyJ1IjoiemF6em8zMyIsImEiOiJjbW9xdmQ0b2wxeTEzMnBwaHhzamVwaHF1In0.7cm8WazVMzTogDvB8A6WMA';

class GlobalMapScreen3D extends StatefulWidget {
  const GlobalMapScreen3D({super.key});

  @override
  State<GlobalMapScreen3D> createState() => _GlobalMapScreen3DState();
}

class _GlobalMapScreen3DState extends State<GlobalMapScreen3D> {
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
    MapboxOptions.setAccessToken(mapboxPublicToken);
    _loadAssessmentsAndGeocode();
  }

  // --- MOTORE GRAFICO: Replica esatta del Pin dell'immagine (Teardrop + Base staccata) ---
  Future<Uint8List> _generatePinImage(Color color) async {
    const double size = 120.0;
    const double canvasSize = size * 1.2; // Spazio extra per evitare tagli
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    final double centerX = canvasSize / 2;

    // 1. Disegna l'ombra/base (ellisse) staccata in fondo
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(centerX, canvasSize * 0.88),
        width: size * 0.5,
        height: size * 0.18,
      ),
      Paint()..color = color,
    );

    // 2. Disegna il corpo principale (La Goccia)
    final Path path = Path();
    final double bottomY =
        canvasSize * 0.78; // Lascia uno spazio bianco tra punta e base
    final double topRadius = size * 0.35;
    final double topCenterY = canvasSize * 0.35;

    path.moveTo(centerX, bottomY);
    // Curva destra dal basso verso l'alto
    path.cubicTo(centerX + topRadius * 0.4, bottomY * 0.85, centerX + topRadius,
        topCenterY + topRadius * 0.8, centerX + topRadius, topCenterY);
    // Mezzo cerchio superiore
    path.arcToPoint(
      Offset(centerX - topRadius, topCenterY),
      radius: Radius.circular(topRadius),
      clockwise: false,
    );
    // Curva sinistra dall'alto verso il basso
    path.cubicTo(centerX - topRadius, topCenterY + topRadius * 0.8,
        centerX - topRadius * 0.4, bottomY * 0.85, centerX, bottomY);
    path.close();

    canvas.drawPath(path, Paint()..color = color);

    // 3. Disegna l'anello bianco interno
    canvas.drawCircle(
      Offset(centerX, topCenterY),
      size * 0.14, // Raggio dell'anello
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = size * 0.07, // Spessore dell'anello
    );

    final ui.Image image = await pictureRecorder
        .endRecording()
        .toImage(canvasSize.toInt(), canvasSize.toInt());
    final ByteData? byteData =
        await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  Future<void> _loadAssessmentsAndGeocode() async {
    setState(() => _isLoading = true);

    _pinRed = await _generatePinImage(Colors.red.shade600);
    _pinAmber = await _generatePinImage(Colors.amber.shade500);
    _pinGreen = await _generatePinImage(Colors.green.shade500);

    final assessments = await DatabaseService.instance.getAllAssessments();
    final List<FacilityLayout> validFacilities = [];
    final List<Point> coords = [];

    for (var facility in assessments) {
      final point = await _resolveFacilityLocation(facility);
      if (point != null) {
        coords.add(point);
        validFacilities.add(facility);
      }
    }

    setState(() {
      _allCoordinates = coords;
      _loadedFacilities = validFacilities;
      _isLoading = false;
    });
  }

  Future<Point?> _resolveFacilityLocation(FacilityLayout facility) async {
    String text = facility.generalInfo?.facilityAddressOrGps ?? '';
    Point? coords = await _getCoordinatesFromText(text);
    if (coords != null) return coords;

    String city = facility.generalInfo?.city ?? '';
    String country = facility.generalInfo?.country ?? '';
    String query = '$city, $country'.trim();
    query =
        query.replaceAll(RegExp(r'^,\s*'), '').replaceAll(RegExp(r',\s*$'), '');

    if (query.isNotEmpty) {
      coords = await _getCoordinatesFromText(query);
      if (coords != null) return coords;
    }
    return null;
  }

  Future<Point?> _getCoordinatesFromText(String text) async {
    if (text.trim().isEmpty) return null;

    final RegExp coordRegExp =
        RegExp(r'([-+]?[0-9]*\.?[0-9]+)[\s,]+([-+]?[0-9]*\.?[0-9]+)');
    final match = coordRegExp.firstMatch(text);
    if (match != null && match.groupCount >= 2) {
      try {
        final lat = double.parse(match.group(1)!);
        final lng = double.parse(match.group(2)!);
        if (lat >= -90 && lat <= 90 && lng >= -180 && lng <= 180) {
          return Point(coordinates: Position(lng, lat));
        }
      } catch (_) {}
    }

    try {
      final url = Uri.parse(
          'https://nominatim.openstreetmap.org/search?q=${Uri.encodeComponent(text)}&format=json&limit=1');
      final response = await http
          .get(url, headers: {'User-Agent': 'WhoHealthAssessmentApp'});
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List && data.isNotEmpty) {
          final lat = double.parse(data[0]['lat']);
          final lon = double.parse(data[0]['lon']);
          return Point(coordinates: Position(lon, lat));
        }
      }
    } catch (e) {
      debugPrint('Geocoding error: $e');
    }
    return null;
  }

  Color _getScoreColor(double score) {
    if (score >= 80) return Colors.green.shade500;
    if (score >= 50) return Colors.amber.shade500;
    return Colors.red.shade600;
  }

  Uint8List _getPinImageForScore(double score) {
    if (score >= 80) return _pinGreen!;
    if (score >= 50) return _pinAmber!;
    return _pinRed!;
  }

  Future<void> _onMapCreated(MapboxMap mapboxMap) async {
    _mapboxMap = mapboxMap;

    try {
      await _mapboxMap?.style
          .setProjection(StyleProjection(name: StyleProjectionName.globe));
    } catch (e) {
      debugPrint("Info: La proiezione globo non è supportata o attiva: $e");
    }

    if (_allCoordinates.isNotEmpty) {
      _pointAnnotationManager =
          await mapboxMap.annotations.createPointAnnotationManager();
      List<PointAnnotationOptions> pins = [];

      for (int i = 0; i < _loadedFacilities.length; i++) {
        pins.add(PointAnnotationOptions(
          geometry: _allCoordinates[i],
          image:
              _getPinImageForScore(_loadedFacilities[i].globalReadinessScore),
          iconSize:
              0.55, // Ridimensionato leggermente per compensare la forma a goccia allungata
          iconAnchor: IconAnchor
              .BOTTOM, // La base (l'ellisse in basso) tocca le coordinate esatte
          customData: {"index": i},
        ));
      }

      await _pointAnnotationManager?.createMulti(pins);

      _pointAnnotationManager?.addOnPointAnnotationClickListener(
        CustomAnnotationClickListener((PointAnnotation annotation) {
          final dynamic customData = annotation.customData;

          if (customData != null) {
            try {
              Map<String, dynamic> dataMap;
              if (customData is String) {
                dataMap = json.decode(customData);
              } else {
                dataMap = Map<String, dynamic>.from(customData as Map);
              }

              if (dataMap.containsKey("index")) {
                final int index =
                    double.parse(dataMap["index"].toString()).toInt();

                if (index >= 0 && index < _loadedFacilities.length) {
                  final facility = _loadedFacilities[index];
                  _showFacilityPreview(facility);
                }
              }
            } catch (e) {
              debugPrint("Errore fatale parsing indice pin: $e");
            }
          }
        }),
      );
    }
  }

  void _showFacilityPreview(FacilityLayout facility) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        Color scoreColor = _getScoreColor(facility.globalReadinessScore);
        double score = facility.globalReadinessScore;

        return Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                  color: const Color(0xFF38BDF8).withOpacity(0.3), width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 20,
                  spreadRadius: 5,
                )
              ]),
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: scoreColor.withOpacity(0.15),
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: scoreColor.withOpacity(0.5), width: 2),
                    ),
                    child: Icon(Icons.health_and_safety,
                        color: scoreColor, size: 32),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          facility.facilityName.isEmpty
                              ? "Unnamed Facility"
                              : facility.facilityName,
                          style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(Icons.location_on,
                                size: 14, color: Colors.grey.shade400),
                            const SizedBox(width: 4),
                            Text(
                              "${facility.generalInfo?.city ?? 'Unknown'}, ${facility.generalInfo?.country ?? 'Unknown'}",
                              style: TextStyle(
                                  color: Colors.grey.shade400, fontSize: 13),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Assessed on ${DateFormat('dd MMM yyyy').format(facility.dateCreated ?? DateTime.now())}",
                          style: TextStyle(
                              color: Colors.grey.shade500, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Container(
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
                        Text("READINESS SCORE",
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
                                  color: scoreColor,
                                  height: 1),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 6.0, left: 2),
                              child: Text("%",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: scoreColor)),
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        FacilityType typeToOpen =
                            FacilityType.existingFacilityWithWard;
                        final savedTypeStr =
                            facility.generalInfo?.assessedFacilityType;
                        if (savedTypeStr ==
                            "Mpox stand-alone treatment centre") {
                          typeToOpen = FacilityType.standAloneCenter;
                        } else if (savedTypeStr ==
                            "Screening for Internally Displaced People (IDP) and refugee camps") {
                          typeToOpen = FacilityType.congregateSetting;
                        } else if (savedTypeStr ==
                            "Screening and temporary isolation for mpox") {
                          typeToOpen = FacilityType.screeningAndIsolation;
                        }

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => InteractiveMapScreen(
                              emergencyType: facility.emergencyType,
                              facilityType: typeToOpen,
                              assessmentId: facility.id,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.analytics_rounded, size: 20),
                      label: const Text("View Details",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15)),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Future<void> _flyToFacilities() async {
    if (_allCoordinates.isEmpty || _mapboxMap == null) return;

    try {
      double minLat = 90, maxLat = -90, minLng = 180, maxLng = -180;

      for (var point in _allCoordinates) {
        final lng = point.coordinates.lng;
        final lat = point.coordinates.lat;
        minLat = math.min(minLat, lat as double);
        maxLat = math.max(maxLat, lat as double);
        minLng = math.min(minLng, lng as double);
        maxLng = math.max(maxLng, lng as double);
      }

      if (minLat == maxLat && minLng == maxLng) {
        minLat -= 0.5;
        maxLat += 0.5;
        minLng -= 0.5;
        maxLng += 0.5;
      }

      final bounds = CoordinateBounds(
        southwest: Point(coordinates: Position(minLng, minLat)),
        northeast: Point(coordinates: Position(maxLng, maxLat)),
        infiniteBounds: true,
      );

      final cameraOptions = await _mapboxMap!.cameraForCoordinateBounds(
        bounds,
        MbxEdgeInsets(top: 100, left: 100, bottom: 100, right: 100),
        null,
        null,
        null,
        null,
      );

      await _mapboxMap!.flyTo(
        cameraOptions,
        MapAnimationOptions(duration: 3000, startDelay: 0),
      );
    } catch (e) {
      debugPrint("Errore durante il flyTo: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text("Global Assessment Map",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                      color: Color(0xFF38BDF8), strokeWidth: 3),
                  SizedBox(height: 24),
                  Text("Initializing 3D Engine...",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                ],
              ),
            )
          : MapWidget(
              cameraOptions: CameraOptions(
                center: Point(coordinates: Position(20.0, 5.0)),
                // LEGGERMENTE PIÙ ZOOMATA: Da 0.8 l'ho portato a 1.1!
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
              label: const Text("Fit to Extent",
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
    );
  }
}

// --- CLASSE LISTENER PER INTERCETTARE I CLICK SUI PIN ---
class CustomAnnotationClickListener extends OnPointAnnotationClickListener {
  final void Function(PointAnnotation annotation) onAnnotationClick;

  CustomAnnotationClickListener(this.onAnnotationClick);

  @override
  void onPointAnnotationClick(PointAnnotation annotation) {
    onAnnotationClick(annotation);
  }
}
