import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../domain/entities/analytics_entity.dart';

class CashflowBarChart extends StatelessWidget {
  final List<CashflowPoint> points;

  const CashflowBarChart({super.key, required this.points});

  @override
  Widget build(BuildContext context) {
    if (points.isEmpty) {
      return const SizedBox.shrink();
    }

    final maxVal = points.fold<double>(
      0.0,
      (max, p) => math.max(max, math.max(p.income, p.expense)),
    );

    final isDark = context.isDarkMode;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Legend
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _buildLegendItem('Thu nhập', AppColors.income),
            const SizedBox(width: AppSpacing.md),
            _buildLegendItem('Chi tiêu', AppColors.expense),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),

        // Bars Container
        SizedBox(
          height: 140,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: points.map((p) {
              final incomeHeight = maxVal > 0 ? (p.income / maxVal) * 100 : 0.0;
              final expenseHeight = maxVal > 0
                  ? (p.expense / maxVal) * 100
                  : 0.0;

              return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Income Bar
                      Container(
                        width: 10,
                        height: math.max(incomeHeight, 4.0),
                        decoration: const BoxDecoration(
                          color: AppColors.income,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(4),
                          ),
                        ),
                      ),
                      const SizedBox(width: 3),
                      // Expense Bar
                      Container(
                        width: 10,
                        height: math.max(expenseHeight, 4.0),
                        decoration: const BoxDecoration(
                          color: AppColors.expense,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(4),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    p.label,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            borderRadius: AppRadius.borderFull,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.darkTextSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
