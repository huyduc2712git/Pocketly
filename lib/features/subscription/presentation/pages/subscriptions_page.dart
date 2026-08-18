import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../shared/widgets/amount_text.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_empty_state.dart';
import '../../../../shared/widgets/app_loading.dart';
import '../../domain/entities/subscription_entity.dart';
import '../controllers/subscriptions_controller.dart';
import '../widgets/add_subscription_sheet.dart';

class SubscriptionsPage extends ConsumerWidget {
  const SubscriptionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subsAsync = ref.watch(subscriptionsStreamProvider);
    final totalMonthlyCost = ref.watch(totalMonthlySubscriptionCostProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gói Thuê Bao & Định Kỳ'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            tooltip: 'Thêm gói thuê bao',
            onPressed: () => AddSubscriptionSheet.show(context),
          ),
        ],
      ),
      body: subsAsync.when(
        loading: () =>
            const AppLoading(message: 'Đang tải danh sách gói thuê bao...'),
        error: (err, _) => Center(child: Text('Lỗi: $err')),
        data: (subscriptions) {
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              // Monthly Burden Overview Card
              AppCard(
                padding: const EdgeInsets.all(AppSpacing.lg),
                gradient: AppColors.balanceGradient,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Chi phí thuê bao hàng tháng',
                      style: TextStyle(color: Color(0xFFC7D2FE), fontSize: 13),
                    ),
                    const SizedBox(height: 4),
                    AmountText(
                      amount: totalMonthlyCost,
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${subscriptions.where((s) => s.isActive).length} gói dịch vụ đang kích hoạt',
                      style: const TextStyle(
                        color: Color(0xFFC7D2FE),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Danh sách dịch vụ (${subscriptions.length})',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.darkTextPrimary,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () => AddSubscriptionSheet.show(context),
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text('Thêm mới'),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),

              if (subscriptions.isEmpty)
                AppEmptyState(
                  title: 'Chưa có gói thuê bao nào',
                  message:
                      'Thêm Netflix, Spotify, iCloud... để không bao giờ quên ngày gia hạn trừ tiền.',
                  actionText: 'Thêm gói thuê bao ngay',
                  onActionPressed: () => AddSubscriptionSheet.show(context),
                )
              else
                ...subscriptions.map((sub) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: _SubscriptionTile(subscription: sub),
                  );
                }),
            ],
          );
        },
      ),
    );
  }
}

class _SubscriptionTile extends ConsumerWidget {
  final SubscriptionEntity subscription;

  const _SubscriptionTile({required this.subscription});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDueSoon = subscription.isDueSoon;

    return AppCard(
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: isDueSoon
                  ? AppColors.warning.withValues(alpha: 0.15)
                  : AppColors.primary.withValues(alpha: 0.15),
              borderRadius: AppRadius.borderMd,
            ),
            child: Icon(
              Icons.subscriptions_rounded,
              color: isDueSoon ? AppColors.warning : AppColors.primaryLight,
              size: 22,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        subscription.name,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.darkTextPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isDueSoon) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.warning.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Còn ${subscription.daysUntilRenewal} ngày',
                          style: const TextStyle(
                            fontSize: 10,
                            color: AppColors.warning,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  'Gia hạn: ${DateFormatter.formatDate(subscription.nextBillingDate)} (${subscription.billingCycle.displayName})',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.darkTextSecondary,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              AmountText(
                amount: subscription.amount,
                currency: subscription.currency,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
              Switch(
                value: subscription.isActive,
                activeThumbColor: AppColors.primary,
                onChanged: (_) {
                  ref
                      .read(subscriptionsControllerProvider.notifier)
                      .toggleActive(subscription);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
