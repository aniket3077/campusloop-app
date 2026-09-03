class RatingModel {
  final String id;
  final String transactionId;
  final String resourceTitle;
  final String raterId;
  final String raterName;
  final String ratedUserId;
  final double rating; // 1.0 to 5.0
  final String? feedback;
  final DateTime createdAt;

  const RatingModel({
    required this.id,
    required this.transactionId,
    required this.resourceTitle,
    required this.raterId,
    required this.raterName,
    required this.ratedUserId,
    required this.rating,
    this.feedback,
    required this.createdAt,
  });

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      id: json['id'] as String,
      transactionId: json['transactionId'] as String,
      resourceTitle: json['resourceTitle'] as String? ?? 'Campus Exchange',
      raterId: json['raterId'] as String,
      raterName: json['raterName'] as String,
      ratedUserId: json['ratedUserId'] as String,
      rating: (json['rating'] as num).toDouble(),
      feedback: json['feedback'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'transactionId': transactionId,
      'resourceTitle': resourceTitle,
      'raterId': raterId,
      'raterName': raterName,
      'ratedUserId': ratedUserId,
      'rating': rating,
      'feedback': feedback,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  static List<RatingModel> get mockRatings => [
    RatingModel(
      id: 'rt_001',
      transactionId: 'tx_001',
      resourceTitle: 'Linear Algebra & Its Applications (6th Ed)',
      raterId: 'user_102',
      raterName: 'Marcus Chen',
      ratedUserId: 'user_101',
      rating: 5.0,
      feedback: 'Punctual, friendly, and communicated pickup timing perfectly at Engineering Quad!',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    RatingModel(
      id: 'rt_002',
      transactionId: 'tx_002',
      resourceTitle: 'TI-84 Plus CE Graphing Calculator',
      raterId: 'user_103',
      raterName: 'Sophia Patel',
      ratedUserId: 'user_101',
      rating: 4.8,
      feedback: 'Item was returned on time and in flawless condition. Highly trusted student!',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
  ];
}
