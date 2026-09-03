import 'package:flutter/material.dart';
import '../../core/utils/formatters.dart';
import '../common/resource_type_chip.dart';

class ItemPreviewCard extends StatelessWidget {
  final String resourceId;
  final String resourceTitle;
  final String resourceType;
  final double resourcePrice;
  final VoidCallback? onMakeOffer;

  const ItemPreviewCard({
    super.key,
    required this.resourceId,
    required this.resourceTitle,
    required this.resourceType,
    required this.resourcePrice,
    this.onMakeOffer,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.2),
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.menu_book_rounded, color: theme.colorScheme.primary, size: 24),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ResourceTypeChip(resourceType: resourceType),
                    const SizedBox(width: 6),
                    Text(
                      Formatters.formatCurrency(resourcePrice),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  resourceTitle,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          if (onMakeOffer != null)
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              onPressed: onMakeOffer,
              child: const Text('Bargain', style: TextStyle(fontSize: 12)),
            ),
        ],
      ),
    );
  }
}
