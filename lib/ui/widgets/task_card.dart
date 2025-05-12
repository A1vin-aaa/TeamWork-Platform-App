import 'package:challenge1_group3/models/task_card_model.dart';
import 'package:flutter/material.dart';

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
    return Draggable(
      data: data,
      feedback: Material(
        child: Container(
          width: 260,
          margin: EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 0.8,
                blurRadius: 8,
              )
            ],
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
          margin: EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 0.8,
                blurRadius: 8,
              )
            ],
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(8),
                child: Row(
                  children: [
                    InkWell(
                      onTap: onComplete,
                      child: Icon(
                        task.isDone
                            ? Icons.check_box
                            : Icons.check_box_outline_blank,
                        size: 20,
                      ),
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
    );
  }
}
