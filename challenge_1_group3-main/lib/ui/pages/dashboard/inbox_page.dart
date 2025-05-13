import 'package:challenge1_group3/models/inbox_model.dart';
import 'package:challenge1_group3/styling/custom_theme.dart';
import 'package:challenge1_group3/styling/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:challenge1_group3/provider/board_provider.dart';

class InboxPage extends StatelessWidget {
  const InboxPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BoardProvider>();

    final List<InboxModel> inboxActivities = provider.inboxActivity;
    inboxActivities.sort((a, b) => b.sentAt.compareTo(a.sentAt));

    return Scaffold(
      appBar: AppBar(
        title: Text('Inbox', style: CustomTextStyle.title16SemiBold),
      ),
      body: inboxActivities.isEmpty
          ? const Center(child: Text('No recent activity in inbox.'))
          : Column(
              children: [
                Divider(
                  height: 1,
                ),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    itemCount: inboxActivities.length,
                    itemBuilder: (ctx, i) {
                      return Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: .5,
                                color: CustomTheme.black.withValues(alpha: .3)),
                            color: CustomTheme.white,
                            borderRadius: BorderRadius.circular(8)),
                        margin:
                            const EdgeInsets.only(right: 8, left: 8, bottom: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 8),
                              child: Text(
                                inboxActivities[i].content,
                                style: CustomTextStyle.title13Regular,
                              ),
                            ),
                            Divider(
                              height: .5,
                              color: CustomTheme.hint.withValues(alpha: .3),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 8),
                              child: Text(
                                "created at : ${DateFormat("dd MMM yyyy hh:mm a").format(inboxActivities[i].sentAt)}",
                                style: TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
