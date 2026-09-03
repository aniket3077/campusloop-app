import '../models/impact_stats_model.dart';

abstract class ImpactService {
  Future<ImpactStatsModel> getCampusImpactStats(String university);
}

class MockImpactService implements ImpactService {
  @override
  Future<ImpactStatsModel> getCampusImpactStats(String university) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return ImpactStatsModel.mockCampusImpact;
  }
}
