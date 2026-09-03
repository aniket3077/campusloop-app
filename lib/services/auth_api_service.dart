import '../models/user_model.dart';

/// Abstract REST API Service Interface for Google Cloud backend (Cloud Run)
abstract class AuthApiService {
  Future<UserModel> register({
    required String fullName,
    required String email,
    required String university,
    required String department,
    required String academicYear,
    required String password,
  });

  Future<UserModel> login({
    required String email,
    required String password,
  });

  Future<bool> sendForgotPasswordEmail(String email);

  Future<bool> sendCollegeEmailOtp(String email);

  Future<UserModel> verifyCollegeEmailOtp({
    required String email,
    required String otpCode,
  });

  Future<UserModel> submitCollegeIdVerification({
    required String userId,
    required String studentIdNumber,
    required String documentFileName,
  });

  Future<StudentVerificationStatus> fetchVerificationStatus(String userId);

  Future<void> logout();
}

/// Cloud Run Auth API Service Mock/Production Driver
class CloudRunAuthApiService implements AuthApiService {
  UserModel? _sessionUser;

  // Endpoint routes for Cloud Run backend implementation
  static const String registerEndpoint = '/api/v1/auth/register';
  static const String loginEndpoint = '/api/v1/auth/login';
  static const String forgotPasswordEndpoint = '/api/v1/auth/forgot-password';
  static const String sendOtpEndpoint = '/api/v1/auth/send-verification-email';
  static const String verifyOtpEndpoint = '/api/v1/auth/verify-email-code';
  static const String submitIdEndpoint = '/api/v1/auth/submit-student-id';
  static const String statusEndpoint = '/api/v1/auth/verification-status';

  @override
  Future<UserModel> register({
    required String fullName,
    required String email,
    required String university,
    required String department,
    required String academicYear,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));
    _sessionUser = UserModel(
      id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
      name: fullName,
      email: email,
      university: university,
      department: department,
      academicYear: academicYear,
      verificationStatus: StudentVerificationStatus.emailPending,
      trustRating: 5.0,
      totalTransactions: 0,
      co2SavedKg: 0.0,
      moneySavedUsd: 0.0,
      itemsCirculated: 0,
    );
    return _sessionUser!;
  }

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _sessionUser = UserModel(
      id: 'usr_101',
      name: email.split('@').first.replaceAll('.', ' '),
      email: email,
      university: 'Stanford University',
      department: 'Computer Science & Engineering',
      academicYear: 'Senior (4th Year)',
      verificationStatus: StudentVerificationStatus.verified,
      trustRating: 4.9,
      totalTransactions: 15,
      co2SavedKg: 38.0,
      moneySavedUsd: 320.0,
      itemsCirculated: 10,
    );
    return _sessionUser!;
  }

  @override
  Future<bool> sendForgotPasswordEmail(String email) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return true;
  }

  @override
  Future<bool> sendCollegeEmailOtp(String email) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return true;
  }

  @override
  Future<UserModel> verifyCollegeEmailOtp({
    required String email,
    required String otpCode,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (_sessionUser != null) {
      _sessionUser = _sessionUser!.copyWith(
        verificationStatus: StudentVerificationStatus.idPending,
      );
      return _sessionUser!;
    }
    throw Exception('Session expired');
  }

  @override
  Future<UserModel> submitCollegeIdVerification({
    required String userId,
    required String studentIdNumber,
    required String documentFileName,
  }) async {
    await Future.delayed(const Duration(milliseconds: 700));
    if (_sessionUser != null) {
      _sessionUser = _sessionUser!.copyWith(
        verificationStatus: StudentVerificationStatus.verified,
        verifiedAt: DateTime.now(),
      );
      return _sessionUser!;
    }
    throw Exception('User not logged in');
  }

  @override
  Future<StudentVerificationStatus> fetchVerificationStatus(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _sessionUser?.verificationStatus ?? StudentVerificationStatus.unverified;
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _sessionUser = null;
  }
}
