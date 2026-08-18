import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../shared/widgets/amount_text.dart';
import '../../../../shared/widgets/app_card.dart';

class WalletsPage extends StatelessWidget {
  const WalletsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ví Tiền & Tài Khoản'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: const [
          // Total Net Worth Card
          AppCard(
            padding: EdgeInsets.all(AppSpacing.lg),
            gradient: AppColors.balanceGradient,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tổng tài sản ròng',
                  style: TextStyle(color: Color(0xFFC7D2FE), fontSize: 13),
                ),
                SizedBox(height: 4),
                AmountText(
                  amount: 18300000.0,
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
                SizedBox(height: 8),
                Text(
                  '2 tài khoản đang tính vào tổng số dư',
                  style: TextStyle(color: Color(0xFFC7D2FE), fontSize: 12),
                ),
              ],
            ),
          ),
          SizedBox(height: AppSpacing.lg),

          Text(
            'Danh sách ví đang dùng',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.darkTextPrimary,
            ),
          ),
          SizedBox(height: AppSpacing.sm),

          _WalletCardItem(
            name: 'Tiền mặt',
            type: 'Tiền mặt trong ví',
            amount: 2500000.0,
            icon: Icons.account_balance_wallet_rounded,
            color: AppColors.income,
          ),
          SizedBox(height: AppSpacing.sm),
          _WalletCardItem(
            name: 'Tài khoản Ngân hàng',
            type: 'MB Bank •••• 8866',
            amount: 15800000.0,
            icon: Icons.account_balance_rounded,
            color: AppColors.primary,
          ),
        ],
      ),
    );
  }
}

class _WalletCardItem extends StatelessWidget {
  final String name;
  final String type;
  final double amount;
  final IconData icon;
  final Color color;

  const _WalletCardItem({
    required this.name,
    required this.type,
    required this.amount,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: AppRadius.borderMd,
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkTextPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  type,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.darkTextSecondary,
                  ),
                ),
              ],
            ),
          ),
          AmountText(
            amount: amount,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ],
      ),
    );
  }
}
