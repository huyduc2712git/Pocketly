import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/utils/icon_helper.dart';
import '../../../../shared/widgets/amount_text.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_empty_state.dart';
import '../../../../shared/widgets/app_loading.dart';
import '../../domain/entities/wallet_entity.dart';
import '../controllers/wallets_controller.dart';
import '../widgets/add_wallet_sheet.dart';

class WalletsPage extends ConsumerWidget {
  const WalletsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final walletsAsync = ref.watch(walletsStreamProvider);
    final totalNetWorth = ref.watch(totalNetWorthProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ví Tiền & Tài Khoản'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            tooltip: 'Thêm ví mới',
            onPressed: () => AddWalletSheet.show(context),
          ),
        ],
      ),
      body: walletsAsync.when(
        loading: () => const AppLoading(message: 'Đang tải danh sách ví...'),
        error: (err, _) => Center(child: Text('Lỗi: $err')),
        data: (wallets) {
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              // Total Net Worth Card
              AppCard(
                padding: const EdgeInsets.all(AppSpacing.lg),
                gradient: AppColors.balanceGradient,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tổng tài sản ròng',
                      style: TextStyle(color: Color(0xFFC7D2FE), fontSize: 13),
                    ),
                    const SizedBox(height: 4),
                    AmountText(
                      amount: totalNetWorth,
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${wallets.where((w) => !w.isExcludedFromTotal).length} tài khoản đang tính vào tổng số dư',
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
                    'Danh sách ví (${wallets.length})',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.darkTextPrimary,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () => AddWalletSheet.show(context),
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text('Thêm ví'),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),

              if (wallets.isEmpty)
                AppEmptyState(
                  title: 'Chưa có ví nào',
                  message: 'Tạo ví mới để bắt đầu quản lý tài chính của bạn',
                  actionText: 'Tạo ví ngay',
                  onActionPressed: () => AddWalletSheet.show(context),
                )
              else
                ...wallets.map((wallet) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: _WalletListTile(wallet: wallet),
                  );
                }),
            ],
          );
        },
      ),
    );
  }
}

class _WalletListTile extends ConsumerWidget {
  final WalletEntity wallet;

  const _WalletListTile({required this.wallet});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final iconData = IconHelper.getIcon(wallet.icon);
    final color = IconHelper.getColor(wallet.color);

    return AppCard(
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: AppRadius.borderMd,
            ),
            child: Icon(iconData, color: color, size: 22),
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
                        wallet.name,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.darkTextPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (wallet.isExcludedFromTotal) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.darkBorder,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'Tách biệt',
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.darkTextSecondary,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  wallet.type.displayName,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.darkTextSecondary,
                  ),
                ),
              ],
            ),
          ),
          AmountText(
            amount: wallet.balance,
            currency: wallet.currency,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
          PopupMenuButton<String>(
            icon: const Icon(
              Icons.more_vert_rounded,
              size: 18,
              color: AppColors.darkTextMuted,
            ),
            onSelected: (val) {
              if (val == 'delete') {
                _confirmDelete(context, ref);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(
                      Icons.delete_outline_rounded,
                      color: AppColors.error,
                      size: 18,
                    ),
                    SizedBox(width: 8),
                    Text('Xóa ví', style: TextStyle(color: AppColors.error)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xác nhận xóa ví?'),
        content: Text(
          'Bạn có chắc muốn xóa ví "${wallet.name}" không? Các giao dịch cũ vẫn được lưu trữ an toàn.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              ref
                  .read(walletsControllerProvider.notifier)
                  .deleteWallet(wallet.id);
              context.showSnackBar('Đã xóa ví "${wallet.name}"');
            },
            child: const Text('Xóa', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}
