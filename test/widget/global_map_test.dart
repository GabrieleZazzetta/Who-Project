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
  // TEST SUITE: GLOBAL MAP SCREEN 3D
  group('GlobalMapScreen3D Tests', () {
    testWidgets('renders loading state initially', (WidgetTester tester) async {
      // Setup device viewport
      await tester.binding.setSurfaceSize(const Size(1200, 1000));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      // Provision empty database mock
      final mockDb = MockDatabaseService();
      
      // Mount widget
      await tester.pumpWidget(
        ProviderScope(
          overrides: [],
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: GlobalMapScreen3D(),
          ),
        ),
      );

      // Validate loading indicator rendering
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.textContaining('Initializing'), findsWidgets);
    });
  });
}
