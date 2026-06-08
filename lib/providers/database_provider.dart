import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/database_service.dart';

// DATABASE SERVICE PROVIDER
// Exposes singleton instance to enable dependency injection and test mocking
final databaseServiceProvider = Provider<DatabaseService>((ref) {
  return DatabaseService.instance;
});
