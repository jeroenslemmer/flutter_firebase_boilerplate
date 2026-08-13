import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'device/device_settings.dart';
import 'device/device_settings_controller_provider.dart';
import 'device/device_settings_provider.dart';
import '../../core/theme/app_spacing.dart';
import '../../l10n/app_localizations.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final settings = ref.watch(deviceSettingsProvider);
    final controller = ref.read(deviceSettingsControllerProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),

      body: ListView(
        padding: AppSpacing.screenPadding,
        children: [
          Text(l10n.theme, style: Theme.of(context).textTheme.titleLarge),

          RadioGroup<AppThemeMode>(
            groupValue: settings.themeMode,
            onChanged: (value) {
              if (value != null) {
                controller.setThemeMode(value);
              }
            },
            child: Column(
              children: [
                RadioListTile<AppThemeMode>(
                  title: Text(l10n.systemTheme),
                  value: AppThemeMode.system,
                ),

                RadioListTile<AppThemeMode>(
                  title: Text(l10n.lightTheme),
                  value: AppThemeMode.light,
                ),

                RadioListTile<AppThemeMode>(
                  title: Text(l10n.darkTheme),
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
