import 'package:flutter/foundation.dart';
import '../../models/academic_resource_model.dart';
import '../../models/pickup_location_model.dart';
import '../../models/user_model.dart';
import 'firebase_manager.dart';

/// Database seeding and initialization utility for Google Cloud Firestore
class FirestoreSeeder {
  FirestoreSeeder._();

  /// Automatically seeds Firestore collections if they are currently empty
  static Future<void> seedIfEmpty() async {
    final firestore = FirebaseManager.firestore;
    if (firestore == null) {
      debugPrint('[FirestoreSeeder] Firebase not active, skipping seed.');
      return;
    }

    try {
      // 1. Seed Resources if empty
      final resSnapshot = await firestore
          .collection(FirebaseManager.colResources)
          .limit(1)
          .get();

      if (resSnapshot.docs.isEmpty) {
        debugPrint('[FirestoreSeeder] Seeding initial resources to Cloud Firestore...');
        final batch = firestore.batch();
        for (final item in AcademicResourceModel.mockResources) {
          final docRef = firestore.collection(FirebaseManager.colResources).doc(item.id);
          batch.set(docRef, item.toJson());
        }
        await batch.commit();
        debugPrint('[FirestoreSeeder] Successfully seeded resources.');
      }

      // 2. Seed Pickup Locations if empty
      final locSnapshot = await firestore
          .collection(FirebaseManager.colPickupLocations)
          .limit(1)
          .get();

      if (locSnapshot.docs.isEmpty) {
        debugPrint('[FirestoreSeeder] Seeding campus pickup safe zones to Cloud Firestore...');
        final batch = firestore.batch();
        for (final loc in PickupLocationModel.adminConfiguredLocations) {
          final docRef = firestore.collection(FirebaseManager.colPickupLocations).doc(loc.id);
          batch.set(docRef, loc.toJson());
        }
        await batch.commit();
        debugPrint('[FirestoreSeeder] Successfully seeded pickup locations.');
      }

      // 3. Seed Mock User if empty
      final userSnapshot = await firestore
          .collection(FirebaseManager.colUsers)
          .doc(UserModel.mockUser.id)
          .get();

      if (!userSnapshot.exists) {
        await firestore
            .collection(FirebaseManager.colUsers)
            .doc(UserModel.mockUser.id)
            .set(UserModel.mockUser.toJson());
        debugPrint('[FirestoreSeeder] Seeded default user profile.');
      }
    } catch (e) {
      debugPrint('[FirestoreSeeder] Notice during seeding: $e');
    }
  }

  /// Manually force-seeds or updates sample data in Firestore
  static Future<bool> forceSeed() async {
    final firestore = FirebaseManager.firestore;
    if (firestore == null) return false;

    try {
      final batch = firestore.batch();
      for (final item in AcademicResourceModel.mockResources) {
        final docRef = firestore.collection(FirebaseManager.colResources).doc(item.id);
        batch.set(docRef, item.toJson());
      }
      for (final loc in PickupLocationModel.adminConfiguredLocations) {
        final docRef = firestore.collection(FirebaseManager.colPickupLocations).doc(loc.id);
        batch.set(docRef, loc.toJson());
      }
      batch.set(
        firestore.collection(FirebaseManager.colUsers).doc(UserModel.mockUser.id),
        UserModel.mockUser.toJson(),
      );
      await batch.commit();
      return true;
    } catch (e) {
      debugPrint('[FirestoreSeeder] Force seed error: $e');
      return false;
    }
  }
}
