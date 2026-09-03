import '../models/digital_product_model.dart';
import '../services/digital_product_service.dart';

class DigitalProductRepository {
  final DigitalProductService _digitalService;

  DigitalProductRepository({DigitalProductService? digitalService})
      : _digitalService = digitalService ?? CloudRunDigitalProductService();

  Future<List<DigitalProductModel>> getDigitalProducts({String? searchQuery, String? provider}) =>
      _digitalService.getDigitalProducts(searchQuery: searchQuery, provider: provider);

  Future<DigitalProductModel> createDigitalListing(DigitalProductModel product) =>
      _digitalService.createDigitalListing(product);

  Future<DigitalProductModel> getDigitalProductById(String id) =>
      _digitalService.getDigitalProductById(id);

  Future<String> revealSecureAccessCode(String productId, String transactionId) =>
      _digitalService.revealSecureAccessCode(productId, transactionId);
}
