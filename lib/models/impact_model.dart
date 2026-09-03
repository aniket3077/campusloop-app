import 'transaction_model.dart';

class ImpactModel {
  final int itemsReused;
  final int successfulTransfers;
  final double moneySaved;
  final int borrowTransactions;
  final int donations;
  final int exchanges;
  final double wasteAvoidedKg;

  const ImpactModel({
    required this.itemsReused,
    required this.successfulTransfers,
    required this.moneySaved,
    required this.borrowTransactions,
    required this.donations,
    required this.exchanges,
    required this.wasteAvoidedKg,
  });

  /// Dynamically calculate impact metrics from actual transaction records
  factory ImpactModel.fromTransactions(List<TransactionModel> transactions) {
    int reused = 0;
    int transfers = 0;
    double saved = 0.0;
    int borrows = 0;
    int dons = 0;
    int exch = 0;

    for (final tx in transactions) {
      if (tx.status == TransactionStatus.completed ||
          tx.status == TransactionStatus.rated ||
          tx.status == TransactionStatus.returned ||
          tx.status == TransactionStatus.borrowed) {
        transfers++;
        reused++;

        switch (tx.transactionType) {
          case TransactionType.sell:
            // Estimated savings on used textbook/gear vs new retail (~40% saved)
            saved += (tx.resourcePrice > 0 ? tx.resourcePrice * 0.7 : 20.0);
            break;
          case TransactionType.borrow:
            borrows++;
            // Full purchase price saved by borrowing instead of buying (~$80 avg)
            saved += (tx.resourcePrice > 0 ? tx.resourcePrice * 4 : 75.0);
            break;
          case TransactionType.exchange:
            exch++;
            // Value of both items exchanged without spending money
            saved += 45.0;
            break;
          case TransactionType.donate:
            dons++;
            // Full retail value saved by receiving a donation
            saved += 35.0;
            break;
        }
      }
    }

    // Waste avoided calculation: ~2.2 kg of landfill e-waste/paper waste avoided per item reused
    final wasteKg = reused * 2.2;

    return ImpactModel(
      itemsReused: reused,
      successfulTransfers: transfers,
      moneySaved: saved,
      borrowTransactions: borrows,
      donations: dons,
      exchanges: exch,
      wasteAvoidedKg: wasteKg,
    );
  }

  factory ImpactModel.fromJson(Map<String, dynamic> json) {
    return ImpactModel(
      itemsReused: json['itemsReused'] as int? ?? 0,
      successfulTransfers: json['successfulTransfers'] as int? ?? 0,
      moneySaved: (json['moneySaved'] as num?)?.toDouble() ?? 0.0,
      borrowTransactions: json['borrowTransactions'] as int? ?? 0,
      donations: json['donations'] as int? ?? 0,
      exchanges: json['exchanges'] as int? ?? 0,
      wasteAvoidedKg: (json['wasteAvoidedKg'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'itemsReused': itemsReused,
      'successfulTransfers': successfulTransfers,
      'moneySaved': moneySaved,
      'borrowTransactions': borrowTransactions,
      'donations': donations,
      'exchanges': exchanges,
      'wasteAvoidedKg': wasteAvoidedKg,
    };
  }
}
