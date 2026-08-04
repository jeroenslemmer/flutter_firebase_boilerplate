import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/firebase/firebase_service.dart';
import 'core/router/app_router.dart';

import 'features/device_settings/device_settings.dart';
import 'features/device_settings/device_settings_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FirebaseService.init();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(deviceSettingsProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,

      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),

      themeMode: switch (settings.themeMode) {
        AppThemeMode.light => ThemeMode.light,
        AppThemeMode.dark => ThemeMode.dark,
        AppThemeMode.system => ThemeMode.system,
      },

      routerConfig: appRouter,
    );
  }
}