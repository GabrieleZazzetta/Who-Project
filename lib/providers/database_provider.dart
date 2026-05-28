import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/database_service.dart';

/// Fornisce l'istanza singleton del DatabaseService.
/// Questo permette di mockare il database durante i test tramite Riverpod overrides.
final databaseServiceProvider = Provider<DatabaseService>((ref) {
  return DatabaseService.instance;
});
