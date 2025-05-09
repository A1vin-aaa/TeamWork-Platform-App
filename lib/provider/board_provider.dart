import 'package:challenge1_group3/models/board_column_model.dart';
import 'package:challenge1_group3/models/board_model.dart';
import 'package:challenge1_group3/models/task_card_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/material.dart';

class BoardProvider with ChangeNotifier {

  // The currently logged‑in user
  String? currentUserId;

  List<BoardModel> boards = [];
  Map<String, List<BoardColumnModel>> columnsMap = {};

  /// In‑memory cache of profiles loaded from prefs
  final Map<String, Map<String, String>> userProfiles = {};

  BoardProvider() {
    _loadLoginState();
    _loadAllProfiles();
  }

  /// Load the saved userId and set currentUserId
  Future<void> _loadLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    final savedUser = prefs.getString('currentUserId') ?? '';
    if (savedUser.isNotEmpty) {
      currentUserId = savedUser;
      notifyListeners();
    }
  }

  /// Load saved profiles for both users
  Future<void> _loadAllProfiles() async {
    final prefs = await SharedPreferences.getInstance();
    for (final id in ['username1', 'username2']) {
      final nameKey = '${id}_name';
      final emailKey = '${id}_email';
      userProfiles[id] = {
        'name': prefs.getString(nameKey) ?? (id == 'username1' ? 'User One' : 'User Two'),
        'email': prefs.getString(emailKey) ?? (id == 'username1' ? 'user1@example.com' : 'user2@example.com'),
      };
    }
    // no notify here, AccountPage will read via context.watch
  }

  /// Log in as this user (also persists)
  Future<void> setCurrentUserId(String id) async {
    currentUserId = id;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('currentUserId', id);
  }

  /// Update *one* profile field, persist immediately
  Future<void> updateProfileField(String userId, String field, String value) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '${userId}_${field.toLowerCase()}';
    await prefs.setString(key, value);
    userProfiles[userId]![field.toLowerCase()] = value;
    notifyListeners();
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString('currentUserId');
    if (saved != null && saved.isNotEmpty) {
      currentUserId = saved;
      notifyListeners();
    }
  }

  List<BoardModel> get visibleBoards {
    if (currentUserId == null) return [];
    return boards.where((b) => b.ownerId == currentUserId).toList();
  }

  void addBoard(BoardModel board) {
    boards.add(board);
    columnsMap[board.id] = [
      BoardColumnModel(id: 'todo', title: 'To Do', cards: []),
      BoardColumnModel(id: 'doing', title: 'Doing', cards: []),
      BoardColumnModel(id: 'done', title: 'Done', cards: []),
    ];

    notifyListeners();
  }

  void addBoardWithName(String id, String name) {
    // Use the real user if set, otherwise default to 'guest'
    final owner = (currentUserId != null && currentUserId!.isNotEmpty)
        ? currentUserId!
        : 'guest';

    final board = BoardModel(
      id: id,
      name: name,
      ownerId: owner,             // now always non-null
    );
    addBoard(board);
  }


  void removeBoard(String boardId) {
    boards.removeWhere((b) => b.id == boardId);
    columnsMap.remove(boardId);
    notifyListeners();
  }

  BoardModel? getBoardById(String id) => boards.firstWhere((b) => b.id == id);

  void addColumn(String boardId, BoardColumnModel column) {
    final columns = columnsMap[boardId];
    if (columns != null) {
      columns.add(column);
      notifyListeners();
    }
  }

  void removeColumn(String boardId, String columnId) {
    final columns = columnsMap[boardId];
    if (columns != null) {
      columns.removeWhere((c) => c.id == columnId);
      notifyListeners();
    }
  }

  List<BoardColumnModel> getColumns(String boardId) =>
      columnsMap[boardId] ?? [];

  void addCard(String boardId, String columnId, TaskCardModel card) {
    final column = _getColumn(boardId, columnId);
    column?.cards.add(card);
    notifyListeners();
  }

  void removeCard(String boardId, String columnId, String cardId) {
    final column = _getColumn(boardId, columnId);
    column?.cards.removeWhere((c) => c.id == cardId);
    notifyListeners();
  }

  void moveCard({
    required String boardId,
    required String fromColumnId,
    required String toColumnId,
    required TaskCardModel card,
    required int toIndex,
  }) {
    final fromColumn = _getColumn(boardId, fromColumnId);
    final toColumn = _getColumn(boardId, toColumnId);

    if (fromColumn != null && toColumn != null) {
      fromColumn.cards.removeWhere((c) => c.id == card.id);
      toColumn.cards.insert(toIndex, card);
      notifyListeners();
    }
  }

  BoardColumnModel? _getColumn(String boardId, String columnId) {
    final columns = columnsMap[boardId];
    if (columns == null) return null;
    return columns.firstWhere((c) => c.id == columnId);
  }
}
