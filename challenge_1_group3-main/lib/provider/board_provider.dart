import 'package:challenge1_group3/main.dart';
import 'package:challenge1_group3/models/activity_model.dart';
import 'package:challenge1_group3/models/board_column_model.dart';
import 'package:challenge1_group3/models/board_model.dart';
import 'package:challenge1_group3/models/inbox_model.dart';
import 'package:challenge1_group3/models/task_card_model.dart';
import 'package:challenge1_group3/provider/user_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

UserProvider userProvider = Provider.of(navKey.currentContext!, listen: false);
BoardProvider boardProvider =
    Provider.of(navKey.currentContext!, listen: false);

class BoardProvider with ChangeNotifier {
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final List<Activity> _activities = [];
  final List<InboxModel> _inboxActivity = [];
  final List<BoardModel> _boards = [];
  final List<TaskCardModel> _cards = [];
  Map<String, List<BoardColumnModel>> columnsMap = {};
  void fetchBoards() {
    FirebaseFirestore.instance
        .collection('boards')
        .where("members", arrayContains: UserProvider.currentUserId)
        .snapshots()
        .listen((v) {
      _boards.clear();
      _boards.addAll(v.docs.map((e) => BoardModel.fromSnapshot(e)));
      notifyListeners();
    });
  }

  void fetchColumns(String boardId) {
    FirebaseFirestore.instance
        .collection('columns')
        .where("board_id", isEqualTo: boardId)
        .orderBy("created_at", descending: false)
        .snapshots()
        .listen((v) {
      if (columnsMap[boardId] == null) {
        columnsMap[boardId] = [];
      } else {
        columnsMap[boardId]!.clear();
      }
      columnsMap[boardId]?.addAll(v.docs
          .map((e) => BoardColumnModel.fromJson({...e.data(), 'id': e.id})));
      notifyListeners();
    });
  }

  void fetchCards(String boardId) {
    FirebaseFirestore.instance
        .collection('cards')
        .where("boardId", isEqualTo: boardId)
        .orderBy("createdAt", descending: false)
        .snapshots()
        .listen((v) {
      _cards.clear();
      _cards.addAll(v.docs
          .map((e) => TaskCardModel.fromJson({
                ...e.data(),
                'id': e.id,
              }))
          .toList());
      notifyListeners();
    });
  }

  void fetchInbox() {
    FirebaseFirestore.instance
        .collection('inboxActivity')
        .where("receiver", arrayContains: UserProvider.currentUserId)
        .orderBy("createdAt", descending: true)
        .snapshots()
        .listen((v) {
      _inboxActivity.clear();
      _inboxActivity.addAll(
          v.docs.map((e) => InboxModel.fromJson({'id': e.id, ...e.data()})));
      notifyListeners();
    });
  }

  void fetchActivity() {
    FirebaseFirestore.instance
        .collection('activites')
        .where("receivedBy", arrayContains: UserProvider.currentUserId)
        .orderBy("createdAt", descending: true)
        .snapshots()
        .listen((v) {
      _activities.clear();
      _activities.addAll(
          v.docs.map((e) => Activity.fromJson({'id': e.id, ...e.data()})));
      notifyListeners();
    });
  }

  void addBoard(BoardModel board) async {
    _boards.add(board);
    notifyListeners();
    _firebaseFirestore.collection("boards").doc(board.id).set(board.toJson());
    await _firebaseFirestore.collection('columns').add({
      'created_at': DateTime.now(),
      'board_id': board.id,
      'title': 'To Do',
    });
    await _firebaseFirestore.collection('columns').add({
      'created_at': DateTime.now(),
      'board_id': board.id,
      'title': 'Doing',
    });
    await _firebaseFirestore.collection('columns').add({
      'created_at': DateTime.now(),
      'board_id': board.id,
      'title': 'Done',
    });
  }

  void updateBoard(BoardModel board) async {
    print(board.members);
    final index = _boards.indexWhere((c) => c.id == board.id);
    if (index != -1) {
      _boards[index] = board;
      notifyListeners();
    }
    await _firebaseFirestore
        .collection("boards")
        .doc(board.id)
        .update(board.toJson());
  }

  void addActivity(Activity activity) {
    _firebaseFirestore.collection("activites").add(activity.toJson());
    notifyListeners();
  }

  void addInboxActivity(InboxModel activity) {
    _inboxActivity.add(activity);
    _firebaseFirestore.collection("inboxActivity").add(activity.toJson());
    notifyListeners();
  }

  void removeBoard(String boardId) {
    _boards.removeWhere((b) => b.id == boardId);
    columnsMap.remove(boardId);
    _firebaseFirestore.collection('boards').doc(boardId).delete();
    notifyListeners();
  }

  void addColumn(String boardId, BoardColumnModel column) {
    final columns = columnsMap[boardId];
    if (columns != null) {
      columns.add(column);
      notifyListeners();
    }
    _firebaseFirestore.collection('columns').add({
      'created_at': DateTime.now(),
      'board_id': boardId,
      'title': column.title,
    });
    addActivity(Activity(
        boardName: _boards.firstWhere((e) => e.id == boardId).name,
        action:
            "${column.title} has been added by ${userProvider.currentUser!.fullName}",
        createdAt: DateTime.now(),
        receivedBy: _boards.firstWhere((e) => e.id == boardId).members));
  }

  void removeColumn(String boardId, String columnId) {
    final columns = columnsMap[boardId];
    if (columns != null) {
      columns.removeWhere((c) => c.id == columnId);
      notifyListeners();
      _firebaseFirestore.collection('columns').doc(columnId).delete();
      addActivity(Activity(
          boardName: _boards.firstWhere((e) => e.id == boardId).name,
          action:
              "${columnsMap[boardId]!.firstWhere((e) => e.id == columnId).title} has been removed by ${userProvider.currentUser!.fullName}",
          createdAt: DateTime.now(),
          receivedBy: _boards.firstWhere((e) => e.id == boardId).members));
    }
  }

  List<BoardColumnModel> getColumns(String boardId) =>
      columnsMap[boardId] ?? [];

  void addCard(String boardId, String columnId, TaskCardModel task) async {
    await _firebaseFirestore.collection("cards").add(task.toJson());
    addActivity(Activity(
        boardName: _boards.firstWhere((e) => e.id == task.boardId).name,
        action:
            "${task.title} has been added by ${userProvider.currentUser!.fullName}",
        createdAt: DateTime.now(),
        receivedBy: _boards.firstWhere((e) => e.id == task.boardId).members));
  }

  void updateCard(String boardId, String columnId, TaskCardModel updatedCard) {
    final index = _cards.indexWhere((c) => c.id == updatedCard.id);
    if (index != -1) {
      _cards[index] = updatedCard;
      notifyListeners();
    }
    FirebaseFirestore.instance
        .collection('cards')
        .doc(updatedCard.id)
        .update(updatedCard.toJson());
  }

  void toggleCardDone(TaskCardModel task) {
    final index = _cards.indexWhere((c) => c.id == task.id);
    if (index != -1) {
      final card = _cards[index];
      final updatedCard = card.copyWith(isDone: !card.isDone);
      _cards[index] = updatedCard;
      notifyListeners();
      _firebaseFirestore
          .collection("cards")
          .doc(task.id)
          .update(updatedCard.toJson());

      addActivity(Activity(
          boardName: _boards.firstWhere((e) => e.id == task.boardId).name,
          action:
              "${task.title} has been marked as ${updatedCard.isDone ? "Completed" : "InComplete"} by ${userProvider.currentUser!.fullName}",
          createdAt: DateTime.now(),
          receivedBy: _boards.firstWhere((e) => e.id == task.boardId).members));
    }
  }

  void removeCard(TaskCardModel task) {
    _cards.removeWhere((c) => c.id == task.id);
    _firebaseFirestore.collection("cards").doc(task.id).delete();
    notifyListeners();
    addActivity(Activity(
        boardName: _boards.firstWhere((e) => e.id == task.boardId).name,
        action:
            "${task.title} has been removed by ${userProvider.currentUser!.fullName}",
        createdAt: DateTime.now(),
        receivedBy: _boards.firstWhere((e) => e.id == task.boardId).members));
  }

  void moveCard({
    required String boardId,
    required String fromColumnId,
    required String toColumnId,
    required TaskCardModel task,
  }) {
    int index = _cards.indexWhere((c) => c.id == task.id);
    _cards[index] = task.copyWith(columnId: toColumnId);
    notifyListeners();
    _firebaseFirestore
        .collection("cards")
        .doc(task.id)
        .update(task.copyWith(columnId: toColumnId).toJson());
    addActivity(Activity(
        boardName: _boards.firstWhere((e) => e.id == boardId).name,
        action:
            "${task.title} has been move to ${columnsMap[boardId]!.firstWhere((e) => e.id == toColumnId).title} by ${userProvider.currentUser!.fullName}",
        createdAt: DateTime.now(),
        receivedBy: _boards.firstWhere((e) => e.id == boardId).members));
  }

  BoardModel? getBoardById(String id) => _boards.firstWhere((b) => b.id == id);
  List<TaskCardModel> getCardsByBoard(String id) =>
      _cards.where((e) => e.boardId == id).toList();
  List<String> getBoardMembers(String id) =>
      _boards.firstWhere((b) => b.id == id).members;
  List<BoardModel> get getMyBoards => _boards;
  List<Activity> get activities => _activities;
  List<InboxModel> get inboxActivity => _inboxActivity;
}
