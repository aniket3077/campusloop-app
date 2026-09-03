import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import '../repositories/transaction_repository.dart';

class TransactionProvider extends ChangeNotifier {
  final TransactionRepository _repository;

  List<TransactionModel> _transactions = [];
  bool _isLoading = false;
  String? _errorMessage;

  TransactionProvider({TransactionRepository? repository})
      : _repository = repository ?? TransactionRepository() {
    loadTransactions('user_101');
  }

  List<TransactionModel> get transactions => _transactions;
  List<TransactionModel> get activeTransactions =>
      _transactions.where((t) => t.status.isActive).toList();
  List<TransactionModel> get completedTransactions =>
      _transactions.where((t) => t.status.isCompleted).toList();

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadTransactions(String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _transactions = await _repository.getUserTransactions(userId);
    } catch (e) {
      _errorMessage = 'Failed to load campus transactions.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createTransaction(TransactionModel transaction) async {
    try {
      final created = await _repository.createTransaction(transaction);
      _transactions.insert(0, created);
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateStatus(String transactionId, TransactionStatus newStatus) async {
    try {
      final updated = await _repository.updateTransactionStatus(transactionId, newStatus);
      final index = _transactions.indexWhere((t) => t.id == transactionId);
      if (index != -1) {
        _transactions[index] = updated;
        notifyListeners();
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> submitRating(String transactionId, double rating, String review) async {
    try {
      final updated = await _repository.submitRating(transactionId, rating, review);
      final index = _transactions.indexWhere((t) => t.id == transactionId);
      if (index != -1) {
        _transactions[index] = updated;
        notifyListeners();
      }
      return true;
    } catch (e) {
      return false;
    }
  }
}
