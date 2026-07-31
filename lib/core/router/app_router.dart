// import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/login_screen.dart';
import '../../features/shell/app_shell.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_refresh_notifier.dart';

final authRefreshNotifier = AuthRefreshNotifier();

final GoRouter appRouter = GoRouter(
  initialLocation: '/home',
  refreshListenable: authRefreshNotifier,
  redirect: (context, state) {

    final loggedIn = FirebaseAuth.instance.currentUser != null;

    final loggingIn = state.matchedLocation == '/login';

    if (!loggedIn && !loggingIn) {
      return '/login';
    }

    if (loggedIn && loggingIn) {
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

  ],
);