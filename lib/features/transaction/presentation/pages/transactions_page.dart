import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/transaction_tile.dart';

class TransactionsPage extends StatelessWidget {
  const TransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sổ Thu Chi'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_rounded),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          // Filter summary chip row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('Tháng này', isSelected: true),
                const SizedBox(width: AppSpacing.xs),
                _buildFilterChip('Tất cả ví', isSelected: false),
                const SizedBox(width: AppSpacing.xs),
                _buildFilterChip('Tất cả danh mục', isSelected: false),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Transactions Grouped by Day
          _buildDayHeader('Hôm nay, 18/08/2026', totalSpent: 145000.0),
          AppCard(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs, vertical: AppSpacing.xs),
            child: Column(
              children: [
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
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          _buildDayHeader('Hôm qua, 17/08/2026', totalEarned: 25000000.0),
          AppCard(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs, vertical: AppSpacing.xs),
            child: Column(
              children: [
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, {required bool isSelected}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary : AppColors.darkCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? AppColors.primary : AppColors.darkBorder,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : AppColors.darkTextSecondary,
          fontSize: 13,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
    );
  }

  Widget _buildDayHeader(String dateStr, {double? totalSpent, double? totalEarned}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            dateStr,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.darkTextSecondary,
            ),
          ),
          if (totalSpent != null)
            Text(
              '-${totalSpent.toInt()} ₫',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.expense,
              ),
            )
          else if (totalEarned != null)
            Text(
              '+${totalEarned.toInt()} ₫',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.income,
              ),
            ),
        ],
      ),
    );
  }
}
