import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_settings.dart';
import 'app_settings_provider.dart';

class AppSettingsController {
  final Ref ref;

  AppSettingsController(this.ref);

  AppSettings get settings =>
      ref.read(appSettingsProvider);

  void setThemeMode(AppThemeMode mode) {
    ref.read(appSettingsProvider.notifier).state =
        settings.copyWith(
      themeMode: mode,
    );
  }

  void setLanguage(String language) {
    ref.read(appSettingsProvider.notifier).state =
        settings.copyWith(
      language: language,
    );
  }
}