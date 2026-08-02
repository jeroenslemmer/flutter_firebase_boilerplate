import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/app_user.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> createUserIfNeeded(AppUser user) async {
    final ref = _db.collection('users').doc(user.uid);

    final snapshot = await ref.get();

    if (!snapshot.exists) {
      await ref.set({
        'email': user.email,
        'displayName': user.displayName,
        'photoUrl': user.photoUrl,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }
}