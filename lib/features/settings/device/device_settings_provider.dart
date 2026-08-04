import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'device_settings.dart';

final deviceSettingsProvider =
    StateProvider<DeviceSettings>((ref) {
  return const DeviceSettings();
});