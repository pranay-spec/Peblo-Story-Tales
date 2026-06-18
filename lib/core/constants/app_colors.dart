import 'package:flutter/material.dart';

abstract final class AppColors {
  static const Color background = Color(0xFFFFF8E7);

  static const Color primary = Color(0xFF6C63FF);

  static const Color primaryLight = Color(0xFF8B83FF);

  static const Color primaryDark = Color(0xFF4A42D4);

  static const Color secondary = Color(0xFFFFB703);

  static const Color accent = Color(0xFFFF6B6B);

  static const Color success = Color(0xFF4CAF50);

  static const Color cardBackground = Color(0xFFFFFFFF);

  static const Color textPrimary = Color(0xFF2D2D2D);

  static const Color textSecondary = Color(0xFF6B6B6B);

  static const Color disabled = Color(0xFFBDBDBD);

  static const Color border = Color(0xFFE0E0E0);

  static const Color shadow = Color(0x1A000000);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient successGradient = LinearGradient(
    colors: [Color(0xFF4CAF50), Color(0xFF66BB6A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient errorGradient = LinearGradient(
    colors: [Color(0xFFFF6B6B), Color(0xFFFF8A8A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
