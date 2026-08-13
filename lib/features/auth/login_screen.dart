import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_controller.dart';
import 'auth_provider.dart';
import 'register_screen.dart';
import 'widgets/google_sign_in_button.dart';
import '../../core/theme/app_spacing.dart';
import '../../l10n/app_localizations.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  AuthController get _authController => ref.read(authControllerProvider);

  bool _loading = false;

  Future<void> _login() async {
    setState(() => _loading = true);
    try {
      await _authController.signIn(
        _emailController.text.trim(),
        _passwordController.text,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.errorWithDetails(e.toString()),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: Padding(
        padding: AppSpacing.formPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(l10n.login, style: Theme.of(context).textTheme.headlineMedium),

            AppSpacing.gapLg,

            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: l10n.email),
            ),

            AppSpacing.gapMd,

            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: l10n.password),
            ),

            AppSpacing.gapLg,

            _loading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _loading ? null : _login,
                    child: Text(l10n.login),
                  ),

            AppSpacing.gapSm,

            const GoogleSignInButton(),

            AppSpacing.gapLg,

            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RegisterScreen()),
                );
              },
              child: Text(l10n.createNewAccount),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
