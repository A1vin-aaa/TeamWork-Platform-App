import 'package:challenge1_group3/models/task_card_model.dart';
import 'package:challenge1_group3/provider/board_provider.dart';
import 'package:challenge1_group3/styling/custom_theme.dart';
import 'package:challenge1_group3/styling/text_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TaskTile extends StatelessWidget {
  final TaskCardModel task;
  final VoidCallback onComplete;
  final VoidCallback showDetail;
  final Map<String, dynamic> data;
  const TaskTile(
      {super.key,
      required this.task,
      required this.showDetail,
      required this.onComplete,
      required this.data});

  @override
  Widget build(BuildContext context) {
    return LongPressDraggable(
      data: data,
      feedback: Material(
        child: Container(
          width: 260,
          // margin: EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(8),
                child: Row(
                  children: [
                    Icon(
                      task.isDone
                          ? Icons.check_box
                          : Icons.check_box_outline_blank,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        task.title,
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(height: 1),
              if (task.description.isNotEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: Text(
                    task.description,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                    maxLines: 3,
                  ),
                ),
              Divider(height: 1),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: Text(
                  "created at : ${task.createdAt.toString().split(" ").first}",
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
      ),
      childWhenDragging: SizedBox(),
      child: InkWell(
        onTap: showDetail,
        child: Container(
          decoration: BoxDecoration(color: Colors.white),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(8),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          InkWell(
                            onTap: onComplete,
                            child: Icon(
                              task.isDone
                                  ? Icons.radio_button_checked_sharp
                                  : Icons.radio_button_off,
                              size: 20,
                              color: task.isDone
                                  ? CustomTheme.accentColor
                                  : CustomTheme.hint,
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              task.title,
                              style: CustomTextStyle.title14SemiBold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 25,
                      child: CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          context.read<BoardProvider>().removeCard(task);
                        },
                        child: Icon(
                          CupertinoIcons.trash,
                          size: 18,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Divider(
                height: .5,
                color: CustomTheme.hint.withValues(alpha: .3),
              ),
              if (task.description.isNotEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: Text(
                    task.description,
                    style: CustomTextStyle.title13Regular,
                    maxLines: 3,
                  ),
                ),
              Divider(
                height: .5,
                color: CustomTheme.hint.withValues(alpha: .3),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: Text(
                  "created at : ${DateFormat("dd MMM yyyy hh:mm a").format(task.createdAt)}",
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
                ),
              ),
              Divider(
                height: .5,
                color: CustomTheme.hint,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
