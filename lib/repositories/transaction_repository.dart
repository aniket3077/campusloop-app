import '../models/transaction_model.dart';
import '../services/firestore_transaction_service.dart';
import '../services/transaction_service.dart';

class TransactionRepository {
  final TransactionService _transactionService;

  TransactionRepository({TransactionService? transactionService})
      : _transactionService = transactionService ?? FirestoreTransactionService();

  Future<List<TransactionModel>> getUserTransactions(String userId) =>
      _transactionService.getUserTransactions(userId);

  Future<TransactionModel> createTransaction(TransactionModel transaction) =>
      _transactionService.createTransaction(transaction);

  Future<TransactionModel> updateTransactionStatus(
          String transactionId, TransactionStatus status) =>
      _transactionService.updateTransactionStatus(transactionId, status);

  Future<TransactionModel> submitRating(
          String transactionId, double rating, String review) =>
      _transactionService.submitRating(transactionId, rating, review);
}
