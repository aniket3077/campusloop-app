enum TransactionType {
  sell,
  borrow,
  exchange,
  donate,
}

enum TransactionStatus {
  requested,
  negotiating,
  agreed,
  approved,
  scheduledForPickup,
  pickedUp,
  borrowed,
  returned,
  completed,
  rated,
  cancelled,
}

extension TransactionStatusX on TransactionStatus {
  String get displayName {
    switch (this) {
      case TransactionStatus.requested:
        return 'Request Pending';
      case TransactionStatus.negotiating:
        return 'Negotiating Terms';
      case TransactionStatus.agreed:
        return 'Terms Agreed';
      case TransactionStatus.approved:
        return 'Owner Approved';
      case TransactionStatus.scheduledForPickup:
        return 'Scheduled for Pickup';
      case TransactionStatus.pickedUp:
        return 'Item Picked Up';
      case TransactionStatus.borrowed:
        return 'Currently Borrowed';
      case TransactionStatus.returned:
        return 'Item Returned';
      case TransactionStatus.completed:
        return 'Transaction Completed';
      case TransactionStatus.rated:
        return 'Completed & Rated';
      case TransactionStatus.cancelled:
        return 'Cancelled';
    }
  }

  bool get isActive =>
      this != TransactionStatus.completed &&
      this != TransactionStatus.rated &&
      this != TransactionStatus.cancelled;

  bool get isCompleted =>
      this == TransactionStatus.completed || this == TransactionStatus.rated;
}

class TransactionModel {
  final String id;
  final String resourceId;
  final String resourceTitle;
  final double resourcePrice;
  final TransactionType transactionType;
  final String buyerId;
  final String buyerName;
  final String sellerId;
  final String sellerName;
  final TransactionStatus status;
  final String pickupLocation;
  final DateTime? pickupTime;
  final DateTime? borrowStartDate;
  final DateTime? expectedReturnDate;
  final DateTime? actualReturnDate;
  final String? exchangeItemTitle;
  final double? rating;
  final String? review;
  final DateTime createdAt;
  final DateTime updatedAt;

  const TransactionModel({
    required this.id,
    required this.resourceId,
    required this.resourceTitle,
    required this.resourcePrice,
    required this.transactionType,
    required this.buyerId,
    required this.buyerName,
    required this.sellerId,
    required this.sellerName,
    required this.status,
    required this.pickupLocation,
    this.pickupTime,
    this.borrowStartDate,
    this.expectedReturnDate,
    this.actualReturnDate,
    this.exchangeItemTitle,
    this.rating,
    this.review,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as String,
      resourceId: json['resourceId'] as String,
      resourceTitle: json['resourceTitle'] as String,
      resourcePrice: (json['resourcePrice'] as num).toDouble(),
      transactionType: TransactionType.values.firstWhere(
        (e) => e.name == json['transactionType'],
        orElse: () => TransactionType.sell,
      ),
      buyerId: json['buyerId'] as String,
      buyerName: json['buyerName'] as String,
      sellerId: json['sellerId'] as String,
      sellerName: json['sellerName'] as String,
      status: TransactionStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => TransactionStatus.requested,
      ),
      pickupLocation: json['pickupLocation'] as String,
      pickupTime: json['pickupTime'] != null ? DateTime.parse(json['pickupTime'] as String) : null,
      borrowStartDate: json['borrowStartDate'] != null ? DateTime.parse(json['borrowStartDate'] as String) : null,
      expectedReturnDate: json['expectedReturnDate'] != null ? DateTime.parse(json['expectedReturnDate'] as String) : null,
      actualReturnDate: json['actualReturnDate'] != null ? DateTime.parse(json['actualReturnDate'] as String) : null,
      exchangeItemTitle: json['exchangeItemTitle'] as String?,
      rating: (json['rating'] as num?)?.toDouble(),
      review: json['review'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'resourceId': resourceId,
      'resourceTitle': resourceTitle,
      'resourcePrice': resourcePrice,
      'transactionType': transactionType.name,
      'buyerId': buyerId,
      'buyerName': buyerName,
      'sellerId': sellerId,
      'sellerName': sellerName,
      'status': status.name,
      'pickupLocation': pickupLocation,
      'pickupTime': pickupTime?.toIso8601String(),
      'borrowStartDate': borrowStartDate?.toIso8601String(),
      'expectedReturnDate': expectedReturnDate?.toIso8601String(),
      'actualReturnDate': actualReturnDate?.toIso8601String(),
      'exchangeItemTitle': exchangeItemTitle,
      'rating': rating,
      'review': review,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  TransactionModel copyWith({
    String? id,
    TransactionStatus? status,
    DateTime? pickupTime,
    DateTime? borrowStartDate,
    DateTime? expectedReturnDate,
    DateTime? actualReturnDate,
    double? rating,
    String? review,
    DateTime? updatedAt,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      resourceId: resourceId,
      resourceTitle: resourceTitle,
      resourcePrice: resourcePrice,
      transactionType: transactionType,
      buyerId: buyerId,
      buyerName: buyerName,
      sellerId: sellerId,
      sellerName: sellerName,
      status: status ?? this.status,
      pickupLocation: pickupLocation,
      pickupTime: pickupTime ?? this.pickupTime,
      borrowStartDate: borrowStartDate ?? this.borrowStartDate,
      expectedReturnDate: expectedReturnDate ?? this.expectedReturnDate,
      actualReturnDate: actualReturnDate ?? this.actualReturnDate,
      exchangeItemTitle: exchangeItemTitle,
      rating: rating ?? this.rating,
      review: review ?? this.review,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  static List<TransactionModel> get mockTransactions => const [];
}
