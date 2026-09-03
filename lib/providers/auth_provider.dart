import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../repositories/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _repository;

  UserModel? _user;
  bool _isLoading = false;
  String? _errorMessage;

  AuthProvider({AuthRepository? repository})
      : _repository = repository ?? AuthRepository() {
    _init();
  }

  UserModel? get user => _user;
  bool get isAuthenticated => _user != null;
  bool get isVerifiedStudent => _user?.isVerifiedStudent ?? false;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> _init() async {
    _isLoading = true;
    notifyListeners();
    try {
      _user = await _repository.getCurrentUser();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> verifyAndLogin(String eduEmail, String university) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _user = await _repository.verifyStudentEmail(eduEmail, university);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed student verification. Check email or connection.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    _user = null;
    notifyListeners();
  }
}
