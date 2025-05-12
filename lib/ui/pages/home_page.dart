import 'package:challenge1_group3/models/board_model.dart';
import 'package:challenge1_group3/provider/board_provider.dart';
import 'package:challenge1_group3/ui/pages/account_page.dart';
import 'package:challenge1_group3/ui/pages/activity_page.dart';
import 'package:challenge1_group3/ui/pages/board_page.dart';
import 'package:challenge1_group3/ui/pages/inbox_page.dart';
import 'package:challenge1_group3/ui/widgets/board_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final List<Widget> _pages = const [
    BoardCardsView(),
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

class BoardCardsView extends StatelessWidget {
  const BoardCardsView({super.key});

  @override
  Widget build(BuildContext context) {
    final boardProvider = Provider.of<BoardProvider>(context);
    final boards = boardProvider.boards;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Boards'),
      ),
      body: boards.isEmpty
          ? const Center(child: Text('No boards found. Add one!'))
          : ListView.builder(
              itemCount: boards.length,
              itemBuilder: (context, index) {
                final board = boards[index];
                return BoardTile(
                  board: board,
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => BoardPage(boardId: board.id)));
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCreateBoardDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showCreateBoardDialog(BuildContext context) {
    final nameController = TextEditingController();
    GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              backgroundColor: Colors.white,
              title: const Text('Create Board'),
              content: Form(
                key: _formKey,
                child: TextFormField(
                  validator: (v) {
                    if (v!.isEmpty) return "Please enter board name";
                    return null;
                  },
                  controller: nameController,
                  decoration: const InputDecoration(hintText: 'Board name', border: OutlineInputBorder()),
                ),
              ),
              actions: [
                MaterialButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                MaterialButton(
                  color: Colors.green,
                  onPressed: () {
                    if (!_formKey.currentState!.validate()) return;
                    final name = nameController.text.trim();
                    if (name.isNotEmpty) {
                      final id = DateTime.now().millisecondsSinceEpoch.toString();
                      final board = BoardModel(
                        id: id,
                        name: name,
                        createdAt: DateTime.now(),
                      );
                      Provider.of<BoardProvider>(context, listen: false).addBoard(board);
                    }
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Create',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ));
  }
}
