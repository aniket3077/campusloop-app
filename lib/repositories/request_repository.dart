import '../models/request_model.dart';
import '../services/request_service.dart';

class RequestRepository {
  final RequestService _requestService;

  RequestRepository({RequestService? requestService})
      : _requestService = requestService ?? CloudRunRequestService();

  Future<RequestModel> createRequest(RequestModel request) =>
      _requestService.createRequest(request);

  Future<List<RequestModel>> getRequestsForUser(String userId) =>
      _requestService.getRequestsForUser(userId);

  Future<List<RequestModel>> getAllRequests() =>
      _requestService.getAllRequests();
}
