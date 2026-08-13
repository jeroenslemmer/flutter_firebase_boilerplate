import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_firebase_boilerplate/core/theme/app_theme.dart';
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

  test('AppLocalizations provides Dutch and English app text', () async {
    final dutch = await AppLocalizations.delegate.load(const Locale('nl'));
    final english = await AppLocalizations.delegate.load(const Locale('en'));

    expect(dutch.profile, 'Profiel');
    expect(dutch.settings, 'Instellingen');
    expect(english.profile, 'Profile');
    expect(english.settings, 'Settings');
  });
}
