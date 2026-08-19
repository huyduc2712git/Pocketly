import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:finly/app/theme/app_colors.dart';
import 'package:finly/app/theme/app_spacing.dart';
import 'package:finly/core/extensions/context_extensions.dart';
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
        // Legend Pills
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _buildLegendItem('Thu nhập', AppColors.income, isDark),
            const SizedBox(width: AppSpacing.md),
            _buildLegendItem('Chi tiêu', AppColors.expense, isDark),
          ],
        ),
        const SizedBox(height: AppSpacing.md),

        // Bars Container
        SizedBox(
          height: 150,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: points.map((p) {
              final incomeHeight = maxVal > 0
                  ? math.max(6.0, (p.income / maxVal) * 110)
                  : 6.0;
              final expenseHeight = maxVal > 0
                  ? math.max(6.0, (p.expense / maxVal) * 110)
                  : 6.0;

              return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Income Bar Capsule
                      Container(
                        width: 14,
                        height: incomeHeight,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF34D399),
                              Color(0xFF059669),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.circular(7),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF10B981).withValues(alpha: 0.3),
                              blurRadius: 6,
                              offset: const Offset(0, -2),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 5),
                      // Expense Bar Capsule
                      Container(
                        width: 14,
                        height: expenseHeight,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFFFB7185),
                              Color(0xFFE11D48),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.circular(7),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFF43F5E).withValues(alpha: 0.3),
                              blurRadius: 6,
                              offset: const Offset(0, -2),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Month Label
                  Text(
                    p.label,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
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

  Widget _buildLegendItem(String label, Color color, bool isDark) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.6),
                blurRadius: 4,
              ),
            ],
          ),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isDark
                ? AppColors.darkTextPrimary
                : AppColors.lightTextPrimary,
          ),
        ),
      ],
    );
  }
}
