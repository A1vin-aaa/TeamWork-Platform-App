import 'package:challenge1_group3/models/task_card_model.dart';
import 'package:challenge1_group3/provider/board_provider.dart';
import 'package:challenge1_group3/provider/user_provider.dart';
import 'package:challenge1_group3/styling/custom_theme.dart';
import 'package:challenge1_group3/styling/text_styles.dart';
import 'package:challenge1_group3/ui/widgets/custom_textfied.dart';
import 'package:challenge1_group3/ui/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void showAddCard(BuildContext context, BoardProvider provider, String boardId,
    String columnId) {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      titlePadding: EdgeInsets.all(12),
      contentPadding: EdgeInsets.all(12),
      actionsPadding: EdgeInsets.all(12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      backgroundColor: Colors.white,
      title: Text(
        'New Card',
        style: CustomTextStyle.title14SemiBold,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomTextField(
            required: true,
            onValidate: (v) {
              if (v!.isEmpty) return "Please enter Card title";
              return null;
            },
            verticalPadding: 16,
            hintText: 'Card Title',
            controller: titleController,
          ),
          const SizedBox(height: 8),
          CustomTextField(
            verticalPadding: 16,
            hintText: 'Instruction / Description',
            controller: descriptionController,
          ),
        ],
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
            final title = titleController.text.trim();
            final description = descriptionController.text.trim();
            UserProvider userProvider = Provider.of(context, listen: false);
            if (title.isNotEmpty) {
              final card = TaskCardModel(
                id: '',
                title: title,
                description: description,
                isDone: false,
                createdAt: DateTime.now(),
                boardId: boardId,
                columnId: columnId,
                receiver: [userProvider.currentUser!.uid],
                assignedUser: [userProvider.currentUser!.fullName],
              );
              provider.addCard(boardId, columnId, card);
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
