class TaskCardModel {
  String id;
  String title;
  String description;

  TaskCardModel({required this.id, required this.title, this.description = ''});

  factory TaskCardModel.fromJson(Map<String, dynamic> json) => TaskCardModel(
        id: json['id'],
        title: json['title'],
        description: json['description'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
      };
}
