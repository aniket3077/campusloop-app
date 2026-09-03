/// Abstract REST API Service Interface designed for Cloud Run Backend deployment
abstract class ApiService {
  static const String baseUrl = 'https://campusloop-api-cloudrun.a.run.app/api/v1';

  Future<Map<String, dynamic>> get(String endpoint, {Map<String, String>? headers});
  Future<Map<String, dynamic>> post(String endpoint, {required Map<String, dynamic> body, Map<String, String>? headers});
  Future<Map<String, dynamic>> put(String endpoint, {required Map<String, dynamic> body, Map<String, String>? headers});
  Future<Map<String, dynamic>> delete(String endpoint, {Map<String, String>? headers});
}

/// Placeholder Mock ApiService Implementation
class MockApiService implements ApiService {
  @override
  Future<Map<String, dynamic>> get(String endpoint, {Map<String, String>? headers}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return {'status': 'success', 'data': {}};
  }

  @override
  Future<Map<String, dynamic>> post(String endpoint, {required Map<String, dynamic> body, Map<String, String>? headers}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return {'status': 'success', 'data': body};
  }

  @override
  Future<Map<String, dynamic>> put(String endpoint, {required Map<String, dynamic> body, Map<String, String>? headers}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return {'status': 'success', 'data': body};
  }

  @override
  Future<Map<String, dynamic>> delete(String endpoint, {Map<String, String>? headers}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return {'status': 'success'};
  }
}
