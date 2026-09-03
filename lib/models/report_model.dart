enum ReportType {
  user,
  listing,
}

class ReportModel {
  final String id;
  final ReportType type;
  final String targetId; // UserId or ListingId
  final String targetTitle; // User name or Listing title
  final String reporterId;
  final String reporterName;
  final String reason;
  final String? details;
  final DateTime createdAt;
  final bool isResolved;

  const ReportModel({
    required this.id,
    required this.type,
    required this.targetId,
    required this.targetTitle,
    required this.reporterId,
    required this.reporterName,
    required this.reason,
    this.details,
    required this.createdAt,
    this.isResolved = false,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      id: json['id'] as String,
      type: ReportType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => ReportType.user,
      ),
      targetId: json['targetId'] as String,
      targetTitle: json['targetTitle'] as String,
      reporterId: json['reporterId'] as String,
      reporterName: json['reporterName'] as String,
      reason: json['reason'] as String,
      details: json['details'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      isResolved: json['isResolved'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'targetId': targetId,
      'targetTitle': targetTitle,
      'reporterId': reporterId,
      'reporterName': reporterName,
      'reason': reason,
      'details': details,
      'createdAt': createdAt.toIso8601String(),
      'isResolved': isResolved,
    };
  }
}
