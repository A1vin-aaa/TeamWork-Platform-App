import 'package:challenge1_group3/models/board_column_model.dart';

class BoardModel {
  String id;
  String name;
  String ownerId;

  BoardModel({required this.id,
    required this.name,
    required this.ownerId,});

  factory BoardModel.fromJson(Map<String, dynamic> json) => BoardModel(
        id: json['id'],
        name: json['name'],
        ownerId: json['ownerId'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'ownerId': ownerId,
      };
}
