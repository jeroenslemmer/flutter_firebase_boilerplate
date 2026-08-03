enum AppThemeMode {
  system,
  light,
  dark,
}

class AppSettings {
  final AppThemeMode themeMode;
  final String language;

  const AppSettings({
    this.themeMode = AppThemeMode.system,
    this.language = 'nl',
  });

  AppSettings copyWith({
    AppThemeMode? themeMode,
    String? language,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      language: language ?? this.language,
    );
  }
}