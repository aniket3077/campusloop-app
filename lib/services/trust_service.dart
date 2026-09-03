import '../models/rating_model.dart';
import '../models/report_model.dart';

abstract class TrustService {
  Future<RatingModel> submitRating(RatingModel rating);
  Future<List<RatingModel>> getUserRatings(String userId);
  Future<ReportModel> submitReport(ReportModel report);
  Future<bool> blockUser(String currentUserId, String targetUserId);
}

class CloudRunTrustService implements TrustService {
  final List<RatingModel> _ratings = List.from(RatingModel.mockRatings);
  final List<ReportModel> _reports = [];
  final Set<String> _blockedUsers = {};

  static const String trustEndpoint = '/api/v1/trust';

  @override
  Future<RatingModel> submitRating(RatingModel rating) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _ratings.insert(0, rating);
    return rating;
  }

  @override
  Future<List<RatingModel>> getUserRatings(String userId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _ratings.where((r) => r.ratedUserId == userId || r.raterId == userId).toList();
  }

  @override
  Future<ReportModel> submitReport(ReportModel report) async {
    await Future.delayed(const Duration(milliseconds: 350));
    _reports.insert(0, report);
    return report;
  }

  @override
  Future<bool> blockUser(String currentUserId, String targetUserId) async {
    await Future.delayed(const Duration(milliseconds: 250));
    _blockedUsers.add(targetUserId);
    return true;
  }
}
