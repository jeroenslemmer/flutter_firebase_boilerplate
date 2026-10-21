import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_provider.dart';
import 'auth_error_message.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/widgets/password_field.dart';
import '../../l10n/app_localizations.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _loading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    final l10n = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.passwordsDoNotMatch),
        ),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      await ref
          .read(authControllerProvider)
          .signUp(
            _emailController.text.trim(),
            _passwordController.text,
            languageCode: Localizations.localeOf(context).languageCode,
          );
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(authErrorMessage(error, l10n))));
      }
    }

    if (mounted) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.register)),
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
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    autofillHints: const [
                      AutofillHints.newUsername,
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
                    autofillHints: const [AutofillHints.newPassword],
                    textInputAction: TextInputAction.next,
                    validator: (value) => value == null || value.length < 6
                        ? l10n.passwordMinimumLength
                        : null,
                  ),

                  AppSpacing.gapMd,

                  PasswordField(
                    labelText: l10n.confirmPassword,
                    controller: _confirmPasswordController,
                    autofillHints: const [AutofillHints.newPassword],
                    textInputAction: TextInputAction.done,
                    validator: (value) => value == null || value.isEmpty
                        ? l10n.enterPasswordConfirmation
                        : null,
                    onFieldSubmitted: (_) => _loading ? null : _register(),
                  ),

                  AppSpacing.gapLg,

                  _loading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: _register,
                          child: Text(l10n.createAccount),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
