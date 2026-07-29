import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/firebase/auth_service.dart';
import 'auth_controller.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

final authControllerProvider = Provider<AuthController>((ref) {
  return AuthController(ref.read(authServiceProvider));
});