import 'package:flutter/material.dart';
import '../models/digital_product_model.dart';
import '../repositories/digital_product_repository.dart';

class DigitalProductProvider extends ChangeNotifier {
  final DigitalProductRepository _repository;

  List<DigitalProductModel> _products = [];
  bool _isLoading = false;
  String? _errorMessage;

  DigitalProductProvider({DigitalProductRepository? repository})
      : _repository = repository ?? DigitalProductRepository() {
    loadProducts();
  }

  List<DigitalProductModel> get products => _products;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadProducts({String? searchQuery, String? provider}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _products = await _repository.getDigitalProducts(searchQuery: searchQuery, provider: provider);
    } catch (e) {
      _errorMessage = 'Failed to load digital course products.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addDigitalProduct(DigitalProductModel product) async {
    try {
      final created = await _repository.createDigitalListing(product);
      _products.insert(0, created);
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<String?> fetchSecureAccessCode(String productId, String transactionId) async {
    try {
      return await _repository.revealSecureAccessCode(productId, transactionId);
    } catch (e) {
      return null;
    }
  }
}
