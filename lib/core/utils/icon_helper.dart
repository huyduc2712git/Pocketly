import 'package:flutter/material.dart';
import '../../app/theme/app_3d_icons.dart';

class IconHelper {
  IconHelper._();

  static String get3DAsset(String? iconName) {
    switch (iconName) {
      case 'fastfood_rounded':
      case 'food':
        return AppIcons3D.food;
      case 'directions_car_rounded':
      case 'transport':
        return AppIcons3D.transport;
      case 'shopping_bag_rounded':
      case 'shopping':
        return AppIcons3D.shopping;
      case 'receipt_long_rounded':
      case 'bills':
        return AppIcons3D.bills;
      case 'movie_rounded':
      case 'entertainment':
        return AppIcons3D.entertainment;
      case 'medical_services_rounded':
      case 'health':
        return AppIcons3D.health;
      case 'payments_rounded':
      case 'salary':
        return AppIcons3D.salary;
      case 'trending_up_rounded':
      case 'investment':
        return AppIcons3D.investment;
      case 'account_balance_wallet_rounded':
      case 'wallet_rounded':
      case 'wallet':
      case 'cash':
        return AppIcons3D.cash;
      case 'account_balance_rounded':
      case 'bank':
        return AppIcons3D.bank;
      case 'credit_card_rounded':
      case 'credit':
        return AppIcons3D.credit;
      case 'savings_rounded':
      case 'savings':
        return AppIcons3D.savings;
      case 'phone_android_rounded':
      case 'ewallet':
        return AppIcons3D.ewallet;
      case 'home_rounded':
      case 'home':
        return AppIcons3D.housing;
      case 'flight_takeoff_rounded':
      case 'travel':
        return AppIcons3D.travel;
      case 'school_rounded':
      case 'education':
        return AppIcons3D.education;
      case 'fitness_center_rounded':
      case 'fitness':
        return AppIcons3D.fitness;
      case 'card_giftcard_rounded':
      case 'gift':
        return AppIcons3D.gift;
      case 'coffee':
        return AppIcons3D.coffee;
      case 'netflix':
        return AppIcons3D.netflix;
      case 'youtube':
        return AppIcons3D.youtube;
      case 'spotify':
        return AppIcons3D.spotify;
      case 'apple':
        return AppIcons3D.apple;
      case 'google':
        return AppIcons3D.google;
      case 'chatgpt':
        return AppIcons3D.chatgpt;
      case 'icloud':
        return AppIcons3D.icloud;
      case 'discord':
        return AppIcons3D.discord;
      case 'telegram':
        return AppIcons3D.telegram;
      case 'github':
        return AppIcons3D.github;
      case 'amazon':
        return AppIcons3D.amazon;
      case 'playstation':
        return AppIcons3D.playstation;
      case 'twitch':
        return AppIcons3D.twitch;
      case 'tiktok':
        return AppIcons3D.tiktok;
      case 'instagram':
        return AppIcons3D.instagram;
      default:
        return AppIcons3D.category;
    }
  }

  static String getSubscription3DAsset(String? serviceName) {
    if (serviceName == null || serviceName.isEmpty) {
      return AppIcons3D.subscription;
    }
    final lower = serviceName.toLowerCase();
    if (lower.contains('netflix')) return AppIcons3D.netflix;
    if (lower.contains('youtube') || lower.contains('yt')) return AppIcons3D.youtube;
    if (lower.contains('spotify')) return AppIcons3D.spotify;
    if (lower.contains('icloud')) return AppIcons3D.icloud;
    if (lower.contains('apple')) return AppIcons3D.apple;
    if (lower.contains('google') || lower.contains('drive')) return AppIcons3D.google;
    if (lower.contains('chatgpt') || lower.contains('openai') || lower.contains('gpt')) return AppIcons3D.chatgpt;
    if (lower.contains('discord')) return AppIcons3D.discord;
    if (lower.contains('telegram')) return AppIcons3D.telegram;
    if (lower.contains('github')) return AppIcons3D.github;
    if (lower.contains('amazon') || lower.contains('prime')) return AppIcons3D.amazon;
    if (lower.contains('playstation') || lower.contains('psn') || lower.contains('ps plus')) return AppIcons3D.playstation;
    if (lower.contains('twitch')) return AppIcons3D.twitch;
    if (lower.contains('tiktok')) return AppIcons3D.tiktok;
    if (lower.contains('instagram')) return AppIcons3D.instagram;
    return AppIcons3D.subscription;
  }

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
