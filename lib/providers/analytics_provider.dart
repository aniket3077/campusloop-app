import 'package:flutter/material.dart';
import '../models/impact_model.dart';
import '../models/transaction_model.dart';
import '../repositories/analytics_repository.dart';

enum ImpactScope {
  user,
  campus,
  total,
}

class AnalyticsProvider extends ChangeNotifier {
  final AnalyticsRepository _repository;

  ImpactModel? _userImpact;
  ImpactModel? _campusImpact;
  ImpactModel? _totalImpact;
  ImpactScope _activeScope = ImpactScope.campus;
  bool _isLoading = false;

  AnalyticsProvider({AnalyticsRepository? repository})
      : _repository = repository ?? AnalyticsRepository();

  ImpactModel? get activeImpact {
    switch (_activeScope) {
      case ImpactScope.user:
        return _userImpact;
      case ImpactScope.campus:
        return _campusImpact;
      case ImpactScope.total:
        return _totalImpact;
    }
  }

  ImpactScope get activeScope => _activeScope;
  bool get isLoading => _isLoading;

  void setScope(ImpactScope scope) {
    _activeScope = scope;
    notifyListeners();
  }

  Future<void> refreshAnalytics(String userId, String university, List<TransactionModel> transactions) async {
    _isLoading = true;
    notifyListeners();

    try {
      _userImpact = await _repository.getUserImpact(userId, transactions);
      _campusImpact = await _repository.getCampusImpact(university, transactions);
      _totalImpact = await _repository.getTotalImpact(transactions);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
