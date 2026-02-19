import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/user.dart';

class UserProvider extends ChangeNotifier {
  User? _user;
  final _uuid = const Uuid();

  User? get user => _user;

  void createDefaultUser(String name) {
    _user = User(id: _uuid.v4(), name: name);
    notifyListeners();
  }
}
