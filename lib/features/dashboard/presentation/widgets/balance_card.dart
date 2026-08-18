import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../shared/widgets/amount_text.dart';
import '../../../../shared/widgets/currency_text.dart';
import '../controllers/dashboard_controller.dart';

class BalanceCard extends StatelessWidget {
  final DashboardSummary summary;
  final VoidCallback onToggleVisibility;

  const BalanceCard({
    super.key,
    required this.summary,
    required this.onToggleVisibility,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.balanceGradient,
        borderRadius: AppRadius.borderLg,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4338CA).withValues(alpha: 0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Label & Visibility Toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text(
                      'Tổng số dư khả dụng',
                      style: TextStyle(
                        color: Color(0xFFC7D2FE),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    CurrencyText(currency: summary.currency),
                  ],
                ),
                IconButton(
                  icon: Icon(
                    summary.isBalanceHidden
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: const Color(0xFFC7D2FE),
                    size: 20,
                  ),
                  onPressed: onToggleVisibility,
                  constraints: const BoxConstraints(),
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            // Balance Text
            if (summary.isBalanceHidden)
              const Text(
                '•••••••• ₫',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2.0,
                ),
              )
            else
              AmountText(
                amount: summary.totalBalance,
                currency: summary.currency,
                fontSize: 30,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            const SizedBox(height: AppSpacing.xl),
            // Divider inside card
            Container(height: 1, color: Colors.white.withValues(alpha: 0.12)),
            const SizedBox(height: AppSpacing.md),
            // Income vs Expense Breakdown Row
            Row(
              children: [
                // Income Column
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.income.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_downward_rounded,
                          color: AppColors.income,
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Thu nhập',
                              style: TextStyle(
                                color: Color(0xFFC7D2FE),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            AmountText(
                              amount: summary.monthlyIncome,
                              currency: summary.currency,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF6EE7B7),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 1,
                  height: 36,
                  color: Colors.white.withValues(alpha: 0.12),
                ),
                const SizedBox(width: AppSpacing.md),
                // Expense Column
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.expense.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_upward_rounded,
                          color: AppColors.expense,
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Chi tiêu',
                              style: TextStyle(
                                color: Color(0xFFC7D2FE),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            AmountText(
                              amount: summary.monthlyExpense,
                              currency: summary.currency,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFFFDA4AF),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
