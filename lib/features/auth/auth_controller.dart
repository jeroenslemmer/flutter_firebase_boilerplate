import 'package:firebase_auth/firebase_auth.dart';
import '../../core/firebase/auth_service.dart';
import '../../core/models/app_user.dart';
import '../../core/firebase/firestore_service.dart';

class AuthController {
  final AuthService _authService;
  final FirestoreService _firestoreService;

  AuthController(this._authService, this._firestoreService);

  Stream<User?> get authState => _authService.authStateChanges;

  AppUser? get currentUser => _authService.currentAppUser();

  Future<void> signIn(String email, String password) async {
    await _authService.signIn(email, password);
    await _ensureUserProfile();
  }

  Future<void> signUp(
    String email,
    String password, {
    required String languageCode,
  }) async {
    await _authService.signUp(email, password);
    await _ensureUserProfile();
    await _authService.sendEmailVerification(languageCode: languageCode);
  }

  Future<void> signOut() async {
    await _authService.signOut();
  }

  Future<void> signInWithGoogle() async {
    await _authService.signInWithGoogle();
    await _ensureUserProfile();
  }

  Future<void> signInWithApple() async {
    await _authService.signInWithApple();
    await _ensureUserProfile();
  }

  Future<void> sendPasswordResetEmail(
    String email, {
    required String languageCode,
  }) {
    return _authService.sendPasswordResetEmail(
      email,
      languageCode: languageCode,
    );
  }

  Future<String> verifyPasswordResetCode(String code) {
    return _authService.verifyPasswordResetCode(code);
  }

  Future<void> confirmPasswordReset(String code, String newPassword) {
    return _authService.confirmPasswordReset(code, newPassword);
  }

  Future<void> sendEmailVerification({required String languageCode}) {
    return _authService.sendEmailVerification(languageCode: languageCode);
  }

  Future<void> applyEmailAction(String code, String mode) {
    return _authService.applyEmailAction(code, mode);
  }

  Future<void> reloadCurrentUser() {
    return _authService.reloadCurrentUser();
  }

  Future<void> deleteAccount({String? password}) async {
    final appUser = _authService.currentAppUser();
    if (appUser == null) {
      return;
    }

    await _authService.reauthenticate(password: password);
    await _firestoreService.deleteUserProfile(appUser.uid);
    await _authService.deleteCurrentUser();
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await _authService.reauthenticate(password: currentPassword);
    await _authService.updatePassword(newPassword);
  }

  Future<void> _ensureUserProfile() async {
    final appUser = _authService.currentAppUser();
    if (appUser != null) {
      await _firestoreService.createUserIfNeeded(appUser.uid);
    }
  }
}
