import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_firebase_boilerplate/core/theme/app_theme.dart';
import 'package:flutter_firebase_boilerplate/core/widgets/password_field.dart';
import 'package:flutter_firebase_boilerplate/l10n/app_localizations.dart';

void main() {
  test('AppTheme provides matching light and dark themes', () {
    final lightTheme = AppTheme.light;
    final darkTheme = AppTheme.dark;

    expect(lightTheme.brightness, Brightness.light);
    expect(darkTheme.brightness, Brightness.dark);
    expect(lightTheme.useMaterial3, isTrue);
    expect(darkTheme.useMaterial3, isTrue);
  });

  test('AppTheme defines shared component styling', () {
    final theme = AppTheme.light;

    expect(theme.inputDecorationTheme.filled, isTrue);
    expect(theme.elevatedButtonTheme.style?.minimumSize, isNotNull);
    expect(theme.snackBarTheme.behavior, SnackBarBehavior.floating);
  });

  test(
    'AppLocalizations provides Dutch, English and French app text',
    () async {
      final dutch = await AppLocalizations.delegate.load(const Locale('nl'));
      final english = await AppLocalizations.delegate.load(const Locale('en'));
      final french = await AppLocalizations.delegate.load(const Locale('fr'));

      expect(dutch.profile, 'Profiel');
      expect(dutch.settings, 'Instellingen');
      expect(english.profile, 'Profile');
      expect(english.settings, 'Settings');
      expect(french.profile, 'Profil');
      expect(french.settings, 'Paramètres');
      expect(french.french, 'Français');
    },
  );

  testWidgets('PasswordField toggles password visibility', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: PasswordField(labelText: 'Password')),
      ),
    );

    expect(
      tester.widget<EditableText>(find.byType(EditableText)).obscureText,
      isTrue,
    );

    await tester.tap(find.byIcon(Icons.visibility_outlined));
    await tester.pump();

    expect(
      tester.widget<EditableText>(find.byType(EditableText)).obscureText,
      isFalse,
    );
    expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
  });
}
