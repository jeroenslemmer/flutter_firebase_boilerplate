import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRefreshNotifier extends ChangeNotifier {
  late final StreamSubscription<User?> _subscription;

  AuthRefreshNotifier() {
    _subscription =
        FirebaseAuth.instance.authStateChanges().listen((_) {
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}