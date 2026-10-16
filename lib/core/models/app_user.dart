class AppUser {
  final String uid;
  final String? email;
  final String? displayName;
  final String? photoUrl;
  final bool emailVerified;
  final List<String> providerIds;

  const AppUser({
    required this.uid,
    this.email,
    this.displayName,
    this.photoUrl,
    this.emailVerified = false,
    this.providerIds = const [],
  });

  bool get usesPassword => providerIds.contains('password');

  bool get requiresEmailVerification => usesPassword && !emailVerified;
}
