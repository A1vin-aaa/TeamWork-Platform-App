class TaskCardModel {
  final String id;
  final String title;
  final String description;
  final bool isDone;
  final DateTime createdAt;

  TaskCardModel(
      {required this.id,
      required this.title,
      this.description = '',
      required this.isDone,
      required this.createdAt});

  factory TaskCardModel.fromJson(Map<String, dynamic> json) => TaskCardModel(
        id: json['id'],
        title: json['title'],
        description: json['description'] ?? '',
        isDone: json['isDone'] ?? false,
        createdAt: json['createdAt'] ?? DateTime.now(),
      );
  TaskCardModel copyWith({
    String? id,
    String? title,
    String? description,
    bool? isDone,
    DateTime? createdAt,
  }) {
    return TaskCardModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isDone: isDone ?? this.isDone,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'createdAt': createdAt,
      };
}
