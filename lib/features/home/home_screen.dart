import 'package:flutter/material.dart';
import '../../core/widgets/debug_info.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../auth/auth_provider.dart';
import '../../core/theme/app_spacing.dart';
// import '../auth/user_profile_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider);
    // final profile = ref.watch(userProfileProvider);
    return user.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),

      error: (error, stack) =>
          Scaffold(body: Center(child: Text(error.toString()))),

      data: (appUser) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Home'),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  ref.read(authControllerProvider).signOut();
                },
              ),
            ],
          ),

          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Welcome',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                AppSpacing.gapLg,
                Text(appUser?.email ?? "geen email"),
                Text(appUser?.displayName ?? "geen naam"),
                Text(appUser?.uid ?? "geen uid"),
                AppSpacing.gapLg,
                const DebugInfo(),
              ],
            ),
          ),
        );
      },
    );
  }
}
