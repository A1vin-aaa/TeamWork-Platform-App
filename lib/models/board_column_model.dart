import 'package:challenge1_group3/models/task_card_model.dart';

class BoardColumnModel {
  String id;
  String title;
  List<TaskCardModel> cards;

  BoardColumnModel(
      {required this.id, required this.title, this.cards = const []});

  factory BoardColumnModel.fromJson(Map<String, dynamic> json) =>
      BoardColumnModel(
        id: json['id'],
        title: json['title'],
        cards: (json['cards'] as List)
            .map((e) => TaskCardModel.fromJson(e))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'cards': cards.map((e) => e.toJson()).toList(),
      };
}
