const fs = require('fs');
let content = fs.readFileSync('test/widget/core_widgets_test.dart', 'utf8');

const targetStr = `bool popped = false;
        final router = GoRouter(
          initialLocation: '/',
          routes: [
            GoRoute(path: '/', builder: (context, state) => const FacilitySelectionScreen(emergency: EmergencyType.mpox)),
          ],
        );`;

const replacement = `final router = GoRouter(
          initialLocation: '/home',
          routes: [
            GoRoute(path: '/home', builder: (context, state) => const Scaffold(body: Text('Home'))),
            GoRoute(path: '/facility', builder: (context, state) => const FacilitySelectionScreen(emergency: EmergencyType.mpox)),
          ],
        );`;

content = content.replace(targetStr, replacement);

const pumpWidgetStr = `        await tester.pumpWidget(MaterialApp.router(
          locale: const Locale('en'),
          routerConfig: router,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));`;

const pumpWidgetReplacement = `        await tester.pumpWidget(MaterialApp.router(
          locale: const Locale('en'),
          routerConfig: router,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));
        router.push('/facility');
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));`;

content = content.replace(pumpWidgetStr, pumpWidgetReplacement);

fs.writeFileSync('test/widget/core_widgets_test.dart', content);
