enum DigitalProductType {
  accessCode,
  courseLicense,
  voucher,
  digitalCourseMaterial,
  transferableEnrollment,
  studyNotes,
}

extension DigitalProductTypeX on DigitalProductType {
  String get displayName {
    switch (this) {
      case DigitalProductType.accessCode:
        return 'Publisher Access Code';
      case DigitalProductType.courseLicense:
        return 'Official Course License';
      case DigitalProductType.voucher:
        return 'Exam / Platform Voucher';
      case DigitalProductType.digitalCourseMaterial:
        return 'Digital Course Material';
      case DigitalProductType.transferableEnrollment:
        return 'Transferable Enrollment Voucher';
      case DigitalProductType.studyNotes:
        return 'Study Notes & Problem Sets';
    }
  }
}

class DigitalProductModel {
  final String id;
  final String courseName;
  final String providerPlatform; // e.g. Pearson MyLab, McGraw-Hill Connect, WileyPLUS, Canvas
  final DigitalProductType productType;
  final String validityExpiry; // e.g. 'Valid through Dec 31, 2026'
  final double price;
  final String description;
  final bool isOwnershipVerified;
  final String sellerId;
  final String sellerName;
  final double sellerRating;
  final bool isVerifiedSeller;
  final String university;
  final DateTime createdAt;
  final bool isAccessDelivered;
  final String? secureAccessCode; // Only delivered after transaction confirmation, NEVER in public chat/plaintext

  const DigitalProductModel({
    required this.id,
    required this.courseName,
    required this.providerPlatform,
    required this.productType,
    required this.validityExpiry,
    required this.price,
    required this.description,
    this.isOwnershipVerified = true,
    required this.sellerId,
    required this.sellerName,
    required this.sellerRating,
    required this.isVerifiedSeller,
    required this.university,
    required this.createdAt,
    this.isAccessDelivered = false,
    this.secureAccessCode,
  });

  factory DigitalProductModel.fromJson(Map<String, dynamic> json) {
    return DigitalProductModel(
      id: json['id'] as String,
      courseName: json['courseName'] as String,
      providerPlatform: json['providerPlatform'] as String,
      productType: DigitalProductType.values.firstWhere(
        (e) => e.name == json['productType'],
        orElse: () => DigitalProductType.accessCode,
      ),
      validityExpiry: json['validityExpiry'] as String,
      price: (json['price'] as num).toDouble(),
      description: json['description'] as String,
      isOwnershipVerified: json['isOwnershipVerified'] as bool? ?? true,
      sellerId: json['sellerId'] as String,
      sellerName: json['sellerName'] as String,
      sellerRating: (json['sellerRating'] as num).toDouble(),
      isVerifiedSeller: json['isVerifiedSeller'] as bool? ?? true,
      university: json['university'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      isAccessDelivered: json['isAccessDelivered'] as bool? ?? false,
      secureAccessCode: json['secureAccessCode'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'courseName': courseName,
      'providerPlatform': providerPlatform,
      'productType': productType.name,
      'validityExpiry': validityExpiry,
      'price': price,
      'description': description,
      'isOwnershipVerified': isOwnershipVerified,
      'sellerId': sellerId,
      'sellerName': sellerName,
      'sellerRating': sellerRating,
      'isVerifiedSeller': isVerifiedSeller,
      'university': university,
      'createdAt': createdAt.toIso8601String(),
      'isAccessDelivered': isAccessDelivered,
      'secureAccessCode': secureAccessCode,
    };
  }

  static List<DigitalProductModel> get mockDigitalProducts => [
    DigitalProductModel(
      id: 'dig_001',
      courseName: 'CS 106B: Programming Abstractions',
      providerPlatform: 'Canvas / Publisher Store',
      productType: DigitalProductType.accessCode,
      validityExpiry: 'Valid through June 30, 2027',
      price: 25.00,
      description: 'Unused official access activation code for online interactive C++ labs. Purchased directly from publisher store.',
      isOwnershipVerified: true,
      sellerId: 'user_102',
      sellerName: 'Marcus Chen',
      sellerRating: 4.95,
      isVerifiedSeller: true,
      university: 'Stanford University',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      secureAccessCode: 'PEARSON-CS106B-84920-X82',
    ),
    DigitalProductModel(
      id: 'dig_002',
      courseName: 'Math 51: Linear Algebra & Multivariable Calculus',
      providerPlatform: 'McGraw-Hill Connect',
      productType: DigitalProductType.voucher,
      validityExpiry: 'Valid through Dec 31, 2026',
      price: 20.00,
      description: 'Official Student Voucher for homework portal access. Code receipt verified.',
      isOwnershipVerified: true,
      sellerId: 'user_103',
      sellerName: 'Sophia Patel',
      sellerRating: 4.88,
      isVerifiedSeller: true,
      university: 'Stanford University',
      createdAt: DateTime.now().subtract(const Duration(hours: 6)),
      secureAccessCode: 'MH-CONNECT-MATH51-9920',
    ),
    DigitalProductModel(
      id: 'dig_003',
      courseName: 'Chem 31A: Chemical Principles',
      providerPlatform: 'WileyPLUS',
      productType: DigitalProductType.studyNotes,
      validityExpiry: 'Lifetime Access',
      price: 15.00,
      description: 'Comprehensive digitized lecture summaries, reaction mechanisms cheatsheets, and worked practice midterm solutions.',
      isOwnershipVerified: true,
      sellerId: 'user_101',
      sellerName: 'Alex Rivera',
      sellerRating: 4.90,
      isVerifiedSeller: true,
      university: 'Stanford University',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      secureAccessCode: 'CAMPUSLOOP-CHEM31A-NOTES-PDF',
    ),
  ];
}
