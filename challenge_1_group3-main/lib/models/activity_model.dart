class Activity {
  final String boardName;
  final String action;
  final DateTime createdAt;
  final List<String> receivedBy;

  Activity({
    required this.boardName,
    required this.action,
    required this.createdAt,
    required this.receivedBy,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      boardName: json['boardName'],
      action: json['action'],
      createdAt: DateTime.parse(json['createdAt']),
      receivedBy: List<String>.from(json['receivedBy']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'boardName': boardName,
      'action': action,
      'createdAt': createdAt.toIso8601String(),
      'receivedBy': receivedBy,
    };
  }
}
