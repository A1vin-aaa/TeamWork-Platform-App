import 'package:challenge1_group3/models/board_column_model.dart';

class BoardModel {
  String id;
  String name;
  DateTime createdAt;

  BoardModel({required this.id, required this.createdAt, required this.name});

  factory BoardModel.fromJson(Map<String, dynamic> json) => BoardModel(
        id: json['id'],
        name: json['name'],
        createdAt: json['created_at'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'created_at': createdAt,
      };
}
