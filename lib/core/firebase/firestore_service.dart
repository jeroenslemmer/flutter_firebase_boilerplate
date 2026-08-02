import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_profile.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get users =>
      _db.collection('users');

  Future<void> createUserIfNeeded(String uid) async {
    final ref = users.doc(uid);

    final snapshot = await ref.get();

    if (!snapshot.exists) {
      await ref.set({
        'createdAt': FieldValue.serverTimestamp(),
        'lastLogin': FieldValue.serverTimestamp(),
        'profileComplete': false,
        'language': 'nl',
        'themeMode': 'system',
      });
    } else {
      await ref.update({
        'lastLogin': FieldValue.serverTimestamp(),
      });
    }
  }

  Stream<UserProfile?> userProfile(String uid) {
    return users.doc(uid).snapshots().map((snapshot) {
      if (!snapshot.exists) {
        return null;
      }

      return UserProfile.fromFirestore(
        uid,
        snapshot.data()!,
      );
    });
  }
}