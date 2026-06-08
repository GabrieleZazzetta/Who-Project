import 'package:flutter_test/flutter_test.dart';
import 'package:assessment_tool/data/mpox/mpox_congregate_setting_data.dart';

void main() {
  // TEST SUITE: MPOX DATA FACTORY
  group('Mpox Data Tests', () {
    test('MpoxCongregateSettingData gets layout', () {
      final layout = MpoxCongregateSettingData.getLayout();
      expect(layout.facilityName, isNotEmpty);
      expect(layout.zones, isNotEmpty);
    });
  });
}
