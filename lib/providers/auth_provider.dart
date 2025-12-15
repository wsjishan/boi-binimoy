import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _user;
  UserModel? _userModel;
  bool _isLoading = true;

  AuthProvider() {
    _authService.authStateChanges.listen((User? user) {
      _user = user;
      if (user != null) {
        _loadUserData(user.uid);
      } else {
        _userModel = null;
        _isLoading = false;
      }
      notifyListeners();
    });
  }

  User? get user => _user;
  UserModel? get userModel => _userModel;
  bool get isLoading => _isLoading;

  Future<void> _loadUserData(String uid) async {
    _userModel = await _authService.getUserData(uid);
    _isLoading = false;
    notifyListeners();
  }

  Future<String?> signUp({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    return await _authService.signUp(
      email: email,
      password: password,
      name: name,
      phone: phone,
    );
  }

  Future<String?> signIn({
    required String email,
    required String password,
  }) async {
    return await _authService.signIn(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await _authService.signOut();
  }
}