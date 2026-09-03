import 'package:flutter/material.dart';
import '../../providers/resource_provider.dart';

class SortBottomSheet extends StatelessWidget {
  final ResourceProvider resourceProvider;

  const SortBottomSheet({
    super.key,
    required this.resourceProvider,
  });

  static Future<void> show(BuildContext context, ResourceProvider provider) {
    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SortBottomSheet(resourceProvider: provider),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentSort = resourceProvider.sortOption;

    final sortOptions = [
      {'option': SortOption.newest, 'label': 'Most Recent (Newest First)', 'icon': Icons.access_time_rounded},
      {'option': SortOption.priceAsc, 'label': 'Price: Low to High', 'icon': Icons.arrow_upward_rounded},
      {'option': SortOption.priceDesc, 'label': 'Price: High to Low', 'icon': Icons.arrow_downward_rounded},
      {'option': SortOption.highestRating, 'label': 'Highest Rated Seller', 'icon': Icons.star_rounded},
      {'option': SortOption.nearby, 'label': 'Nearby Campus Pickup', 'icon': Icons.near_me_rounded},
    ];

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
            'Sort Marketplace Items',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...sortOptions.map((item) {
            final option = item['option'] as SortOption;
            final label = item['label'] as String;
            final icon = item['icon'] as IconData;
            final isSelected = currentSort == option;

            return ListTile(
              leading: Icon(
                icon,
                color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
              ),
              title: Text(
                label,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface,
                ),
              ),
              trailing: isSelected
                  ? Icon(Icons.check_circle_rounded, color: theme.colorScheme.primary)
                  : null,
              onTap: () {
                resourceProvider.setSortOption(option);
                Navigator.pop(context);
              },
            );
          }),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
