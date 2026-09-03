import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../constants/app_constants.dart';

class Formatters {
  static String formatCurrency(double amount) {
    if (amount == 0) return 'Free';
    final isInt = amount.truncateToDouble() == amount;
    return '₹${isInt ? amount.toInt() : amount.toStringAsFixed(2)}';
  }

  static String formatRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 7) {
      return '${dateTime.month}/${dateTime.day}/${dateTime.year}';
    } else if (difference.inDays >= 1) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours >= 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes >= 1) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  static Color getResourceTypeColor(String type) {
    switch (type.toUpperCase()) {
      case AppConstants.typeBuy:
      case AppConstants.typeSell:
        return AppColors.badgeBuy;
      case AppConstants.typeBorrow:
        return AppColors.badgeBorrow;
      case AppConstants.typeExchange:
        return AppColors.badgeExchange;
      case AppConstants.typeDonate:
        return AppColors.badgeDonate;
      case AppConstants.typeRequest:
        return AppColors.badgeRequest;
      default:
        return AppColors.primary;
    }
  }
}
