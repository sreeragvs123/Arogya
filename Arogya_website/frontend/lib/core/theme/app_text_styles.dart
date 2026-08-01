import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Typography scale. The page title uses a serif face to match the portal's
/// editorial look; everything else uses the default sans-serif.
///
/// If you pull in `google_fonts`, swap `fontFamily` below for e.g.
/// GoogleFonts.playfairDisplay().fontFamily and GoogleFonts.inter().fontFamily.
class AppTextStyles {
  AppTextStyles._();

  static const String _serifFamily = 'Georgia';

  static const TextStyle eyebrow = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.1,
    color: AppColors.textMuted,
  );

  static const TextStyle pageTitle = TextStyle(
    fontFamily: _serifFamily,
    fontSize: 34,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.2,
  );

  static const TextStyle pageSubtitle = TextStyle(
    fontSize: 15.5,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  static const TextStyle cardEyebrow = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.8,
    color: AppColors.accent,
  );

  static const TextStyle cardTitle = TextStyle(
    fontFamily: _serifFamily,
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle cardBody = TextStyle(
    fontSize: 13.5,
    color: AppColors.textSecondary,
    height: 1.45,
  );

  static const TextStyle label = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle navItem = TextStyle(
    fontSize: 14.5,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static const TextStyle buttonLabel = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
}
