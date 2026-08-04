import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'device_settings_controller.dart';

final deviceSettingsControllerProvider =
    Provider<AppSettingsController>((ref) {
  return AppSettingsController(ref);
});
