// lib/ui/pages/activity_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:challenge1_group3/provider/board_provider.dart';
import 'package:challenge1_group3/models/task_card_model.dart';

class ActivityPage extends StatelessWidget {
  const ActivityPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BoardProvider>();
    final boards = provider.boards;

    // Flatten all tasks across each board's columns
    final List<_Activity> activities = boards.expand((board) {
      final columns = provider.getColumns(board.id);
      return columns.expand((col) => col.cards.map((task) {
        return _Activity(
          boardName: board.name,
          columnTitle: col.title,
          task: task,
        );
      }));
    }).toList()
    // Sort by creation time, newest first
      ..sort((a, b) => b.task.createdAt.compareTo(a.task.createdAt));

    return Scaffold(
      appBar: AppBar(title: const Text('Activity')),
      body: activities.isEmpty
          ? const Center(child: Text('No recent activity.'))
          : ListView.builder(
        itemCount: activities.length,
        itemBuilder: (ctx, i) {
          final act = activities[i];
          final created = act.task.createdAt.toLocal();
          final dateStr = "${created.year}-${created.month.toString().padLeft(2,'0')}-${created.day.toString().padLeft(2,'0')}";
          final timeStr = "${created.hour.toString().padLeft(2,'0')}:${created.minute.toString().padLeft(2,'0')}";

          return ListTile(
            title: Text(act.task.title),
            subtitle: Text("${act.boardName} • ${act.columnTitle}"),
            trailing: Text("$dateStr $timeStr",
                style: const TextStyle(fontSize: 12, color: Colors.grey)),
          );
        },
      ),
    );
  }
}

/// Helper model to represent a single activity entry
class _Activity {
  final String boardName;
  final String columnTitle;
  final TaskCardModel task;

  _Activity({
    required this.boardName,
    required this.columnTitle,
    required this.task,
  });
}
