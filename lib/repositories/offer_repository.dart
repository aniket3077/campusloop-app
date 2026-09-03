import '../models/offer_model.dart';
import '../services/offer_service.dart';

class OfferRepository {
  final OfferService _offerService;

  OfferRepository({OfferService? offerService})
      : _offerService = offerService ?? CloudRunOfferService();

  Future<OfferModel> createOffer(OfferModel offer) =>
      _offerService.createOffer(offer);

  Future<OfferModel> counterOffer(
          String parentOfferId, double counterPrice, String? message) =>
      _offerService.counterOffer(parentOfferId, counterPrice, message);

  Future<OfferModel> updateOfferStatus(String offerId, OfferStatus status) =>
      _offerService.updateOfferStatus(offerId, status);

  Future<List<OfferModel>> getOffersForItem(String itemId) =>
      _offerService.getOffersForItem(itemId);

  Future<List<OfferModel>> getOffersForUser(String userId) =>
      _offerService.getOffersForUser(userId);
}
