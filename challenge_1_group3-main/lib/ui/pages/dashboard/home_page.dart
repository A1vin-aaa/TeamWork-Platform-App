import 'package:challenge1_group3/models/user_model.dart';
import 'package:challenge1_group3/provider/board_provider.dart';
import 'package:challenge1_group3/provider/user_provider.dart';
import 'package:challenge1_group3/ui/pages/dashboard/account_page.dart';
import 'package:challenge1_group3/ui/pages/dashboard/activity_page.dart';
import 'package:challenge1_group3/ui/pages/dashboard/inbox_page.dart';
import 'package:challenge1_group3/ui/pages/dashboard/list_boards.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final List<Widget> _pages = const [
    ListBoards(),
    InboxPage(),
    ActivityPage(),
    AccountPage(),
  ];

  fetchUserDetails() async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(UserProvider.currentUserId)
        .get();

    if (doc.exists) {
      final data = doc.data()!;
      final fetchedUser = UserModel.fromJson({
        ...data,
        'uid': UserProvider.currentUserId,
      });
      await context.read<UserProvider>().updateUser(fetchedUser);
    }
  }

  fetchUserBoards() async {
    BoardProvider provider = context.read<BoardProvider>();
    provider.fetchBoards();
    provider.fetchActivity();
    provider.fetchInbox();
  }

  @override
  void initState() {
    fetchUserDetails();
    fetchUserBoards();
    super.initState();
  }

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
