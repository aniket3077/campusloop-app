import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../core/firebase/firebase_manager.dart';
import '../models/academic_resource_model.dart';
import '../providers/resource_provider.dart';
import 'backend_api_service.dart';
import 'resource_service.dart';

/// Concrete Google Cloud Firestore & Cloud Run REST implementation of [ResourceService]
class FirestoreResourceService implements ResourceService {
  final FirebaseFirestore? _firestore;
  final ResourceService _fallbackService;

  FirestoreResourceService({
    FirebaseFirestore? firestore,
    ResourceService? fallbackService,
  })  : _firestore = firestore ?? FirebaseManager.firestore,
        _fallbackService = fallbackService ?? MockResourceService();

  CollectionReference<Map<String, dynamic>>? get _collection {
    final db = _firestore ?? FirebaseManager.firestore;
    return db?.collection(FirebaseManager.colResources);
  }

  @override
  Future<List<AcademicResourceModel>> fetchResources({
    String? category,
    String? resourceType,
    String? searchQuery,
    double? minPrice,
    double? maxPrice,
    String? condition,
    String? pickupLocation,
    bool? availableOnly,
    SortOption? sortOption,
    String? courseCode,
    String? university,
  }) async {
    // 1. Try fetching live from Cloud Run REST backend (Supabase PostgreSQL via Prisma)
    try {
      final backendItems = await BackendApiService.fetchItems(
        category: category,
        transactionType: resourceType,
        searchQuery: searchQuery,
        courseCode: courseCode,
      );

      if (backendItems != null && backendItems.isNotEmpty) {
        final items = backendItems
            .map((json) => AcademicResourceModel.fromJson(json))
            .toList();

        return _applyFiltersAndSort(
          items,
          courseCode: courseCode,
          searchQuery: searchQuery,
          minPrice: minPrice,
          maxPrice: maxPrice,
          condition: condition,
          pickupLocation: pickupLocation,
          availableOnly: availableOnly,
          sortOption: sortOption,
        );
      }
    } catch (e) {
      debugPrint('[FirestoreResourceService] Cloud Run backend notice: $e');
    }

    // 2. Try Firestore
    final col = _collection;
    if (col == null) {
      return _fallbackService.fetchResources(
        category: category,
        resourceType: resourceType,
        searchQuery: searchQuery,
        minPrice: minPrice,
        maxPrice: maxPrice,
        condition: condition,
        pickupLocation: pickupLocation,
        availableOnly: availableOnly,
        sortOption: sortOption,
        courseCode: courseCode,
        university: university,
      );
    }

    try {
      Query<Map<String, dynamic>> query = col;

      if (availableOnly == true) {
        query = query.where('isAvailable', isEqualTo: true);
      }

      if (category != null && category != 'All' && category != 'All Categories') {
        query = query.where('category', isEqualTo: category);
      }

      if (resourceType != null && resourceType != 'All Types') {
        query = query.where('resourceType', isEqualTo: resourceType.toUpperCase());
      }

      final snapshot = await query.get().timeout(const Duration(seconds: 4));

      // If Firestore is empty, fallback to curated MIT CSN mock data
      if (snapshot.docs.isEmpty) {
        return await _fallbackService.fetchResources(
          category: category,
          resourceType: resourceType,
          searchQuery: searchQuery,
          minPrice: minPrice,
          maxPrice: maxPrice,
          condition: condition,
          pickupLocation: pickupLocation,
          availableOnly: availableOnly,
          sortOption: sortOption,
          courseCode: courseCode,
          university: university,
        );
      }

      final items = snapshot.docs.map((doc) {
        final data = Map<String, dynamic>.from(doc.data());
        data['id'] = doc.id;
        return AcademicResourceModel.fromJson(data);
      }).toList();

      return _applyFiltersAndSort(
        items,
        courseCode: courseCode,
        searchQuery: searchQuery,
        minPrice: minPrice,
        maxPrice: maxPrice,
        condition: condition,
        pickupLocation: pickupLocation,
        availableOnly: availableOnly,
        sortOption: sortOption,
      );
    } catch (e) {
      debugPrint('[FirestoreResourceService] Error querying Firestore, using fallback: $e');
      return _fallbackService.fetchResources(
        category: category,
        resourceType: resourceType,
        searchQuery: searchQuery,
        minPrice: minPrice,
        maxPrice: maxPrice,
        condition: condition,
        pickupLocation: pickupLocation,
        availableOnly: availableOnly,
        sortOption: sortOption,
        courseCode: courseCode,
        university: university,
      );
    }
  }

  List<AcademicResourceModel> _applyFiltersAndSort(
    List<AcademicResourceModel> rawItems, {
    String? courseCode,
    String? searchQuery,
    double? minPrice,
    double? maxPrice,
    String? condition,
    String? pickupLocation,
    bool? availableOnly,
    SortOption? sortOption,
  }) {
    var items = rawItems;

    if (courseCode != null && courseCode != 'All' && courseCode != 'All Courses') {
      items = items
          .where((item) => (item.courseCode ?? '')
              .toLowerCase()
              .contains(courseCode.toLowerCase()))
          .toList();
    }

    if (searchQuery != null && searchQuery.trim().isNotEmpty) {
      final q = searchQuery.toLowerCase().trim();
      items = items.where((item) {
        return item.title.toLowerCase().contains(q) ||
            item.description.toLowerCase().contains(q) ||
            item.category.toLowerCase().contains(q) ||
            (item.courseCode ?? '').toLowerCase().contains(q);
      }).toList();
    }

    if (minPrice != null) {
      items = items.where((item) => item.price >= minPrice).toList();
    }
    if (maxPrice != null && maxPrice < 200) {
      items = items.where((item) => item.price <= maxPrice).toList();
    }

    if (condition != null && condition != 'All') {
      items = items.where((item) => item.condition == condition).toList();
    }

    if (pickupLocation != null && pickupLocation != 'All Locations') {
      items = items
          .where((item) => item.pickupLocation == pickupLocation)
          .toList();
    }

    if (availableOnly == true) {
      items = items.where((item) => item.isAvailable).toList();
    }

    // Sort
    if (sortOption != null) {
      switch (sortOption) {
        case SortOption.newest:
          items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          break;
        case SortOption.priceAsc:
          items.sort((a, b) => a.price.compareTo(b.price));
          break;
        case SortOption.priceDesc:
          items.sort((a, b) => b.price.compareTo(a.price));
          break;
        case SortOption.highestRating:
          items.sort((a, b) => b.sellerRating.compareTo(a.sellerRating));
          break;
        case SortOption.nearby:
          items.sort((a, b) {
            final aIsNearby = a.isNearby ? 0 : 1;
            final bIsNearby = b.isNearby ? 0 : 1;
            return aIsNearby.compareTo(bIsNearby);
          });
          break;
      }
    }

    return items;
  }

  @override
  Future<AcademicResourceModel> getResourceById(String id) async {
    final col = _collection;
    if (col == null) return _fallbackService.getResourceById(id);

    try {
      final doc = await col.doc(id).get();
      if (doc.exists && doc.data() != null) {
        final data = Map<String, dynamic>.from(doc.data()!);
        data['id'] = doc.id;
        return AcademicResourceModel.fromJson(data);
      }
    } catch (e) {
      debugPrint('[FirestoreResourceService] Error fetching resource $id: $e');
    }
    return _fallbackService.getResourceById(id);
  }

  @override
  Future<AcademicResourceModel> createResource(AcademicResourceModel resource) async {
    // Sync directly to live Cloud Run Backend
    try {
      await BackendApiService.createItem({
        'title': resource.title,
        'description': resource.description,
        'category': resource.category,
        'condition': resource.condition,
        'price': resource.price,
        'transactionType': resource.resourceType,
        'courseCode': resource.courseCode,
        'images': resource.imageUrls,
        'pickupLocationName': resource.pickupLocation,
      });
    } catch (e) {
      debugPrint('[FirestoreResourceService] Cloud Run create item notice: $e');
    }

    final col = _collection;
    if (col == null) return _fallbackService.createResource(resource);

    try {
      final data = resource.toJson();
      if (resource.id.isNotEmpty) {
        await col.doc(resource.id).set(data, SetOptions(merge: true)).timeout(const Duration(seconds: 4));
      } else {
        final docRef = await col.add(data).timeout(const Duration(seconds: 4));
        return resource.copyWith(id: docRef.id);
      }
      return resource;
    } catch (e) {
      debugPrint('[FirestoreResourceService] Error saving resource to Firestore: $e');
      return _fallbackService.createResource(resource);
    }
  }

  @override
  Future<bool> deleteResource(String id) async {
    final col = _collection;
    if (col == null) return _fallbackService.deleteResource(id);

    try {
      await col.doc(id).delete();
      return true;
    } catch (e) {
      debugPrint('[FirestoreResourceService] Error deleting resource $id: $e');
      return _fallbackService.deleteResource(id);
    }
  }

  /// Real-time live Firestore Stream for resources
  Stream<List<AcademicResourceModel>> watchAvailableResources() {
    final col = _collection;
    if (col == null) {
      return Stream.value(AcademicResourceModel.mockResources);
    }

    return col
        .where('isAvailable', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = Map<String, dynamic>.from(doc.data());
        data['id'] = doc.id;
        return AcademicResourceModel.fromJson(data);
      }).toList();
    });
  }
}
