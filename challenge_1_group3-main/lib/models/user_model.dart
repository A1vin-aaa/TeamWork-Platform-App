class UserModel {
  final String uid;
  final String fullName;
  final String email;

  UserModel({
    required this.uid,
    required this.fullName,
    required this.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] ?? '',
      fullName: json['full_name'] ?? '',
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'full_name': fullName,
      'email': email,
    };
  }

  UserModel copyWith({
    String? uid,
    String? fullName,
    String? email,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
    );
  }
}
