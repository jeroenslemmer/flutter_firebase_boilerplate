import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../../l10n/app_localizations.dart';

String authErrorMessage(Object error, AppLocalizations l10n) {
  if (kDebugMode) {
    debugPrint('Authentication flow failed: $error');
  }

  if (error is FirebaseException && error.plugin == 'cloud_firestore') {
    return switch (error.code) {
      'permission-denied' => l10n.profileSyncPermissionDenied,
      'unavailable' => l10n.profileSyncUnavailable,
      _ => l10n.profileSyncFailed,
    };
  }

  if (error is! FirebaseAuthException) {
    return l10n.authErrorUnknown;
  }

  return switch (error.code) {
    'invalid-email' => l10n.authErrorInvalidEmail,
    'invalid-credential' ||
    'user-not-found' ||
    'wrong-password' => l10n.authErrorInvalidCredential,
    'email-already-in-use' => l10n.authErrorEmailAlreadyInUse,
    'weak-password' => l10n.authErrorWeakPassword,
    'user-disabled' => l10n.authErrorUserDisabled,
    'too-many-requests' => l10n.authErrorTooManyRequests,
    'network-request-failed' => l10n.authErrorNetwork,
    'operation-not-allowed' => l10n.authErrorOperationNotAllowed,
    'requires-recent-login' => l10n.authErrorRequiresRecentLogin,
    'keychain-error' => l10n.authErrorKeychain,
    'missing-password' => l10n.authErrorPasswordRequired,
    'unsupported-provider' => l10n.authErrorUnsupportedProvider,
    'popup-closed-by-user' ||
    'web-context-cancelled' ||
    'canceled' => l10n.authErrorCancelled,
    _ => l10n.authErrorUnknown,
  };
}
