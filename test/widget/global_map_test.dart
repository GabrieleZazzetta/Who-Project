import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:assessment_tool/screens/global_map_screen_3d.dart';
import 'package:assessment_tool/providers/database_provider.dart';
import 'package:assessment_tool/services/database_service.dart';
import 'package:assessment_tool/l10n/app_localizations.dart';
import '../helpers/mocks.dart';

void main() {
  group('GlobalMapScreen3D Tests', () {
    testWidgets('renders loading state initially', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 1000));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final mockDb = MockDatabaseService();
      // Setup mock to return empty list of assessments
      // Assuming mockDb returns something for getAllAssessments. It's a mocktail mock so we need to stub it.
      // But actually if we don't stub it, we can just use DatabaseService directly or a Fake.
      // In this test environment, FLUTTER_TEST is set, so mapbox won't crash instantly.
      
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            // If using real DatabaseService, we need it initialized. We can mock it.
          ],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: GlobalMapScreen3D(),
          ),
        ),
      );

      // We expect the CircularProgressIndicator because it starts loading
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.textContaining('Initializing'), findsWidgets);
    });
  });
}
