import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_spacing.dart';
import '../../l10n/app_localizations.dart';
import 'auth_error_message.dart';
import 'auth_provider.dart';

class EmailVerificationScreen extends ConsumerStatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  ConsumerState<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState
    extends ConsumerState<EmailVerificationScreen> {
  bool _checking = false;
  bool _resending = false;

  Future<void> _checkVerification() async {
    setState(() => _checking = true);
    final l10n = AppLocalizations.of(context)!;
    try {
      await ref.read(authControllerProvider).reloadCurrentUser();
      final user = ref.read(authControllerProvider).currentUser;
      if (mounted && user?.emailVerified != true) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.emailNotVerifiedYet)));
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(authErrorMessage(error, l10n))));
      }
    } finally {
      if (mounted) {
        setState(() => _checking = false);
      }
    }
  }

  Future<void> _resend() async {
    setState(() => _resending = true);
    final l10n = AppLocalizations.of(context)!;
    try {
      await ref
          .read(authControllerProvider)
          .sendEmailVerification(
            languageCode: Localizations.localeOf(context).languageCode,
          );
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.verificationEmailResent)));
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(authErrorMessage(error, l10n))));
      }
    } finally {
      if (mounted) {
        setState(() => _resending = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final email = ref.watch(authStateProvider).valueOrNull?.email;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: AppSpacing.formPadding,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.mark_email_unread_outlined, size: 72),
                AppSpacing.gapLg,
                Text(
                  l10n.verifyEmail,
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                AppSpacing.gapMd,
                Text(
                  l10n.verificationEmailInstructions(email ?? l10n.noEmail),
                  textAlign: TextAlign.center,
                ),
                AppSpacing.gapLg,
                FilledButton(
                  onPressed: _checking ? null : _checkVerification,
                  child: _checking
                      ? const SizedBox.square(
                          dimension: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(l10n.iHaveVerifiedEmail),
                ),
                AppSpacing.gapSm,
                TextButton(
                  onPressed: _resending ? null : _resend,
                  child: Text(l10n.resendVerificationEmail),
                ),
                TextButton(
                  onPressed: () => ref.read(authControllerProvider).signOut(),
                  child: Text(l10n.signOut),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
