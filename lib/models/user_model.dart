enum StudentVerificationStatus {
  unverified,
  emailPending,
  idPending,
  pending,
  verified,
  rejected,
}

extension StudentVerificationStatusX on StudentVerificationStatus {
  String get displayName {
    switch (this) {
      case StudentVerificationStatus.unverified:
        return 'Unverified';
      case StudentVerificationStatus.emailPending:
        return 'Email Verification Pending';
      case StudentVerificationStatus.idPending:
        return 'Student ID Pending';
      case StudentVerificationStatus.pending:
        return 'Verification Under Review';
      case StudentVerificationStatus.verified:
        return 'Verified Student';
      case StudentVerificationStatus.rejected:
        return 'Verification Rejected';
    }
  }

  bool get isVerified => this == StudentVerificationStatus.verified;
  bool get isPending =>
      this == StudentVerificationStatus.pending ||
      this == StudentVerificationStatus.emailPending ||
      this == StudentVerificationStatus.idPending;
}

class UserModel {
  final String id;
  final String name;
  final String email;
  final String university;
  final String department;
  final String academicYear;
  final StudentVerificationStatus verificationStatus;
  final String? verificationNote;
  final DateTime? verifiedAt;
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
    required this.department,
    required this.academicYear,
    this.verificationStatus = StudentVerificationStatus.unverified,
    this.verificationNote,
    this.verifiedAt,
    this.avatarUrl,
    required this.trustRating,
    required this.totalTransactions,
    required this.co2SavedKg,
    required this.moneySavedUsd,
    required this.itemsCirculated,
  });

  bool get isVerifiedStudent => verificationStatus == StudentVerificationStatus.verified;

  String get collegeDomain {
    final parts = email.split('@');
    if (parts.length > 1) {
      return parts[1];
    }
    return 'university.edu';
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      university: json['university'] as String,
      department: json['department'] as String? ?? 'General Studies',
      academicYear: json['academicYear'] as String? ?? 'Junior (3rd Year)',
      verificationStatus: StudentVerificationStatus.values.firstWhere(
        (e) => e.name == json['verificationStatus'],
        orElse: () => (json['isVerifiedStudent'] == true
            ? StudentVerificationStatus.verified
            : StudentVerificationStatus.unverified),
      ),
      verificationNote: json['verificationNote'] as String?,
      verifiedAt: json['verifiedAt'] != null
          ? DateTime.tryParse(json['verifiedAt'] as String)
          : null,
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
      'department': department,
      'academicYear': academicYear,
      'verificationStatus': verificationStatus.name,
      'verificationNote': verificationNote,
      'verifiedAt': verifiedAt?.toIso8601String(),
      'avatarUrl': avatarUrl,
      'trustRating': trustRating,
      'totalTransactions': totalTransactions,
      'co2SavedKg': co2SavedKg,
      'moneySavedUsd': moneySavedUsd,
      'itemsCirculated': itemsCirculated,
    };
  }

  UserModel copyWith({
    String? name,
    String? email,
    String? university,
    String? department,
    String? academicYear,
    StudentVerificationStatus? verificationStatus,
    String? verificationNote,
    DateTime? verifiedAt,
    String? avatarUrl,
  }) {
    return UserModel(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      university: university ?? this.university,
      department: department ?? this.department,
      academicYear: academicYear ?? this.academicYear,
      verificationStatus: verificationStatus ?? this.verificationStatus,
      verificationNote: verificationNote ?? this.verificationNote,
      verifiedAt: verifiedAt ?? this.verifiedAt,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      trustRating: trustRating,
      totalTransactions: totalTransactions,
      co2SavedKg: co2SavedKg,
      moneySavedUsd: moneySavedUsd,
      itemsCirculated: itemsCirculated,
    );
  }

  static const UserModel mockUser = UserModel(
    id: 'user_101',
    name: 'Aniket Sharma',
    email: 'aniket@mit.asia',
    university: 'MIT CSN',
    department: 'Computer Science & Engineering',
    academicYear: 'Senior (4th Year)',
    verificationStatus: StudentVerificationStatus.verified,
    trustRating: 4.9,
    totalTransactions: 18,
    co2SavedKg: 48.5,
    moneySavedUsd: 410.00,
    itemsCirculated: 14,
  );
}
