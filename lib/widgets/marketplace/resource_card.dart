import 'package:flutter/material.dart';
import '../../models/academic_resource_model.dart';
import '../../core/utils/formatters.dart';

import '../common/resource_type_chip.dart';

class ResourceCard extends StatelessWidget {
  final AcademicResourceModel resource;
  final VoidCallback onTap;

  const ResourceCard({
    super.key,
    required this.resource,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image header & badges
            Stack(
              children: [
                Container(
                  height: 120,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                  ),
                  child: Center(
                    child: Icon(
                      _getCategoryIcon(resource.category),
                      size: 48,
                      color: theme.colorScheme.primary.withValues(alpha: 0.6),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: ResourceTypeChip(resourceType: resource.resourceType),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.65),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      Formatters.formatCurrency(resource.price),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Item Information
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    resource.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 13,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          resource.pickupLocation,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 10,
                            backgroundColor: theme.colorScheme.primary,
                            child: Text(
                              resource.sellerName.isNotEmpty
                                  ? resource.sellerName[0]
                                  : 'U',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            resource.sellerName,
                            style: theme.textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if (resource.isVerifiedSeller)
                            const Padding(
                              padding: EdgeInsets.only(left: 2),
                              child: Icon(
                                Icons.verified,
                                size: 12,
                                color: Color(0xFF0284C7),
                              ),
                            ),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded, size: 14, color: Color(0xFFF59E0B)),
                          Text(
                            resource.sellerRating.toStringAsFixed(1),
                            style: theme.textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    if (category.contains('Textbooks')) return Icons.menu_book_rounded;
    if (category.contains('Lab')) return Icons.science_rounded;
    if (category.contains('Notes')) return Icons.notes_rounded;
    if (category.contains('Electronics')) return Icons.calculate_rounded;
    if (category.contains('Drafting')) return Icons.brush_rounded;
    return Icons.inventory_2_rounded;
  }
}
