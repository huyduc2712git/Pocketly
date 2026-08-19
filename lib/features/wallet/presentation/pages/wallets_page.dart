import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/utils/icon_helper.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../../shared/widgets/app_empty_state.dart';
import '../../../../shared/widgets/app_loading.dart';
import '../../../../shared/widgets/transaction_tile.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../transaction/presentation/controllers/transactions_controller.dart';
import '../../domain/entities/wallet_entity.dart';
import '../controllers/wallets_controller.dart';
import '../widgets/add_wallet_sheet.dart';
import '../widgets/fintech_card_widget.dart';

class WalletsPage extends ConsumerStatefulWidget {
  const WalletsPage({super.key});

  @override
  ConsumerState<WalletsPage> createState() => _WalletsPageState();
}

class _WalletsPageState extends ConsumerState<WalletsPage> {
  int _selectedCardIndex = 0;
  final PageController _pageController = PageController(viewportFraction: 0.92);

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final walletsAsync = ref.watch(walletsStreamProvider);
    final transactionsAsync = ref.watch(transactionsStreamProvider);
    final authState = ref.watch(authControllerProvider);
    final isDark = context.isDarkMode;

    final userName = authState is Authenticated
        ? authState.user.name
        : 'Người dùng Finly';

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: AppSpacing.md),
          child: Center(
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDark
                      ? AppColors.darkBorder
                      : const Color(0xFFF0F1F5),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(
                      alpha: isDark ? 0.2 : 0.03,
                    ),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 18,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                ),
                padding: EdgeInsets.zero,
                onPressed: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go(RouteNames.home);
                  }
                },
              ),
            ),
          ),
        ),
        title: null,
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.md),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDark
                          ? AppColors.darkBorder
                          : const Color(0xFFF0F1F5),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(
                          alpha: isDark ? 0.2 : 0.03,
                        ),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.notifications_none_rounded,
                      size: 20,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    ),
                    padding: EdgeInsets.zero,
                    onPressed: () => context.go(RouteNames.analytics),
                  ),
                ),
                // Notification red dot badge
                Positioned(
                  top: 3,
                  right: 3,
                  child: Container(
                    width: 9,
                    height: 9,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF3B30),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isDark ? AppColors.darkSurface : Colors.white,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: walletsAsync.when(
        loading: () => const AppLoading(message: 'Đang tải danh sách ví...'),
        error: (err, _) => Center(child: Text('Lỗi: $err')),
        data: (wallets) {
          final activeCount =
              wallets.where((w) => !w.isExcludedFromTotal).length;

          // Transactions filtered for currently active wallet or all
          final selectedWallet = wallets.isNotEmpty &&
                  _selectedCardIndex < wallets.length
              ? wallets[_selectedCardIndex]
              : null;

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.xs,
              AppSpacing.md,
              AppSpacing.bottomClearance,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header: "Your Cards" and active counter
                Text(
                  'Ví & Thẻ của bạn',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '$activeCount ví / thẻ đang hoạt động',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Card Preview Carousel
                if (wallets.isEmpty)
                  AppEmptyState(
                    title: 'Chưa có thẻ / ví nào',
                    message:
                        'Thêm thẻ ngân hàng hoặc ví đầu tiên để bắt đầu quản lý chi tiêu',
                    actionText: 'Thêm thẻ mới',
                    onActionPressed: () => AddWalletSheet.show(context),
                  )
                else ...[
                  SizedBox(
                    height: 220,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: wallets.length,
                      onPageChanged: (idx) {
                        setState(() => _selectedCardIndex = idx);
                      },
                      itemBuilder: (context, index) {
                        final wallet = wallets[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: FintechCardWidget(
                            wallet: wallet,
                            userName: userName,
                            cardIndex: index,
                            onDelete: () => _confirmDelete(wallet),
                          ),
                        );
                      },
                    ),
                  ),

                  // Carousel Pagination Dots Indicator
                  if (wallets.length > 1) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(wallets.length, (index) {
                        final isSelected = index == _selectedCardIndex;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          width: isSelected ? 22 : 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary
                                : (isDark
                                    ? AppColors.darkBorder
                                    : const Color(0xFFE2E8F0)),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        );
                      }),
                    ),
                  ],
                ],
                const SizedBox(height: AppSpacing.md),

                // "+ Add new card" Capsule Button
                Center(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => AddWalletSheet.show(context),
                      borderRadius: BorderRadius.circular(24),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkSurface : Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.4),
                            width: 1.2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(
                                alpha: isDark ? 0.2 : 0.08,
                              ),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.add_rounded,
                              size: 18,
                              color: AppColors.primary,
                            ),
                            SizedBox(width: 6),
                            Text(
                              'Thêm thẻ / ví mới',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),

                // Section: "Recent Transaction" & "See all >"
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Giao dịch gần đây',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.2,
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightTextPrimary,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => context.go(RouteNames.transactions),
                      child: const Row(
                        children: [
                          Text(
                            'Xem tất cả',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                          SizedBox(width: 2),
                          Icon(
                            Icons.chevron_right_rounded,
                            size: 16,
                            color: AppColors.primary,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),

                // Recent Transactions List Card
                transactionsAsync.when(
                  loading: () => const Center(
                    child: Padding(
                      padding: EdgeInsets.all(AppSpacing.lg),
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                  error: (err, _) => Center(child: Text('Lỗi: $err')),
                  data: (transactions) {
                    final walletTxList = selectedWallet != null
                        ? transactions
                            .where((tx) =>
                                tx.walletId == selectedWallet.id ||
                                tx.toWalletId == selectedWallet.id)
                            .take(6)
                            .toList()
                        : transactions.take(6).toList();

                    // If current wallet has no transactions, fallback to overall recent transactions
                    final displayList = walletTxList.isNotEmpty
                        ? walletTxList
                        : transactions.take(5).toList();

                    if (displayList.isEmpty) {
                      return AppCard(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        child: Center(
                          child: Text(
                            'Chưa có giao dịch nào trên ví này',
                            style: TextStyle(
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      );
                    }

                    return AppCard(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xs,
                        vertical: AppSpacing.xs,
                      ),
                      child: Column(
                        children: [
                          for (int i = 0; i < displayList.length; i++) ...[
                            if (i > 0) const Divider(height: 1, indent: 56),
                            TransactionTile(
                              title: displayList[i].note?.isNotEmpty == true
                                  ? displayList[i].note!
                                  : (displayList[i].categoryName ??
                                      (displayList[i].isTransfer
                                          ? 'Chuyển tiền'
                                          : 'Giao dịch')),
                              subtitle: displayList[i].categoryName,
                              walletName: displayList[i].walletName,
                              toWalletName: displayList[i].toWalletName,
                              occurredAt: displayList[i].occurredAt,
                              amount: displayList[i].amount,
                              currency: displayList[i].currency,
                              type: displayList[i].type,
                              icon: IconHelper.getIcon(
                                displayList[i].categoryIcon,
                              ),
                              iconAsset: IconHelper.get3DAsset(
                                displayList[i].categoryIcon,
                              ),
                              iconColor: IconHelper.getColor(
                                displayList[i].categoryColor,
                              ),
                              syncStatus: displayList[i].syncStatus,
                              onTap: () => context.go(RouteNames.transactions),
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _confirmDelete(WalletEntity wallet) {
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
