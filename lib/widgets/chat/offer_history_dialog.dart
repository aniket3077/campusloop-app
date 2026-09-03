import 'package:flutter/material.dart';
import '../../core/utils/formatters.dart';
import '../../models/offer_model.dart';
import '../../providers/app_state_provider.dart';

class OfferHistoryDialog extends StatelessWidget {
  final String itemId;
  final String itemTitle;

  const OfferHistoryDialog({
    super.key,
    required this.itemId,
    required this.itemTitle,
  });

  static void show(BuildContext context, String itemId, String itemTitle) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => OfferHistoryDialog(itemId: itemId, itemTitle: itemTitle),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final offerProvider = AppStateProvider.of(context).offerProvider;

    return ListenableBuilder(
      listenable: offerProvider,
      builder: (context, _) {
        final itemOffers = offerProvider.offers.where((o) => o.itemId == itemId || itemId.contains('res')).toList();

        return Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.outline.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Text(
                'Bargain Offer History',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                itemTitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),

              if (itemOffers.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24.0),
                  child: Center(child: Text('No bargain offers proposed yet.')),
                )
              else
                ...itemOffers.map((o) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Offered: ${Formatters.formatCurrency(o.offeredPrice)}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: o.status == OfferStatus.accepted ? Colors.green.shade700 : Colors.amber.shade800,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              o.status.displayName,
                              style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (o.message != null && o.message!.isNotEmpty)
                            Text('"${o.message}"', style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic)),
                          Text(Formatters.formatRelativeTime(o.createdAt), style: const TextStyle(fontSize: 10, color: Colors.grey)),
                        ],
                      ),
                    ),
                  );
                }),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }
}
