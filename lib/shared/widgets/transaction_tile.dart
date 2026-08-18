import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_radius.dart';
import '../../app/theme/app_spacing.dart';
import '../../core/utils/date_formatter.dart';
import 'amount_text.dart';

class TransactionTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? walletName;
  final String? toWalletName;
  final DateTime occurredAt;
  final double amount;
  final String currency;
  final String type; // 'expense', 'income', 'transfer'
  final IconData icon;
  final Color iconColor;
  final String? syncStatus; // 'pending', 'syncing', 'synced', 'failed'
  final VoidCallback? onTap;

  const TransactionTile({
    super.key,
    required this.title,
    this.subtitle,
    this.walletName,
    this.toWalletName,
    required this.occurredAt,
    required this.amount,
    this.currency = 'VND',
    required this.type,
    this.icon = Icons.receipt_long_rounded,
    this.iconColor = AppColors.primary,
    this.syncStatus,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    AmountType amountType = AmountType.normal;
    if (type == 'income') {
      amountType = AmountType.income;
    } else if (type == 'expense') {
      amountType = AmountType.expense;
    } else if (type == 'transfer') {
      amountType = AmountType.transfer;
    }

    String walletDisplay = walletName ?? '';
    if (type == 'transfer' && toWalletName != null) {
      walletDisplay = '$walletName ➔ $toWalletName';
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.borderMd,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs,
          ),
          child: Row(
            children: [
              // Category Icon Container
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.12),
                  borderRadius: AppRadius.borderMd,
                ),
                child: Center(child: Icon(icon, size: 22, color: iconColor)),
              ),
              const SizedBox(width: AppSpacing.md),
              // Transaction Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? AppColors.darkTextPrimary
                                  : AppColors.lightTextPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (syncStatus == 'pending') ...[
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.cloud_upload_outlined,
                            size: 14,
                            color: AppColors.warning,
                          ),
                        ] else if (syncStatus == 'failed') ...[
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.cloud_off_rounded,
                            size: 14,
                            color: AppColors.error,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        if (walletDisplay.isNotEmpty) ...[
                          Flexible(
                            child: Text(
                              walletDisplay,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.lightTextSecondary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            ' • ',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark
                                  ? AppColors.darkTextMuted
                                  : AppColors.lightTextMuted,
                            ),
                          ),
                        ],
                        Text(
                          DateFormatter.formatRelative(occurredAt),
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark
                                ? AppColors.darkTextMuted
                                : AppColors.lightTextMuted,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              // Amount
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AmountText(
                    amount: amount,
                    currency: currency,
                    type: amountType,
                    showSign: type != 'transfer',
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                  if (subtitle != null && subtitle!.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 120),
                      child: Text(
                        subtitle!,
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark
                              ? AppColors.darkTextMuted
                              : AppColors.lightTextMuted,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
