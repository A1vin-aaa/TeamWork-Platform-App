import 'package:challenge1_group3/models/board_column_model.dart';
import 'package:challenge1_group3/models/board_model.dart';
import 'package:challenge1_group3/models/inbox_model.dart';
import 'package:challenge1_group3/models/task_card_model.dart';
import 'package:challenge1_group3/provider/board_provider.dart';
import 'package:challenge1_group3/styling/custom_theme.dart';
import 'package:challenge1_group3/styling/text_styles.dart';
import 'package:challenge1_group3/ui/dialogs/add_card.dart';
import 'package:challenge1_group3/ui/dialogs/add_user_board.dart';
import 'package:challenge1_group3/ui/dialogs/assigned_user_to_card.dart';
import 'package:challenge1_group3/ui/dialogs/new_column.dart';
import 'package:challenge1_group3/ui/widgets/custom_textfied.dart';
import 'package:challenge1_group3/ui/widgets/square_button.dart';
import 'package:challenge1_group3/ui/widgets/task_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BoardDetailPage extends StatefulWidget {
  final BoardModel board;

  const BoardDetailPage({super.key, required this.board});

  @override
  State<BoardDetailPage> createState() => _BoardDetailPageState();
}

class _BoardDetailPageState extends State<BoardDetailPage> {
  String _searchQuery = '';

  State<BoardDetailPage> createState() => _BoardDetailPageState();

  @override
  void initState() {
    Provider.of<BoardProvider>(context, listen: false)
        .fetchColumns(widget.board.id);
    Provider.of<BoardProvider>(context, listen: false)
        .fetchCards(widget.board.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BoardProvider>(context);
    final updatedColumns = provider.getColumns(widget.board.id);
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 70,
        leading: SquareButton(
          icon: Icons.keyboard_backspace,
          bgColor: CustomTheme.white,
          contentColor: CustomTheme.black,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        automaticallyImplyLeading: false,
        surfaceTintColor: Colors.transparent,
        backgroundColor: CustomTheme.white,
        centerTitle: true,
        title: Text(widget.board.name, style: CustomTextStyle.title16SemiBold),
        actions: [
          SquareButton(
            icon: Icons.add,
            bgColor: CustomTheme.white,
            contentColor: CustomTheme.black,
            onPressed: () {
              addUserToBoard(context, widget.board);
            },
          ),
          SizedBox(width: 16)
        ],
      ),
      body: Column(
        children: [
          Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: CustomTextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.trim().toLowerCase();
                });
              },
              hintText: 'Search Card',
            ),
          ),
          Divider(height: 1),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(12),
              scrollDirection: Axis.horizontal,
              children: [
                ...updatedColumns.map((column) {
                  return _buildColumn(context, provider, column);
                }),
                _buildAddColumnButton(context, provider),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColumn(
      BuildContext context, BoardProvider provider, BoardColumnModel column) {
    final filteredCards = _searchQuery.isEmpty
        ? provider
            .getCardsByBoard(widget.board.id)
            .where((e) => e.columnId == column.id)
            .toList()
        : provider
            .getCardsByBoard(widget.board.id)
            .where((e) => e.columnId == column.id)
            .where((card) {
            return card.title.toLowerCase().contains(_searchQuery) ||
                (card.description.toLowerCase()).contains(_searchQuery);
          }).toList();

    return DragTarget<Map<String, dynamic>>(
      onAcceptWithDetails: (receivedTask) {
        setState(() {
          provider.moveCard(
            boardId: widget.board.id,
            fromColumnId: receivedTask.data['columnId'],
            toColumnId: column.id,
            task: receivedTask.data['task'],
          );
        });
      },
      builder:
          (BuildContext context, candidateData, List<dynamic> rejectedData) {
        return Container(
          width: 260,
          margin: const EdgeInsets.only(right: 6),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            border: Border.all(color: CustomTheme.hint.withValues(alpha: .1)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                color: CustomTheme.accentColor,
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(column.title,
                        style: CustomTextStyle.title14SemiBold
                            .copyWith(color: CustomTheme.white)),
                    SizedBox(
                      height: 25,
                      child: CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          context
                              .read<BoardProvider>()
                              .removeColumn(column.boardId, column.id);
                        },
                        child: Icon(
                          CupertinoIcons.trash,
                          color: CustomTheme.white,
                          size: 18,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Divider(
                height: 1,
                color: CustomTheme.hint.withValues(alpha: .4),
              ),
              if (candidateData.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(Icons.task_outlined),
                      SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: Text(
                          "Release To Move Task Here",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              Expanded(
                  child: ListView(
                shrinkWrap: true,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () => showAddCard(
                          context, provider, widget.board.id, column.id),
                      child: Container(
                        child: Row(
                          children: [
                            Icon(
                              Icons.add,
                              color: CustomTheme.accentColor,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              child: Text(
                                "Add New Card",
                                style: CustomTextStyle.title14SemiBold
                                    .copyWith(color: CustomTheme.accentColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  ...filteredCards.map((task) => TaskTile(
                      task: task,
                      data: {"task": task, "columnId": column.id},
                      showDetail: () {
                        showCardDetails(
                          context: context,
                          provider: provider,
                          boardId: widget.board.id,
                          columnId: column.id,
                          task: task,
                        );
                      },
                      onComplete: () {
                        provider.toggleCardDone(task);
                      })),
                ],
              )),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAddColumnButton(BuildContext context, BoardProvider provider) {
    return GestureDetector(
      onTap: () {
        showNewColumn(context, provider, widget.board.id);
      },
      child: Container(
        width: 260,
        margin: const EdgeInsets.only(right: 6),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          border: Border.all(color: CustomTheme.hint.withValues(alpha: .1)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(child: Icon(Icons.add, size: 30)),
      ),
    );
  }

  void showCardDetails({
    required BuildContext context,
    required BoardProvider provider,
    required String boardId,
    required String columnId,
    required TaskCardModel task,
  }) {
    var users = [];

    for (int i = 0; i < task.assignedUser.length; i++) {
      if (i == 0) {
        users.add(Positioned(
          left: 0,
          child: CircleAvatar(
            radius: 14,
            backgroundColor: Colors.white,
            child: Center(
              child: Text(
                task.assignedUser[i].substring(0, 1),
                style: TextStyle(fontSize: 12),
              ),
            ),
          ),
        ));
      } else {
        users.add(Positioned(
          left: (i) * 20,
          child: CircleAvatar(
            radius: 14,
            backgroundColor: Colors.white,
            child: Center(
              child: Text(
                task.assignedUser[i].substring(0, 1),
                style: TextStyle(fontSize: 12),
              ),
            ),
          ),
        ));
      }
    }

    users.add(Positioned(
      left: (task.assignedUser.length) * 20,
      child: InkWell(
        onTap: () {
          assignedUser(context, boardId, columnId, task);
        },
        child: CircleAvatar(
          radius: 14,
          child: Icon(Icons.add),
        ),
      ),
    ));

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              titlePadding: EdgeInsets.all(8),
              contentPadding: EdgeInsets.all(8),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              title: Text(
                'Task Details',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          spreadRadius: 0.8,
                          blurRadius: 8,
                        )
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Text(
                            task.title,
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Divider(height: 1),
                        if (task.description.isNotEmpty)
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 4, horizontal: 8),
                            child: Text(
                              task.description,
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w400),
                              maxLines: 3,
                            ),
                          ),
                        Divider(height: 1),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                          child: Text(
                            "created at : ${task.createdAt.toString().split(" ").first}",
                            style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  if (task.assignedUser.isNotEmpty) Text("Assigned users"),
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      SizedBox(
                        width: double.infinity,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      // CircleAvatar(
                      //   radius: 14,
                      //   backgroundColor: Colors.green,
                      //   child: Center(
                      //     child: Text(
                      //       task.assignedUser.first.substring(0, 1),
                      //       style: TextStyle(fontSize: 12),
                      //     ),
                      //   ),
                      // ),
                      ...users,
                    ],
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }
}
