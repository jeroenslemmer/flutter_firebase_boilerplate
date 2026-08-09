import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_firebase_boilerplate/core/theme/app_theme.dart';

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
}
