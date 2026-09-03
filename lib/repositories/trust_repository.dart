import '../models/rating_model.dart';
import '../models/report_model.dart';
import '../services/trust_service.dart';

class TrustRepository {
  final TrustService _trustService;

  TrustRepository({TrustService? trustService})
      : _trustService = trustService ?? CloudRunTrustService();

  Future<RatingModel> submitRating(RatingModel rating) =>
      _trustService.submitRating(rating);

  Future<List<RatingModel>> getUserRatings(String userId) =>
      _trustService.getUserRatings(userId);

  Future<ReportModel> submitReport(ReportModel report) =>
      _trustService.submitReport(report);

  Future<bool> blockUser(String currentUserId, String targetUserId) =>
      _trustService.blockUser(currentUserId, targetUserId);
}
