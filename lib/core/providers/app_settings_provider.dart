import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/app_settings.dart';

final appSettingsProvider =
    StateProvider<AppSettings>((ref) {
  return const AppSettings();
});