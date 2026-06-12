import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

abstract final class AppText {
  // Display
  static TextStyle get displayLg => GoogleFonts.nunitoSans(
        fontSize: 32,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.02 * 32,
        color: AppColors.onSurface,
        height: 1.2,
      );

  static TextStyle get displayMd => GoogleFonts.nunitoSans(
        fontSize: 28,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.01 * 28,
        color: AppColors.onSurface,
        height: 1.2,
      );

  // Headline
  static TextStyle get headlineLg => GoogleFonts.nunitoSans(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: AppColors.onSurface,
        height: 1.3,
      );

  static TextStyle get headlineMd => GoogleFonts.nunitoSans(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: AppColors.onSurface,
        height: 1.3,
      );

  static TextStyle get headlineSm => GoogleFonts.nunitoSans(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: AppColors.onSurface,
        height: 1.3,
      );

  // Body
  static TextStyle get bodyLg => GoogleFonts.nunitoSans(
        fontSize: 18,
        fontWeight: FontWeight.w400,
        color: AppColors.onSurface,
        height: 1.5,
      );

  static TextStyle get bodyMd => GoogleFonts.nunitoSans(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppColors.onSurface,
        height: 1.5,
      );

  static TextStyle get bodySm => GoogleFonts.nunitoSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.onSurfaceVariant,
        height: 1.5,
      );

  // Label
  static TextStyle get labelLg => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.01 * 16,
        color: AppColors.onSurface,
      );

  static TextStyle get labelMd => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.01 * 14,
        color: AppColors.onSurface,
      );

  static TextStyle get labelSm => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.01 * 12,
        color: AppColors.onSurfaceVariant,
      );

  // Data visualization
  static TextStyle get dataViz => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: AppColors.onSurface,
      );

  static TextStyle get dataLg => GoogleFonts.inter(
        fontSize: 48,
        fontWeight: FontWeight.w800,
        color: AppColors.onSurface,
      );

  static TextStyle get dataXl => GoogleFonts.inter(
        fontSize: 64,
        fontWeight: FontWeight.w800,
        letterSpacing: -2,
        color: AppColors.onSurface,
      );
}
