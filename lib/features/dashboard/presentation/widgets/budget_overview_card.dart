import 'package:flutter/material.dart';
import '../../../../app/theme/app_3d_icons.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/budget_progress.dart';

class BudgetOverviewCard extends StatelessWidget {
  final VoidCallback? onManageBudget;

  const BudgetOverviewCard({super.key, this.onManageBudget});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Ngân sách danh mục',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.darkTextPrimary,
                ),
              ),
              if (onManageBudget != null)
                GestureDetector(
                  onTap: onManageBudget,
                  child: const Text(
                    'Chi tiết',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryLight,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          const Divider(height: 1),
          const SizedBox(height: AppSpacing.sm),
          const BudgetProgress(
            categoryName: 'Ăn uống',
            iconAsset: AppIcons3D.food,
            categoryColor: Color(0xFFFF7043),
            spent: 3200000.0,
            budgetAmount: 4500000.0,
            forecastAmount: 4200000.0,
          ),
          const SizedBox(height: AppSpacing.sm),
          const BudgetProgress(
            categoryName: 'Di chuyển',
            iconAsset: AppIcons3D.transport,
            categoryColor: Color(0xFF42A5F5),
            spent: 1100000.0,
            budgetAmount: 1500000.0,
          ),
          const SizedBox(height: AppSpacing.sm),
          const BudgetProgress(
            categoryName: 'Mua sắm & Quần áo',
            iconAsset: AppIcons3D.shopping,
            categoryColor: Color(0xFFAB47BC),
            spent: 1800000.0,
            budgetAmount: 2000000.0,
            forecastAmount: 2300000.0,
          ),
          const SizedBox(height: AppSpacing.sm),
          const BudgetProgress(
            categoryName: 'Hóa đơn & Tiện ích',
            iconAsset: AppIcons3D.bills,
            categoryColor: Color(0xFFFFA726),
            spent: 600000.0,
            budgetAmount: 2000000.0,
          ),
        ],
      ),
    );
  }
}
