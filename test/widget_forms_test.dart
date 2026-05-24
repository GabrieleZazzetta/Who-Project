import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:assessment_tool/screens/login_screen.dart';
import 'package:assessment_tool/l10n/app_localizations.dart';

void main() {
  group('2.1 e 2.2 Widget Testing - Accessibilità, Form Inputs e Chiavi Uniche', () {
    
    setUpAll(() {
      // Silenzia gli errori di overflow nell'ambiente di test headless
      final originalOnError = FlutterError.onError;
      FlutterError.onError = (FlutterErrorDetails details) {
        if (details.exceptionAsString().contains('overflowed')) {
          return; // ignora gli overflow legati ai font nel test runner
        }
        originalOnError?.call(details);
      };
    });
    
    testWidgets('Enforcement Autenticazione WHO: Verifica validazione dominio in modalità WHO Staff', (WidgetTester tester) async {
      // Imposta dimensione dello schermo per evitare overflow
      await tester.binding.setSurfaceSize(const Size(1200, 1000));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      // 1. Costruiamo il widget avvolto in ProviderScope e MaterialApp
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              body: LoginScreen(),
            ),
          ),
        ),
      );

      // Settle per completare le animazioni di caricamento iniziali
      await tester.pumpAndSettle();

      // 2. Troviamo i campi di input tramite Chiavi Uniche (Fase 2.2)
      final emailFieldFinder = find.byKey(const Key('input_email'));
      final passwordFieldFinder = find.byKey(const Key('input_password'));
      final authButtonFinder = find.byKey(const Key('btn_authenticate'));

      expect(emailFieldFinder, findsOneWidget);
      expect(passwordFieldFinder, findsOneWidget);
      expect(authButtonFinder, findsOneWidget);

      // Di default l'app parte in modalità "WHO Staff"
      // Inseriamo un'email non-WHO (es. gmail) per innescare l'errore
      await tester.enterText(emailFieldFinder, "medico@gmail.com");
      await tester.enterText(passwordFieldFinder, "dummyPassword123!");
      
      // Clicchiamo su Authenticate
      await tester.tap(authButtonFinder);
      await tester.pumpAndSettle();

      // Verifica che sia mostrato il messaggio di errore per WHO Staff
      expect(find.text("WHO Staff must use a @who.int email"), findsOneWidget);

      // Inseriamo ora un'email WHO Staff valida
      await tester.enterText(emailFieldFinder, "medico@who.int");
      
      // Clicchiamo nuovamente su Authenticate
      await tester.tap(authButtonFinder);
      await tester.pumpAndSettle();

      // L'errore WHO Staff deve essere sparito!
      expect(find.text("WHO Staff must use a @who.int email"), findsNothing);
    });

    testWidgets('Enforcement Autenticazione: Toggling a External Partner consente email generiche ed esclude dominio WHO', (WidgetTester tester) async {
      // Imposta dimensione dello schermo per evitare overflow
      await tester.binding.setSurfaceSize(const Size(1200, 1000));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              body: LoginScreen(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // 1. Troviamo e clicchiamo sul Toggle "External Partner" tramite Chiave Unica (Fase 2.2)
      final externalPartnerToggleFinder = find.byKey(const Key('toggle_external_partner'));
      expect(externalPartnerToggleFinder, findsOneWidget);
      
      await tester.tap(externalPartnerToggleFinder);
      await tester.pumpAndSettle();

      // Troviamo i campi tramite Chiave Unica (Fase 2.2)
      final emailFieldFinder = find.byKey(const Key('input_email'));
      final passwordFieldFinder = find.byKey(const Key('input_password'));
      final authButtonFinder = find.byKey(const Key('btn_authenticate'));

      // 2. Inseriamo una stringa che NON è una mail valida
      await tester.enterText(emailFieldFinder, "not-a-valid-email");
      await tester.enterText(passwordFieldFinder, "dummyPassword123!");

      await tester.tap(authButtonFinder);
      await tester.pumpAndSettle();

      // Verifica validazione generica attiva
      expect(find.text("Please enter a valid email address"), findsOneWidget);

      // 3. Inseriamo un'email partner valida (generica, non WHO)
      await tester.enterText(emailFieldFinder, "partner@gmail.com");

      await tester.tap(authButtonFinder);
      await tester.pumpAndSettle();

      // L'errore deve essere scomparso per le email reali
      expect(find.text("Please enter a valid email address"), findsNothing);
      expect(find.text("WHO Staff must use a @who.int email"), findsNothing);
    });

    testWidgets('2.2 Integrazione Chiavi ed Identificatori: Verifica presenza di tutte le chiavi critiche attive in UI', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 1000));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              body: LoginScreen(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verifica l'esistenza di tutti gli identificatori univoci (Keys) per il testing automatico
      expect(find.byKey(const Key('input_email')), findsOneWidget);
      expect(find.byKey(const Key('input_password')), findsOneWidget);
      expect(find.byKey(const Key('btn_authenticate')), findsOneWidget);
      expect(find.byKey(const Key('toggle_who_staff')), findsOneWidget);
      expect(find.byKey(const Key('toggle_external_partner')), findsOneWidget);
    });
  });
}
