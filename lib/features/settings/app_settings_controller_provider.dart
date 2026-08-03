import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_settings_controller.dart';

final appSettingsControllerProvider =
    Provider<AppSettingsController>((ref) {
  return AppSettingsController(ref);
});