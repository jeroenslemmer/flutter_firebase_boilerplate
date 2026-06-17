import 'package:firebase_auth/firebase_auth.dart';
import '../../core/firebase/auth_service.dart';

class AuthController {
  final AuthService _authService = AuthService();

  Stream<User?> get authState => _authService.authStateChanges;

  Future<void> signIn(String email, String password) async {
    await _authService.signIn(email, password);
  }

  Future<void> signUp(String email, String password) async {
    await _authService.signUp(email, password);
  }

  Future<void> signOut() async {
    await _authService.signOut();
  }
  Future<void> signInWithGoogle() async {
  await _authService.signInWithGoogle();
}
}

