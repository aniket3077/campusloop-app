import '../models/user_model.dart';
import 'auth_api_service.dart';

abstract class AuthService {
  Future<UserModel?> getCurrentUser();
  Future<UserModel> register({
    required String fullName,
    required String email,
    required String university,
    required String department,
    required String academicYear,
    required String password,
  });
  Future<UserModel> login({required String email, required String password});
  Future<bool> sendForgotPasswordEmail(String email);
  Future<bool> sendCollegeEmailOtp(String email);
  Future<UserModel> verifyCollegeEmailOtp({required String email, required String otpCode});
  Future<UserModel> submitCollegeIdVerification({
    required String userId,
    required String studentIdNumber,
    required String documentFileName,
  });
  Future<void> logout();
}

class MockAuthService implements AuthService {
  final AuthApiService _apiService;

  MockAuthService({AuthApiService? apiService})
      : _apiService = apiService ?? CloudRunAuthApiService();

  UserModel? _currentUser = UserModel.mockUser;

  @override
  Future<UserModel?> getCurrentUser() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _currentUser;
  }

  @override
  Future<UserModel> register({
    required String fullName,
    required String email,
    required String university,
    required String department,
    required String academicYear,
    required String password,
  }) async {
    _currentUser = await _apiService.register(
      fullName: fullName,
      email: email,
      university: university,
      department: department,
      academicYear: academicYear,
      password: password,
    );
    return _currentUser!;
  }

  @override
  Future<UserModel> login({required String email, required String password}) async {
    _currentUser = await _apiService.login(email: email, password: password);
    return _currentUser!;
  }

  @override
  Future<bool> sendForgotPasswordEmail(String email) async {
    return await _apiService.sendForgotPasswordEmail(email);
  }

  @override
  Future<bool> sendCollegeEmailOtp(String email) async {
    return await _apiService.sendCollegeEmailOtp(email);
  }

  @override
  Future<UserModel> verifyCollegeEmailOtp({
    required String email,
    required String otpCode,
  }) async {
    _currentUser = await _apiService.verifyCollegeEmailOtp(email: email, otpCode: otpCode);
    return _currentUser!;
  }

  @override
  Future<UserModel> submitCollegeIdVerification({
    required String userId,
    required String studentIdNumber,
    required String documentFileName,
  }) async {
    _currentUser = await _apiService.submitCollegeIdVerification(
      userId: userId,
      studentIdNumber: studentIdNumber,
      documentFileName: documentFileName,
    );
    return _currentUser!;
  }

  @override
  Future<void> logout() async {
    await _apiService.logout();
    _currentUser = null;
  }
}
