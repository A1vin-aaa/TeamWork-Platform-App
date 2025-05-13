class BoardColumnModel {
  String id;
  String boardId;
  String title;

  BoardColumnModel(
      {required this.id, required this.title, required this.boardId});

  factory BoardColumnModel.fromJson(Map<String, dynamic> json) =>
      BoardColumnModel(
        id: json['id'],
        title: json['title'],
        boardId: json['board_id'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'board_id': boardId,
      };
}
