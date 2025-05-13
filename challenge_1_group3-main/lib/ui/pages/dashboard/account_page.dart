import 'package:challenge1_group3/provider/user_provider.dart';
import 'package:challenge1_group3/styling/custom_theme.dart';
import 'package:challenge1_group3/styling/text_styles.dart';
import 'package:challenge1_group3/ui/pages/auth/login_screen.dart';
import 'package:challenge1_group3/ui/widgets/custom_textfied.dart';
import 'package:challenge1_group3/ui/widgets/primary_button.dart';
import 'package:challenge1_group3/ui/widgets/square_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final user = userProvider.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile', style: CustomTextStyle.title16SemiBold),
      ),
      body: user == null
          ? SizedBox()
          : Column(
              children: [
                Center(
                  child: Container(
                    margin: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: CustomTheme.accentColor.withValues(alpha: .8)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text('Name: ${user.fullName}',
                                    style: CustomTextStyle.title13Regular
                                        .copyWith(color: CustomTheme.white)),
                              ),
                              SquareButton(
                                  icon: Icons.edit,
                                  bgColor: CustomTheme.accentColor,
                                  contentColor: CustomTheme.white,
                                  onPressed: () {
                                    _showEditDialog(
                                        context, "full name", user.fullName,
                                        (v) async {
                                      userProvider.updateUser(
                                          user.copyWith(fullName: v));
                                      FirebaseFirestore.instance
                                          .collection("users")
                                          .doc(UserProvider.currentUserId)
                                          .update({"full_name": v});
                                      return;
                                    });
                                  })
                            ],
                          ),
                        ),
                        Divider(
                          height: .5,
                          color: CustomTheme.white,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'email: ${user.email}',
                            style: CustomTextStyle.title13Regular
                                .copyWith(color: CustomTheme.white),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: PrimaryButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()));
                      userProvider.updateUser(null);
                    },
                    label: 'Log Out',
                    color: CustomTheme.red,
                    textColor: CustomTheme.white,
                  ),
                ),
              ],
            ),
    );
  }

  void _showEditDialog(
    BuildContext context,
    String fieldName,
    String currentValue,
    Future<void> Function(String) onSave,
  ) {
    final ctrl = TextEditingController(text: currentValue);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        titlePadding: EdgeInsets.all(12),
        contentPadding: EdgeInsets.all(12),
        actionsPadding: EdgeInsets.all(12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        backgroundColor: Colors.white,
        title: Text(
          'Edit $fieldName',
          style: CustomTextStyle.title14SemiBold,
        ),
        content: CustomTextField(
          controller: ctrl,
          hintText: "Full name",
        ),
        actions: [
          PrimaryButton(
            color: CustomTheme.red,
            onPressed: () => Navigator.pop(context),
            label: 'Cancel',
            textColor: CustomTheme.white,
          ),
          PrimaryButton(
            color: CustomTheme.accentColor,
            onPressed: () async {
              final val = ctrl.text.trim();
              if (val.isNotEmpty) await onSave(val);
              Navigator.pop(context);
            },
            label: 'Save',
            textColor: CustomTheme.white,
          ),
        ],
      ),
    );
  }
}
