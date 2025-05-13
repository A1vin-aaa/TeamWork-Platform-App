import 'package:challenge1_group3/models/board_column_model.dart';
import 'package:challenge1_group3/provider/board_provider.dart';
import 'package:challenge1_group3/styling/custom_theme.dart';
import 'package:challenge1_group3/styling/text_styles.dart';
import 'package:challenge1_group3/ui/widgets/custom_textfied.dart';
import 'package:challenge1_group3/ui/widgets/primary_button.dart';
import 'package:flutter/material.dart';

showNewColumn(context, BoardProvider provider, String boardId) {
  final nameController = TextEditingController();

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      titlePadding: EdgeInsets.all(12),
      contentPadding: EdgeInsets.all(12),
      actionsPadding: EdgeInsets.all(12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      backgroundColor: Colors.white,
      title: Text(
        'New Column',
        style: CustomTextStyle.title14SemiBold,
      ),
      content: CustomTextField(
        required: true,
        onValidate: (v) {
          if (v!.isEmpty) return "Please enter Column name";
          return null;
        },
        controller: nameController,
        verticalPadding: 16,
        hintText: 'Column Name',
      ),
      actions: [
        PrimaryButton(
          onPressed: () => Navigator.pop(context),
          label: 'Cancel',
          color: CustomTheme.red,
          textColor: CustomTheme.white,
        ),
        PrimaryButton(
          onPressed: () {
            final name = nameController.text.trim();
            if (name.isNotEmpty) {
              final newCol = BoardColumnModel(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                title: name,
                boardId: boardId,
              );
              provider.addColumn(boardId, newCol);
            }
            Navigator.pop(context);
          },
          label: 'Add',
          color: CustomTheme.accentColor,
          textColor: CustomTheme.white,
        ),
      ],
    ),
  );
}
