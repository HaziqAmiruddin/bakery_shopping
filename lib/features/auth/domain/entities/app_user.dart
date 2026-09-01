class AppUser {
  final String uid;
  final String email;
  final String name;
  final String? photoUrl;

  AppUser({
    required this.uid,
    required this.email,
    required this.name,
    this.photoUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'photoUrl': photoUrl ?? '',
    };
  }

  factory AppUser.fromJson(Map<String, dynamic> jsonUser) {
    return AppUser(
      uid: jsonUser['uid'],
      email: jsonUser['email'],
      name: jsonUser['name'],
      photoUrl: (jsonUser['photoUrl'] as String?)?.isNotEmpty == true
          ? jsonUser['photoUrl'] as String
          : null,
    );
  }

  AppUser copyWith({String? name, String? photoUrl}) {
    return AppUser(
      uid: uid,
      email: email,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }
}
