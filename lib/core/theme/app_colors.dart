import 'package:flutter/material.dart';

/// Myntra-inspired vibrant theme colors for high contrast across Light & Dark mode
class AppColors {
  AppColors._();

  // Primary Brand Colors (Signature Myntra Pink / Magenta)
  static const Color primary = Color(0xFFFF3F6C);
  static const Color primaryDark = Color(0xFFE02D5A);
  static const Color primaryLight = Color(0xFFFF6584);

  // Secondary Accent (Warm Coral / Rose Accent)
  static const Color secondary = Color(0xFFFF527B);
  static const Color secondaryDark = Color(0xFFE03E65);
  static const Color secondaryLight = Color(0xFFFFA882);

  // Vibrant Accents & Badges
  static const Color accent = Color(0xFFFF905A);
  static const Color orange = Color(0xFFFF7A00);
  static const Color amber = Color(0xFFFFB400);

  // Status & Feedback
  static const Color success = Color(0xFF03A685);
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFFF9800);
  static const Color info = Color(0xFF2196F3);

  // Light Theme Neutrals (Clean Myntra Palette)
  static const Color lightBackground = Color(0xFFF5F5F6);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightTextPrimary = Color(0xFF282C3F);
  static const Color lightTextSecondary = Color(0xFF535766);
  static const Color lightTextTertiary = Color(0xFF94969F);
  static const Color lightBorder = Color(0xFFEAEAEC);
  static const Color lightDivider = Color(0xFFEAEAEC);

  // Dark Theme Neutrals (High-Contrast Modern Dark Palette)
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E2029);
  static const Color darkCard = Color(0xFF252834);
  static const Color darkTextPrimary = Color(0xFFF5F6FA);
  static const Color darkTextSecondary = Color(0xFFA0A6B5);
  static const Color darkTextTertiary = Color(0xFF6C7280);
  static const Color darkBorder = Color(0xFF2E3240);
  static const Color darkDivider = Color(0xFF282B37);

  // Shimmer
  static const Color shimmerBaseLight = Color(0xFFE0E0E0);
  static const Color shimmerHighlightLight = Color(0xFFF5F5F5);
  static const Color shimmerBaseDark = Color(0xFF2A2D36);
  static const Color shimmerHighlightDark = Color(0xFF383C48);
}
