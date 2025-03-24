import 'package:flutter/foundation.dart';
import '../helpers/database_helper.dart';

class AuthProvider with ChangeNotifier {
  String? _currentUser;

  String? get currentUser => _currentUser;

  Future<bool> login(String libraryCardNumber, String password) async {
    // TODO: Implement actual login logic with database
    // For now, we'll use a mock login
    if (libraryCardNumber == '123456' && password == 'password') {
      _currentUser = 'John Doe';
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> createAccount(String name, String email, String password) async {
    // TODO: Implement actual account creation logic with database
    // For now, we'll use a mock account creation
    _currentUser = name;
    notifyListeners();
    return true;
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}

