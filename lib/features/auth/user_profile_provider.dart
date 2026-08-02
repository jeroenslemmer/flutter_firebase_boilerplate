import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/models/user_profile.dart';
import 'auth_provider.dart';

final userProfileProvider =
    StreamProvider<UserProfile?>((ref) {

  final authUser = ref.watch(authStateProvider).value;

  if (authUser == null) {
    return Stream.value(null);
  }

  return ref
      .read(firestoreServiceProvider)
      .userProfile(authUser.uid);
});