enum AppThemeMode {
  system,
  light,
  dark,
}

class DeviceSettings {
  final AppThemeMode themeMode;

  const DeviceSettings({
    this.themeMode = AppThemeMode.system,
  });

  DeviceSettings copyWith({
    AppThemeMode? themeMode,
    String? language,
  }) {
    return DeviceSettings(
      themeMode: themeMode ?? this.themeMode,
    );
  }
}