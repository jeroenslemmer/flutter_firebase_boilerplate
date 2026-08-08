import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../auth_provider.dart';
import 'package:flutter/foundation.dart';
import 'google_sign_in_web_button_stub.dart'
    if (dart.library.js_interop) 'google_sign_in_web_button.dart'
    as google_web_button;

class GoogleSignInButton extends ConsumerStatefulWidget {
  const GoogleSignInButton({super.key});

  @override
  ConsumerState<GoogleSignInButton> createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends ConsumerState<GoogleSignInButton> {
  bool _loading = false;

  Future<void> _loginWithGoogle() async {
    setState(() => _loading = true);

    try {
      await ref.read(authControllerProvider).signInWithGoogle();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      final initialization = ref.watch(googleInitializationProvider);

      return initialization.when(
        loading: () => const SizedBox(
          height: 40,
          child: Center(child: CircularProgressIndicator()),
        ),
        error: (error, stackTrace) => Text(
          'Google Sign-In kon niet worden voorbereid: $error',
          textAlign: TextAlign.center,
        ),
        data: (_) => google_web_button.buildGoogleSignInWebButton(),
      );
    }

    return _loading
        ? const CircularProgressIndicator()
        : ElevatedButton(
            onPressed: _loginWithGoogle,
            child: const Text('Sign in with Google'),
          );
  }
}
