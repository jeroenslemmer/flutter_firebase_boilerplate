import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_spacing.dart';
import '../../l10n/app_localizations.dart';
import 'auth_error_message.dart';
import 'auth_provider.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key, this.initialEmail = ''});

  final String initialEmail;

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  bool _loading = false;
  bool _sent = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.initialEmail);
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendResetEmail() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _loading = true);
    final l10n = AppLocalizations.of(context)!;
    try {
      await ref
          .read(authControllerProvider)
          .sendPasswordResetEmail(
            _emailController.text.trim(),
            languageCode: Localizations.localeOf(context).languageCode,
          );
      if (mounted) {
        setState(() => _sent = true);
      }
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
      appBar: AppBar(title: Text(l10n.resetPassword)),
      body: Center(
        child: SingleChildScrollView(
          padding: AppSpacing.formPadding,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: _sent
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.mark_email_read_outlined, size: 64),
                      AppSpacing.gapLg,
                      Text(
                        l10n.passwordResetEmailSent,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      AppSpacing.gapLg,
                      FilledButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(l10n.backToLogin),
                      ),
                    ],
                  )
                : Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          l10n.passwordResetInstructions,
                          textAlign: TextAlign.center,
                        ),
                        AppSpacing.gapLg,
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          autofillHints: const [AutofillHints.email],
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(labelText: l10n.email),
                          validator: (value) =>
                              value == null ||
                                  value.trim().isEmpty ||
                                  !value.contains('@')
                              ? l10n.enterValidEmail
                              : null,
                          onFieldSubmitted: (_) =>
                              _loading ? null : _sendResetEmail(),
                        ),
                        AppSpacing.gapLg,
                        FilledButton(
                          onPressed: _loading ? null : _sendResetEmail,
                          child: _loading
                              ? const SizedBox.square(
                                  dimension: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(l10n.sendResetEmail),
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
