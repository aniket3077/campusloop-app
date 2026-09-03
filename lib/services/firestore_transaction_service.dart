import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../core/firebase/firebase_manager.dart';
import '../models/transaction_model.dart';
import 'transaction_service.dart';

/// Concrete Google Cloud Firestore implementation of [TransactionService]
class FirestoreTransactionService implements TransactionService {
  final FirebaseFirestore? _firestore;
  final TransactionService _fallbackService;

  FirestoreTransactionService({
    FirebaseFirestore? firestore,
    TransactionService? fallbackService,
  })  : _firestore = firestore ?? FirebaseManager.firestore,
        _fallbackService = fallbackService ?? CloudRunTransactionService();

  CollectionReference<Map<String, dynamic>>? get _col {
    final db = _firestore ?? FirebaseManager.firestore;
    return db?.collection(FirebaseManager.colTransactions);
  }

  @override
  Future<List<TransactionModel>> getUserTransactions(String userId) async {
    final col = _col;
    if (col == null) return _fallbackService.getUserTransactions(userId);

    try {
      final buyerQuery = await col.where('buyerId', isEqualTo: userId).get();
      final sellerQuery = await col.where('sellerId', isEqualTo: userId).get();

      final allDocs = <String, DocumentSnapshot<Map<String, dynamic>>>{};
      for (final doc in buyerQuery.docs) {
        allDocs[doc.id] = doc;
      }
      for (final doc in sellerQuery.docs) {
        allDocs[doc.id] = doc;
      }

      if (allDocs.isEmpty) {
        return _fallbackService.getUserTransactions(userId);
      }

      final items = allDocs.values.map((doc) {
        final data = Map<String, dynamic>.from(doc.data()!);
        data['id'] = doc.id;
        return TransactionModel.fromJson(data);
      }).toList();

      items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return items;
    } catch (e) {
      debugPrint('[FirestoreTransactionService] Error querying transactions: $e');
      return _fallbackService.getUserTransactions(userId);
    }
  }

  @override
  Future<TransactionModel> createTransaction(TransactionModel transaction) async {
    final col = _col;
    if (col == null) return _fallbackService.createTransaction(transaction);

    try {
      final data = transaction.toJson();
      if (transaction.id.isNotEmpty) {
        await col.doc(transaction.id).set(data, SetOptions(merge: true));
      } else {
        final ref = await col.add(data);
        return transaction.copyWith(id: ref.id);
      }
      return transaction;
    } catch (e) {
      debugPrint('[FirestoreTransactionService] Error creating transaction: $e');
      return _fallbackService.createTransaction(transaction);
    }
  }

  @override
  Future<TransactionModel> updateTransactionStatus(
    String transactionId,
    TransactionStatus status,
  ) async {
    final col = _col;
    if (col == null) {
      return _fallbackService.updateTransactionStatus(transactionId, status);
    }

    try {
      await col.doc(transactionId).update({
        'status': status.name,
        'updatedAt': DateTime.now().toIso8601String(),
      });
      final doc = await col.doc(transactionId).get();
      if (doc.exists && doc.data() != null) {
        final data = Map<String, dynamic>.from(doc.data()!);
        data['id'] = doc.id;
        return TransactionModel.fromJson(data);
      }
    } catch (e) {
      debugPrint('[FirestoreTransactionService] Error updating status: $e');
    }
    return _fallbackService.updateTransactionStatus(transactionId, status);
  }

  @override
  Future<TransactionModel> submitRating(
    String transactionId,
    double rating,
    String review,
  ) async {
    final col = _col;
    if (col == null) {
      return _fallbackService.submitRating(transactionId, rating, review);
    }

    try {
      await col.doc(transactionId).update({
        'rating': rating,
        'review': review,
        'status': TransactionStatus.rated.name,
        'updatedAt': DateTime.now().toIso8601String(),
      });
      final doc = await col.doc(transactionId).get();
      if (doc.exists && doc.data() != null) {
        final data = Map<String, dynamic>.from(doc.data()!);
        data['id'] = doc.id;
        return TransactionModel.fromJson(data);
      }
    } catch (e) {
      debugPrint('[FirestoreTransactionService] Error submitting rating: $e');
    }
    return _fallbackService.submitRating(transactionId, rating, review);
  }
}
