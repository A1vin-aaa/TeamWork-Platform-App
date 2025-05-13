import 'package:challenge1_group3/models/activity_model.dart';
import 'package:challenge1_group3/models/board_model.dart';
import 'package:challenge1_group3/provider/board_provider.dart';
import 'package:challenge1_group3/provider/user_provider.dart';
import 'package:challenge1_group3/styling/custom_theme.dart';
import 'package:challenge1_group3/styling/text_styles.dart';
import 'package:challenge1_group3/ui/widgets/custom_textfied.dart';
import 'package:challenge1_group3/ui/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void showCreateBoardDialog(BuildContext context) {
  final nameController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  showDialog(
      context: context,
      builder: (_) => AlertDialog(
            titlePadding: EdgeInsets.all(12),
            contentPadding: EdgeInsets.all(12),
            actionsPadding: EdgeInsets.all(12),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            backgroundColor: Colors.white,
            title: Text(
              'Create Board',
              style: CustomTextStyle.title14SemiBold,
            ),
            content: Form(
              key: _formKey,
              child: CustomTextField(
                required: true,
                onValidate: (v) {
                  if (v!.isEmpty) return "Please enter board name";
                  return null;
                },
                controller: nameController,
                verticalPadding: 16,
                hintText: 'Board Name',
              ),
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
                  final boardProvider =
                      Provider.of<BoardProvider>(context, listen: false);
                  final userProvider =
                      Provider.of<UserProvider>(context, listen: false);
                  if (!_formKey.currentState!.validate()) return;
                  final name = nameController.text.trim();
                  if (name.isNotEmpty) {
                    final id = DateTime.now().millisecondsSinceEpoch.toString();
                    final board = BoardModel(
                      id: id,
                      name: name,
                      members: [userProvider.currentUser!.uid],
                      createdAt: DateTime.now(),
                    );

                    boardProvider.addBoard(board);
                    Provider.of<BoardProvider>(context, listen: false)
                        .addActivity(Activity(
                            boardName: board.name,
                            action:
                                "${board.name} has been added by ${userProvider.currentUser?.fullName ?? ""}",
                            createdAt: DateTime.now(),
                            receivedBy: [userProvider.currentUser?.uid ?? ""]));
                  }
                  Navigator.pop(context);
                },
                label: 'Add',
                color: CustomTheme.accentColor,
                textColor: CustomTheme.white,
              ),
            ],
          ));
}
