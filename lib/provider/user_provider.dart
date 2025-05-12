import 'package:challenge1_group3/models/user_model.dart';
import 'package:flutter/cupertino.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _user;

  updateUser(UserModel? user) {
    _user = user;
    notifyListeners();
  }

  UserModel? get currentUser => _user;
}
