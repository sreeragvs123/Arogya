import 'package:flutter/material.dart';

/// Centralized color palette for the Arogya clinician portal.
/// Keep every hardcoded color out of widgets — reference this class instead
/// so a theme change is a one-file edit.
class AppColors {
  AppColors._();

  // Brand
  static const Color primary = Color(0xFF0E6B5C); // deep teal-green
  static const Color primaryDark = Color(0xFF0A4F44);
  static const Color accent = Color(0xFF10A37F); // scan frame / active states

  // Backgrounds
  static const Color scaffoldBackground = Color(0xFFF5F6FB);
  static const Color sidebarBackground = Color(0xFFFFFFFF);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color softPanel = Color(0xFFEFF1FB); // right-rail tinted card

  // Text
  static const Color textPrimary = Color(0xFF14161A);
  static const Color textSecondary = Color(0xFF5B6472);
  static const Color textMuted = Color(0xFF8B93A1);

  // Borders / dividers
  static const Color border = Color(0xFFE6E8F0);
  static const Color divider = Color(0xFFEDEFF5);

  // Status
  static const Color liveIndicator = Color(0xFF16A34A);
  static const Color emergencyBackground = Color(0xFFDFF5EC);
  static const Color emergencyText = Color(0xFF0E6B5C);

  // Step badges (pro tips)
  static const Color stepBadgeBackground = Color(0xFFDCEFE9);
  static const Color stepBadgeText = Color(0xFF0E6B5C);
}
