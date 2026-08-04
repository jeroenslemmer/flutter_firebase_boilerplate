import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'device_settings.dart';
import 'device_settings_provider.dart';
import '../../core/preferences/preferences_service.dart';

class DeviceSettingsController {
  final Ref ref;
  final PreferencesService _preferences;

  DeviceSettingsController(
    this.ref,
    this._preferences,
  );

  DeviceSettings get settings =>
      ref.read(deviceSettingsProvider);

  Future<void> setThemeMode(AppThemeMode mode) async {
    ref.read(deviceSettingsProvider.notifier).state =
      settings.copyWith(
        themeMode: mode,
      );
    await _preferences.saveThemeMode(
      mode.name,
    );
  }

  Future<void> loadSettings() async {
    final saved = _preferences.loadThemeMode();
    if (saved == null) {
      return;
    }

    final mode =
      AppThemeMode.values.firstWhere(
        (e) => e.name == saved,
        orElse: () => AppThemeMode.system,
      );

    ref.read(deviceSettingsProvider.notifier).state =
      settings.copyWith(
        themeMode: mode,
      );
}

}