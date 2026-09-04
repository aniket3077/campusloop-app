import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/supabase_auth_service.dart';

class AuthRepository {
  final AuthService _authService;

  AuthRepository({AuthService? authService}) : _authService = authService ?? SupabaseAuthService();

  Future<UserModel?> getCurrentUser() => _authService.getCurrentUser();

  Future<UserModel> register({
    required String fullName,
    required String email,
    required String university,
    required String department,
    required String academicYear,
    required String password,
  }) =>
      _authService.register(
        fullName: fullName,
        email: email,
        university: university,
        department: department,
        academicYear: academicYear,
        password: password,
      );

  Future<UserModel> login({
    required String email,
    required String password,
  }) =>
      _authService.login(email: email, password: password);

  Future<bool> sendForgotPasswordEmail(String email) =>
      _authService.sendForgotPasswordEmail(email);

  Future<bool> sendCollegeEmailOtp(String email) =>
      _authService.sendCollegeEmailOtp(email);

  Future<UserModel> verifyCollegeEmailOtp({
    required String email,
    required String otpCode,
  }) =>
      _authService.verifyCollegeEmailOtp(email: email, otpCode: otpCode);

  Future<UserModel> submitCollegeIdVerification({
    required String userId,
    required String studentIdNumber,
    required String documentFileName,
  }) =>
      _authService.submitCollegeIdVerification(
        userId: userId,
        studentIdNumber: studentIdNumber,
        documentFileName: documentFileName,
      );

  Future<UserModel> updateProfile({
    required String userId,
    String? name,
    String? department,
    String? academicYear,
    String? avatarUrl,
  }) =>
      _authService.updateProfile(
        userId: userId,
        name: name,
        department: department,
        academicYear: academicYear,
        avatarUrl: avatarUrl,
      );

  Future<void> logout() => _authService.logout();
}
