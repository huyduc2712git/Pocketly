import 'package:flutter/material.dart';
import 'package:finly/app/theme/app_colors.dart';
import 'package:finly/app/theme/app_spacing.dart';
import 'package:finly/core/utils/date_formatter.dart';
import 'package:finly/shared/widgets/amount_text.dart';
import 'package:finly/shared/widgets/app_3d_icon.dart';

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
  final String? iconAsset;
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
    this.iconAsset,
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
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.sm - 2,
          ),
          child: Row(
            children: [
              // Rich Squircle Category Icon with Gradient Shadow
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      iconColor.withValues(alpha: 0.25),
                      iconColor.withValues(alpha: 0.08),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: iconColor.withValues(alpha: 0.3),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: iconColor.withValues(alpha: 0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: iconAsset != null
                      ? App3DIcon(assetPath: iconAsset!, size: 28)
                      : Icon(
                          icon,
                          size: 22,
                          color: iconColor,
                        ),
                ),
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
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.2,
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
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        if (walletDisplay.isNotEmpty) ...[
                          Flexible(
                            child: Text(
                              walletDisplay,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
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

              // Amount Column
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AmountText(
                    amount: amount,
                    currency: currency,
                    type: amountType,
                    showSign: type != 'transfer',
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                  if (subtitle != null && subtitle!.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 120),
                      child: Text(
                        subtitle!,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
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
