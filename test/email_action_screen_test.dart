import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firebase_boilerplate/features/auth/auth_controller.dart';
import 'package:flutter_firebase_boilerplate/features/auth/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_firebase_boilerplate/features/auth/email_action_screen.dart';
import 'package:flutter_firebase_boilerplate/l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> showAction(
    WidgetTester tester,
    FakeActionController controller,
    String mode,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [authControllerProvider.overrideWithValue(controller)],
        child: MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: EmailActionScreen(mode: mode, actionCode: 'test-code'),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  for (final mode in ['verifyEmail', 'recoverEmail', 'verifyAndChangeEmail']) {
    testWidgets('completes $mode and displays the correct result', (
      tester,
    ) async {
      final controller = FakeActionController();
      await showAction(tester, controller, mode);
      expect(controller.applied, ['test-code', mode]);
      final l10n = await AppLocalizations.delegate.load(const Locale('en'));
      expect(
        find.text(
          mode == 'recoverEmail'
              ? l10n.emailAddressRestored
              : l10n.emailAddressConfirmed,
        ),
        findsOneWidget,
      );
      expect(find.byType(TextFormField), findsNothing);
    });
  }

  for (final code in ['invalid-action-code', 'expired-action-code']) {
    testWidgets('shows request-new-email guidance for $code', (tester) async {
      final controller = FakeActionController()
        ..failure = FirebaseAuthException(code: code);
      await showAction(tester, controller, 'verifyEmail');
      expect(
        find.text(
          'This link is invalid or expired. Request a new email in the app.',
        ),
        findsOneWidget,
      );
      expect(find.byIcon(Icons.check_circle_outline), findsNothing);
    });
  }

  testWidgets('resets password only after matching confirmation', (
    tester,
  ) async {
    final controller = FakeActionController();
    await showAction(tester, controller, 'resetPassword');
    expect(controller.verifiedCode, 'test-code');
    expect(find.text('test@example.com'), findsOneWidget);
    await tester.enterText(find.byType(TextFormField).at(0), 'new-password');
    await tester.enterText(
      find.byType(TextFormField).at(1),
      'different-password',
    );
    final l10n = await AppLocalizations.delegate.load(const Locale('en'));
    await tester.ensureVisible(find.text(l10n.savePassword));
    await tester.tap(find.text(l10n.savePassword));
    await tester.pumpAndSettle();
    expect(controller.reset, isNull);
    expect(find.text(l10n.passwordsDoNotMatch), findsOneWidget);
    await tester.enterText(find.byType(TextFormField).at(1), 'new-password');
    await tester.ensureVisible(find.text(l10n.savePassword));
    await tester.tap(find.text(l10n.savePassword));
    await tester.pumpAndSettle();
    expect(controller.reset, ['test-code', 'new-password']);
    expect(find.text(l10n.passwordChanged), findsOneWidget);
  });

  for (final mode in [null, 'signIn', 'unknown', 'verifyEmail']) {
    testWidgets('rejects invalid action or missing code: $mode', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            locale: const Locale('nl'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: EmailActionScreen(
              mode: mode,
              actionCode: mode == 'verifyEmail' ? null : 'code',
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(
        find.text(
          'Deze link is ongeldig of verlopen. Vraag een nieuwe e-mail aan in de app.',
        ),
        findsOneWidget,
      );
      expect(find.byType(TextFormField), findsNothing);
    });
  }
}

// Isolates the screen from Firebase; these tests do not prove live email delivery.
class FakeActionController implements AuthController {
  List<String>? applied;
  List<String>? reset;
  String? verifiedCode;
  Object? failure;

  @override
  Future<void> applyEmailAction(String code, String mode) async {
    if (failure != null) throw failure!;
    applied = [code, mode];
  }

  @override
  Future<String> verifyPasswordResetCode(String code) async {
    if (failure != null) throw failure!;
    verifiedCode = code;
    return 'test@example.com';
  }

  @override
  Future<void> confirmPasswordReset(String code, String password) async {
    if (failure != null) throw failure!;
    reset = [code, password];
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
