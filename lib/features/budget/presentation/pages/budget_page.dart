import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/budget_progress.dart';

class BudgetPage extends StatelessWidget {
  const BudgetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản Lý Ngân Sách'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_chart_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          // Total Budget Summary Card
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ngân sách Tháng 08/2026',
                  style: TextStyle(
                    color: Color(0xFFC7D2FE),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '12.000.000 ₫',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: AppSpacing.sm),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Đã chi: 6.700.000 ₫ (55.8%)',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    Text(
                      'Còn lại: 5.300.000 ₫',
                      style: TextStyle(
                        color: Color(0xFF6EE7B7),
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          const Text(
            'Hạng mục ngân sách chi tiết',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.darkTextPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),

          const AppCard(
            child: Column(
              children: [
                BudgetProgress(
                  categoryName: 'Ăn uống',
                  icon: Icons.fastfood_rounded,
                  categoryColor: Color(0xFFFF7043),
                  spent: 3200000.0,
                  budgetAmount: 4500000.0,
                  forecastAmount: 4200000.0,
                ),
                Divider(height: AppSpacing.md),
                BudgetProgress(
                  categoryName: 'Di chuyển',
                  icon: Icons.directions_car_rounded,
                  categoryColor: Color(0xFF42A5F5),
                  spent: 1100000.0,
                  budgetAmount: 1500000.0,
                ),
                Divider(height: AppSpacing.md),
                BudgetProgress(
                  categoryName: 'Mua sắm & Quần áo',
                  icon: Icons.shopping_bag_rounded,
                  categoryColor: Color(0xFFAB47BC),
                  spent: 1800000.0,
                  budgetAmount: 2000000.0,
                  forecastAmount: 2300000.0,
                ),
                Divider(height: AppSpacing.md),
                BudgetProgress(
                  categoryName: 'Hóa đơn & Tiện ích',
                  icon: Icons.receipt_long_rounded,
                  categoryColor: Color(0xFFFFA726),
                  spent: 600000.0,
                  budgetAmount: 2000000.0,
                ),
                Divider(height: AppSpacing.md),
                BudgetProgress(
                  categoryName: 'Giải trí',
                  icon: Icons.movie_rounded,
                  categoryColor: Color(0xFFEC407A),
                  spent: 800000.0,
                  budgetAmount: 1000000.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
