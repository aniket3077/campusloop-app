class UserModel {
  final String id;
  final String name;
  final String email;
  final String university;
  final bool isVerifiedStudent;
  final String? avatarUrl;
  final double trustRating;
  final int totalTransactions;
  final double co2SavedKg;
  final double moneySavedUsd;
  final int itemsCirculated;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.university,
    required this.isVerifiedStudent,
    this.avatarUrl,
    required this.trustRating,
    required this.totalTransactions,
    required this.co2SavedKg,
    required this.moneySavedUsd,
    required this.itemsCirculated,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      university: json['university'] as String,
      isVerifiedStudent: json['isVerifiedStudent'] as bool? ?? false,
      avatarUrl: json['avatarUrl'] as String?,
      trustRating: (json['trustRating'] as num?)?.toDouble() ?? 5.0,
      totalTransactions: json['totalTransactions'] as int? ?? 0,
      co2SavedKg: (json['co2SavedKg'] as num?)?.toDouble() ?? 0.0,
      moneySavedUsd: (json['moneySavedUsd'] as num?)?.toDouble() ?? 0.0,
      itemsCirculated: json['itemsCirculated'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'university': university,
      'isVerifiedStudent': isVerifiedStudent,
      'avatarUrl': avatarUrl,
      'trustRating': trustRating,
      'totalTransactions': totalTransactions,
      'co2SavedKg': co2SavedKg,
      'moneySavedUsd': moneySavedUsd,
      'itemsCirculated': itemsCirculated,
    };
  }

  static const UserModel mockUser = UserModel(
    id: 'user_101',
    name: 'Alex Rivera',
    email: 'arivera@stanford.edu',
    university: 'Stanford University',
    isVerifiedStudent: true,
    avatarUrl: null,
    trustRating: 4.9,
    totalTransactions: 18,
    co2SavedKg: 42.5,
    moneySavedUsd: 380.00,
    itemsCirculated: 12,
  );
}
