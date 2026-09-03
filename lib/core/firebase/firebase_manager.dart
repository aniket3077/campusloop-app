import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'firebase_options.dart';

/// Centralized Firebase and Google Cloud initialization & status manager
class FirebaseManager {
  FirebaseManager._();

  static bool _initialized = false;
  static String? _initError;

  /// Returns true if Firebase has been successfully initialized
  static bool get isInitialized => _initialized;

  /// Returns error string if Firebase initialization encountered an issue
  static String? get initError => _initError;

  /// Firestore database instance (null if not initialized)
  static FirebaseFirestore? get firestore =>
      _initialized ? FirebaseFirestore.instance : null;

  /// Firebase Auth instance (null if not initialized)
  static FirebaseAuth? get auth =>
      _initialized ? FirebaseAuth.instance : null;

  /// Firebase Storage instance (null if not initialized)
  static FirebaseStorage? get storage =>
      _initialized ? FirebaseStorage.instance : null;

  /// Firestore Collection Names
  static const String colUsers = 'users';
  static const String colResources = 'resources';
  static const String colChats = 'chats';
  static const String colMessages = 'messages';
  static const String colTransactions = 'transactions';
  static const String colOffers = 'offers';
  static const String colDigitalProducts = 'digital_products';
  static const String colPickupLocations = 'pickup_locations';
  static const String colRequests = 'requests';
  static const String colReports = 'reports';

  /// Initializes Firebase with platform options and graceful fallback
  static Future<bool> initialize() async {
    if (_initialized) return true;

    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      }
      _initialized = true;
      _initError = null;

      // Enable offline persistence for Firestore if available
      try {
        FirebaseFirestore.instance.settings = const Settings(
          persistenceEnabled: true,
          cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
        );
      } catch (e) {
        debugPrint('[FirebaseManager] Persistence configuration notice: $e');
      }

      debugPrint('[FirebaseManager] Firebase & Cloud Firestore initialized successfully.');
      return true;
    } catch (e, st) {
      _initialized = false;
      _initError = e.toString();
      debugPrint('[FirebaseManager] Firebase initialization notice (falling back to local mock): $e\n$st');
      return false;
    }
  }
}
