import 'package:flutter/material.dart';
import '../models/academic_resource_model.dart';
import '../repositories/resource_repository.dart';

class ResourceProvider extends ChangeNotifier {
  final ResourceRepository _repository;

  List<AcademicResourceModel> _resources = [];
  bool _isLoading = false;
  String? _errorMessage;

  String _selectedCategory = 'All Categories';
  String _selectedType = 'All Types';
  String _searchQuery = '';

  ResourceProvider({ResourceRepository? repository})
      : _repository = repository ?? ResourceRepository() {
    loadResources();
  }

  List<AcademicResourceModel> get resources => _resources;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get selectedCategory => _selectedCategory;
  String get selectedType => _selectedType;
  String get searchQuery => _searchQuery;

  Future<void> loadResources() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _resources = await _repository.getResources(
        category: _selectedCategory,
        resourceType: _selectedType,
        searchQuery: _searchQuery,
      );
    } catch (e) {
      _errorMessage = 'Failed to load campus resources.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
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

  Future<bool> addResource(AcademicResourceModel resource) async {
    try {
      final created = await _repository.createResource(resource);
      _resources.insert(0, created);
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }
}
