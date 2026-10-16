import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/app_user.dart';

class AuthService {
  final Future<void> Function(String uid)? _onSignedIn;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  late final Future<void> _googleInitialization;

  AuthService({Future<void> Function(String uid)? onSignedIn})
    : _onSignedIn = onSignedIn {
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

  Stream<User?> get userChanges => _auth.userChanges();

  Future<UserCredential> signIn(String email, String password) {
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential> signUp(String email, String password) {
    return _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> sendPasswordResetEmail(
    String email, {
    required String languageCode,
  }) async {
    await _auth.setLanguageCode(languageCode);
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> sendEmailVerification({required String languageCode}) async {
    final user = _requireCurrentUser();
    await _auth.setLanguageCode(languageCode);
    await user.sendEmailVerification();
  }

  Future<void> reloadCurrentUser() async {
    await _requireCurrentUser().reload();
  }

  Future<void> signOut() async {
    await _auth.signOut();
    try {
      await _googleInitialization;
      await _googleSignIn.signOut();
    } catch (error) {
      debugPrint('Google sign-out failed: $error');
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    // v7 flow: authentication (not classic signIn-only assumption)
    await _googleInitialization;

    final googleUser = await _googleSignIn.authenticate();

    return _signInWithGoogleUser(googleUser);
  }

  Future<UserCredential> signInWithApple() async {
    final provider = AppleAuthProvider()
      ..addScope('email')
      ..addScope('name');

    if (kIsWeb) {
      return _auth.signInWithPopup(provider);
    }
    return _auth.signInWithProvider(provider);
  }

  Future<void> reauthenticate({String? password}) async {
    final user = _requireCurrentUser();
    final providerIds = user.providerData
        .map((provider) => provider.providerId)
        .toSet();

    if (providerIds.contains(EmailAuthProvider.PROVIDER_ID)) {
      final email = user.email;
      if (email == null || password == null || password.isEmpty) {
        throw FirebaseAuthException(code: 'missing-password');
      }
      final credential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );
      await user.reauthenticateWithCredential(credential);
      return;
    }

    if (providerIds.contains(GoogleAuthProvider.PROVIDER_ID)) {
      if (kIsWeb) {
        await user.reauthenticateWithPopup(GoogleAuthProvider());
        return;
      }
      await _googleInitialization;
      final googleUser = await _googleSignIn.authenticate();
      final googleAuth = googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );
      await user.reauthenticateWithCredential(credential);
      return;
    }

    if (providerIds.contains(AppleAuthProvider.PROVIDER_ID)) {
      final provider = AppleAuthProvider()
        ..addScope('email')
        ..addScope('name');
      if (kIsWeb) {
        await user.reauthenticateWithPopup(provider);
      } else {
        await user.reauthenticateWithProvider(provider);
      }
      return;
    }

    throw FirebaseAuthException(code: 'unsupported-provider');
  }

  Future<void> deleteCurrentUser() async {
    await _requireCurrentUser().delete();
  }

  Future<void> _handleWebGoogleAuthenticationEvent(
    GoogleSignInAuthenticationEvent event,
  ) async {
    try {
      switch (event) {
        case GoogleSignInAuthenticationEventSignIn():
          final credential = await _signInWithGoogleUser(event.user);
          final user = credential.user;
          if (user != null) {
            await _onSignedIn?.call(user.uid);
          }
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

    return _toAppUser(user);
  }

  Stream<AppUser?> get appUserChanges {
    return _auth.userChanges().map((user) {
      if (user == null) {
        return null;
      }

      return _toAppUser(user);
    });
  }

  User _requireCurrentUser() {
    final user = _auth.currentUser;
    if (user == null) {
      throw FirebaseAuthException(code: 'no-current-user');
    }
    return user;
  }

  AppUser _toAppUser(User user) {
    return AppUser(
      uid: user.uid,
      email: user.email,
      displayName: user.displayName,
      photoUrl: user.photoURL,
      emailVerified: user.emailVerified,
      providerIds: user.providerData
          .map((provider) => provider.providerId)
          .toSet()
          .toList(growable: false),
    );
  }
}
