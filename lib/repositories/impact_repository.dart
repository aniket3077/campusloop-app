import '../models/impact_stats_model.dart';
import '../services/impact_service.dart';

class ImpactRepository {
  final ImpactService _impactService;

  ImpactRepository({ImpactService? impactService})
      : _impactService = impactService ?? MockImpactService();

  Future<ImpactStatsModel> getCampusImpactStats(String university) =>
      _impactService.getCampusImpactStats(university);
}
