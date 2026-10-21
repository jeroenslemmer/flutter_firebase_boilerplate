import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_controller.dart';
import 'auth_error_message.dart';
import 'auth_provider.dart';
import 'forgot_password_screen.dart';
import 'register_screen.dart';
import 'widgets/apple_sign_in_button.dart';
import 'widgets/google_sign_in_button.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/password_field.dart';
import '../../l10n/app_localizations.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  AuthController get _authController => ref.read(authControllerProvider);

  bool _loading = false;

  Future<void> _openForgotPassword() async {
    final resetEmailSent = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) =>
            ForgotPasswordScreen(initialEmail: _emailController.text.trim()),
      ),
    );

    if (resetEmailSent == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.passwordResetEmailSent),
        ),
      );
    }
  }

  Future<void> _login() async {
    final l10n = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() => _loading = true);
    try {
      await _authController.signIn(
        _emailController.text.trim(),
        _passwordController.text,
      );
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
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: AppSpacing.formPadding,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    l10n.login,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),

                  AppSpacing.gapLg,

                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    autofillHints: const [
                      AutofillHints.username,
                      AutofillHints.email,
                    ],
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(labelText: l10n.email),
                    validator: (value) =>
                        value == null ||
                            value.trim().isEmpty ||
                            !value.contains('@')
                        ? l10n.enterValidEmail
                        : null,
                  ),

                  AppSpacing.gapMd,

                  PasswordField(
                    labelText: l10n.password,
                    controller: _passwordController,
                    autofillHints: const [AutofillHints.password],
                    textInputAction: TextInputAction.done,
                    validator: (value) => value == null || value.isEmpty
                        ? l10n.enterPassword
                        : null,
                    onFieldSubmitted: (_) => _loading ? null : _login(),
                  ),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: _loading ? null : _openForgotPassword,
                      child: Text(l10n.forgotPassword),
                    ),
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

                  AppSpacing.gapSm,

                  const AppleSignInButton(),

                  AppSpacing.gapLg,

                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const RegisterScreen(),
                        ),
                      );
                    },
                    child: Text(l10n.createNewAccount),
                  ),
                ],
              ),
            ),
          ),
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
