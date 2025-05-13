import 'package:challenge1_group3/models/board_model.dart';
import 'package:challenge1_group3/models/inbox_model.dart';
import 'package:challenge1_group3/models/task_card_model.dart';
import 'package:challenge1_group3/provider/board_provider.dart';
import 'package:challenge1_group3/styling/text_styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void addUserToBoard(BuildContext context, BoardModel board) async {
  final selectedUser = await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        titlePadding: EdgeInsets.all(12),
        contentPadding: EdgeInsets.all(12),
        actionsPadding: EdgeInsets.all(12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        backgroundColor: Colors.white,
        title: Text(
          'Add User To board',
          style: CustomTextStyle.title14SemiBold,
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection("users").snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Center(child: CircularProgressIndicator());

              final users = snapshot.data!.docs;

              return ListView.builder(
                shrinkWrap: true,
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  final userId = user.id;
                  final fullName = user['full_name'] ?? 'Unnamed';
                  final email = user['email'] ?? 'No email';

                  return ListTile(
                    title: Text(fullName),
                    subtitle: Text(email),
                    onTap: () => Navigator.pop(context, {
                      'id': userId,
                      'name': fullName,
                    }),
                  );
                },
              );
            },
          ),
        ),
      );
    },
  );

  if (selectedUser == null) return;
  if (board.members.contains(selectedUser['id'])) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('User Already assigned to this card')),
    );
    return;
  }

  board = boardProvider.getBoardById(board.id) ?? board;
  if (selectedUser != null && !board.members.contains(selectedUser['id'])) {
    final updatedBoard = board.copyWith(
      members: [...board.members, selectedUser['id']],
    );

    Provider.of<BoardProvider>(context, listen: false).addInboxActivity(InboxModel(
        messageId: '',
        content:
            "You have been added to ${board.name} by ${userProvider.currentUser!.fullName}",
        sentAt: DateTime.now(),
        sender: userProvider.currentUser!.uid,
        receiverId: selectedUser['id'],
        isRead: false));
    Provider.of<BoardProvider>(context, listen: false)
        .updateBoard(updatedBoard);
  }
}
