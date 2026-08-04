import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const _themeModeKey = 'themeMode';

  final SharedPreferences prefs;

  PreferencesService(this.prefs);

  Future<void> saveThemeMode(String value) async {
    await prefs.setString(
      _themeModeKey,
      value,
    );
  }

  String? loadThemeMode() {
    return prefs.getString(
      _themeModeKey,
    );
  }
}