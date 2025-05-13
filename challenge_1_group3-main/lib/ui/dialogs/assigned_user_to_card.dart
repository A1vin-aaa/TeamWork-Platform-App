import 'package:challenge1_group3/models/inbox_model.dart';
import 'package:challenge1_group3/models/task_card_model.dart';
import 'package:challenge1_group3/provider/board_provider.dart';
import 'package:challenge1_group3/styling/text_styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void assignedUser(BuildContext context, String boardId, String columnId,
    TaskCardModel task) async {
  List<String> members = Provider.of<BoardProvider>(context, listen: false)
      .getBoardMembers(boardId);
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
          'Assign User',
          style: CustomTextStyle.title14SemiBold,
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: members.length,
            itemBuilder: (context, index) {
              final user = members[index];
              return StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("users")
                      .doc(user)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.data == null) return SizedBox();
                    return ListTile(
                      title: Text(snapshot.requireData.get('full_name')),
                      subtitle: Text(snapshot.requireData.get('email')),
                      onTap: () => Navigator.pop(context, {
                        'id': user,
                        'name': snapshot.requireData.get('full_name')
                      }),
                    );
                  });
            },
          ),
        ),
      );
    },
  );
  if (selectedUser == null) return;
  if (task.receiver.contains(selectedUser['id'])) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('User Already assigned to this card')),
    );
    return;
  }

  if (selectedUser != null && !task.receiver.contains(selectedUser['id'])) {
    final updatedTask = task.copyWith(
      assignedUser: [...task.assignedUser, selectedUser['name']],
      receiver: [...task.receiver, selectedUser['id']],
    );

    Provider.of<BoardProvider>(context, listen: false).addInboxActivity(InboxModel(
        messageId: '',
        content:
            "You have been assigned to ${task.title} by ${userProvider.currentUser!.fullName}",
        sentAt: DateTime.now(),
        sender: userProvider.currentUser!.uid,
        receiverId: selectedUser['id'],
        isRead: false));
    Provider.of<BoardProvider>(context, listen: false).updateCard(
      boardId,
      columnId,
      updatedTask,
    );
    Navigator.pop(context);
  }
}
