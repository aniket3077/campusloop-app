import '../models/request_model.dart';

/// Request REST API Service Interface designed for Google Cloud backend deployment (Cloud Run)
abstract class RequestService {
  Future<RequestModel> createRequest(RequestModel request);
  Future<List<RequestModel>> getRequestsForUser(String userId);
  Future<List<RequestModel>> getAllRequests();
}

/// Cloud Run Request API Service Mock Driver
class CloudRunRequestService implements RequestService {
  final List<RequestModel> _requests = [];

  // Cloud Run API endpoint route
  static const String requestEndpoint = '/api/v1/requests';

  @override
  Future<RequestModel> createRequest(RequestModel request) async {
    await Future.delayed(const Duration(milliseconds: 400));
    _requests.insert(0, request);
    return request;
  }

  @override
  Future<List<RequestModel>> getRequestsForUser(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _requests.where((r) => r.requesterId == userId).toList();
  }

  @override
  Future<List<RequestModel>> getAllRequests() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_requests);
  }
}
