import 'package:challenge1_group3/models/board_model.dart';
import 'package:flutter/material.dart';

class BoardTile extends StatelessWidget {
  final BoardModel board;
  final VoidCallback onPressed;
  const BoardTile({super.key, required this.board, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(8),
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: .1),
              spreadRadius: .8,
              blurRadius: 8)
        ], color: Colors.white, borderRadius: BorderRadius.circular(8)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              board.name,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              "created at : ${board.createdAt.toIso8601String()}",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
