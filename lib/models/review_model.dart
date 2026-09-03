class ReviewModel {
  final String id;
  final String reviewerName;
  final double rating;
  final String comment;
  final DateTime createdAt;
  final bool isVerifiedStudent;

  const ReviewModel({
    required this.id,
    required this.reviewerName,
    required this.rating,
    required this.comment,
    required this.createdAt,
    required this.isVerifiedStudent,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'] as String,
      reviewerName: json['reviewerName'] as String,
      rating: (json['rating'] as num).toDouble(),
      comment: json['comment'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      isVerifiedStudent: json['isVerifiedStudent'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reviewerName': reviewerName,
      'rating': rating,
      'comment': comment,
      'createdAt': createdAt.toIso8601String(),
      'isVerifiedStudent': isVerifiedStudent,
    };
  }
}
