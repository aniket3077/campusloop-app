import '../models/academic_resource_model.dart';
import '../providers/resource_provider.dart';
import '../services/firestore_resource_service.dart';
import '../services/resource_service.dart';

class ResourceRepository {
  final ResourceService _resourceService;

  ResourceRepository({ResourceService? resourceService})
      : _resourceService = resourceService ?? FirestoreResourceService();

  Future<List<AcademicResourceModel>> getResources({
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
  }) =>
      _resourceService.fetchResources(
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

  Future<AcademicResourceModel> getResourceById(String id) =>
      _resourceService.getResourceById(id);

  Future<AcademicResourceModel> createResource(AcademicResourceModel resource) =>
      _resourceService.createResource(resource);

  Future<bool> deleteResource(String id) =>
      _resourceService.deleteResource(id);
}
