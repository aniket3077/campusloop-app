class AcademicResourceModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final String resourceType; // SELL, BORROW, EXCHANGE, DONATE, REQUEST
  final double price;
  final String condition;
  final String pickupLocation;
  final String sellerId;
  final String sellerName;
  final double sellerRating;
  final bool isVerifiedSeller;
  final String university;
  final List<String> imageUrls;
  final DateTime createdAt;
  final bool isAvailable;
  final String? exchangeForRequirement;
  final int? maxBorrowDays;
  final bool isRecommended;
  final bool isNearby;
  final bool isMyActiveRequest;
  final int? distanceMeters;
  final String? courseCode;

  const AcademicResourceModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.resourceType,
    required this.price,
    required this.condition,
    required this.pickupLocation,
    required this.sellerId,
    required this.sellerName,
    required this.sellerRating,
    required this.isVerifiedSeller,
    required this.university,
    required this.imageUrls,
    required this.createdAt,
    this.isAvailable = true,
    this.exchangeForRequirement,
    this.maxBorrowDays,
    this.isRecommended = false,
    this.isNearby = false,
    this.isMyActiveRequest = false,
    this.distanceMeters,
    this.courseCode,
  });

  factory AcademicResourceModel.fromJson(Map<String, dynamic> json) {
    return AcademicResourceModel(
      id: (json['id'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      category: (json['category'] ?? 'General').toString(),
      resourceType: (json['resourceType'] ?? json['transactionType'] ?? json['type'] ?? 'SELL').toString().toUpperCase(),
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      condition: (json['condition'] ?? 'Good').toString(),
      pickupLocation: (json['pickupLocation'] ?? json['pickupLocationName'] ?? 'MIT CSN Main Gate Security Post').toString(),
      sellerId: (json['sellerId'] ?? json['ownerId'] ?? '').toString(),
      sellerName: (json['sellerName'] ?? json['ownerName'] ?? 'MIT CSN Student').toString(),
      sellerRating: (json['sellerRating'] as num?)?.toDouble() ?? 5.0,
      isVerifiedSeller: json['isVerifiedSeller'] as bool? ?? true,
      university: (json['university'] ?? json['collegeName'] ?? 'MIT CSN').toString(),
      imageUrls: (json['imageUrls'] as List<dynamic>?)?.map((e) => e.toString()).toList() ??
          (json['images'] as List<dynamic>?)?.map((e) => e.toString()).toList() ??
          const ['https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c'],
      createdAt: json['createdAt'] != null
          ? (DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now())
          : DateTime.now(),
      isAvailable: json['isAvailable'] as bool? ?? true,
      exchangeForRequirement: (json['exchangeForRequirement'] ?? json['exchangePreferences']) as String?,
      maxBorrowDays: json['maxBorrowDays'] as int?,
      isRecommended: json['isRecommended'] as bool? ?? true,
      isNearby: json['isNearby'] as bool? ?? true,
      isMyActiveRequest: json['isMyActiveRequest'] as bool? ?? false,
      distanceMeters: json['distanceMeters'] as int?,
      courseCode: json['courseCode'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'resourceType': resourceType,
      'price': price,
      'condition': condition,
      'pickupLocation': pickupLocation,
      'sellerId': sellerId,
      'sellerName': sellerName,
      'sellerRating': sellerRating,
      'isVerifiedSeller': isVerifiedSeller,
      'university': university,
      'imageUrls': imageUrls,
      'createdAt': createdAt.toIso8601String(),
      'isAvailable': isAvailable,
      'exchangeForRequirement': exchangeForRequirement,
      'maxBorrowDays': maxBorrowDays,
      'isRecommended': isRecommended,
      'isNearby': isNearby,
      'isMyActiveRequest': isMyActiveRequest,
      'distanceMeters': distanceMeters,
      'courseCode': courseCode,
    };
  }

  AcademicResourceModel copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    String? resourceType,
    double? price,
    String? condition,
    String? pickupLocation,
    String? sellerId,
    String? sellerName,
    double? sellerRating,
    bool? isVerifiedSeller,
    String? university,
    List<String>? imageUrls,
    DateTime? createdAt,
    bool? isAvailable,
    String? exchangeForRequirement,
    int? maxBorrowDays,
    bool? isRecommended,
    bool? isNearby,
    bool? isMyActiveRequest,
    int? distanceMeters,
    String? courseCode,
  }) {
    return AcademicResourceModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      resourceType: resourceType ?? this.resourceType,
      price: price ?? this.price,
      condition: condition ?? this.condition,
      pickupLocation: pickupLocation ?? this.pickupLocation,
      sellerId: sellerId ?? this.sellerId,
      sellerName: sellerName ?? this.sellerName,
      sellerRating: sellerRating ?? this.sellerRating,
      isVerifiedSeller: isVerifiedSeller ?? this.isVerifiedSeller,
      university: university ?? this.university,
      imageUrls: imageUrls ?? this.imageUrls,
      createdAt: createdAt ?? this.createdAt,
      isAvailable: isAvailable ?? this.isAvailable,
      exchangeForRequirement: exchangeForRequirement ?? this.exchangeForRequirement,
      maxBorrowDays: maxBorrowDays ?? this.maxBorrowDays,
      isRecommended: isRecommended ?? this.isRecommended,
      isNearby: isNearby ?? this.isNearby,
      isMyActiveRequest: isMyActiveRequest ?? this.isMyActiveRequest,
      distanceMeters: distanceMeters ?? this.distanceMeters,
      courseCode: courseCode ?? this.courseCode,
    );
  }

  static List<AcademicResourceModel> get mockResources => const [];
}
