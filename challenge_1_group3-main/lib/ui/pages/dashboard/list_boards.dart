import 'package:challenge1_group3/provider/board_provider.dart';
import 'package:challenge1_group3/styling/text_styles.dart';
import 'package:challenge1_group3/ui/dialogs/create_new_board.dart';
import 'package:challenge1_group3/ui/pages/dashboard/board_detail_page.dart';
import 'package:challenge1_group3/ui/widgets/board_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListBoards extends StatelessWidget {
  const ListBoards({super.key});

  @override
  Widget build(BuildContext context) {
    final boardProvider = Provider.of<BoardProvider>(context);
    final boards = boardProvider.getMyBoards;

    return Scaffold(
      appBar: AppBar(
        title: Text('Boards', style: CustomTextStyle.title16SemiBold),
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                BoardDetailPage(board: board)));
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showCreateBoardDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
