import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'device_settings.dart';
import 'device_settings_provider.dart';

class AppSettingsController {
  final Ref ref;

  AppSettingsController(this.ref);

  DeviceSettings get settings =>
      ref.read(deviceSettingsProvider);

  void setThemeMode(AppThemeMode mode) {
    ref.read(deviceSettingsProvider.notifier).state =
        settings.copyWith(
      themeMode: mode,
    );
  }

}