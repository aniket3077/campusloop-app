enum RequestStatus {
  pending,
  approved,
  fulfilled,
  cancelled,
}

extension RequestStatusX on RequestStatus {
  String get displayName {
    switch (this) {
      case RequestStatus.pending:
        return 'Pending Review';
      case RequestStatus.approved:
        return 'Approved by Owner';
      case RequestStatus.fulfilled:
        return 'Fulfilled & Picked Up';
      case RequestStatus.cancelled:
        return 'Cancelled';
    }
  }
}

class RequestModel {
  final String id;
  final String? resourceId;
  final String resourceTitle;
  final String transactionType; // BUY, BORROW, EXCHANGE, DONATE
  final DateTime requiredDate;
  final String? optionalMessage;
  final String requesterId;
  final String requesterName;
  final DateTime createdAt;
  final RequestStatus status;

  const RequestModel({
    required this.id,
    this.resourceId,
    required this.resourceTitle,
    required this.transactionType,
    required this.requiredDate,
    this.optionalMessage,
    required this.requesterId,
    required this.requesterName,
    required this.createdAt,
    this.status = RequestStatus.pending,
  });

  factory RequestModel.fromJson(Map<String, dynamic> json) {
    return RequestModel(
      id: json['id'] as String,
      resourceId: json['resourceId'] as String?,
      resourceTitle: json['resourceTitle'] as String,
      transactionType: json['transactionType'] as String,
      requiredDate: DateTime.parse(json['requiredDate'] as String),
      optionalMessage: json['optionalMessage'] as String?,
      requesterId: json['requesterId'] as String,
      requesterName: json['requesterName'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      status: RequestStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => RequestStatus.pending,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'resourceId': resourceId,
      'resourceTitle': resourceTitle,
      'transactionType': transactionType,
      'requiredDate': requiredDate.toIso8601String(),
      'optionalMessage': optionalMessage,
      'requesterId': requesterId,
      'requesterName': requesterName,
      'createdAt': createdAt.toIso8601String(),
      'status': status.name,
    };
  }

  static List<RequestModel> get mockRequests => const [];
}
