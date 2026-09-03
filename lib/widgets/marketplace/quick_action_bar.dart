import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/formatters.dart';

class QuickActionBar extends StatelessWidget {
  final String selectedType;
  final ValueChanged<String> onTypeSelected;

  const QuickActionBar({
    super.key,
    required this.selectedType,
    required this.onTypeSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final actions = [
      {'type': AppConstants.typeBuy, 'label': 'Buy', 'icon': Icons.shopping_bag_outlined},
      {'type': AppConstants.typeSell, 'label': 'Sell', 'icon': Icons.sell_outlined},
      {'type': AppConstants.typeBorrow, 'label': 'Borrow', 'icon': Icons.repeat_rounded},
      {'type': AppConstants.typeExchange, 'label': 'Exchange', 'icon': Icons.swap_horiz_rounded},
      {'type': AppConstants.typeDonate, 'label': 'Donate', 'icon': Icons.volunteer_activism_outlined},
      {'type': AppConstants.typeRequest, 'label': 'Request', 'icon': Icons.add_alert_outlined},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          child: Text(
            'Quick Actions',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 42,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: actions.length,
            itemBuilder: (context, index) {
              final action = actions[index];
              final type = action['type'] as String;
              final label = action['label'] as String;
              final icon = action['icon'] as IconData;
              final isSelected = selectedType == type;
              final color = Formatters.getResourceTypeColor(type);

              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: InkWell(
                  onTap: () => onTypeSelected(isSelected ? 'All Types' : type),
                  borderRadius: BorderRadius.circular(20),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? color : color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: color,
                        width: isSelected ? 1.5 : 1.0,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          icon,
                          size: 16,
                          color: isSelected ? Colors.white : color,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          label,
                          style: TextStyle(
                            color: isSelected ? Colors.white : color,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
