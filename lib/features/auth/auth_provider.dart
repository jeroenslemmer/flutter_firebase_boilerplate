import 'package:flutter_riverpod/flutter_riverpod.dart';
//import 'package:firebase_auth/firebase_auth.dart';

import '../../core/firebase/auth_service.dart';
import 'auth_controller.dart';
import '../../core/models/app_user.dart';  


final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

final authControllerProvider = Provider<AuthController>((ref) {
  return AuthController(ref.read(authServiceProvider));
});

final authStateProvider = StreamProvider<AppUser?>((ref) {
  return ref.read(authServiceProvider).appUserChanges;
});