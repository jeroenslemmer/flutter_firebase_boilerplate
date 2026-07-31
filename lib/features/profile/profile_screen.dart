import 'package:flutter/material.dart';
import '../auth/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final user = ref.watch(authStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),

      body: user.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),

        error: (error, stack) => Center(
          child: Text(error.toString()),
        ),

        data: (appUser) {

          if (appUser == null) {
            return const Center(
              child: Text('No user'),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  appUser.email ?? '',
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  appUser.displayName ?? 
                  'Geen naam',
                ),

                const SizedBox(height: 12),

                Text(
                  'UID: ${appUser.uid}',
                ),

              ],
            ),
          );
        },
      ),
    );
  }
}