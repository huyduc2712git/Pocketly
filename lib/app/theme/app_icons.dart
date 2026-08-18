import 'package:flutter/material.dart';

/// Centralized semantic icon definitions for Pocketly.
/// Prevents random mixing of icons, eliminates emojis as UI buttons,
/// and provides consistent semantics across all platforms.
class AppIcons {
  AppIcons._();

  // Navigation
  static const IconData dashboard = Icons.grid_view_rounded;
  static const IconData transactions = Icons.receipt_long_rounded;
  static const IconData budget = Icons.pie_chart_outline_rounded;
  static const IconData analytics = Icons.bar_chart_rounded;
  static const IconData profile = Icons.person_outline_rounded;

  // Financial Transaction Types
  static const IconData income = Icons.arrow_downward_rounded;
  static const IconData expense = Icons.arrow_upward_rounded;
  static const IconData transfer = Icons.swap_horiz_rounded;

  // Actions & Utilities
  static const IconData add = Icons.add_rounded;
  static const IconData edit = Icons.edit_outlined;
  static const IconData delete = Icons.delete_outline_rounded;
  static const IconData close = Icons.close_rounded;
  static const IconData check = Icons.check_rounded;
  static const IconData filter = Icons.filter_list_rounded;
  static const IconData calendar = Icons.calendar_today_outlined;
  static const IconData copy = Icons.copy_rounded;
  static const IconData download = Icons.download_rounded;
  static const IconData cloudSync = Icons.cloud_upload_rounded;
  static const IconData cloudDone = Icons.cloud_done_rounded;
  static const IconData refresh = Icons.refresh_rounded;

  // Features
  static const IconData wallet = Icons.account_balance_wallet_outlined;
  static const IconData subscription = Icons.subscriptions_outlined;
  static const IconData recurring = Icons.repeat_rounded;
  static const IconData insight = Icons.auto_awesome_rounded;
  static const IconData warning = Icons.warning_amber_rounded;
  static const IconData info = Icons.info_outline_rounded;
  static const IconData error = Icons.error_outline_rounded;
  static const IconData notifications = Icons.notifications_none_rounded;
  static const IconData darkMode = Icons.dark_mode_outlined;
  static const IconData lightMode = Icons.light_mode_outlined;
  static const IconData security = Icons.shield_outlined;
  static const IconData currency = Icons.monetization_on_outlined;
  static const IconData visibilityOn = Icons.visibility_outlined;
  static const IconData visibilityOff = Icons.visibility_off_outlined;

  // Default icon size
  static const double sm = 16.0;
  static const double md = 20.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
}
