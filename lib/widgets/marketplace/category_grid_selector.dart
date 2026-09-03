import 'package:flutter/material.dart';
import '../../core/navigation/app_routes.dart';

class CategoryGridSelector extends StatelessWidget {
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;

  const CategoryGridSelector({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  static const List<Map<String, dynamic>> _categories = [
    {
      'title': 'Books',
      'icon': Icons.menu_book_rounded,
      'bgColor': Color(0xFFEAF8EE),
      'iconColor': Color(0xFF16A34A),
    },
    {
      'title': 'Calculators',
      'icon': Icons.calculate_rounded,
      'bgColor': Color(0xFFEBF5FF),
      'iconColor': Color(0xFF0284C7),
    },
    {
      'title': 'Drawing Kits',
      'icon': Icons.architecture_rounded,
      'bgColor': Color(0xFFFFF7ED),
      'iconColor': Color(0xFFEA580C),
    },
    {
      'title': 'Electronics',
      'icon': Icons.desktop_windows_rounded,
      'bgColor': Color(0xFFF5F3FF),
      'iconColor': Color(0xFF7C3AED),
    },
    {
      'title': 'Lab Components',
      'icon': Icons.science_rounded,
      'bgColor': Color(0xFFFDF2F8),
      'iconColor': Color(0xFFDB2777),
    },
    {
      'title': 'Project Materials',
      'icon': Icons.settings_suggest_rounded,
      'bgColor': Color(0xFFECFEFF),
      'iconColor': Color(0xFF0891B2),
    },
    {
      'title': 'Tools',
      'icon': Icons.handyman_rounded,
      'bgColor': Color(0xFFFFF1F2),
      'iconColor': Color(0xFFE11D48),
    },
    {
      'title': 'Other',
      'icon': Icons.grid_view_rounded,
      'bgColor': Color(0xFFEFF6FF),
      'iconColor': Color(0xFF2563EB),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with "Explore by Category" and "See all"
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Explore by Category',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F172A),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.category, arguments: 'All');
                },
                child: const Text(
                  'See all',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF5B42F3),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),

        // 2 Rows x 4 Columns Grid
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _categories.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 0.96,
            ),
            itemBuilder: (context, index) {
              final cat = _categories[index];
              final title = cat['title'] as String;
              final icon = cat['icon'] as IconData;
              final bgColor = cat['bgColor'] as Color;
              final iconColor = cat['iconColor'] as Color;
              final isSelected = selectedCategory == title;

              return InkWell(
                onTap: () {
                  onCategorySelected(title);
                  Navigator.pushNamed(
                    context,
                    AppRoutes.category,
                    arguments: title,
                  );
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected ? iconColor.withValues(alpha: 0.15) : bgColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected ? iconColor : Colors.transparent,
                      width: 1.5,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        icon,
                        color: iconColor,
                        size: 26,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1E293B),
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
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
