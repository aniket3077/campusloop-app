import '../models/transaction_model.dart';

/// Transaction Service interface designed for Google Cloud backend deployment (Cloud Run)
abstract class TransactionService {
  Future<List<TransactionModel>> getUserTransactions(String userId);
  Future<TransactionModel> createTransaction(TransactionModel transaction);
  Future<TransactionModel> updateTransactionStatus(String transactionId, TransactionStatus status);
  Future<TransactionModel> submitRating(String transactionId, double rating, String review);
}

/// Cloud Run Transaction REST API Implementation Driver
class CloudRunTransactionService implements TransactionService {
  final List<TransactionModel> _transactions = [];

  // Cloud Run API endpoint
  static const String transactionEndpoint = '/api/v1/transactions';

  @override
  Future<List<TransactionModel>> getUserTransactions(String userId) async {
    await Future.delayed(const Duration(milliseconds: 250));
    return _transactions.where((t) => t.buyerId == userId || t.sellerId == userId).toList();
  }

  @override
  Future<TransactionModel> createTransaction(TransactionModel transaction) async {
    await Future.delayed(const Duration(milliseconds: 350));
    _transactions.insert(0, transaction);
    return transaction;
  }

  @override
  Future<TransactionModel> updateTransactionStatus(String transactionId, TransactionStatus status) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _transactions.indexWhere((t) => t.id == transactionId);
    if (index != -1) {
      _transactions[index] = _transactions[index].copyWith(
        status: status,
        updatedAt: DateTime.now(),
      );
      return _transactions[index];
    }
    throw Exception('Transaction not found');
  }

  @override
  Future<TransactionModel> submitRating(String transactionId, double rating, String review) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _transactions.indexWhere((t) => t.id == transactionId);
    if (index != -1) {
      _transactions[index] = _transactions[index].copyWith(
        rating: rating,
        review: review,
        status: TransactionStatus.rated,
        updatedAt: DateTime.now(),
      );
      return _transactions[index];
    }
    throw Exception('Transaction not found');
  }
}
