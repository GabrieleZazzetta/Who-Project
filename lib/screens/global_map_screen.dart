import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

import '../models/assessment_models.dart';
import '../services/database_service.dart';
import 'interactive_map_screen.dart';

class GlobalMapScreen extends StatefulWidget {
  const GlobalMapScreen({super.key});

  @override
  State<GlobalMapScreen> createState() => _GlobalMapScreenState();
}

class _GlobalMapScreenState extends State<GlobalMapScreen> {
  final MapController _mapController = MapController();
  bool _isLoading = true;

  List<Marker> _markers = [];
  List<LatLng> _allCoordinates = [];

  @override
  void initState() {
    super.initState();
    _loadAssessmentsAndGeocode();
  }

  Future<void> _loadAssessmentsAndGeocode() async {
    setState(() => _isLoading = true);

    final assessments = await DatabaseService.instance.getAllAssessments();
    final List<Marker> generatedMarkers = [];
    final List<LatLng> coords = [];

    for (var facility in assessments) {
      final latLng = await _resolveFacilityLocation(facility);
      if (latLng != null) {
        coords.add(latLng);
        generatedMarkers.add(
          Marker(
            point: latLng,
            width: 40,
            height: 40,
            child: GestureDetector(
              onTap: () => _showFacilityDetails(facility),
              child: _buildPin(facility.globalReadinessScore),
            ),
          ),
        );
      }
    }

    setState(() {
      _markers = generatedMarkers;
      _allCoordinates = coords;
      _isLoading = false;
    });

    // Rimosso il blocco WidgetsBinding.instance.addPostFrameCallback
    // Ora la mappa rimarrà sulla visuale globale iniziale del mondo intero.
  }

  void _zoomToFacilities() {
    if (_allCoordinates.isEmpty) return;
    try {
      LatLngBounds bounds;

      if (_allCoordinates.length == 1) {
        final point = _allCoordinates.first;
        bounds = LatLngBounds(
          LatLng(point.latitude - 0.05, point.longitude - 0.05),
          LatLng(point.latitude + 0.05, point.longitude + 0.05),
        );
      } else {
        bounds = LatLngBounds.fromPoints(_allCoordinates);
        // SAFETY CHECK
        if (bounds.northWest == bounds.southEast) {
          final point = bounds.northWest;
          bounds = LatLngBounds(
            LatLng(point.latitude - 0.05, point.longitude - 0.05),
            LatLng(point.latitude + 0.05, point.longitude + 0.05),
          );
        }
      }

      _mapController.fitCamera(CameraFit.bounds(
        bounds: bounds,
        padding: const EdgeInsets.all(80),
      ));
    } catch (e) {
      debugPrint("Error fitting bounds: $e");
    }
  }

  Future<LatLng?> _resolveFacilityLocation(FacilityLayout facility) async {
    String text = facility.generalInfo?.facilityAddressOrGps ?? '';
    LatLng? coords = await _getCoordinatesFromText(text);
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

  Future<LatLng?> _getCoordinatesFromText(String text) async {
    if (text.trim().isEmpty) return null;

    final RegExp coordRegExp =
        RegExp(r'([-+]?[0-9]*\.?[0-9]+)[\s,]+([-+]?[0-9]*\.?[0-9]+)');
    final match = coordRegExp.firstMatch(text);
    if (match != null && match.groupCount >= 2) {
      try {
        final lat = double.parse(match.group(1)!);
        final lng = double.parse(match.group(2)!);
        if (lat >= -90 && lat <= 90 && lng >= -180 && lng <= 180) {
          return LatLng(lat, lng);
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
          return LatLng(lat, lon);
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
    return Colors.red.shade500;
  }

  Widget _buildPin(double score) {
    Color pinColor = _getScoreColor(score);
    Color shadowColor = pinColor.withOpacity(0.6);

    return Container(
      decoration: BoxDecoration(
          color: pinColor,
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFF1E1E1E), width: 2),
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              blurRadius: 12,
              spreadRadius: 3,
              offset: const Offset(0, 0),
            )
          ]),
      child: const Center(
        child:
            Icon(Icons.medical_services_rounded, color: Colors.white, size: 18),
      ),
    );
  }

  void _showFacilityDetails(FacilityLayout facility) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        Color scoreColor = _getScoreColor(facility.globalReadinessScore);
        double score = facility.globalReadinessScore;

        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        color: scoreColor.withOpacity(0.1),
                        shape: BoxShape.circle),
                    child: Icon(Icons.health_and_safety,
                        color: scoreColor, size: 28),
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
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F172A)),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.location_on,
                                size: 14, color: Colors.grey.shade500),
                            const SizedBox(width: 4),
                            Text(
                              "${facility.generalInfo?.city ?? 'Unknown City'}, ${facility.generalInfo?.country ?? 'Unknown'}",
                              style: TextStyle(
                                  color: Colors.grey.shade600, fontSize: 13),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Divider(color: Colors.grey.shade100),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("GLOBAL READINESS",
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
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF005DA8),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                    onPressed: () {
                      Navigator.pop(context);

                      FacilityType typeToOpen =
                          FacilityType.existingFacilityWithWard;
                      final savedTypeStr =
                          facility.generalInfo?.assessedFacilityType;
                      if (savedTypeStr == "Mpox stand-alone treatment centre") {
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
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("View Details",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15)),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward_rounded, size: 18),
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFF0F172A), // Sfondo scuro per look analitico
      appBar: AppBar(
        title: const Text("Global Assessment Map",
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
                  const CircularProgressIndicator(
                      color: Color(0xFF38BDF8), strokeWidth: 3),
                  const SizedBox(height: 24),
                  const Text("Calibrating Satellite Imagery...",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                  const SizedBox(height: 8),
                  Text("Syncing assessment coordinates",
                      style:
                          TextStyle(color: Colors.grey.shade400, fontSize: 12)),
                ],
              ),
            )
          : FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter:
                    const LatLng(20.0, 0.0), // Centro del mondo iniziale
                initialZoom: 2.0, // Zoom che inquadra tutto il mondo
                maxZoom: 18.0,
                minZoom: 2.0,
                cameraConstraint: CameraConstraint.contain(
                  bounds: LatLngBounds(
                      const LatLng(-90, -180), const LatLng(90, 180)),
                ),
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png',
                  subdomains: const ['a', 'b', 'c', 'd'],
                  userAgentPackageName: 'com.who.healthassessmentapp',
                ),
                MarkerClusterLayerWidget(
                  options: MarkerClusterLayerOptions(
                    maxClusterRadius: 45,
                    size: const Size(40, 40),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(50),
                    maxZoom: 15,
                    markers: _markers,
                    builder: (context, markers) {
                      return Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: const Color(0xFF1E293B),
                            border: Border.all(
                                color: const Color(0xFF38BDF8), width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF000000).withOpacity(0.5),
                                blurRadius: 8,
                                spreadRadius: 1,
                                offset: const Offset(0, 3),
                              )
                            ]),
                        child: Center(
                          child: Text(
                            markers.length.toString(),
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
      floatingActionButton: _isLoading || _allCoordinates.isEmpty
          ? null
          : FloatingActionButton.extended(
              onPressed: _zoomToFacilities,
              backgroundColor: const Color(0xFF38BDF8),
              foregroundColor: const Color(0xFF0F172A),
              elevation: 6,
              icon: const Icon(Icons.zoom_out_map_rounded),
              label: const Text("Fit to Extent",
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
    );
  }
}
