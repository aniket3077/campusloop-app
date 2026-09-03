import '../models/academic_resource_model.dart';

abstract class ResourceService {
  Future<List<AcademicResourceModel>> fetchResources({
    String? category,
    String? resourceType,
    String? searchQuery,
    String? university,
  });

  Future<AcademicResourceModel> getResourceById(String id);
  Future<AcademicResourceModel> createResource(AcademicResourceModel resource);
  Future<bool> deleteResource(String id);
}

class MockResourceService implements ResourceService {
  final List<AcademicResourceModel> _items = List.from(AcademicResourceModel.mockResources);

  @override
  Future<List<AcademicResourceModel>> fetchResources({
    String? category,
    String? resourceType,
    String? searchQuery,
    String? university,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _items.where((item) {
      if (category != null && category != 'All Categories' && item.category != category) {
        return false;
      }
      if (resourceType != null && resourceType != 'All Types' && item.resourceType != resourceType.toUpperCase()) {
        return false;
      }
      if (searchQuery != null && searchQuery.isNotEmpty) {
        final query = searchQuery.toLowerCase();
        final matchTitle = item.title.toLowerCase().contains(query);
        final matchDesc = item.description.toLowerCase().contains(query);
        final matchCat = item.category.toLowerCase().contains(query);
        if (!matchTitle && !matchDesc && !matchCat) return false;
      }
      return true;
    }).toList();
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
