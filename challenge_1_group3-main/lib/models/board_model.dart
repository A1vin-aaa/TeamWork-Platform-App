import 'package:cloud_firestore/cloud_firestore.dart';

class BoardModel {
  final String id;
  final String name;
  final List<String> members;
  final DateTime createdAt;

  BoardModel({
    required this.id,
    required this.name,
    required this.members,
    required this.createdAt,
  });

  factory BoardModel.fromSnapshot(DocumentSnapshot snap) {
    final data = {
      ...snap.data() as Map<String, dynamic>,
      'id': snap.id,
    };
    return BoardModel.fromJson(data);
  }

  factory BoardModel.fromJson(Map<String, dynamic> json) {
    return BoardModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      members: List<String>.from(json['members'] ?? []),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'members': members,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  BoardModel copyWith({
    String? id,
    String? name,
    List<String>? members,
    DateTime? createdAt,
  }) {
    return BoardModel(
      id: id ?? this.id,
      name: name ?? this.name,
      members: members ?? this.members,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
