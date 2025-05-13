import 'package:challenge1_group3/models/board_model.dart';
import 'package:challenge1_group3/provider/board_provider.dart';
import 'package:challenge1_group3/styling/custom_theme.dart';
import 'package:challenge1_group3/styling/text_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class BoardTile extends StatelessWidget {
  final BoardModel board;
  final VoidCallback onPressed;
  const BoardTile({super.key, required this.board, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.withValues(alpha: .3)),
          color: Colors.white,
          borderRadius: BorderRadius.circular(8)),
      child: InkWell(
        onTap: onPressed,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(board.name, style: CustomTextStyle.title14SemiBold),
                  Text(
                      "created at : ${DateFormat("dd MMM yyyy hh:mm a").format(board.createdAt)}",
                      style: CustomTextStyle.title10Medium),
                ],
              ),
            ),
            CupertinoButton(
              onPressed: () {
                context.read<BoardProvider>().removeBoard(board.id);
              },
              child: Icon(
                CupertinoIcons.trash,
                color: CustomTheme.red,
                size: 18,
              ),
            )
          ],
        ),
      ),
    );
  }
}
