import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/foundation.dart';
import '../core/firebase/firebase_manager.dart';
import '../models/user_model.dart';
import 'auth_api_service.dart';
import 'auth_service.dart';
import 'backend_api_service.dart';

/// Concrete Google Cloud Firestore & Firebase Auth implementation of [AuthService]
class FirestoreAuthService implements AuthService {
  final fb.FirebaseAuth? _auth;
  final FirebaseFirestore? _firestore;
  final AuthService _fallbackService;

  FirestoreAuthService({
    fb.FirebaseAuth? auth,
    FirebaseFirestore? firestore,
    AuthService? fallbackService,
  })  : _auth = auth ?? FirebaseManager.auth,
        _firestore = firestore ?? FirebaseManager.firestore,
        _fallbackService = fallbackService ?? MockAuthService(apiService: CloudRunAuthApiService());

  CollectionReference<Map<String, dynamic>>? get _usersCol {
    final db = _firestore ?? FirebaseManager.firestore;
    return db?.collection(FirebaseManager.colUsers);
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    // 1. Try session user from CloudRunAuthApiService
    final sessionUser = await _fallbackService.getCurrentUser();
    if (sessionUser != null) {
      return sessionUser;
    }

    // 2. Try fetching from PostgreSQL backend using stored token
    try {
      final me = await BackendApiService.getCurrentUser();
      if (me != null && me['id'] != null) {
        return UserModel.fromJson(me);
      }
    } catch (_) {}

    return null;
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
    // 1. Connect and register with live PostgreSQL backend
    final user = await _fallbackService.register(
      fullName: fullName,
      email: email,
      university: university,
      department: department,
      academicYear: academicYear,
      password: password,
    );

    // 2. Optional Firestore sync with fast timeout
    final col = _usersCol;
    if (col != null && user.id.isNotEmpty) {
      try {
        await col
            .doc(user.id)
            .set(user.toJson(), SetOptions(merge: true))
            .timeout(const Duration(seconds: 2));
      } catch (_) {}
    }

    return user;
  }

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    // 1. Authenticate with live PostgreSQL backend
    final user = await _fallbackService.login(email: email, password: password);

    // 2. Optional Firestore sync with fast timeout
    final col = _usersCol;
    if (col != null && user.id.isNotEmpty) {
      try {
        await col
            .doc(user.id)
            .set(user.toJson(), SetOptions(merge: true))
            .timeout(const Duration(seconds: 2));
      } catch (_) {}
    }

    return user;
  }

  @override
  Future<bool> sendForgotPasswordEmail(String email) async {
    final auth = _auth ?? FirebaseManager.auth;
    if (auth != null) {
      try {
        await auth.sendPasswordResetEmail(email: email);
        return true;
      } catch (e) {
        debugPrint('[FirestoreAuthService] Password reset notice: $e');
      }
    }
    return _fallbackService.sendForgotPasswordEmail(email);
  }

  @override
  Future<bool> sendCollegeEmailOtp(String email) =>
      _fallbackService.sendCollegeEmailOtp(email);

  @override
  Future<UserModel> verifyCollegeEmailOtp({
    required String email,
    required String otpCode,
  }) async {
    final user = await _fallbackService.verifyCollegeEmailOtp(
      email: email,
      otpCode: otpCode,
    );

    final col = _usersCol;
    if (col != null && user.id.isNotEmpty) {
      try {
        await col
            .doc(user.id)
            .set(user.toJson(), SetOptions(merge: true))
            .timeout(const Duration(seconds: 3));
      } catch (e) {
        debugPrint('[FirestoreAuthService] Error updating user verification in Firestore: $e');
      }
    }

    return user;
  }

  @override
  Future<UserModel> submitCollegeIdVerification({
    required String userId,
    required String studentIdNumber,
    required String documentFileName,
  }) async {
    final user = await _fallbackService.submitCollegeIdVerification(
      userId: userId,
      studentIdNumber: studentIdNumber,
      documentFileName: documentFileName,
    );

    final col = _usersCol;
    if (col != null && userId.isNotEmpty) {
      try {
        await col
            .doc(userId)
            .set(user.toJson(), SetOptions(merge: true))
            .timeout(const Duration(seconds: 3));
      } catch (e) {
        debugPrint('[FirestoreAuthService] Error updating student ID verification: $e');
      }
    }

    return user;
  }

  @override
  Future<UserModel> updateProfile({
    required String userId,
    String? name,
    String? department,
    String? academicYear,
    String? avatarUrl,
  }) async {
    final col = _usersCol;
    if (col != null && userId.isNotEmpty) {
      try {
        final updateData = <String, dynamic>{};
        if (name != null) updateData['name'] = name;
        if (department != null) updateData['department'] = department;
        if (academicYear != null) updateData['academicYear'] = academicYear;
        if (avatarUrl != null) updateData['avatarUrl'] = avatarUrl;
        await col.doc(userId).set(updateData, SetOptions(merge: true));
      } catch (e) {
        debugPrint('[FirestoreAuthService] Error updating profile in Firestore: $e');
      }
    }

    return _fallbackService.updateProfile(
      userId: userId,
      name: name,
      department: department,
      academicYear: academicYear,
      avatarUrl: avatarUrl,
    );
  }

  @override
  Future<void> logout() async {
    final auth = _auth ?? FirebaseManager.auth;
    if (auth != null) {
      try {
        await auth.signOut();
      } catch (e) {
        debugPrint('[FirestoreAuthService] SignOut error: $e');
      }
    }
    return _fallbackService.logout();
  }
}
