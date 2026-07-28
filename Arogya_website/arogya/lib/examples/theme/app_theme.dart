import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const primaryGreen = Color(0xFF2E7D32);
  static const mediumGreen = Color(0xFF43A047);
  static const lightGreen = Color(0xFFA5D6A7);
  static const surfaceWhite = Color(0xFFF1F8F1);
  static const white = Color(0xFFFFFFFF);
  static const darkText = Color(0xFF1A1A1A);
  static const mutedText = Color(0xFF6B7280);
  static const borderColor = Color(0xFFD1E8D1);
  static const errorRed = Color(0xFFD32F2F);
  static const successGreen = Color(0xFF388E3C);
  static const cardShadow = Color(0x1A2E7D32);
}

class AppTheme {
  static ThemeData get theme => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryGreen,
          primary: AppColors.primaryGreen,
          secondary: AppColors.mediumGreen,
          surface: AppColors.white,
          background: AppColors.surfaceWhite,
        ),
        textTheme: GoogleFonts.dmSansTextTheme().copyWith(
          displayLarge: GoogleFonts.playfairDisplay(
            fontSize: 48,
            fontWeight: FontWeight.w700,
            color: AppColors.darkText,
            height: 1.2,
          ),
          displayMedium: GoogleFonts.playfairDisplay(
            fontSize: 36,
            fontWeight: FontWeight.w700,
            color: AppColors.darkText,
            height: 1.2,
          ),
          displaySmall: GoogleFonts.playfairDisplay(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: AppColors.darkText,
          ),
          headlineMedium: GoogleFonts.dmSans(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: AppColors.darkText,
          ),
          headlineSmall: GoogleFonts.dmSans(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.darkText,
          ),
          bodyLarge: GoogleFonts.dmSans(
            fontSize: 16,
            color: AppColors.darkText,
            height: 1.6,
          ),
          bodyMedium: GoogleFonts.dmSans(
            fontSize: 14,
            color: AppColors.mutedText,
            height: 1.5,
          ),
          labelLarge: GoogleFonts.dmSans(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryGreen,
            foregroundColor: AppColors.white,
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 0,
            textStyle: GoogleFonts.dmSans(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primaryGreen,
            side: const BorderSide(color: AppColors.primaryGreen, width: 1.5),
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            textStyle: GoogleFonts.dmSans(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.borderColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.borderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                const BorderSide(color: AppColors.primaryGreen, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.errorRed),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          hintStyle: GoogleFonts.dmSans(
            color: AppColors.mutedText,
            fontSize: 14,
          ),
          labelStyle: GoogleFonts.dmSans(
            color: AppColors.mutedText,
            fontSize: 14,
          ),
          floatingLabelStyle: GoogleFonts.dmSans(
            color: AppColors.primaryGreen,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        cardTheme: CardThemeData(
          color: AppColors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: AppColors.borderColor),
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.white,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: GoogleFonts.playfairDisplay(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryGreen,
          ),
          iconTheme: const IconThemeData(color: AppColors.primaryGreen),
        ),
        scaffoldBackgroundColor: AppColors.surfaceWhite,
        dividerColor: AppColors.borderColor,
        chipTheme: ChipThemeData(
          backgroundColor: AppColors.lightGreen.withOpacity(0.3),
          labelStyle: GoogleFonts.dmSans(
            color: AppColors.primaryGreen,
            fontWeight: FontWeight.w500,
            fontSize: 13,
          ),
          side: BorderSide.none,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      );
}

// Reusable spacing constants
class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
}

// Reusable border radius
class AppRadius {
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
}