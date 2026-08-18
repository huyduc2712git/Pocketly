import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../shared/widgets/amount_text.dart';
import '../../../../shared/widgets/app_card.dart';

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Báo Cáo & Phân Tích'),
        actions: [
          IconButton(
            icon: const Icon(Icons.date_range_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          // Period Selector Header
          AppCard(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Tháng 08 / 2026',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkTextPrimary,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Đúng kế hoạch',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryLight,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Income vs Expense Summary
          Row(
            children: [
              Expanded(
                child: AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Tổng thu nhập',
                        style: TextStyle(fontSize: 12, color: AppColors.darkTextSecondary),
                      ),
                      const SizedBox(height: 4),
                      const AmountText(
                        amount: 25000000.0,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.income,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '+12% so với tháng trước',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.income.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Tổng chi tiêu',
                        style: TextStyle(fontSize: 12, color: AppColors.darkTextSecondary),
                      ),
                      const SizedBox(height: 4),
                      const AmountText(
                        amount: 6700000.0,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.expense,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '-5% so với tháng trước',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.income.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          const Text(
            'Phân bổ chi tiêu theo danh mục',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.darkTextPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),

          AppCard(
            child: Column(
              children: [
                _buildCategorySpendRow(
                  name: 'Ăn uống',
                  amount: 3200000.0,
                  percentage: 47.7,
                  color: const Color(0xFFFF7043),
                  icon: Icons.fastfood_rounded,
                ),
                const Divider(height: AppSpacing.md),
                _buildCategorySpendRow(
                  name: 'Mua sắm & Quần áo',
                  amount: 1800000.0,
                  percentage: 26.8,
                  color: const Color(0xFFAB47BC),
                  icon: Icons.shopping_bag_rounded,
                ),
                const Divider(height: AppSpacing.md),
                _buildCategorySpendRow(
                  name: 'Di chuyển',
                  amount: 1100000.0,
                  percentage: 16.4,
                  color: const Color(0xFF42A5F5),
                  icon: Icons.directions_car_rounded,
                ),
                const Divider(height: AppSpacing.md),
                _buildCategorySpendRow(
                  name: 'Hóa đơn & Tiện ích',
                  amount: 600000.0,
                  percentage: 9.1,
                  color: const Color(0xFFFFA726),
                  icon: Icons.receipt_long_rounded,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySpendRow({
    required String name,
    required double amount,
    required double percentage,
    required Color color,
    required IconData icon,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: AppRadius.borderSm,
          ),
          child: Icon(icon, size: 18, color: color),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkTextPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '$percentage% tổng chi',
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.darkTextMuted,
                ),
              ),
            ],
          ),
        ),
        AmountText(
          amount: amount,
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
      ],
    );
  }
}
