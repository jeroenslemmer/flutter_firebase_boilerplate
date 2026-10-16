// import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/login_screen.dart';
import '../../features/auth/email_verification_screen.dart';
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
      path: '/verify-email',
      builder: (context, state) {
        return const EmailVerificationScreen();
      },
    ),
  ],
);
