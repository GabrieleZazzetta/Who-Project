import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:assessment_tool/helpers/global_map_helper.dart';
import 'package:assessment_tool/models/assessment_models.dart';

void main() {
  group('GlobalMapHelper Unit Tests', () {
    test('scoreColor returns correct colors', () {
      expect(GlobalMapHelper.scoreColor(85), equals(Colors.green.shade500));
      expect(GlobalMapHelper.scoreColor(80), equals(Colors.green.shade500));
      expect(GlobalMapHelper.scoreColor(65), equals(Colors.amber.shade500));
      expect(GlobalMapHelper.scoreColor(50), equals(Colors.amber.shade500));
      expect(GlobalMapHelper.scoreColor(40), equals(Colors.red.shade600));
    });

    test('parseOrGeocode returns direct coordinates if formatted lat/lng', () async {
      final point = await GlobalMapHelper.parseOrGeocode('12.34, 56.78');
      expect(point, isNotNull);
      expect(point!.coordinates.lat, equals(12.34));
      expect(point.coordinates.lng, equals(56.78));
    });

    test('parseOrGeocode handles invalid direct coordinates and falls back to HTTP', () async {
      // It should call Nominatim because 900 is invalid lat. We mock HTTP to return empty array.
      final mockClient = MockClient((request) async {
        return http.Response('[]', 200);
      });
      final point = await GlobalMapHelper.parseOrGeocode('900.0, 900.0', httpClient: mockClient);
      expect(point, isNull);
    });

    test('parseOrGeocode returns coordinates from Nominatim', () async {
      final mockClient = MockClient((request) async {
        if (request.url.toString().contains('Rome')) {
          return http.Response('[{"lat": "41.9", "lon": "12.5"}]', 200);
        }
        return http.Response('[]', 404);
      });

      final point = await GlobalMapHelper.parseOrGeocode('Rome', httpClient: mockClient);
      expect(point, isNotNull);
      expect(point!.coordinates.lat, equals(41.9));
      expect(point.coordinates.lng, equals(12.5));
    });

    test('resolveLocation falls back to city and country if direct fails', () async {
      final mockClient = MockClient((request) async {
        if (request.url.toString().contains('Paris%2C%20France')) {
          return http.Response('[{"lat": "48.85", "lon": "2.35"}]', 200);
        }
        return http.Response('[]', 200);
      });

      final facility = FacilityLayout(emergencyType: EmergencyType.mpox);
      facility.generalInfo = GeneralFacilityInfo();
      facility.generalInfo!.facilityAddressOrGps = 'invalid gps text';
      facility.generalInfo!.city = 'Paris';
      facility.generalInfo!.country = 'France';

      final point = await GlobalMapHelper.resolveLocation(facility, httpClient: mockClient);
      expect(point, isNotNull);
      expect(point!.coordinates.lat, equals(48.85));
      expect(point.coordinates.lng, equals(2.35));
    });
  });
}
