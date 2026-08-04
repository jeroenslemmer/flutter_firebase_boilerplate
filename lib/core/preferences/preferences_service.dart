import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String themeModeKey = 'themeMode';

  final SharedPreferences prefs;

  PreferencesService(this.prefs);

  Future<void> saveThemeMode(String value) async {
    await prefs.setString(themeModeKey, value);
  }

  String? loadThemeMode() {
    return prefs.getString(themeModeKey);
  }
}