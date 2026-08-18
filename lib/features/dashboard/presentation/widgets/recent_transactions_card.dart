import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/transaction_tile.dart';

class RecentTransactionsCard extends StatelessWidget {
  final VoidCallback? onViewAll;

  const RecentTransactionsCard({super.key, this.onViewAll});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Giao dịch gần đây',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkTextPrimary,
                  ),
                ),
                if (onViewAll != null)
                  GestureDetector(
                    onTap: onViewAll,
                    child: const Text(
                      'Xem tất cả',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryLight,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          const Divider(height: 1),
          const SizedBox(height: AppSpacing.xs),
          TransactionTile(
            title: 'Ăn tối cùng đồng nghiệp',
            subtitle: 'Phở Thìn Lò Đúc',
            walletName: 'Tiền mặt',
            occurredAt: DateTime.now(),
            amount: 145000.0,
            type: 'expense',
            icon: Icons.fastfood_rounded,
            iconColor: const Color(0xFFFF7043),
            syncStatus: 'synced',
          ),
          const Divider(height: 1, indent: 60),
          TransactionTile(
            title: 'Lương tháng 08/2026',
            subtitle: 'Công ty Cổ phần Công nghệ',
            walletName: 'Tài khoản Ngân hàng',
            occurredAt: DateTime.now().subtract(const Duration(days: 1)),
            amount: 25000000.0,
            type: 'income',
            icon: Icons.payments_rounded,
            iconColor: const Color(0xFF66BB6A),
            syncStatus: 'synced',
          ),
          const Divider(height: 1, indent: 60),
          TransactionTile(
            title: 'Chuyển tiền vào ví tiết kiệm',
            walletName: 'Ngân hàng',
            toWalletName: 'Tiết kiệm',
            occurredAt: DateTime.now().subtract(const Duration(days: 2)),
            amount: 5000000.0,
            type: 'transfer',
            icon: Icons.swap_horiz_rounded,
            iconColor: AppColors.transfer,
            syncStatus: 'synced',
          ),
          const Divider(height: 1, indent: 60),
          TransactionTile(
            title: 'Xăng xe máy',
            subtitle: 'Petrolimex',
            walletName: 'Tiền mặt',
            occurredAt: DateTime.now().subtract(const Duration(days: 3)),
            amount: 90000.0,
            type: 'expense',
            icon: Icons.local_gas_station_rounded,
            iconColor: const Color(0xFF42A5F5),
            syncStatus: 'pending',
          ),
        ],
      ),
    );
  }
}
