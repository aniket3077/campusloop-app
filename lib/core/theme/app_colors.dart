import 'package:flutter/material.dart';

/// CampusLoop Color Palette Extracted Directly From the Official Logo
/// Features the signature Emerald Green, Deep Navy Blue, Royal Violet, Sunset Gold, and Crimson Rose.
class AppColors {
  // Primary - Vibrant Emerald Green (Matching "Loop" & Eco Leaves)
  static const Color primary = Color(0xFF00A86B);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFFD1FAE5);
  static const Color onPrimaryContainer = Color(0xFF064E3B);

  // Secondary - Deep Navy Blue (Matching "Campus" & Graduation Cap)
  static const Color secondary = Color(0xFF0A192F);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFFE2E8F0);
  static const Color onSecondaryContainer = Color(0xFF0F172A);

  // Tertiary - Royal Purple / Violet (Matching Infinity Loop Gradient & Book Stack)
  static const Color tertiary = Color(0xFF7C3AED);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color tertiaryContainer = Color(0xFFEDE9FE);
  static const Color onTertiaryContainer = Color(0xFF4C1D95);

  // Neutral & Surfaces - Light Mode
  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color onBackgroundLight = Color(0xFF0F172A);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color onSurfaceLight = Color(0xFF0F172A);
  static const Color surfaceVariantLight = Color(0xFFF1F5F9);
  static const Color onSurfaceVariantLight = Color(0xFF475569);
  static const Color outlineLight = Color(0xFFCBD5E1);

  // Neutral & Surfaces - Dark Mode
  static const Color backgroundDark = Color(0xFF0A0F1D);
  static const Color onBackgroundDark = Color(0xFFF1F5F9);
  static const Color surfaceDark = Color(0xFF0F172A);
  static const Color onSurfaceDark = Color(0xFFF1F5F9);
  static const Color surfaceVariantDark = Color(0xFF1E293B);
  static const Color onSurfaceVariantDark = Color(0xFF94A3B8);
  static const Color outlineDark = Color(0xFF334155);

  // Error
  static const Color error = Color(0xFFE11D48);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFFFE4E6);
  static const Color onErrorContainer = Color(0xFF881337);

  // Action Badges Extracted Directly From the Bottom Text of the Official Logo
  static const Color badgeBuy = Color(0xFF0077FF);      // BUY - Ocean Blue
  static const Color badgeSell = Color(0xFFF59E0B);     // SELL - Amber Gold
  static const Color badgeBorrow = Color(0xFF7C3AED);   // BORROW - Royal Violet
  static const Color badgeExchange = Color(0xFF00A86B); // EXCHANGE - Emerald Green
  static const Color badgeDonate = Color(0xFFE11D48);   // DONATE - Crimson Rose
  static const Color badgeRequest = Color(0xFF0891B2);  // REQUEST - Cyan Blue

  // Verified Badge & Rating Colors
  static const Color verifiedBadge = Color(0xFF0077FF);
  static const Color ratingStar = Color(0xFFF59E0B);
  static const Color co2Saved = Color(0xFF00A86B);
  static const Color moneySaved = Color(0xFF059669);
}
