import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String uid;
  final DateTime? createdAt;
  final DateTime? lastLogin;
  final bool profileComplete;
  final String language;
  final String themeMode;

  UserProfile({
    required this.uid,
    this.createdAt,
    this.lastLogin,
    this.profileComplete = false,
    this.language = 'nl',
    this.themeMode = 'system',
  });

  factory UserProfile.fromFirestore(
  String uid,
  Map<String, dynamic> data,
) {
  return UserProfile(
    uid: uid,
    createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    lastLogin: (data['lastLogin'] as Timestamp?)?.toDate(),
    profileComplete: data['profileComplete'] ?? false,
    language: data['language'] ?? 'nl',
    themeMode: data['themeMode'] ?? 'system',
  );
}
}