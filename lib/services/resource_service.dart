import '../models/academic_resource_model.dart';
import '../providers/resource_provider.dart';

abstract class ResourceService {
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
  });

  Future<AcademicResourceModel> getResourceById(String id);
  Future<AcademicResourceModel> createResource(AcademicResourceModel resource);
  Future<bool> deleteResource(String id);
}

class MockResourceService implements ResourceService {
  final List<AcademicResourceModel> _items = [];

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
    await Future.delayed(const Duration(milliseconds: 250));

    var filtered = _items.where((item) {
      // Course Code filter
      if (courseCode != null && courseCode != 'All' && courseCode != 'All Courses') {
        final code = item.courseCode ?? '';
        if (!code.toLowerCase().contains(courseCode.toLowerCase())) {
          return false;
        }
      }

      // Category filter
      if (category != null && category != 'All' && category != 'All Categories' && item.category != category) {
        return false;
      }

      // Resource Type filter
      if (resourceType != null && resourceType != 'All Types' && item.resourceType != resourceType.toUpperCase()) {
        return false;
      }

      // Search Query filter across: Item Name, Category, Description, Course Code
      if (searchQuery != null && searchQuery.isNotEmpty) {
        final query = searchQuery.toLowerCase();
        final matchTitle = item.title.toLowerCase().contains(query);
        final matchDesc = item.description.toLowerCase().contains(query);
        final matchCat = item.category.toLowerCase().contains(query);
        final matchCourse = (item.courseCode ?? '').toLowerCase().contains(query);
        if (!matchTitle && !matchDesc && !matchCat && !matchCourse) return false;
      }

      // Price Range filter
      if (minPrice != null && item.price < minPrice) return false;
      if (maxPrice != null && maxPrice < 200 && item.price > maxPrice) return false;

      // Condition filter
      if (condition != null && condition != 'All' && item.condition != condition) {
        return false;
      }

      // Pickup Location filter
      if (pickupLocation != null && pickupLocation != 'All Locations' && item.pickupLocation != pickupLocation) {
        return false;
      }

      // Availability filter
      if (availableOnly == true && !item.isAvailable) {
        return false;
      }

      return true;
    }).toList();

    // Sorting Logic
    if (sortOption != null) {
      switch (sortOption) {
        case SortOption.newest:
          filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          break;
        case SortOption.priceAsc:
          filtered.sort((a, b) => a.price.compareTo(b.price));
          break;
        case SortOption.priceDesc:
          filtered.sort((a, b) => b.price.compareTo(a.price));
          break;
        case SortOption.highestRating:
          filtered.sort((a, b) => b.sellerRating.compareTo(a.sellerRating));
          break;
        case SortOption.nearby:
          filtered.sort((a, b) {
            final aIsNearby = a.isNearby ? 0 : 1;
            final bIsNearby = b.isNearby ? 0 : 1;
            return aIsNearby.compareTo(bIsNearby);
          });
          break;
      }
    }

    return filtered;
  }

  @override
  Future<AcademicResourceModel> getResourceById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _items.firstWhere((r) => r.id == id, orElse: () => _items.first);
  }

  @override
  Future<AcademicResourceModel> createResource(AcademicResourceModel resource) async {
    await Future.delayed(const Duration(milliseconds: 400));
    _items.insert(0, resource);
    return resource;
  }

  @override
  Future<bool> deleteResource(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _items.removeWhere((r) => r.id == id);
    return true;
  }
}
