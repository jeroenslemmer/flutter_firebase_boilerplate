import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_boilerplate/core/models/app_user.dart';
import 'package:flutter_firebase_boilerplate/features/auth/auth_error_message.dart';
import 'package:flutter_firebase_boilerplate/l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppUser verification', () {
    test('requires verification for an unverified password account', () {
      const user = AppUser(uid: 'user-1', providerIds: ['password']);

      expect(user.usesPassword, isTrue);
      expect(user.requiresEmailVerification, isTrue);
    });

    test('does not require verification for social or verified accounts', () {
      const socialUser = AppUser(uid: 'user-2', providerIds: ['google.com']);
      const verifiedUser = AppUser(
        uid: 'user-3',
        emailVerified: true,
        providerIds: ['password'],
      );

      expect(socialUser.requiresEmailVerification, isFalse);
      expect(verifiedUser.requiresEmailVerification, isFalse);
    });
  });

  group('authErrorMessage', () {
    late AppLocalizations dutch;

    setUpAll(() async {
      dutch = await AppLocalizations.delegate.load(const Locale('nl'));
    });

    test('maps known Firebase errors to safe localized text', () {
      final message = authErrorMessage(
        FirebaseAuthException(code: 'wrong-password'),
        dutch,
      );

      expect(message, dutch.authErrorInvalidCredential);
    });

    test('does not expose unexpected exception details', () {
      const secret = 'internal implementation detail';

      final message = authErrorMessage(Exception(secret), dutch);

      expect(message, dutch.authErrorUnknown);
      expect(message, isNot(contains(secret)));
    });
  });
}
