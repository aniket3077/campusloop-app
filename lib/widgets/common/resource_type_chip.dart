import 'package:flutter/material.dart';
import '../../core/utils/formatters.dart';

class ResourceTypeChip extends StatelessWidget {
  final String resourceType;
  final bool isSelected;
  final VoidCallback? onTap;

  const ResourceTypeChip({
    super.key,
    required this.resourceType,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final typeColor = Formatters.getResourceTypeColor(resourceType);

    if (onTap == null) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: typeColor.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: typeColor.withValues(alpha: 0.4), width: 0.8),
        ),
        child: Text(
          resourceType.toUpperCase(),
          style: TextStyle(
            color: typeColor,
            fontWeight: FontWeight.bold,
            fontSize: 10,
            letterSpacing: 0.5,
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color: isSelected ? typeColor : typeColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: typeColor,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Text(
          resourceType,
          style: TextStyle(
            color: isSelected ? Colors.white : typeColor,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
