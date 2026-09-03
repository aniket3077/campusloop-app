import '../models/offer_model.dart';

abstract class OfferService {
  Future<OfferModel> createOffer(OfferModel offer);
  Future<OfferModel> counterOffer(String parentOfferId, double counterPrice, String? message);
  Future<OfferModel> updateOfferStatus(String offerId, OfferStatus status);
  Future<List<OfferModel>> getOffersForItem(String itemId);
  Future<List<OfferModel>> getOffersForUser(String userId);
}

class CloudRunOfferService implements OfferService {
  final List<OfferModel> _offers = List.from(OfferModel.mockOffers);

  static const String offerEndpoint = '/api/v1/offers';

  @override
  Future<OfferModel> createOffer(OfferModel offer) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _offers.insert(0, offer);
    return offer;
  }

  @override
  Future<OfferModel> counterOffer(String parentOfferId, double counterPrice, String? message) async {
    await Future.delayed(const Duration(milliseconds: 350));
    final parentIndex = _offers.indexWhere((o) => o.offerId == parentOfferId);
    if (parentIndex != -1) {
      final parent = _offers[parentIndex];

      // Mark parent as countered
      _offers[parentIndex] = parent.copyWith(
        status: OfferStatus.countered,
        updatedAt: DateTime.now(),
      );

      // Create new counter offer
      final counter = OfferModel(
        offerId: 'ofr_${DateTime.now().millisecondsSinceEpoch}',
        itemId: parent.itemId,
        itemTitle: parent.itemTitle,
        buyerId: parent.buyerId,
        sellerId: parent.sellerId,
        originalPrice: parent.originalPrice,
        offeredPrice: counterPrice,
        message: message ?? 'Counter offer proposal',
        status: OfferStatus.pending,
        parentOfferId: parentOfferId,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      _offers.insert(0, counter);
      return counter;
    }
    throw Exception('Parent offer not found');
  }

  @override
  Future<OfferModel> updateOfferStatus(String offerId, OfferStatus status) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _offers.indexWhere((o) => o.offerId == offerId);
    if (index != -1) {
      _offers[index] = _offers[index].copyWith(
        status: status,
        updatedAt: DateTime.now(),
      );
      return _offers[index];
    }
    throw Exception('Offer not found');
  }

  @override
  Future<List<OfferModel>> getOffersForItem(String itemId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _offers.where((o) => o.itemId == itemId).toList();
  }

  @override
  Future<List<OfferModel>> getOffersForUser(String userId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _offers.where((o) => o.buyerId == userId || o.sellerId == userId).toList();
  }
}
