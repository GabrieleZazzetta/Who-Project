import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:http/http.dart' as http;
import '../models/assessment_models.dart';

class GlobalMapHelper {
  // Fallback a cascata: prima GPS/coordinate dirette, poi city+country via Nominatim
  static Future<Point?> resolveLocation(FacilityLayout facility, {http.Client? httpClient}) async {
    final String gpsText = facility.generalInfo?.facilityAddressOrGps ?? '';
    final Point? direct = await parseOrGeocode(gpsText, httpClient: httpClient);
    if (direct != null) return direct;

    final String city = facility.generalInfo?.city ?? '';
    final String country = facility.generalInfo?.country ?? '';
    String fallback = '$city, $country'
        .trim()
        .replaceAll(RegExp(r'^,\s*'), '')
        .replaceAll(RegExp(r',\s*$'), '');

    return fallback.isNotEmpty ? await parseOrGeocode(fallback, httpClient: httpClient) : null;
  }

  // Tenta il parsing diretto lat/lng, altrimenti interroga Nominatim
  static Future<Point?> parseOrGeocode(String text, {http.Client? httpClient}) async {
    if (text.trim().isEmpty) return null;

    final match = RegExp(r'([-+]?[0-9]*\.?[0-9]+)[\s,]+([-+]?[0-9]*\.?[0-9]+)')
        .firstMatch(text);
    if (match != null) {
      try {
        final double lat = double.parse(match.group(1)!);
        final double lng = double.parse(match.group(2)!);
        if (lat >= -90 && lat <= 90 && lng >= -180 && lng <= 180) {
          if (lat == 0.0 && lng == 0.0) return null; // Prevenzione Null Island
          return Point(coordinates: Position(lng, lat));
        }
      } catch (_) {}
    }

    try {
      final url = Uri.parse(
          'https://nominatim.openstreetmap.org/search?q=${Uri.encodeComponent(text)}&format=json&limit=1');
      final response = httpClient != null 
          ? await httpClient.get(url, headers: const {'User-Agent': 'WhoHealthAssessmentApp'})
          : await http.get(url, headers: const {'User-Agent': 'WhoHealthAssessmentApp'});
          
      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);
        if (data is List && data.isNotEmpty) {
          final double lat = double.parse(data[0]['lat'].toString());
          final double lon = double.parse(data[0]['lon'].toString());
          if (lat == 0.0 && lon == 0.0) return null; // Prevenzione Null Island
          return Point(coordinates: Position(lon, lat));
        }
      }
    } catch (e) {
      debugPrint('Geocoding error: $e');
    }
    return null;
  }

  static Color scoreColor(double score) {
    if (score >= 80) return Colors.green.shade500;
    if (score >= 50) return Colors.amber.shade500;
    return Colors.red.shade600;
  }
}
