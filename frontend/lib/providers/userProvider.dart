import 'package:flutter/material.dart';
import 'package:smart_cart/classes/user.dart';

class UserProvider extends ChangeNotifier {
  User? _currentUser;

  User? get currentUser => _currentUser;

  void saveUser(User user) async {
    _currentUser = user;
  }
}
