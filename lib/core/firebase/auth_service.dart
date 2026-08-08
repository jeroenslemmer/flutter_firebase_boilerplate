import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/app_user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  late final Future<void> _googleInitialization;

  AuthService() {
    _googleInitialization = _initGoogle();
  }

Future<void> _initGoogle() async {
  if (kIsWeb) {
    await _googleSignIn.initialize(
      clientId:
          '208926840684-k82tvf91d5m5vsephtpgkkfgqcevcj6f.apps.googleusercontent.com',
    );
  } else {
    await _googleSignIn.initialize();
  }

  if (kIsWeb) {
    _googleSignIn.authenticationEvents.listen(
      _handleWebGoogleAuthenticationEvent,
      onError: (Object error, StackTrace stackTrace) {
        debugPrint('Google web authentication error: $error');
      },
    );
  }
}

  /// Completes when the singleton Google Sign-In instance is ready to use.
  Future<void> get googleInitialization => _googleInitialization;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<UserCredential> signIn(String email, String password) {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential> signUp(String email, String password) {
    return _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<UserCredential> signInWithGoogle() async {
    // v7 flow: authentication (not classic signIn-only assumption)
    await _googleInitialization;

    final googleUser = await _googleSignIn.authenticate();

    return _signInWithGoogleUser(googleUser);
  }

  Future<void> _handleWebGoogleAuthenticationEvent(
    GoogleSignInAuthenticationEvent event,
  ) async {
    try {
      switch (event) {
        case GoogleSignInAuthenticationEventSignIn():
          await _signInWithGoogleUser(event.user);
        case GoogleSignInAuthenticationEventSignOut():
          await _auth.signOut();
      }
    } catch (error) {
      debugPrint('Firebase sign-in with Google failed: $error');
    }
  }

  Future<UserCredential> _signInWithGoogleUser(
    GoogleSignInAccount googleUser,
  ) async {
    final googleAuth = googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );

    return await _auth.signInWithCredential(credential);
  }

  AppUser? currentAppUser() {
    final user = _auth.currentUser;

    if (user == null) {
      return null;
    }

    return AppUser(
      uid: user.uid,
      email: user.email,
      displayName: user.displayName,
      photoUrl: user.photoURL,
    );
  }

  Stream<AppUser?> get appUserChanges {
    return _auth.authStateChanges().map((user) {
      if (user == null) {
        return null;
      }

      return AppUser(
        uid: user.uid,
        email: user.email,
        displayName: user.displayName,
        photoUrl: user.photoURL,
      );
    });
  }
}
