import '../models/academic_resource_model.dart';
import '../services/resource_service.dart';

class ResourceRepository {
  final ResourceService _resourceService;

  ResourceRepository({ResourceService? resourceService})
      : _resourceService = resourceService ?? MockResourceService();

  Future<List<AcademicResourceModel>> getResources({
    String? category,
    String? resourceType,
    String? searchQuery,
    String? university,
  }) =>
      _resourceService.fetchResources(
        category: category,
        resourceType: resourceType,
        searchQuery: searchQuery,
        university: university,
      );

  Future<AcademicResourceModel> getResourceById(String id) =>
      _resourceService.getResourceById(id);

  Future<AcademicResourceModel> createResource(AcademicResourceModel resource) =>
      _resourceService.createResource(resource);

  Future<bool> deleteResource(String id) =>
      _resourceService.deleteResource(id);
}
