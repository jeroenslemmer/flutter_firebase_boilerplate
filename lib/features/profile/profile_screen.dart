import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth/auth_provider.dart';
import '../auth/user_profile_provider.dart';
import '../../core/theme/app_spacing.dart';
import '../../l10n/app_localizations.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _isSavingLanguage = false;

  Future<void> _setLanguage(String uid, String language) async {
    setState(() => _isSavingLanguage = true);

    try {
      await ref
          .read(firestoreServiceProvider)
          .updateUserLanguage(uid, language);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.languageSaveFailed),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSavingLanguage = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final profile = ref.watch(userProfileProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.profile)),
      body: profile.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) =>
            Center(child: Text(l10n.errorWithDetails(e.toString()))),
        data: (profile) {
          if (profile == null) {
            return Center(child: Text(l10n.noProfileFound));
          }

          return ListView(
            padding: AppSpacing.screenPadding,
            children: [
              DropdownButtonFormField<String>(
                initialValue: switch (profile.language) {
                  'en' => 'en',
                  _ => 'nl',
                },
                decoration: InputDecoration(
                  labelText: l10n.appLanguage,
                  prefixIcon: const Icon(Icons.language),
                ),
                items: [
                  DropdownMenuItem(value: 'nl', child: Text(l10n.dutch)),
                  DropdownMenuItem(value: 'en', child: Text(l10n.english)),
                ],
                onChanged: _isSavingLanguage
                    ? null
                    : (language) {
                        if (language != null && language != profile.language) {
                          _setLanguage(profile.uid, language);
                        }
                      },
              ),
              if (_isSavingLanguage) ...[
                const SizedBox(height: 8),
                const LinearProgressIndicator(),
              ],
              const SizedBox(height: 24),
              Text(l10n.themeValue(_themeName(profile.themeMode, l10n))),
              Text(
                l10n.profileCompleteValue(
                  profile.profileComplete ? l10n.yes : l10n.no,
                ),
              ),
              Text(
                l10n.createdAtValue(
                  profile.createdAt?.toString() ?? l10n.notAvailable,
                ),
              ),
              Text(
                l10n.lastLoginValue(
                  profile.lastLogin?.toString() ?? l10n.notAvailable,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _themeName(String value, AppLocalizations l10n) => switch (value) {
    'light' => l10n.lightTheme,
    'dark' => l10n.darkTheme,
    _ => l10n.systemTheme,
  };
}
