import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider with ChangeNotifier {
  String? _email;
  bool _isLoggedIn = false;

  String? get email => _email;
  bool get isLoggedIn => _isLoggedIn;

  Future<void> login(String email) async {
    _email = email;
    _isLoggedIn = true;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userEmail', email);
    await prefs.setBool('isLoggedIn', true);

    notifyListeners();
  }

  Future<void> autoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    _email = prefs.getString('userEmail');
    notifyListeners();
  }

  Future<void> logout() async {
    _email = null;
    _isLoggedIn = false;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userEmail');
    await prefs.remove('isLoggedIn');

    notifyListeners();
  }
}
