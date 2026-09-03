import 'package:flutter/material.dart';
import '../../core/utils/formatters.dart';
import '../../models/offer_model.dart';
import '../../models/transaction_model.dart';
import '../../providers/app_state_provider.dart';
import '../../screens/pickup/select_pickup_location_screen.dart';

class OfferCardWidget extends StatelessWidget {
  final OfferModel offer;
  final VoidCallback? onCounterOffer;

  const OfferCardWidget({
    super.key,
    required this.offer,
    this.onCounterOffer,
  });

  Color _getStatusColor(OfferStatus status) {
    switch (status) {
      case OfferStatus.pending:
        return Colors.amber.shade800;
      case OfferStatus.accepted:
        return Colors.green.shade700;
      case OfferStatus.rejected:
      case OfferStatus.cancelled:
        return Colors.red.shade700;
      case OfferStatus.countered:
        return Colors.purple.shade700;
      case OfferStatus.expired:
        return Colors.grey.shade700;
    }
  }

  void _onAccept(BuildContext context) async {
    final appState = AppStateProvider.of(context);
    final offerProvider = appState.offerProvider;
    final txProvider = appState.transactionProvider;

    final success = await offerProvider.acceptOffer(offer.offerId);
    if (success && context.mounted) {
      // Create transaction with locked agreed price
      final newTx = TransactionModel(
        id: 'tx_${DateTime.now().millisecondsSinceEpoch}',
        resourceId: offer.itemId,
        resourceTitle: offer.itemTitle,
        resourcePrice: offer.offeredPrice, // Locked agreed price
        transactionType: TransactionType.sell,
        buyerId: offer.buyerId,
        buyerName: 'Alex Rivera',
        sellerId: offer.sellerId,
        sellerName: 'Marcus Chen',
        status: TransactionStatus.agreed,
        pickupLocation: 'Engineering Quad Bench A',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await txProvider.createTransaction(newTx);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Offer of \$${offer.offeredPrice.toStringAsFixed(2)} accepted! Price locked for pickup.'),
          ),
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SelectPickupLocationScreen(transaction: newTx),
          ),
        );
      }
    }
  }

  void _onReject(BuildContext context) async {
    final offerProvider = AppStateProvider.of(context).offerProvider;
    final success = await offerProvider.rejectOffer(offer.offerId);
    if (success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Offer declined.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = _getStatusColor(offer.status);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: statusColor.withValues(alpha: 0.4),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Status Badge & Listed vs Offered Price
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  offer.status.displayName.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
              Text(
                'Listed: ${Formatters.formatCurrency(offer.originalPrice)}',
                style: const TextStyle(
                  decoration: TextDecoration.lineThrough,
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Offered Price Highlight
          Row(
            children: [
              Text(
                'Offered Price: ',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              Text(
                Formatters.formatCurrency(offer.offeredPrice),
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: statusColor,
                ),
              ),
            ],
          ),

          if (offer.message != null && offer.message!.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              '"${offer.message}"',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: theme.colorScheme.onSurfaceVariant,
                fontSize: 12,
              ),
            ),
          ],
          const SizedBox(height: 12),

          // Actions based on Offer State
          if (offer.status == OfferStatus.pending) ...[
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    onPressed: () => _onReject(context),
                    child: const Text('Reject'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    onPressed: onCounterOffer,
                    child: const Text('Counter'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.green.shade700,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    onPressed: () => _onAccept(context),
                    child: const Text('Accept'),
                  ),
                ),
              ],
            ),
          ] else if (offer.status == OfferStatus.accepted) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '🔒 Price locked at ${Formatters.formatCurrency(offer.offeredPrice)}. Ready for pickup scheduling.',
                style: TextStyle(
                  color: Colors.green.shade900,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
