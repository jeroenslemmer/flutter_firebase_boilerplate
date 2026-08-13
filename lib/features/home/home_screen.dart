import 'package:flutter/material.dart';
import '../../core/widgets/debug_info.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../auth/auth_provider.dart';
import '../../core/theme/app_spacing.dart';
import '../../l10n/app_localizations.dart';
// import '../auth/user_profile_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final user = ref.watch(authStateProvider);
    // final profile = ref.watch(userProfileProvider);
    return user.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),

      error: (error, stack) => Scaffold(
        body: Center(child: Text(l10n.errorWithDetails(error.toString()))),
      ),

      data: (appUser) {
        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.home),
            actions: [
              IconButton(
                tooltip: l10n.signOut,
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
                  l10n.welcome,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                AppSpacing.gapLg,
                Text(appUser?.email ?? l10n.noEmail),
                Text(appUser?.displayName ?? l10n.noName),
                Text(appUser?.uid ?? l10n.noUid),
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
