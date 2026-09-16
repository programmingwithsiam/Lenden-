class AppUserModel {
  final String uid;
  final String name;
  final String email;
  final String photoUrl;
  final int createdAt;

  const AppUserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.photoUrl = '',
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'createdAt': createdAt,
    };
  }

  factory AppUserModel.fromMap(Map<dynamic, dynamic> map) {
    return AppUserModel(
      uid: map['uid']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      email: map['email']?.toString() ?? '',
      photoUrl: map['photoUrl']?.toString() ?? '',
      createdAt: (map['createdAt'] as num?)?.toInt() ?? 0,
    );
  }
}
