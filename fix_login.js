const fs = require('fs');
let content = fs.readFileSync('test/widget/login_screen_test.dart', 'utf8');

content = content.replace(
  /Widget createProviderAppWithRouter\(Widget home\) \{([\s\S]*?)databaseServiceProvider\.overrideWithValue\(MockDatabaseService\(\)\),/m,
  "Widget createProviderAppWithRouter(Widget home, {DatabaseService? mockDb}) {$1databaseServiceProvider.overrideWithValue(mockDb ?? MockDatabaseService()),"
);

const newTests = `

    testWidgets('forgot password handles missing email in local db', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      
      final mockDb = MockDatabaseService();
      when(() => mockDb.getLocalCredential(any())).thenAnswer((_) async => null);

      await tester.pumpWidget(createProviderAppWithRouter(
        const Scaffold(body: LoginScreen()),
        mockDb: mockDb,
      ));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      final forgotPassBtn = find.text('Forgot Password?');
      await tester.ensureVisible(forgotPassBtn);
      await tester.tap(forgotPassBtn);
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
      
      // select any date
      await tester.tap(find.text('Select Date of Birth'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Verify & Continue'));
      await tester.pumpAndSettle();

      expect(find.text('No matching registered account found locally.'), findsOneWidget);
    });

    testWidgets('forgot password handles incorrect date of birth', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      
      final mockDb = MockDatabaseService();
      final mockCred = LocalCredential()
        ..email = 'test@example.com'
        ..dateOfBirth = DateTime(1990, 1, 1);
      when(() => mockDb.getLocalCredential(any())).thenAnswer((_) async => mockCred);

      await tester.pumpWidget(createProviderAppWithRouter(
        const Scaffold(body: LoginScreen()),
        mockDb: mockDb,
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Forgot Password?'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
      
      // select wrong date (today)
      await tester.tap(find.text('Select Date of Birth'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Verify & Continue'));
      await tester.pumpAndSettle();

      expect(find.text('Incorrect Date of Birth for this email.'), findsOneWidget);
    });

    testWidgets('forgot password completes reset flow successfully', (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      
      final mockDb = MockDatabaseService();
      final mockCred = LocalCredential()
        ..id = 1
        ..email = 'test@example.com'
        ..dateOfBirth = DateTime.now() // to match default picker date
        ..displayName = 'Tester'
        ..isWhoStaff = false;
        
      when(() => mockDb.getLocalCredential(any())).thenAnswer((_) async => mockCred);
      when(() => mockDb.saveLocalCredential(any())).thenAnswer((_) async => 1);
      when(() => mockDb.saveSession(any())).thenAnswer((_) async {});

      await tester.pumpWidget(createProviderAppWithRouter(
        const Scaffold(body: LoginScreen()),
        mockDb: mockDb,
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Forgot Password?'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).first, 'test@example.com');
      
      await tester.tap(find.text('Select Date of Birth'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Verify & Continue'));
      await tester.pumpAndSettle();

      // We should be on step 2 now
      expect(find.text('Reset Password'), findsOneWidget);

      // Enter invalid password
      final passField = find.byType(TextFormField).last;
      await tester.enterText(passField, 'weak');
      await tester.tap(find.text('Reset Password').last);
      await tester.pumpAndSettle();
      expect(find.text('Please meet all password requirements.'), findsOneWidget);

      // Enter valid password
      await tester.enterText(passField, 'Strong!123');
      await tester.pumpAndSettle();
      await tester.tap(find.text('Reset Password').last);
      await tester.pumpAndSettle();

      expect(find.text('Password successfully reset offline!'), findsOneWidget);
    });
`;

content = content.replace(/expect\(find\.text\('Account Recovery'\), findsNothing\);\s*\}\);\s*\}\);\s*\}/, 
  "expect(find.text('Account Recovery'), findsNothing);\n    });" + newTests + "\n  });\n}"
);

fs.writeFileSync('test/widget/login_screen_test.dart', content);
