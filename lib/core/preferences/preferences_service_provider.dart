import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'preferences_provider.dart';
import 'preferences_service.dart';

final preferencesServiceProvider =
    Provider<PreferencesService>((ref) {
  return PreferencesService(
    ref.read(sharedPreferencesProvider),
  );
});