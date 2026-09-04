import 'package:flutter/material.dart';
import '../models/academic_resource_model.dart';
import '../repositories/resource_repository.dart';
import '../services/backend_api_service.dart';

enum SortOption {
  newest,
  priceAsc,
  priceDesc,
  highestRating,
  nearby,
}

class ResourceProvider extends ChangeNotifier {
  final ResourceRepository _repository;

  List<AcademicResourceModel> _resources = [];
  bool _isLoading = false;
  String? _errorMessage;

  String _selectedCategory = 'All';
  String _selectedType = 'All Types';
  String _selectedCourse = 'All Courses';
  String _searchQuery = '';
  RangeValues _priceRange = const RangeValues(0, 5000);
  String _selectedCondition = 'All';
  String _selectedLocation = 'All Locations';
  bool _availableOnly = false;
  SortOption _sortOption = SortOption.newest;

  ResourceProvider({ResourceRepository? repository})
      : _repository = repository ?? ResourceRepository() {
    loadResources();
  }

  List<AcademicResourceModel> get resources => _resources;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  String get selectedCategory => _selectedCategory;
  String get selectedType => _selectedType;
  String get selectedCourse => _selectedCourse;
  String get searchQuery => _searchQuery;
  RangeValues get priceRange => _priceRange;
  String get selectedCondition => _selectedCondition;
  String get selectedLocation => _selectedLocation;
  bool get availableOnly => _availableOnly;
  SortOption get sortOption => _sortOption;

  Future<void> loadResources() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _resources = await _repository.getResources(
        category: _selectedCategory,
        resourceType: _selectedType,
        searchQuery: _searchQuery,
        minPrice: _priceRange.start,
        maxPrice: _priceRange.end,
        condition: _selectedCondition,
        pickupLocation: _selectedLocation,
        availableOnly: _availableOnly,
        sortOption: _sortOption,
        courseCode: _selectedCourse,
      );
    } catch (e) {
      _errorMessage = 'Failed to load campus resources.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setCourse(String course) {
    if (_selectedCourse == course) return;
    _selectedCourse = course;
    loadResources();
  }

  void setCategory(String category) {
    if (_selectedCategory == category) return;
    _selectedCategory = category;
    loadResources();
  }

  void setResourceType(String type) {
    if (_selectedType == type) return;
    _selectedType = type;
    loadResources();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    loadResources();
  }

  void applyFilterOptions({
    required String resourceType,
    required RangeValues priceRange,
    required String condition,
    required String location,
    required bool availableOnly,
  }) {
    _selectedType = resourceType;
    _priceRange = priceRange;
    _selectedCondition = condition;
    _selectedLocation = location;
    _availableOnly = availableOnly;
    loadResources();
  }

  void setSortOption(SortOption option) {
    if (_sortOption == option) return;
    _sortOption = option;
    loadResources();
  }

  Future<bool> addResource(AcademicResourceModel resource) async {
    try {
      // 1. Persist directly to Supabase PostgreSQL via backend API
      final backendItem = await BackendApiService.createItem({
        'title': resource.title,
        'description': resource.description,
        'category': resource.category,
        'condition': resource.condition,
        'price': resource.price,
        'transactionType': resource.resourceType,
        'courseCode': resource.courseCode,
        'images': resource.imageUrls,
        'pickupLocationName': resource.pickupLocation,
        'isRecommended': true,
        'isNearby': true,
      });

      // Use the live Supabase model if returned
      final finalResource = (backendItem != null && backendItem['id'] != null)
          ? AcademicResourceModel.fromJson(backendItem)
          : resource.copyWith(isRecommended: true, isNearby: true);

      _resources.insert(0, finalResource);
      notifyListeners();

      // Background local repository cache
      _repository.createResource(finalResource).catchError((_) => finalResource);

      return true;
    } catch (e) {
      debugPrint('[ResourceProvider] Error adding resource: $e');
      _resources.insert(0, resource);
      notifyListeners();
      return true;
    }
  }
}
