import 'package:challenge1_group3/models/activity_model.dart';
import 'package:challenge1_group3/styling/custom_theme.dart';
import 'package:challenge1_group3/styling/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:challenge1_group3/provider/board_provider.dart';

class ActivityPage extends StatelessWidget {
  const ActivityPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BoardProvider>();

    final List<Activity> activities = provider.activities;
    activities.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return Scaffold(
      appBar: AppBar(
        title: Text('Activities', style: CustomTextStyle.title16SemiBold),
      ),
      body: activities.isEmpty
          ? const Center(child: Text('No recent activity.'))
          : Column(
              children: [
                Divider(
                  height: 1,
                ),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    itemCount: activities.length,
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
                                activities[i].action,
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
                                "created at : ${DateFormat("dd MMM yyyy hh:mm a").format(activities[i].createdAt)}",
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
