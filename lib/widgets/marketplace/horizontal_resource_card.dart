import 'package:flutter/material.dart';
import '../../core/utils/formatters.dart';
import '../../models/academic_resource_model.dart';
import '../common/resource_type_chip.dart';

class HorizontalResourceCard extends StatelessWidget {
  final AcademicResourceModel resource;
  final VoidCallback onTap;

  const HorizontalResourceCard({
    super.key,
    required this.resource,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 170,
      margin: const EdgeInsets.only(right: 12),
      child: Card(
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image / Category icon header
              Stack(
                children: [
                  Container(
                    height: 100,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                    ),
                    child: Center(
                      child: Icon(
                        _getCategoryIcon(resource.category),
                        size: 40,
                        color: theme.colorScheme.primary.withValues(alpha: 0.7),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 6,
                    left: 6,
                    child: ResourceTypeChip(resourceType: resource.resourceType),
                  ),
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        Formatters.formatCurrency(resource.price),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      resource.title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 12,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            resource.pickupLocation,
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontSize: 10,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
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
      default:
        return Icons.category_rounded;
    }
  }
}
