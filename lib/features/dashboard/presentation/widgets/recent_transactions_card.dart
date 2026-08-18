import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/utils/icon_helper.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/transaction_tile.dart';
import '../controllers/dashboard_controller.dart';

class RecentTransactionsCard extends StatelessWidget {
  final DashboardSummary summary;

  const RecentTransactionsCard({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
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
            TextButton(
              onPressed: () => context.go(RouteNames.transactions),
              child: const Text('Xem tất cả'),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        if (summary.recentTransactions.isEmpty)
          const AppCard(
            padding: EdgeInsets.all(AppSpacing.md),
            child: Center(
              child: Text(
                'Chưa có giao dịch gần đây',
                style: TextStyle(
                  color: AppColors.darkTextSecondary,
                  fontSize: 13,
                ),
              ),
            ),
          )
        else
          AppCard(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xs,
              vertical: AppSpacing.xs,
            ),
            child: Column(
              children: [
                for (int i = 0; i < summary.recentTransactions.length; i++) ...[
                  if (i > 0) const Divider(height: 1, indent: 56),
                  TransactionTile(
                    title:
                        summary.recentTransactions[i].note?.isNotEmpty == true
                        ? summary.recentTransactions[i].note!
                        : (summary.recentTransactions[i].categoryName ??
                              (summary.recentTransactions[i].isTransfer
                                  ? 'Chuyển tiền'
                                  : 'Giao dịch')),
                    subtitle: summary.recentTransactions[i].categoryName,
                    walletName: summary.recentTransactions[i].walletName,
                    toWalletName: summary.recentTransactions[i].toWalletName,
                    occurredAt: summary.recentTransactions[i].occurredAt,
                    amount: summary.recentTransactions[i].amount,
                    currency: summary.recentTransactions[i].currency,
                    type: summary.recentTransactions[i].type,
                    icon: IconHelper.getIcon(
                      summary.recentTransactions[i].categoryIcon,
                    ),
                    iconColor: IconHelper.getColor(
                      summary.recentTransactions[i].categoryColor,
                    ),
                    syncStatus: summary.recentTransactions[i].syncStatus,
                    onTap: () => context.go(RouteNames.transactions),
                  ),
                ],
              ],
            ),
          ),
      ],
    );
  }
}
