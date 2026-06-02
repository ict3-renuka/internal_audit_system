import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  static const title = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
  );

  static const label = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 14,
    color: AppColors.textDark,
  );

  static const hint = TextStyle(
    fontSize: 13,
    color: AppColors.textLight,
  );

  static const paragraph = TextStyle(
    color: Colors.black54,
    fontSize: 16,
  );

  static const subTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
  );
}