import 'package:assessment_tool/models/assessment_models.dart';
import 'package:assessment_tool/models/user_model.dart';

// MOCK DATA FACTORIES
class MockData {
  static final UserSession dummyUserSession = UserSession()
    ..email = 'test@who.int'
    ..displayName = 'Test User'
    ..isWhoStaff = true
    ..lastLogin = DateTime.now();

  static FacilityLayout createDummyFacility({int id = 123, String facilityName = 'Test Facility'}) {
    return FacilityLayout()
      ..id = id
      ..remoteId = 'remote_$id'
      ..facilityName = facilityName
      ..dateCreated = DateTime.now()
      ..updatedAt = DateTime.now();
  }
}
