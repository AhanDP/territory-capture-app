import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

extension AppTheme on BuildContext {
  ColorScheme get colors => Theme.of(this).colorScheme;
}

extension AppTextStyles on BuildContext {
  TextStyle get headlineLarge => Theme.of(this).brightness == Brightness.dark
      ? AppTypography.headlineLarge.copyWith(color: AppColors.textPrimaryDark)
      : AppTypography.headlineLarge;

  TextStyle get bodyMedium => Theme.of(this).brightness == Brightness.dark
      ? AppTypography.bodyMedium.copyWith(color: AppColors.textSecondaryDark)
      : AppTypography.bodyMedium;

  TextStyle get labelSmall => Theme.of(this).brightness == Brightness.dark
      ? AppTypography.labelSmall.copyWith(color: AppColors.textSecondaryDark)
      : AppTypography.labelSmall;
}