import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Brand Primaries (Hot Pink & Magenta Accents)
  static const Color primary = Color(0xFFFE4696);
  static const Color primaryDark = Color(0xFFE02B7D);
  static const Color primaryLight = Color(0xFFFF70AF);
  static const Color primaryContainer = Color(0xFFFCE4EC);

  // Soft Pastel Palette (for action buttons, cards & tags)
  static const Color pastelPink = Color(0xFFFCE4EC);
  static const Color pastelPinkLight = Color(0xFFFFF0F5);
  static const Color pastelMint = Color(0xFFE8F8F0);
  static const Color pastelMintLight = Color(0xFFF0FDF4);
  static const Color pastelAmber = Color(0xFFFFF8E1);
  static const Color pastelAmberLight = Color(0xFFFEF9C3);
  static const Color pastelSkyBlue = Color(0xFFE0F2FE);
  static const Color pastelSkyBlueLight = Color(0xFFF0F9FF);
  static const Color pastelPurple = Color(0xFFF3E8FF);
  static const Color pastelPurpleLight = Color(0xFFFAF5FF);

  // Radiant Secondary Accents
  static const Color cyan = Color(0xFF06B6D4);
  static const Color cyanLight = Color(0xFF67E8F9);
  static const Color violet = Color(0xFF8B5CF6);
  static const Color amber = Color(0xFFF59E0B);

  // Financial Semantics
  static const Color income = Color(0xFF10B981); // Mint / Emerald Green
  static const Color incomeLight = Color(0xFFE8F8F0);
  static const Color incomeDark = Color(0xFF059669);

  static const Color expense = Color(0xFFFE4696); // Hot Pink / Coral
  static const Color expenseLight = Color(0xFFFEE8EC);
  static const Color expenseDark = Color(0xFFE02B7D);

  static const Color savings = Color(0xFF8B5CF6); // Purple / Violet
  static const Color savingsLight = Color(0xFFF3E8FF);
  static const Color savingsDark = Color(0xFF7C3AED);

  static const Color transfer = Color(0xFF3B82F6); // Electric Blue
  static const Color transferLight = Color(0xFFE0F2FE);
  static const Color transferDark = Color(0xFF2563EB);

  // Status & Feedback
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Dark Theme Backgrounds & Surfaces
  static const Color darkBackground = Color(0xFF0F0F14);
  static const Color darkSurface = Color(0xFF181820);
  static const Color darkCard = Color(0xFF1E1E28);
  static const Color darkCardElevated = Color(0xFF262634);
  static const Color darkBorder = Color(0xFF2A2A3A);
  static const Color darkBorderLight = Color(0xFF38384C);
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFA1A1AA);
  static const Color darkTextMuted = Color(0xFF71717A);

  // Light Theme Backgrounds & Surfaces (FlowPay Design Language)
  static const Color lightBackground = Color(0xFFF8F9FC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightCardElevated = Color(0xFFF4F5F9);
  static const Color lightBorder = Color(0xFFF0F1F5);
  static const Color lightTextPrimary = Color(0xFF1E1E2D);
  static const Color lightTextSecondary = Color(0xFF71717A);
  static const Color lightTextMuted = Color(0xFFA1A1AA);

  // Glassmorphic Overlay Tokens
  static final Color glassFillDark = const Color(0xFF181820).withValues(alpha: 0.75);
  static final Color glassBorderDark = Colors.white.withValues(alpha: 0.12);
  static final Color glassFillLight = Colors.white.withValues(alpha: 0.85);
  static final Color glassBorderLight = Colors.black.withValues(alpha: 0.06);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFFE4696), Color(0xFFFF5C9F), Color(0xFF8B5CF6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroBalanceGradient = LinearGradient(
    colors: [
      Color(0xFFFFF0F5),
      Color(0xFFFCE4EC),
      Color(0xFFF3E8FF),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroBalanceGradientDark = LinearGradient(
    colors: [
      Color(0xFF2D1224),
      Color(0xFF1E132D),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient pinkPillGradient = LinearGradient(
    colors: [Color(0xFFFE4696), Color(0xFFFF5299)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient incomeGradient = LinearGradient(
    colors: [Color(0xFF059669), Color(0xFF10B981)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient expenseGradient = LinearGradient(
    colors: [Color(0xFFE02B7D), Color(0xFFFE4696)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient balanceGradient = heroBalanceGradient;
  static const LinearGradient heroCardMesh = heroBalanceGradient;
  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFFDE047), Color(0xFFEAB308), Color(0xFFCA8A04)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const LinearGradient purpleGradient = LinearGradient(
    colors: [Color(0xFFA855F7), Color(0xFF7C3AED), Color(0xFF4C1D95)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
