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
    final rawStatus = (json['verificationStatus'] ?? '').toString();
    StudentVerificationStatus status = StudentVerificationStatus.unverified;

    if (rawStatus.toUpperCase().contains('VERIFIED') && !rawStatus.toUpperCase().contains('UN')) {
      status = StudentVerificationStatus.verified;
    } else if (rawStatus.toUpperCase().contains('EMAIL')) {
      status = StudentVerificationStatus.emailPending;
    } else if (rawStatus.toUpperCase().contains('ID')) {
      status = StudentVerificationStatus.idPending;
    } else if (rawStatus.toUpperCase().contains('REJECT')) {
      status = StudentVerificationStatus.rejected;
    } else if (json['isVerifiedStudent'] == true) {
      status = StudentVerificationStatus.verified;
    }

    return UserModel(
      id: (json['id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      university: (json['university'] ?? json['collegeName'] ?? 'MIT CSN').toString(),
      department: (json['department'] ?? 'General Studies').toString(),
      academicYear: (json['academicYear'] ?? 'Junior (3rd Year)').toString(),
      verificationStatus: status,
      verificationNote: json['verificationNote'] as String?,
      verifiedAt: json['verifiedAt'] != null
          ? DateTime.tryParse(json['verifiedAt'].toString())
          : null,
      avatarUrl: json['avatarUrl'] as String?,
      trustRating: (json['trustRating'] as num?)?.toDouble() ?? 5.0,
      totalTransactions: (json['totalTransactions'] as num?)?.toInt() ?? 0,
      co2SavedKg: (json['co2SavedKg'] as num?)?.toDouble() ?? 0.0,
      moneySavedUsd: (json['moneySavedUsd'] as num?)?.toDouble() ?? 0.0,
      itemsCirculated: (json['itemsCirculated'] as num?)?.toInt() ?? 0,
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
    id: 'user_guest',
    name: 'Campus Student',
    email: 'student@mit.asia',
    university: 'MIT CSN',
    department: 'Engineering',
    academicYear: 'Student',
    verificationStatus: StudentVerificationStatus.unverified,
    trustRating: 5.0,
    totalTransactions: 0,
    co2SavedKg: 0.0,
    moneySavedUsd: 0.0,
    itemsCirculated: 0,
  );
}
