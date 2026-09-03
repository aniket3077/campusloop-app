import 'package:flutter/material.dart';
import '../models/rating_model.dart';
import '../models/report_model.dart';
import '../repositories/trust_repository.dart';

class TrustProvider extends ChangeNotifier {
  final TrustRepository _repository;

  List<RatingModel> _userRatings = [];
  bool _isLoading = false;
  String? _errorMessage;

  TrustProvider({TrustRepository? repository})
      : _repository = repository ?? TrustRepository() {
    loadUserRatings('user_101');
  }

  List<RatingModel> get userRatings => _userRatings;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  double get averageRating {
    if (_userRatings.isEmpty) return 5.0;
    final total = _userRatings.fold<double>(0.0, (sum, r) => sum + r.rating);
    return total / _userRatings.length;
  }

  Future<void> loadUserRatings(String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _userRatings = await _repository.getUserRatings(userId);
    } catch (e) {
      _errorMessage = 'Failed to load ratings.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> submitRating(RatingModel rating) async {
    try {
      final submitted = await _repository.submitRating(rating);
      _userRatings.insert(0, submitted);
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> submitReport(ReportModel report) async {
    try {
      await _repository.submitReport(report);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> blockUser(String currentUserId, String targetUserId) async {
    try {
      return await _repository.blockUser(currentUserId, targetUserId);
    } catch (e) {
      return false;
    }
  }
}
