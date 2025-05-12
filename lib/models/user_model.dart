class UserModel {
  final String uid;
  final String fullName;
  final String email;
  final String? profilePic;

  UserModel({
    required this.uid,
    required this.fullName,
    required this.email,
    this.profilePic,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] ?? '',
      fullName: json['full_name'] ?? '',
      email: json['email'] ?? '',
      profilePic: json['profile_pic'],
    );
  }

  // Convert to JSON (e.g., for uploading to server)
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'full_name': fullName,
      'email': email,
      'profile_pic': profilePic,
    };
  }

  UserModel copyWith({
    String? uid,
    String? fullName,
    String? profilePic,
    String? email,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      fullName: fullName ?? this.fullName,
      profilePic: profilePic ?? this.profilePic,
      email: email ?? this.email,
    );
  }
}
