class TaskCardModel {
  final String id;
  final String title;
  final String description;
  final String boardId;
  final String columnId;
  final bool isDone;
  final DateTime createdAt;
  final List<String> assignedUser;
  final List<String> receiver;

  TaskCardModel({
    required this.id,
    required this.title,
    required this.description,
    required this.boardId,
    required this.columnId,
    required this.isDone,
    required this.createdAt,
    required this.assignedUser,
    required this.receiver,
  });

  factory TaskCardModel.fromJson(Map<String, dynamic> json) {
    return TaskCardModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      boardId: json['boardId'] ?? '',
      columnId: json['columnId'] ?? '',
      isDone: json['isDone'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      assignedUser: List<String>.from(json['assignedUser'] ?? []),
      receiver: List<String>.from(json['receiver'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'columnId': columnId,
      'boardId': boardId,
      'description': description,
      'isDone': isDone,
      'createdAt': createdAt.toIso8601String(),
      'assignedUser': assignedUser,
      'receiver': receiver,
    };
  }

  TaskCardModel copyWith({
    String? id,
    String? title,
    String? description,
    String? boardId,
    String? columnId,
    bool? isDone,
    DateTime? createdAt,
    List<String>? assignedUser,
    List<String>? receiver,
  }) {
    return TaskCardModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      boardId: boardId ?? this.boardId,
      columnId: columnId ?? this.columnId,
      isDone: isDone ?? this.isDone,
      createdAt: createdAt ?? this.createdAt,
      assignedUser: assignedUser ?? this.assignedUser,
      receiver: receiver ?? this.receiver,
    );
  }
}
