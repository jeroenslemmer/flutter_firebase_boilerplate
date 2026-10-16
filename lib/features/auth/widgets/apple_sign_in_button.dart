import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../auth_error_message.dart';
import '../auth_provider.dart';

class AppleSignInButton extends ConsumerStatefulWidget {
  const AppleSignInButton({super.key});

  @override
  ConsumerState<AppleSignInButton> createState() => _AppleSignInButtonState();
}

class _AppleSignInButtonState extends ConsumerState<AppleSignInButton> {
  bool _loading = false;

  Future<void> _signIn() async {
    setState(() => _loading = true);
    final l10n = AppLocalizations.of(context)!;
    try {
      await ref.read(authControllerProvider).signInWithApple();
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(authErrorMessage(error, l10n))));
      }
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final supported =
        !kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.iOS ||
            defaultTargetPlatform == TargetPlatform.macOS);
    if (!supported) {
      return const SizedBox.shrink();
    }

    return OutlinedButton.icon(
      onPressed: _loading ? null : _signIn,
      icon: _loading
          ? const SizedBox.square(
              dimension: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.apple),
      label: Text(AppLocalizations.of(context)!.signInWithApple),
    );
  }
}
