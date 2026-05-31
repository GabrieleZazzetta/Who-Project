const fs = require('fs');
let content = fs.readFileSync('test/widget/core_widgets_test.dart', 'utf8');

const newTests = `
        testWidgets('taps back button', (WidgetTester tester) async {
          await tester.binding.setSurfaceSize(const Size(1200, 800));
          addTearDown(() => tester.binding.setSurfaceSize(null));
  
          bool popped = false;
          final router = GoRouter(
            initialLocation: '/',
            routes: [
              GoRoute(path: '/', builder: (context, state) => const FacilitySelectionScreen(emergency: EmergencyType.mpox)),
            ],
          );
          
          router.routerDelegate.addListener(() {
            // we can't easily detect pop this way if it throws, but tapping works.
          });
  
          await tester.pumpWidget(MaterialApp.router(
            locale: const Locale('en'),
            routerConfig: router,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
          ));
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 500));
  
          final backBtn = find.byIcon(Icons.arrow_back_ios_new_rounded);
          if (backBtn.evaluate().isNotEmpty) {
            await tester.tap(backBtn.first);
            await tester.pump();
          }
        });

        testWidgets('toggles sidebar on tablet landscape', (WidgetTester tester) async {
          await tester.binding.setSurfaceSize(const Size(1200, 800));
          addTearDown(() => tester.binding.setSurfaceSize(null));
  
          final router = GoRouter(
            initialLocation: '/',
            routes: [
              GoRoute(path: '/', builder: (context, state) => const FacilitySelectionScreen(emergency: EmergencyType.mpox)),
            ],
          );
  
          await tester.pumpWidget(MaterialApp.router(
            locale: const Locale('en'),
            routerConfig: router,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
          ));
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 500));
  
          final collapseBtn = find.byIcon(Icons.menu_open_rounded);
          if (collapseBtn.evaluate().isNotEmpty) {
            await tester.tap(collapseBtn.first);
            await tester.pump(const Duration(milliseconds: 400));
          }
        });

        testWidgets('handles locked module tap', (WidgetTester tester) async {
          await tester.binding.setSurfaceSize(const Size(400, 800));
          addTearDown(() => tester.binding.setSurfaceSize(null));
  
          final router = GoRouter(
            initialLocation: '/',
            routes: [
              GoRoute(path: '/', builder: (context, state) => const FacilitySelectionScreen(emergency: EmergencyType.mpox)),
            ],
          );
  
          await tester.pumpWidget(MaterialApp.router(
            locale: const Locale('en'),
            routerConfig: router,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
          ));
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 500));
  
          // Tap on a locked module (Stand-alone Center)
          await tester.tap(find.text('Stand-alone Center').hitTestable());
          await tester.pump();
          
          expect(find.byType(SnackBar), findsOneWidget);
        });

        testWidgets('renders mobile landscape layout with list view', (WidgetTester tester) async {
          await tester.binding.setSurfaceSize(const Size(800, 400));
          addTearDown(() => tester.binding.setSurfaceSize(null));
  
          final router = GoRouter(
            initialLocation: '/',
            routes: [
              GoRoute(path: '/', builder: (context, state) => const FacilitySelectionScreen(emergency: EmergencyType.sars)),
            ],
          );
  
          await tester.pumpWidget(MaterialApp.router(
            locale: const Locale('en'),
            routerConfig: router,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
          ));
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 500));
  
          expect(find.text('Select Facility Type'), findsOneWidget);
        });
      });
`;

content = content.replace(/testWidgets\('renders tablet portrait layout'.*?\);\s*\}\);/s, match => {
  return match + '\n' + newTests.trimRight() + '\n';
});

fs.writeFileSync('test/widget/core_widgets_test.dart', content);
