import 'package:flutter/material.dart';

/// Reusable image display widget that fetches and displays images from Supabase Storage S3
/// or external CDN, with loading indicator and graceful category icon fallback.
class ProductImageView extends StatelessWidget {
  final String? imageUrl;
  final String category;
  final double? height;
  final double? width;
  final BorderRadius? borderRadius;
  final BoxFit fit;
  final IconData? fallbackIcon;

  const ProductImageView({
    super.key,
    required this.imageUrl,
    this.category = 'General',
    this.height,
    this.width,
    this.borderRadius,
    this.fit = BoxFit.cover,
    this.fallbackIcon,
  });

  @override
  Widget build(BuildContext context) {
    final validUrl = imageUrl != null && imageUrl!.trim().isNotEmpty;

    Widget imageWidget;

    if (validUrl) {
      imageWidget = Image.network(
        imageUrl!.trim(),
        height: height,
        width: width,
        fit: fit,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              color: _getCategoryColor(category).withValues(alpha: 0.12),
            ),
            child: Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                  color: _getCategoryColor(category),
                ),
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return _buildPlaceholder();
        },
      );
    } else {
      imageWidget = _buildPlaceholder();
    }

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: imageWidget,
      );
    }

    return imageWidget;
  }

  Widget _buildPlaceholder() {
    final color = _getCategoryColor(category);
    final icon = fallbackIcon ?? _getCategoryIcon(category);

    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
      ),
      child: Center(
        child: Icon(
          icon,
          size: (height != null && height! < 90) ? 32 : 44,
          color: color,
        ),
      ),
    );
  }

  Color _getCategoryColor(String cat) {
    switch (cat.toLowerCase()) {
      case 'books':
      case 'textbooks':
        return const Color(0xFF4F46E5);
      case 'electronics':
      case 'calculators':
        return const Color(0xFF0284C7);
      case 'lab equipment':
      case 'lab gear':
        return const Color(0xFF0D9488);
      case 'notes':
      case 'study materials':
        return const Color(0xFFE11D48);
      case 'dorm living':
      case 'dorm essentials':
        return const Color(0xFFF59E0B);
      case 'digital courses':
      case 'software':
        return const Color(0xFF7C3AED);
      default:
        return const Color(0xFF6366F1);
    }
  }

  IconData _getCategoryIcon(String cat) {
    switch (cat.toLowerCase()) {
      case 'books':
      case 'textbooks':
        return Icons.menu_book_rounded;
      case 'electronics':
      case 'calculators':
        return Icons.calculate_outlined;
      case 'lab equipment':
      case 'lab gear':
        return Icons.science_outlined;
      case 'notes':
      case 'study materials':
        return Icons.edit_note_rounded;
      case 'dorm living':
      case 'dorm essentials':
        return Icons.weekend_outlined;
      case 'digital courses':
      case 'software':
        return Icons.computer_rounded;
      default:
        return Icons.category_rounded;
    }
  }
}
