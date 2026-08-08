// Temporary web-only POC for the Google Identity Services button.
//
// Run with:
// flutter run -d chrome --web-hostname localhost --web-port 7357 \
//   -t lib/main_google_button_poc.dart
//
// This deliberately bypasses Firebase, Riverpod and AuthService. It verifies
// only that GoogleSignIn finishes initialization before GIS renders its button.

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_sign_in_web/web_only.dart' as web;

const _webClientId =
    '208926840684-k82tvf91d5m5vsephtpgkkfgqcevcj6f.apps.googleusercontent.com';

void main() {
  runApp(const GoogleButtonPocApp());
}

class GoogleButtonPocApp extends StatefulWidget {
  const GoogleButtonPocApp({super.key});

  @override
  State<GoogleButtonPocApp> createState() => _GoogleButtonPocAppState();
}

class _GoogleButtonPocAppState extends State<GoogleButtonPocApp> {
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  late final Future<void> _initialization;

  @override
  void initState() {
    super.initState();
    _initialization = _initializeGoogle();
  }

  Future<void> _initializeGoogle() async {
    await _googleSignIn.initialize(clientId: _webClientId);
    debugPrint('Google Sign-In initialization completed.');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('Google Sign-In button POC')),
        body: Center(
          child: FutureBuilder<void>(
            future: _initialization,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    'Google Sign-In initialisatie mislukt:\n${snapshot.error}',
                    textAlign: TextAlign.center,
                  ),
                );
              }

              if (snapshot.connectionState != ConnectionState.done) {
                return const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Google Sign-In voorbereiden…'),
                  ],
                );
              }

              return web.renderButton();
            },
          ),
        ),
      ),
    );
  }
}
