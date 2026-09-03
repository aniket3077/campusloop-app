import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';

class CategoryGridSelector extends StatelessWidget {
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;

  const CategoryGridSelector({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          child: Text(
            'Categories',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 86,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: AppConstants.categories.length,
            itemBuilder: (context, index) {
              final category = AppConstants.categories[index];
              final isSelected = category == selectedCategory;
              final icon = _getCategoryIcon(category);

              return GestureDetector(
                onTap: () => onCategorySelected(category),
                child: Container(
                  width: 72,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? theme.colorScheme.primary
                              : theme.colorScheme.primaryContainer.withValues(alpha: 0.25),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? theme.colorScheme.primary
                                : theme.colorScheme.outline.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Icon(
                          icon,
                          size: 22,
                          color: isSelected
                              ? Colors.white
                              : theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        category,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          color: isSelected
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
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

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Books':
        return Icons.menu_book_rounded;
      case 'Calculators':
        return Icons.calculate_rounded;
      case 'Drawing Kits':
        return Icons.draw_rounded;
      case 'Electronics':
        return Icons.developer_board_rounded;
      case 'Lab Components':
        return Icons.science_rounded;
      case 'Project Materials':
        return Icons.inventory_2_rounded;
      case 'Tools':
        return Icons.build_rounded;
      case 'Other':
        return Icons.category_rounded;
      default:
        return Icons.grid_view_rounded;
    }
  }
}
