import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth/auth_provider.dart';
import '../auth/user_profile_provider.dart';
import '../../core/theme/app_spacing.dart';
import '../../l10n/app_localizations.dart';
import '../auth/auth_error_message.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _isSavingLanguage = false;
  bool _isDeletingAccount = false;

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

  Future<void> _deleteAccount() async {
    final l10n = AppLocalizations.of(context)!;
    final appUser = ref.read(authStateProvider).valueOrNull;
    if (appUser == null) {
      return;
    }

    String? password;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(l10n.deleteAccount),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.deleteAccountWarning),
              if (appUser.usesPassword) ...[
                AppSpacing.gapMd,
                TextField(
                  obscureText: true,
                  autofocus: true,
                  onChanged: (value) => password = value,
                  decoration: InputDecoration(labelText: l10n.currentPassword),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
              child: Text(l10n.deletePermanently),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) {
      return;
    }

    setState(() => _isDeletingAccount = true);
    try {
      await ref.read(authControllerProvider).deleteAccount(password: password);
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(authErrorMessage(error, l10n))));
      }
    } finally {
      if (mounted) {
        setState(() => _isDeletingAccount = false);
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
              AppSpacing.gapLg,
              const Divider(),
              AppSpacing.gapMd,
              Text(l10n.account, style: Theme.of(context).textTheme.titleLarge),
              AppSpacing.gapMd,
              FilledButton.tonalIcon(
                onPressed: _isDeletingAccount ? null : _deleteAccount,
                icon: _isDeletingAccount
                    ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.delete_forever_outlined),
                label: Text(l10n.deleteAccount),
                style: FilledButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.error,
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
