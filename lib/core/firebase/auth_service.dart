import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/app_user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  AuthService() {
    _initGoogle();
  }

  Future<void> _initGoogle() async {
    await _googleSignIn.initialize();
  }

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<UserCredential> signIn(String email, String password) {
    return _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
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
  final googleUser = await _googleSignIn.authenticate();

  final googleAuth =  googleUser.authentication;

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


