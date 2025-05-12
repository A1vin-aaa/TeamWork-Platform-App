// lib/ui/pages/board_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:challenge1_group3/models/board_column_model.dart';
import 'package:challenge1_group3/models/task_card_model.dart';
import 'package:challenge1_group3/provider/board_provider.dart';
import 'package:challenge1_group3/ui/widgets/task_card.dart';

class BoardPage extends StatefulWidget {
  final String boardId;

  const BoardPage({Key? key, required this.boardId}) : super(key: key);

  @override
  State<BoardPage> createState() => _BoardPageState();
}

class _BoardPageState extends State<BoardPage> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BoardProvider>();
    final board = provider.getBoardById(widget.boardId)!;
    var columns = provider.getColumns(widget.boardId);

    // Ensure default columns exist just once
    if (columns.isEmpty) {
      provider.addColumn(
          widget.boardId, BoardColumnModel(id: 'todo', title: 'To Do'));
      provider.addColumn(
          widget.boardId, BoardColumnModel(id: 'doing', title: 'Doing'));
      provider.addColumn(
          widget.boardId, BoardColumnModel(id: 'done', title: 'Done'));
      columns = provider.getColumns(widget.boardId);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("${board.name}"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search tasks...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (q) => setState(() => _searchQuery = q.trim().toLowerCase()),
            ),
          ),
        ),
      ),

      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Existing columns
            for (final column in columns)
              _buildColumn(context, provider, column),
            // Add‐column button
            _buildAddColumnButton(context, provider),
          ],
        ),
      ),
    );
  }

  Widget _buildColumn(
      BuildContext context,
      BoardProvider provider,
      BoardColumnModel column,
      ) {
    // Filter cards by search query
    final tasks = _searchQuery.isEmpty
        ? column.cards
        : column.cards.where((t) {
      return t.title.toLowerCase().contains(_searchQuery) ||
          t.description.toLowerCase().contains(_searchQuery);
    }).toList();

    return DragTarget<Map<String, dynamic>>(
      onAcceptWithDetails: (receivedTask) {
        provider.moveCard(
          boardId: widget.boardId,
          fromColumnId: receivedTask.data['columnId'],
          toColumnId: column.id,
          task: receivedTask.data['task'],
        );
      },
      builder: (_, candidateData, __) => Container(
        width: 260,
        margin: const EdgeInsets.only(right: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(column.title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),

            if (candidateData.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(8),
                color: Colors.blue.withOpacity(0.1),
                child: const Text('Release to move here'),
              ),

            // Render filtered tasks
            for (final task in tasks)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: TaskTile(
                  task: task,
                  data: {'task': task, 'columnId': column.id},
                  onComplete: () {
                    provider.toggleCardDone(
                      widget.boardId,
                      column.id,
                      task.id,
                    );
                  },
                  showDetail: () => _showCardDetails(
                    context: context,
                    provider: provider,
                    columnId: column.id,
                    task: task,
                  ),
                ),
              ),

            const Spacer(),

            // Add‐task button
            InkWell(
              onTap: () => _addTask(context, provider, column.id),
              child: Row(
                children: const [
                  Icon(Icons.add, size: 20),
                  SizedBox(width: 8),
                  Text('Add New Card', style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddColumnButton(BuildContext context, BoardProvider provider) {
    final ctrl = TextEditingController();
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('New Column'),
            content: TextField(
              controller: ctrl,
              decoration: const InputDecoration(hintText: 'Column name'),
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel')),
              ElevatedButton(
                onPressed: () {
                  final name = ctrl.text.trim();
                  if (name.isNotEmpty) {
                    provider.addColumn(
                        widget.boardId,
                        BoardColumnModel(
                            id: DateTime.now().millisecondsSinceEpoch.toString(),
                            title: name));
                  }
                  Navigator.pop(context);
                },
                child: const Text('Add'),
              ),
            ],
          ),
        );
      },
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.add, size: 30),
      ),
    );
  }

  void _addTask(BuildContext context, BoardProvider provider, String columnId) {
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('New Task'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleCtrl, decoration: const InputDecoration(hintText: 'Title')),
            const SizedBox(height: 8),
            TextField(
              controller: descCtrl,
              decoration: const InputDecoration(hintText: 'Description'),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final title = titleCtrl.text.trim();
              final desc = descCtrl.text.trim();
              if (title.isNotEmpty) {
                provider.addCard(
                  widget.boardId,
                  columnId,
                  TaskCardModel(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    title: title,
                    description: desc,
                    isDone: false,
                    createdAt: DateTime.now(),
                  ),
                );
              }
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showCardDetails({
    required BuildContext context,
    required BoardProvider provider,
    required String columnId,
    required TaskCardModel task,
  }) {
    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: const Text('Task Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(task.title, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              if (task.description.isNotEmpty) Text(task.description),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text('Completed:'),
                  const SizedBox(width: 8),
                  Checkbox(
                    value: task.isDone,
                    onChanged: (v) {
                      provider.toggleCardDone(
                        widget.boardId,
                        columnId,
                        task.id,
                      );
                      setState(() {}); // refresh dialog
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text('Created: ${task.createdAt.toLocal().toIso8601String().split('T').first}'),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
          ],
        ),
      ),
    );
  }
}
