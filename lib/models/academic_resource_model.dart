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
  });

  factory AcademicResourceModel.fromJson(Map<String, dynamic> json) {
    return AcademicResourceModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      resourceType: json['resourceType'] as String,
      price: (json['price'] as num).toDouble(),
      condition: json['condition'] as String,
      pickupLocation: json['pickupLocation'] as String,
      sellerId: json['sellerId'] as String,
      sellerName: json['sellerName'] as String,
      sellerRating: (json['sellerRating'] as num).toDouble(),
      isVerifiedSeller: json['isVerifiedSeller'] as bool? ?? true,
      university: json['university'] as String,
      imageUrls: (json['imageUrls'] as List<dynamic>).cast<String>(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      isAvailable: json['isAvailable'] as bool? ?? true,
      exchangeForRequirement: json['exchangeForRequirement'] as String?,
      maxBorrowDays: json['maxBorrowDays'] as int?,
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
    };
  }

  static List<AcademicResourceModel> get mockResources => [
    AcademicResourceModel(
      id: 'res_001',
      title: 'Linear Algebra & Its Applications (6th Ed)',
      description: 'Barely used condition with clean margins and no highlighter marks. Essential textbook for Math 51 / CS 205.',
      category: 'Textbooks & Reading',
      resourceType: 'SELL',
      price: 35.00,
      condition: 'Like New',
      pickupLocation: 'Engineering Quad Bench A',
      sellerId: 'user_102',
      sellerName: 'Marcus Chen',
      sellerRating: 4.95,
      isVerifiedSeller: true,
      university: 'Stanford University',
      imageUrls: ['https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c'],
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
      isAvailable: true,
    ),
    AcademicResourceModel(
      id: 'res_002',
      title: 'Texas Instruments TI-84 Plus CE Graphing Calculator',
      description: 'Fully functional with rechargeable battery and charging cable included. Perfect for calculus and stats finals.',
      category: 'Electronics & Calculators',
      resourceType: 'BORROW',
      price: 5.00,
      condition: 'Good',
      pickupLocation: 'Main Library Student Lounge',
      sellerId: 'user_103',
      sellerName: 'Sophia Patel',
      sellerRating: 4.88,
      isVerifiedSeller: true,
      university: 'Stanford University',
      imageUrls: ['https://images.unsplash.com/photo-1594980596870-8aa52a78d8cd'],
      createdAt: DateTime.now().subtract(const Duration(hours: 8)),
      isAvailable: true,
      maxBorrowDays: 14,
    ),
    AcademicResourceModel(
      id: 'res_003',
      title: 'Organic Chemistry Lab Coat (Medium) & Safety Goggles',
      description: 'Standard white cotton lab coat + splash goggles. Cleaned and ready for Chem 31A/B labs.',
      category: 'Lab Equipment & Kits',
      resourceType: 'EXCHANGE',
      price: 0.00,
      condition: 'Good',
      pickupLocation: 'Science & Tech Quad Cafeteria',
      sellerId: 'user_104',
      sellerName: 'Jordan Taylor',
      sellerRating: 5.00,
      isVerifiedSeller: true,
      university: 'Stanford University',
      imageUrls: ['https://images.unsplash.com/photo-1582719478250-c89cae4dc85b'],
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      isAvailable: true,
      exchangeForRequirement: 'Physics 41 Lab Notebook or Bio 81 Study Notes',
    ),
    AcademicResourceModel(
      id: 'res_004',
      title: 'CS 106B Comprehensive Midterm & Final Review Study Guide',
      description: '45 pages of handwritten + typed notes, C++ memory pointers cheatsheet, and practice problem walkthroughs.',
      category: 'Class Notes & Summaries',
      resourceType: 'DONATE',
      price: 0.00,
      condition: 'Like New',
      pickupLocation: 'Student Union Center',
      sellerId: 'user_101',
      sellerName: 'Alex Rivera',
      sellerRating: 4.90,
      isVerifiedSeller: true,
      university: 'Stanford University',
      imageUrls: ['https://images.unsplash.com/photo-1456513080510-7bf3a84b82f8'],
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      isAvailable: true,
    ),
    AcademicResourceModel(
      id: 'res_005',
      title: 'Need: iClicker 2 Student Remote for Physics 41',
      description: 'Looking to buy or borrow an iClicker 2 remote for Autumn quarter. Will pick up anywhere on campus!',
      category: 'Electronics & Calculators',
      resourceType: 'REQUEST',
      price: 15.00,
      condition: 'Fair',
      pickupLocation: 'Campus North Dining Hall',
      sellerId: 'user_105',
      sellerName: 'David Kim',
      sellerRating: 4.80,
      isVerifiedSeller: true,
      university: 'Stanford University',
      imageUrls: ['https://images.unsplash.com/photo-1516321318423-f06f85e504b3'],
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      isAvailable: true,
    ),
  ];
}
