import "package:flutter/material.dart";
import "package:shared_preferences/shared_preferences.dart";
import "../models/user.dart";

class AuthController extends ChangeNotifier {
  User? _currentUser;
  bool _isLoading = true;

  User? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isLoading => _isLoading;

  AuthController() {
    _loadSession();
  }

  Future<void> _loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString("user_id");
    final userName = prefs.getString("user_name");
    final userEmail = prefs.getString("user_email");

    if (userId != null && userName != null && userEmail != null) {
      _currentUser = User(id: userId, name: userName, email: userEmail, isOnline: true);
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) return false;
    if (password.length < 8) return false;

    await Future.delayed(const Duration(seconds: 1));

    // Verify against credentials saved during signup
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString("registered_email");
    final savedPassword = prefs.getString("registered_password");
    final savedName = prefs.getString("registered_name") ?? "User";

    if (email != savedEmail || password != savedPassword) return false;

    await _saveSession("u1", savedName, email);
    return true;
  }

  Future<bool> signup(String name, String email, String password) async {
    if (name.isEmpty || email.isEmpty || password.length < 8) return false;

    await Future.delayed(const Duration(seconds: 1));

    // Save credentials so login can verify them later
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("registered_email", email);
    await prefs.setString("registered_password", password);
    await prefs.setString("registered_name", name);

    await _saveSession("u1", name, email);
    return true;
  }

  Future<void> _saveSession(String id, String name, String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("user_id", id);
    await prefs.setString("user_name", name);
    await prefs.setString("user_email", email);

    _currentUser = User(id: id, name: name, email: email, isOnline: true);
    notifyListeners();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _currentUser = null;
    notifyListeners();
  }
}
