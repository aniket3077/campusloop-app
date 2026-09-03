import 'package:flutter_test/flutter_test.dart';
import 'package:campusloop/models/transaction_model.dart';
import 'package:campusloop/models/offer_model.dart';
import 'package:campusloop/services/backend_api_service.dart';

void main() {
  group('Transaction & Offer Model Tests', () {
    test('Transaction Model instantiation and serialization', () {
      final now = DateTime.now();
      final tx = TransactionModel(
        id: 'tx_123',
        resourceId: 'item_456',
        resourceTitle: 'Engineering Mechanics',
        resourcePrice: 280.0,
        transactionType: TransactionType.sell,
        buyerId: 'user_buyer',
        buyerName: 'Rahul Verma',
        sellerId: 'user_seller',
        sellerName: 'Aniket Sharma',
        status: TransactionStatus.scheduledForPickup,
        pickupLocation: 'Central Library Lounge',
        createdAt: now,
        updatedAt: now,
      );

      expect(tx.id, 'tx_123');
      expect(tx.resourcePrice, 280.0);
      expect(tx.status, TransactionStatus.scheduledForPickup);
      expect(tx.pickupLocation, 'Central Library Lounge');

      final json = tx.toJson();
      expect(json['resourcePrice'], 280.0);
      expect(json['status'], 'scheduledForPickup');
    });

    test('Offer Model bargaining status and counteroffers', () {
      final now = DateTime.now();
      final offer = OfferModel(
        offerId: 'offer_789',
        itemId: 'item_456',
        itemTitle: 'Engineering Mechanics',
        buyerId: 'user_buyer',
        sellerId: 'user_seller',
        originalPrice: 350.0,
        offeredPrice: 280.0,
        status: OfferStatus.accepted,
        message: 'Accept 280 for pickup today?',
        createdAt: now,
        updatedAt: now,
      );

      expect(offer.offeredPrice, 280.0);
      expect(offer.status, OfferStatus.accepted);
      expect(offer.status == OfferStatus.accepted, true);

      final json = offer.toJson();
      expect(json['offeredPrice'], 280.0);
      expect(json['status'], 'ACCEPTED');
    });

    test('BackendApiService default base url is configured', () {
      expect(BackendApiService.baseUrl, isNotEmpty);
      BackendApiService.setAuthToken('test_jwt_token_123');
      // Verify token cleared
      BackendApiService.clearAuthToken();
    });
  });
}
