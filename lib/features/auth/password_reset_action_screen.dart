import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/widgets/password_field.dart';
import '../../l10n/app_localizations.dart';
import 'auth_error_message.dart';
import 'auth_provider.dart';

class PasswordResetActionScreen extends ConsumerStatefulWidget {
  const PasswordResetActionScreen({
    required this.mode,
    required this.actionCode,
    super.key,
  });

  final String? mode;
  final String? actionCode;

  @override
  ConsumerState<PasswordResetActionScreen> createState() =>
      _PasswordResetActionScreenState();
}

class _PasswordResetActionScreenState
    extends ConsumerState<PasswordResetActionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmationController = TextEditingController();

  String? _email;
  Object? _error;
  bool _checking = true;
  bool _saving = false;
  bool _completed = false;

  @override
  void initState() {
    super.initState();
    _verifyCode();
  }

  Future<void> _verifyCode() async {
    final code = widget.actionCode;
    if (widget.mode != 'resetPassword' || code == null || code.isEmpty) {
      setState(() {
        _checking = false;
        _error = const FormatException('Invalid password reset link');
      });
      return;
    }

    try {
      final email = await ref
          .read(authControllerProvider)
          .verifyPasswordResetCode(code);
      if (mounted) {
        setState(() {
          _email = email;
          _checking = false;
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _error = error;
          _checking = false;
        });
      }
    }
  }

  Future<void> _savePassword() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _saving = true);
    try {
      await ref
          .read(authControllerProvider)
          .confirmPasswordReset(widget.actionCode!, _passwordController.text);
      if (mounted) {
        setState(() {
          _saving = false;
          _completed = true;
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _error = error;
          _saving = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmationController.dispose();
    super.dispose();
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
            child: _buildContent(l10n),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(AppLocalizations l10n) {
    if (_checking) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_completed) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle_outline, size: 72),
          AppSpacing.gapLg,
          Text(
            l10n.passwordChanged,
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          AppSpacing.gapLg,
          FilledButton(
            onPressed: () => context.go('/login'),
            child: Text(l10n.backToLogin),
          ),
        ],
      );
    }

    if (_error != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.link_off_outlined, size: 72),
          AppSpacing.gapLg,
          Text(
            _error is FormatException
                ? l10n.invalidPasswordResetLink
                : authErrorMessage(_error!, l10n),
            textAlign: TextAlign.center,
          ),
          AppSpacing.gapLg,
          FilledButton(
            onPressed: () => context.go('/login'),
            child: Text(l10n.backToLogin),
          ),
        ],
      );
    }

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            l10n.chooseNewPassword,
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          AppSpacing.gapSm,
          Text(_email ?? '', textAlign: TextAlign.center),
          AppSpacing.gapLg,
          PasswordField(
            labelText: l10n.newPassword,
            controller: _passwordController,
            autofocus: true,
            autofillHints: const [AutofillHints.newPassword],
            validator: (value) => value == null || value.length < 6
                ? l10n.passwordMinimumLength
                : null,
          ),
          AppSpacing.gapMd,
          PasswordField(
            labelText: l10n.confirmNewPassword,
            controller: _confirmationController,
            autofillHints: const [AutofillHints.newPassword],
            validator: (value) => value != _passwordController.text
                ? l10n.passwordsDoNotMatch
                : null,
          ),
          AppSpacing.gapLg,
          FilledButton(
            onPressed: _saving ? null : _savePassword,
            child: _saving
                ? const SizedBox.square(
                    dimension: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(l10n.savePassword),
          ),
        ],
      ),
    );
  }
}
