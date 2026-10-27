import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_firebase_boilerplate/features/auth/email_action_screen.dart';
import 'package:flutter_firebase_boilerplate/l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
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
