import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class CampusBadge extends StatelessWidget {
  final String university;
  final bool isVerified;
  final bool isCompact;

  const CampusBadge({
    super.key,
    required this.university,
    this.isVerified = true,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 6.0 : 10.0,
        vertical: isCompact ? 2.0 : 4.0,
      ),
      decoration: BoxDecoration(
        color: AppColors.verifiedBadge.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.verifiedBadge.withValues(alpha: 0.3),
          width: 0.8,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.verified,
            size: 14,
            color: AppColors.verifiedBadge,
          ),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              isVerified ? '$university Student' : university,
              style: theme.textTheme.labelMedium?.copyWith(
                color: AppColors.verifiedBadge,
                fontWeight: FontWeight.w600,
                fontSize: isCompact ? 11 : 12,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
