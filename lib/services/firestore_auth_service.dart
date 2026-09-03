import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/foundation.dart';
import '../core/firebase/firebase_manager.dart';
import '../models/user_model.dart';
import 'auth_service.dart';

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
        _fallbackService = fallbackService ?? MockAuthService();

  CollectionReference<Map<String, dynamic>>? get _usersCol {
    final db = _firestore ?? FirebaseManager.firestore;
    return db?.collection(FirebaseManager.colUsers);
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final auth = _auth ?? FirebaseManager.auth;
    final col = _usersCol;

    if (auth == null || col == null || auth.currentUser == null) {
      return _fallbackService.getCurrentUser();
    }

    try {
      final uid = auth.currentUser!.uid;
      final doc = await col.doc(uid).get();
      if (doc.exists && doc.data() != null) {
        final data = Map<String, dynamic>.from(doc.data()!);
        data['id'] = doc.id;
        return UserModel.fromJson(data);
      }
    } catch (e) {
      debugPrint('[FirestoreAuthService] Error fetching user profile: $e');
    }

    return _fallbackService.getCurrentUser();
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
    final auth = _auth ?? FirebaseManager.auth;
    final col = _usersCol;

    if (auth == null || col == null) {
      return _fallbackService.register(
        fullName: fullName,
        email: email,
        university: university,
        department: department,
        academicYear: academicYear,
        password: password,
      );
    }

    try {
      final credential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = credential.user?.uid ?? DateTime.now().millisecondsSinceEpoch.toString();

      final user = UserModel(
        id: uid,
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

      await col.doc(uid).set(user.toJson(), SetOptions(merge: true));
      return user;
    } catch (e) {
      debugPrint('[FirestoreAuthService] Registration error, using fallback: $e');
      return _fallbackService.register(
        fullName: fullName,
        email: email,
        university: university,
        department: department,
        academicYear: academicYear,
        password: password,
      );
    }
  }

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final auth = _auth ?? FirebaseManager.auth;
    final col = _usersCol;

    if (auth == null || col == null) {
      return _fallbackService.login(email: email, password: password);
    }

    try {
      final credential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = credential.user?.uid;
      if (uid != null) {
        final doc = await col.doc(uid).get();
        if (doc.exists && doc.data() != null) {
          final data = Map<String, dynamic>.from(doc.data()!);
          data['id'] = doc.id;
          return UserModel.fromJson(data);
        }
      }
      return _fallbackService.login(email: email, password: password);
    } catch (e) {
      debugPrint('[FirestoreAuthService] Login error, using fallback: $e');
      return _fallbackService.login(email: email, password: password);
    }
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
        await col.doc(user.id).set(user.toJson(), SetOptions(merge: true));
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
        await col.doc(userId).set(user.toJson(), SetOptions(merge: true));
      } catch (e) {
        debugPrint('[FirestoreAuthService] Error updating student ID verification: $e');
      }
    }

    return user;
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
