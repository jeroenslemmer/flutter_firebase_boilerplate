import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/login_screen.dart';
import '../../features/auth/email_verification_screen.dart';
import '../../features/auth/email_action_screen.dart';
import '../../features/shell/app_shell.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_refresh_notifier.dart';

final authRefreshNotifier = AuthRefreshNotifier();

final GoRouter appRouter = GoRouter(
  initialLocation: '/home',
  refreshListenable: authRefreshNotifier,
  redirect: (context, state) {
    final user = FirebaseAuth.instance.currentUser;
    final loggedIn = user != null;
    final usesPassword =
        user?.providerData.any(
          (provider) => provider.providerId == 'password',
        ) ??
        false;
    final requiresVerification =
        loggedIn && usesPassword && !user.emailVerified;

    final loggingIn = state.matchedLocation == '/login';
    final verifyingEmail = state.matchedLocation == '/verify-email';
    final handlingEmailAction = state.matchedLocation == '/auth/action';

    if (handlingEmailAction) {
      return null;
    }

    if (!loggedIn && !loggingIn) {
      return '/login';
    }

    if (requiresVerification && !verifyingEmail) {
      return '/verify-email';
    }

    if (loggedIn && !requiresVerification && (loggingIn || verifyingEmail)) {
      return '/home';
    }

    return null;
  },
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) {
        return const LoginScreen();
      },
    ),

    GoRoute(
      path: '/home',
      builder: (context, state) {
        return const AppShell();
      },
    ),

    GoRoute(
      path: '/auth/action',
      builder: (context, state) {
        final language = state.uri.queryParameters['lang']?.split('-').first;
        final locale = AppLocalizations.supportedLocales
            .where((locale) => locale.languageCode == language)
            .firstOrNull;
        return Localizations.override(
          context: context,
          locale: locale,
          child: EmailActionScreen(
            mode: state.uri.queryParameters['mode'],
            actionCode: state.uri.queryParameters['oobCode'],
          ),
        );
      },
    ),

    GoRoute(
      path: '/verify-email',
      builder: (context, state) {
        return const EmailVerificationScreen();
      },
    ),
  ],
);
