import 'package:flutter/material.dart';

class IconHelper {
  IconHelper._();

  static IconData getIcon(String? iconName) {
    switch (iconName) {
      case 'fastfood_rounded':
      case 'food':
        return Icons.fastfood_rounded;
      case 'directions_car_rounded':
      case 'transport':
        return Icons.directions_car_rounded;
      case 'shopping_bag_rounded':
      case 'shopping':
        return Icons.shopping_bag_rounded;
      case 'receipt_long_rounded':
      case 'bills':
        return Icons.receipt_long_rounded;
      case 'movie_rounded':
      case 'entertainment':
        return Icons.movie_rounded;
      case 'medical_services_rounded':
      case 'health':
        return Icons.medical_services_rounded;
      case 'payments_rounded':
      case 'salary':
        return Icons.payments_rounded;
      case 'trending_up_rounded':
      case 'investment':
        return Icons.trending_up_rounded;
      case 'account_balance_wallet_rounded':
      case 'wallet_rounded':
      case 'cash':
        return Icons.account_balance_wallet_rounded;
      case 'account_balance_rounded':
      case 'bank':
        return Icons.account_balance_rounded;
      case 'credit_card_rounded':
      case 'credit':
        return Icons.credit_card_rounded;
      case 'savings_rounded':
      case 'savings':
        return Icons.savings_rounded;
      case 'phone_android_rounded':
        return Icons.phone_android_rounded;
      case 'home_rounded':
        return Icons.home_rounded;
      case 'flight_takeoff_rounded':
        return Icons.flight_takeoff_rounded;
      case 'school_rounded':
        return Icons.school_rounded;
      case 'fitness_center_rounded':
        return Icons.fitness_center_rounded;
      case 'card_giftcard_rounded':
        return Icons.card_giftcard_rounded;
      default:
        return Icons.category_rounded;
    }
  }

  static Color getColor(String? colorHex) {
    if (colorHex == null || colorHex.isEmpty) {
      return const Color(0xFF6366F1);
    }
    try {
      final cleanHex = colorHex.replaceAll('#', '').replaceAll('0x', '');
      if (cleanHex.length == 6) {
        return Color(int.parse('FF$cleanHex', radix: 16));
      } else if (cleanHex.length == 8) {
        return Color(int.parse(cleanHex, radix: 16));
      }
    } catch (_) {}
    return const Color(0xFF6366F1);
  }
}
