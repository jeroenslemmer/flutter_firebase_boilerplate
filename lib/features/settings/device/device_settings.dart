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
  }) {
    return DeviceSettings(
      themeMode: themeMode ?? this.themeMode,
    );
  }

  String get themeModeValue {
    return themeMode.name;
  }

  static AppThemeMode themeModeFromString(String? value) {
    return AppThemeMode.values.firstWhere(
      (mode) => mode.name == value,
      orElse: () => AppThemeMode.system,
    );
  }
}