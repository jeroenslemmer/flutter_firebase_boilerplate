import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth/user_profile_provider.dart';


class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(userProfileProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Profiel')),
      body: profile.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (e, _) => Center(
          child: Text(e.toString()),
        ),
        data: (profile) {
          if (profile == null) {
            return const Center(
              child: Text('Geen profiel gevonden'),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text('Taal: ${profile.language}'),
              Text('Thema: ${profile.themeMode}'),
              Text('Profiel compleet: ${profile.profileComplete}'),
              Text('Aangemaakt: ${profile.createdAt}'),
              Text('Laatste login: ${profile.lastLogin}'),
            ],
          );
        },
      ),
    );
  }
}