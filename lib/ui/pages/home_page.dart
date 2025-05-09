// lib/ui/pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:challenge1_group3/provider/board_provider.dart';
import 'package:challenge1_group3/ui/pages/board_page.dart';
import 'package:challenge1_group3/ui/pages/inbox_page.dart';
import 'package:challenge1_group3/ui/pages/activity_page.dart';
import 'package:challenge1_group3/ui/pages/account_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final List<Widget> _pages = const [
    BoardPagePlaceholder(),
    InboxPage(),
    ActivityPage(),
    AccountPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Boards',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inbox),
            label: 'Inbox',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Activity',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Account',
          ),
        ],
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}

// Placeholder to wrap existing BoardPage and pass boardProvider data
class BoardPagePlaceholder extends StatelessWidget {
  const BoardPagePlaceholder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final boardProvider = Provider.of<BoardProvider>(context);
    final boards = boardProvider.boards;
    return Scaffold(
      appBar: AppBar(title: const Text('Boards')),
      body: boards.isEmpty
          ? const Center(child: Text('No boards found. Add one!'))
          : ListView.builder(
        itemCount: boards.length,
        itemBuilder: (context, index) {
          final board = boards[index];
          return ListTile(
            title: Text(board.name),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BoardPage(boardId: board.id),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateBoardDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showCreateBoardDialog(BuildContext context) {
    final nameController = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Create Board'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(hintText: 'Board name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final name = nameController.text.trim();
              if (name.isNotEmpty) {
                final id = DateTime.now().millisecondsSinceEpoch.toString();
                final board = Provider.of<BoardProvider>(context, listen: false)
                    .addBoardWithName(id, name);
              }
              Navigator.pop(context);
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}
