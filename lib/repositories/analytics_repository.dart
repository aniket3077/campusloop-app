import '../models/impact_model.dart';
import '../models/transaction_model.dart';
import '../services/analytics_service.dart';

class AnalyticsRepository {
  final AnalyticsService _analyticsService;

  AnalyticsRepository({AnalyticsService? analyticsService})
      : _analyticsService = analyticsService ?? CloudRunAnalyticsService();

  Future<ImpactModel> getUserImpact(String userId, List<TransactionModel> transactions) =>
      _analyticsService.getUserImpact(userId, transactions);

  Future<ImpactModel> getCampusImpact(String university, List<TransactionModel> transactions) =>
      _analyticsService.getCampusImpact(university, transactions);

  Future<ImpactModel> getTotalImpact(List<TransactionModel> transactions) =>
      _analyticsService.getTotalImpact(transactions);
}
