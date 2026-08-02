import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/firebase/auth_service.dart';
import 'auth_controller.dart';
import '../../core/models/app_user.dart';  
import '../../core/router/router_refresh_notifier.dart';
import '../../core/firebase/firestore_service.dart';


final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

final authControllerProvider = Provider<AuthController>((ref) {
  return AuthController(
    ref.read(authServiceProvider),
    ref.read(firestoreServiceProvider),
  );
});

final authStateProvider = StreamProvider<AppUser?>((ref) {
  return ref.read(authServiceProvider).appUserChanges;
});

final routerRefreshProvider = Provider<RouterRefreshNotifier>((ref) {
  return RouterRefreshNotifier(ref);
});

final firestoreServiceProvider = Provider<FirestoreService>((ref) {
  return FirestoreService();
});