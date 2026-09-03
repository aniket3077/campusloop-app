import 'package:flutter/material.dart';
import '../models/offer_model.dart';
import '../repositories/offer_repository.dart';

class OfferProvider extends ChangeNotifier {
  final OfferRepository _repository;

  List<OfferModel> _offers = [];
  bool _isLoading = false;
  String? _errorMessage;

  OfferProvider({OfferRepository? repository})
      : _repository = repository ?? OfferRepository() {
    loadOffersForUser('user_101');
  }

  List<OfferModel> get offers => _offers;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadOffersForUser(String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _offers = await _repository.getOffersForUser(userId);
    } catch (e) {
      _errorMessage = 'Failed to load bargain offers.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<OfferModel?> createOffer(OfferModel offer) async {
    try {
      final created = await _repository.createOffer(offer);
      _offers.insert(0, created);
      notifyListeners();
      return created;
    } catch (e) {
      return null;
    }
  }

  Future<OfferModel?> counterOffer(String parentOfferId, double counterPrice, String? message) async {
    try {
      final counter = await _repository.counterOffer(parentOfferId, counterPrice, message);
      final parentIndex = _offers.indexWhere((o) => o.offerId == parentOfferId);
      if (parentIndex != -1) {
        _offers[parentIndex] = _offers[parentIndex].copyWith(status: OfferStatus.countered);
      }
      _offers.insert(0, counter);
      notifyListeners();
      return counter;
    } catch (e) {
      return null;
    }
  }

  Future<bool> acceptOffer(String offerId) async {
    try {
      final updated = await _repository.updateOfferStatus(offerId, OfferStatus.accepted);
      final index = _offers.indexWhere((o) => o.offerId == offerId);
      if (index != -1) {
        _offers[index] = updated;
        notifyListeners();
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> rejectOffer(String offerId) async {
    try {
      final updated = await _repository.updateOfferStatus(offerId, OfferStatus.rejected);
      final index = _offers.indexWhere((o) => o.offerId == offerId);
      if (index != -1) {
        _offers[index] = updated;
        notifyListeners();
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  OfferModel? getAcceptedOfferForItem(String itemId) {
    try {
      return _offers.firstWhere((o) => o.itemId == itemId && o.status == OfferStatus.accepted);
    } catch (_) {
      return null;
    }
  }
}
