import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthRepository {
  final AuthService _authService;

  AuthRepository({AuthService? authService}) : _authService = authService ?? MockAuthService();

  Future<UserModel?> getCurrentUser() => _authService.getCurrentUser();
  Future<UserModel> verifyStudentEmail(String eduEmail, String university) => _authService.verifyStudentEmail(eduEmail, university);
  Future<void> logout() => _authService.logout();
}
