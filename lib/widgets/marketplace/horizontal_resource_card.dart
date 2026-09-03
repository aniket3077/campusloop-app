import 'package:flutter/material.dart';
import '../../core/utils/formatters.dart';
import '../../models/academic_resource_model.dart';

class HorizontalResourceCard extends StatelessWidget {
  final AcademicResourceModel resource;
  final VoidCallback onTap;
  final bool isCompact;

  const HorizontalResourceCard({
    super.key,
    required this.resource,
    required this.onTap,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isCompact) {
      return _buildCompactCard(context);
    }
    return _buildRecommendedCard(context);
  }

  // 1. Recommended For You Card
  Widget _buildRecommendedCard(BuildContext context) {
    final isLikeNew = resource.condition.toLowerCase().contains('like new');
    final conditionBg = isLikeNew ? const Color(0xFF2563EB) : const Color(0xFF16A34A);

    return Container(
      width: 154,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Image Area with Heart and Condition Badge
            Stack(
              children: [
                Container(
                  height: 108,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: _getItemBgColor(resource.category),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  child: Center(
                    child: Icon(
                      _getItemIcon(resource.title, resource.category),
                      size: 44,
                      color: _getItemIconColor(resource.category),
                    ),
                  ),
                ),

                // Top Right Favorite Heart Icon
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.favorite_border_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),

                // Bottom Left Condition Badge
                Positioned(
                  bottom: 6,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                      color: conditionBg,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      resource.condition,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Card Body Details
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    resource.title,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),

                  // Price in Vibrant Green + Course Badge
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        Formatters.formatCurrency(resource.price),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF16A34A),
                        ),
                      ),
                      if (resource.courseCode != null && resource.courseCode!.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEEF2FF),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: const Color(0xFFC7D2FE), width: 0.8),
                          ),
                          child: Text(
                            resource.courseCode!,
                            style: const TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF4F46E5),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Seller & Star Rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          resource.sellerName,
                          style: const TextStyle(
                            fontSize: 10,
                            color: Color(0xFF64748B),
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            size: 12,
                            color: Color(0xFFF59E0B),
                          ),
                          const SizedBox(width: 2),
                          Text(
                            resource.sellerRating.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF334155),
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

  // 2. Compact Recent Listings Card
  Widget _buildCompactCard(BuildContext context) {
    final distanceText = resource.distanceMeters != null
        ? '${resource.distanceMeters} m'
        : '250 m';

    return Container(
      width: 122,
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Area
            Container(
              height: 76,
              width: double.infinity,
              decoration: BoxDecoration(
                color: _getItemBgColor(resource.category),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
              ),
              child: Center(
                child: Icon(
                  _getItemIcon(resource.title, resource.category),
                  size: 34,
                  color: _getItemIconColor(resource.category),
                ),
              ),
            ),

            // Text Info
            Padding(
              padding: const EdgeInsets.all(7.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Course Code if present
                  if (resource.courseCode != null && resource.courseCode!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 1.0),
                      child: Text(
                        resource.courseCode!,
                        style: const TextStyle(
                          fontSize: 8.5,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF4F46E5),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                  // Title
                  Text(
                    resource.title,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),

                  // Price & Distance
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        Formatters.formatCurrency(resource.price),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF16A34A),
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 10,
                            color: Color(0xFFF97316),
                          ),
                          Text(
                            distanceText,
                            style: const TextStyle(
                              fontSize: 9,
                              color: Color(0xFF64748B),
                              fontWeight: FontWeight.w600,
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

  IconData _getItemIcon(String title, String category) {
    final lower = title.toLowerCase();
    if (lower.contains('calculator')) return Icons.calculate_rounded;
    if (lower.contains('drawing') || lower.contains('drafting')) return Icons.architecture_rounded;
    if (lower.contains('arduino') || lower.contains('board')) return Icons.developer_board_rounded;
    if (lower.contains('multimeter') || lower.contains('meter')) return Icons.electric_meter_rounded;
    if (lower.contains('lab') || lower.contains('chemistry')) return Icons.science_rounded;
    if (lower.contains('book') || lower.contains('textbook') || lower.contains('mechanics') || lower.contains('physics')) {
      return Icons.menu_book_rounded;
    }

    switch (category) {
      case 'Books':
        return Icons.menu_book_rounded;
      case 'Calculators':
        return Icons.calculate_rounded;
      case 'Drawing Kits':
        return Icons.architecture_rounded;
      case 'Electronics':
        return Icons.developer_board_rounded;
      case 'Lab Components':
        return Icons.science_rounded;
      case 'Project Materials':
        return Icons.inventory_2_rounded;
      case 'Tools':
        return Icons.handyman_rounded;
      default:
        return Icons.category_rounded;
    }
  }

  Color _getItemBgColor(String category) {
    switch (category) {
      case 'Books':
        return const Color(0xFFEAF8EE);
      case 'Calculators':
        return const Color(0xFFEBF5FF);
      case 'Drawing Kits':
        return const Color(0xFFFFF7ED);
      case 'Electronics':
        return const Color(0xFFF5F3FF);
      case 'Lab Components':
        return const Color(0xFFFDF2F8);
      case 'Project Materials':
        return const Color(0xFFECFEFF);
      case 'Tools':
        return const Color(0xFFFFF1F2);
      default:
        return const Color(0xFFEFF6FF);
    }
  }

  Color _getItemIconColor(String category) {
    switch (category) {
      case 'Books':
        return const Color(0xFF16A34A);
      case 'Calculators':
        return const Color(0xFF0284C7);
      case 'Drawing Kits':
        return const Color(0xFFEA580C);
      case 'Electronics':
        return const Color(0xFF7C3AED);
      case 'Lab Components':
        return const Color(0xFFDB2777);
      case 'Project Materials':
        return const Color(0xFF0891B2);
      case 'Tools':
        return const Color(0xFFE11D48);
      default:
        return const Color(0xFF2563EB);
    }
  }
}
