import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/preferences/preferences_service.dart';

import '../../core/preferences/preferences_provider.dart';
import 'device_settings_controller.dart';

final preferencesServiceProvider =
  Provider<PreferencesService>((ref) {
    return PreferencesService(
      ref.read(sharedPreferencesProvider),
    );
  });

final deviceSettingsControllerProvider =
    Provider<DeviceSettingsController>((ref) {
  return DeviceSettingsController(
    ref,
    ref.read(preferencesServiceProvider),
  );
});