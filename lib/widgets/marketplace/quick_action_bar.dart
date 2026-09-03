import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';

class QuickActionBar extends StatelessWidget {
  final String selectedType;
  final ValueChanged<String> onTypeSelected;

  const QuickActionBar({
    super.key,
    required this.selectedType,
    required this.onTypeSelected,
  });

  static const List<Map<String, dynamic>> _actions = [
    {
      'type': AppConstants.typeBuy,
      'title': 'Buy',
      'subtitle': 'Buy items',
      'icon': Icons.shopping_bag_rounded,
      'bgColor': Color(0xFFEAF8EE),
      'iconColor': Color(0xFF16A34A),
    },
    {
      'type': AppConstants.typeSell,
      'title': 'Sell',
      'subtitle': 'Sell items',
      'icon': Icons.local_offer_rounded,
      'bgColor': Color(0xFFF5F3FF),
      'iconColor': Color(0xFF7C3AED),
    },
    {
      'type': AppConstants.typeBorrow,
      'title': 'Borrow',
      'subtitle': 'Borrow items',
      'icon': Icons.handshake_rounded,
      'bgColor': Color(0xFFEBF5FF),
      'iconColor': Color(0xFF0284C7),
    },
    {
      'type': AppConstants.typeExchange,
      'title': 'Exchange',
      'subtitle': 'Exchange items',
      'icon': Icons.published_with_changes_rounded,
      'bgColor': Color(0xFFFFFBEB),
      'iconColor': Color(0xFFD97706),
    },
    {
      'type': AppConstants.typeDonate,
      'title': 'Donate',
      'subtitle': 'Donate items',
      'icon': Icons.favorite_rounded,
      'bgColor': Color(0xFFFDF2F8),
      'iconColor': Color(0xFFDB2777),
    },
    {
      'type': AppConstants.typeRequest,
      'title': 'Request',
      'subtitle': 'Request items',
      'icon': Icons.assignment_rounded,
      'bgColor': Color(0xFFECFEFF),
      'iconColor': Color(0xFF0891B2),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          child: Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF0F172A),
            ),
          ),
        ),
        const SizedBox(height: 8),

        // Horizontal Scrollable Cards
        SizedBox(
          height: 96,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: _actions.length,
            itemBuilder: (context, index) {
              final action = _actions[index];
              final type = action['type'] as String;
              final title = action['title'] as String;
              final subtitle = action['subtitle'] as String;
              final icon = action['icon'] as IconData;
              final bgColor = action['bgColor'] as Color;
              final iconColor = action['iconColor'] as Color;
              final isSelected = selectedType == type;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: InkWell(
                  onTap: () {
                    onTypeSelected(isSelected ? 'All Types' : type);
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    width: 90,
                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
                    decoration: BoxDecoration(
                      color: isSelected ? iconColor.withValues(alpha: 0.18) : bgColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? iconColor : Colors.transparent,
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(icon, color: iconColor, size: 24),
                        const SizedBox(height: 4),
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        Text(
                          subtitle,
                          style: const TextStyle(
                            fontSize: 9,
                            color: Color(0xFF64748B),
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
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
