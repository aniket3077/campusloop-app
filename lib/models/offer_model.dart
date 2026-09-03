enum OfferStatus {
  pending,
  accepted,
  rejected,
  countered,
  expired,
  cancelled,
}

extension OfferStatusX on OfferStatus {
  String get displayName {
    switch (this) {
      case OfferStatus.pending:
        return 'Offer Pending';
      case OfferStatus.accepted:
        return 'Offer Accepted';
      case OfferStatus.rejected:
        return 'Offer Declined';
      case OfferStatus.countered:
        return 'Counter Offer Proposed';
      case OfferStatus.expired:
        return 'Offer Expired';
      case OfferStatus.cancelled:
        return 'Offer Cancelled';
    }
  }

  bool get isFinal =>
      this == OfferStatus.accepted ||
      this == OfferStatus.rejected ||
      this == OfferStatus.expired ||
      this == OfferStatus.cancelled;
}

class OfferModel {
  final String offerId;
  final String itemId;
  final String itemTitle;
  final String buyerId;
  final String sellerId;
  final double originalPrice;
  final double offeredPrice;
  final String? message;
  final OfferStatus status;
  final String? parentOfferId; // For counter offer chains
  final DateTime createdAt;
  final DateTime updatedAt;

  const OfferModel({
    required this.offerId,
    required this.itemId,
    required this.itemTitle,
    required this.buyerId,
    required this.sellerId,
    required this.originalPrice,
    required this.offeredPrice,
    this.message,
    this.status = OfferStatus.pending,
    this.parentOfferId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OfferModel.fromJson(Map<String, dynamic> json) {
    final statusStr = (json['status'] as String? ?? 'pending').toLowerCase();
    return OfferModel(
      offerId: json['offerId'] as String,
      itemId: json['itemId'] as String,
      itemTitle: json['itemTitle'] as String? ?? 'Campus Resource',
      buyerId: json['buyerId'] as String,
      sellerId: json['sellerId'] as String,
      originalPrice: (json['originalPrice'] as num).toDouble(),
      offeredPrice: (json['offeredPrice'] as num).toDouble(),
      message: json['message'] as String?,
      status: OfferStatus.values.firstWhere(
        (e) => e.name.toLowerCase() == statusStr,
        orElse: () => OfferStatus.pending,
      ),
      parentOfferId: json['parentOfferId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'offerId': offerId,
      'itemId': itemId,
      'itemTitle': itemTitle,
      'buyerId': buyerId,
      'sellerId': sellerId,
      'originalPrice': originalPrice,
      'offeredPrice': offeredPrice,
      'message': message,
      'status': status.name.toUpperCase(),
      'parentOfferId': parentOfferId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  OfferModel copyWith({
    OfferStatus? status,
    double? offeredPrice,
    String? message,
    DateTime? updatedAt,
  }) {
    return OfferModel(
      offerId: offerId,
      itemId: itemId,
      itemTitle: itemTitle,
      buyerId: buyerId,
      sellerId: sellerId,
      originalPrice: originalPrice,
      offeredPrice: offeredPrice ?? this.offeredPrice,
      message: message ?? this.message,
      status: status ?? this.status,
      parentOfferId: parentOfferId,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  static List<OfferModel> get mockOffers => [
    OfferModel(
      offerId: 'ofr_001',
      itemId: 'res_001',
      itemTitle: 'Linear Algebra & Its Applications (6th Ed)',
      buyerId: 'user_101',
      sellerId: 'user_102',
      originalPrice: 35.00,
      offeredPrice: 30.00,
      message: 'Would you accept \$30.00 for campus pickup today at Engineering Quad?',
      status: OfferStatus.accepted,
      createdAt: DateTime.now().subtract(const Duration(minutes: 45)),
      updatedAt: DateTime.now().subtract(const Duration(minutes: 30)),
    ),
  ];
}
