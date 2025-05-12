import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:challenge1_group3/provider/user_provider.dart';
import 'package:intl/intl.dart';

/// A simple inbox page where users can add tasks with a title, description, and date,
/// and mark them completed with a single checkbox, persisted per user.
class InboxPage extends StatefulWidget {
  const InboxPage({Key? key}) : super(key: key);

  @override
  State<InboxPage> createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage> {
  final List<_InboxTask> _tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = Provider.of<UserProvider>(context, listen: false)
        .currentUser
        ?.uid ??
        'guest';
    final key = 'inbox_$userId';
    final jsonStr = prefs.getString(key);
    if (jsonStr != null) {
      final List<dynamic> data = json.decode(jsonStr);
      setState(() {
        _tasks.clear();
        _tasks.addAll(data.map((e) => _InboxTask.fromJson(e)));
      });
    }
  }

  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = Provider.of<UserProvider>(context, listen: false)
        .currentUser
        ?.uid ??
        'guest';
    final key = 'inbox_$userId';
    final data = _tasks.map((t) => t.toJson()).toList();
    await prefs.setString(key, json.encode(data));
  }

  void _addTask() {
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    DateTime? selectedDate;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('New Inbox Task'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleCtrl,
                decoration: const InputDecoration(
                  labelText: 'Title',
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: descCtrl,
                decoration: const InputDecoration(
                  labelText: 'Description',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: TextEditingController(
                    text: selectedDate == null
                        ? ''
                        : DateFormat.yMMMMd().format(selectedDate!)),
                decoration: const InputDecoration(
                  labelText: 'Date',
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: () async {
                  final now = DateTime.now();
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: now,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    selectedDate = picked;
                    (ctx as Element).markNeedsBuild();
                  }
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final title = titleCtrl.text.trim();
              final desc = descCtrl.text.trim();
              final date = selectedDate;
              if (title.isNotEmpty && date != null) {
                setState(() {
                  _tasks.add(_InboxTask(
                    title: title,
                    description: desc,
                    date: date,
                  ));
                });
                await _saveTasks();
                Navigator.of(ctx).pop();
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inbox')),
      body: _tasks.isEmpty
          ? const Center(child: Text('No tasks yet. Tap + to add.'))
          : ListView.builder(
        itemCount: _tasks.length,
        itemBuilder: (ctx, i) {
          final task = _tasks[i];
          return CheckboxListTile(
            title: Text(task.title),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (task.description.isNotEmpty)
                  Text(task.description),
                Text(
                  DateFormat.yMMMMd().format(task.date),
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            value: task.isDone,
            onChanged: (checked) async {
              setState(() {
                task.isDone = checked ?? false;
              });
              await _saveTasks();
            },
            controlAffinity: ListTileControlAffinity.leading,
          );
        },
      ),
      floatingActionButton:
      FloatingActionButton(onPressed: _addTask, child: const Icon(Icons.add)),
    );
  }
}

class _InboxTask {
  final String title;
  final String description;
  final DateTime date;
  bool isDone;

  _InboxTask({
    required this.title,
    this.description = '',
    required this.date,
    this.isDone = false,
  });

  factory _InboxTask.fromJson(Map<String, dynamic> json) => _InboxTask(
    title: json['title'] as String,
    description: json['description'] as String,
    date: DateTime.parse(json['date'] as String),
    isDone: json['isDone'] as bool,
  );

  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'date': date.toIso8601String(),
    'isDone': isDone,
  };
}
