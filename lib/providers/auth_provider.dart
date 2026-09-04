import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../repositories/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _repository;

  UserModel? _user;
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  AuthProvider({AuthRepository? repository})
      : _repository = repository ?? AuthRepository() {
    _init();
  }

  UserModel? get user => _user;
  bool get isAuthenticated => _user != null;
  bool get isVerifiedStudent => _user?.isVerifiedStudent ?? false;
  StudentVerificationStatus get verificationStatus =>
      _user?.verificationStatus ?? StudentVerificationStatus.unverified;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;

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

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _user = await _repository.login(email: email, password: password);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Login failed. Please check credentials.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register({
    required String fullName,
    required String email,
    required String university,
    required String department,
    required String academicYear,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _user = await _repository.register(
        fullName: fullName,
        email: email,
        university: university,
        department: department,
        academicYear: academicYear,
        password: password,
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Registration failed. Email may already be in use.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> sendForgotPasswordEmail(String email) async {
    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      final success = await _repository.sendForgotPasswordEmail(email);
      if (success) {
        _successMessage = 'Password reset instructions sent to $email';
      }
      _isLoading = false;
      notifyListeners();
      return success;
    } catch (e) {
      _errorMessage = 'Failed to send reset link.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> sendCollegeEmailOtp(String email) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final res = await _repository.sendCollegeEmailOtp(email);
      _isLoading = false;
      notifyListeners();
      return res;
    } catch (e) {
      _errorMessage = 'Failed to send OTP code.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> verifyCollegeEmailOtp(String otpCode) async {
    if (_user == null) return false;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _user = await _repository.verifyCollegeEmailOtp(
        email: _user!.email,
        otpCode: otpCode,
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Invalid verification code.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> submitCollegeIdVerification({
    required String studentIdNumber,
    required String documentFileName,
  }) async {
    if (_user == null) return false;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _user = await _repository.submitCollegeIdVerification(
        userId: _user!.id,
        studentIdNumber: studentIdNumber,
        documentFileName: documentFileName,
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'ID verification upload failed.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateProfile({
    String? name,
    String? email,
    String? university,
    String? department,
    String? academicYear,
    String? avatarUrl,
  }) async {
    if (_user == null) return false;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _user = _user!.copyWith(
        name: name,
        email: email,
        university: university,
        department: department,
        academicYear: academicYear,
        avatarUrl: avatarUrl,
      );

      await _repository.updateProfile(
        userId: _user!.id,
        name: name,
        department: department,
        academicYear: academicYear,
        avatarUrl: avatarUrl,
      );

      _successMessage = 'Profile photo & information updated successfully! ✨';
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to update profile.';
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
