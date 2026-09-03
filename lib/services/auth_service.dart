import '../models/user_model.dart';

abstract class AuthService {
  Future<UserModel?> getCurrentUser();
  Future<UserModel> verifyStudentEmail(String eduEmail, String university);
  Future<void> logout();
}

class MockAuthService implements AuthService {
  UserModel? _currentUser = UserModel.mockUser;

  @override
  Future<UserModel?> getCurrentUser() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _currentUser;
  }

  @override
  Future<UserModel> verifyStudentEmail(String eduEmail, String university) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _currentUser = UserModel(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      name: eduEmail.split('@').first.replaceAll('.', ' '),
      email: eduEmail,
      university: university,
      isVerifiedStudent: true,
      trustRating: 5.0,
      totalTransactions: 0,
      co2SavedKg: 0.0,
      moneySavedUsd: 0.0,
      itemsCirculated: 0,
    );
    return _currentUser!;
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _currentUser = null;
  }
}
