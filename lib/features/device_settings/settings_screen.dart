import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'device_settings.dart';
import 'device_settings_controller_provider.dart';
import 'device_settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(deviceSettingsProvider);
    final controller = ref.read(deviceSettingsControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),

body: ListView(
  padding: const EdgeInsets.all(16),
  children: [
    const Text(
      'Theme',
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),

    RadioGroup<AppThemeMode>(
      groupValue: settings.themeMode,
      onChanged: (value) {
        if (value != null) {
          controller.setThemeMode(value);
        }
      },
      child: Column(
        children: [
          const RadioListTile<AppThemeMode>(
            title: Text('System'),
            value: AppThemeMode.system,
          ),

          const RadioListTile<AppThemeMode>(
            title: Text('Light'),
            value: AppThemeMode.light,
          ),

          const RadioListTile<AppThemeMode>(
            title: Text('Dark'),
            value: AppThemeMode.dark,
          ),
        ],
      ),
    ),
  ],
),
    );
  }
}