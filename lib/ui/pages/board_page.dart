import 'package:challenge1_group3/models/board_column_model.dart';
import 'package:challenge1_group3/models/task_card_model.dart';
import 'package:challenge1_group3/provider/board_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BoardPage extends StatelessWidget {
  final String boardId;

  const BoardPage({super.key, required this.boardId});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BoardProvider>(context);
    final columns = provider.getColumns(boardId);

    // Initialize default columns if none exist
    if (columns.isEmpty) {
      provider.addColumn(boardId, BoardColumnModel(id: 'todo', title: 'To Do'));
      provider.addColumn(
          boardId, BoardColumnModel(id: 'doing', title: 'Doing'));
      provider.addColumn(boardId, BoardColumnModel(id: 'done', title: 'Done'));
    }

    final updatedColumns = provider.getColumns(boardId);

    return Scaffold(
      appBar: AppBar(title: const Text('Board')),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ...updatedColumns.map((column) {
              return _buildColumn(context, provider, column);
            }),
            _buildAddColumnButton(context, provider),
          ],
        ),
      ),
    );
  }

  Widget _buildColumn(
      BuildContext context, BoardProvider provider, BoardColumnModel column) {
    return Container(
      width: 260,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(column.title,
              style:
              const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...column.cards.map((card) => Card(
            child: ListTile(
              title: Text(card.title),
              subtitle: Text(card.description),
            ),
          )),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: () => _addTask(context, provider, column.id),
            icon: const Icon(Icons.add),
            label: const Text('Add Card'),
          ),
        ],
      ),
    );
  }

  Widget _buildAddColumnButton(BuildContext context, BoardProvider provider) {
    final nameController = TextEditingController();
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('New Column'),
            content: TextField(
              controller: nameController,
              decoration: const InputDecoration(hintText: 'Column name'),
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel')),
              ElevatedButton(
                onPressed: () {
                  final name = nameController.text.trim();
                  if (name.isNotEmpty) {
                    final newCol = BoardColumnModel(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      title: name,
                      cards: [],
                    );
                    provider.addColumn(boardId, newCol);
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
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey),
        ),
        child: const Center(child: Icon(Icons.add, size: 30)),
      ),
    );
  }

  void _addTask(BuildContext context, BoardProvider provider, String columnId) {
    final titleController = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('New Task'),
        content: TextField(
          controller: titleController,
          decoration: const InputDecoration(hintText: 'Task title'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final title = titleController.text.trim();
              if (title.isNotEmpty) {
                final card = TaskCardModel(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  title: title,
                  description: '',
                );
                provider.addCard(boardId, columnId, card);
              }
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
