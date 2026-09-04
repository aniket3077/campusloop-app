import '../models/digital_product_model.dart';

/// Digital Product REST API Service Interface designed for Google Cloud backend deployment (Cloud Run)
abstract class DigitalProductService {
  Future<List<DigitalProductModel>> getDigitalProducts({String? searchQuery, String? provider});
  Future<DigitalProductModel> createDigitalListing(DigitalProductModel product);
  Future<DigitalProductModel> getDigitalProductById(String id);
  Future<String> revealSecureAccessCode(String productId, String transactionId);
}

/// Cloud Run Digital Product Service Implementation Driver
class CloudRunDigitalProductService implements DigitalProductService {
  final List<DigitalProductModel> _products = [];

  static const String digitalEndpoint = '/api/v1/digital-products';

  @override
  Future<List<DigitalProductModel>> getDigitalProducts({String? searchQuery, String? provider}) async {
    await Future.delayed(const Duration(milliseconds: 250));
    return _products.where((p) {
      if (provider != null && provider.isNotEmpty && p.providerPlatform != provider) return false;
      if (searchQuery != null && searchQuery.isNotEmpty) {
        final query = searchQuery.toLowerCase();
        final matchCourse = p.courseName.toLowerCase().contains(query);
        final matchProvider = p.providerPlatform.toLowerCase().contains(query);
        final matchDesc = p.description.toLowerCase().contains(query);
        if (!matchCourse && !matchProvider && !matchDesc) return false;
      }
      return true;
    }).toList();
  }

  @override
  Future<DigitalProductModel> createDigitalListing(DigitalProductModel product) async {
    await Future.delayed(const Duration(milliseconds: 400));
    _products.insert(0, product);
    return product;
  }

  @override
  Future<DigitalProductModel> getDigitalProductById(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _products.firstWhere((p) => p.id == id, orElse: () => _products.first);
  }

  @override
  Future<String> revealSecureAccessCode(String productId, String transactionId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final product = _products.firstWhere((p) => p.id == productId, orElse: () => _products.first);
    return product.secureAccessCode ?? 'ACCESS-CODE-VERIFIED-PEARSON-8820';
  }
}
