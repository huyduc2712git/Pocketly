import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/app.dart';
import '../../../../app/theme/app_3d_icons.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../shared/widgets/app_3d_icon.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_card.dart';
import '../../../settings/domain/usecases/export_data_usecase.dart';
import '../../../subscription/presentation/pages/subscriptions_page.dart';
import '../../../sync/presentation/controllers/sync_controller.dart';
import '../../../transaction/presentation/controllers/transactions_controller.dart';
import '../controllers/auth_controller.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final user = authState is Authenticated ? authState.user : null;
    final pendingSyncCount = ref.watch(pendingSyncCountProvider);
    final currentThemeMode = ref.watch(themeModeProvider);
    final isDark = context.isDarkMode;

    return Scaffold(
      appBar: AppBar(title: const Text('Cá Nhân & Cài Đặt')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.bottomClearance,
        ),
        children: [
          // User Card
          AppCard(
            child: Row(
              children: [
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF2D1222)
                        : AppColors.pastelPink,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: App3DIcon(
                      assetPath: AppIcons3D.profile,
                      size: 40,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user?.name ?? 'Người dùng Finly',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.lightTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        user?.email ?? 'demo@finly.app',
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Cloud Sync Card
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.cloud_sync_rounded,
                          color: pendingSyncCount > 0
                              ? AppColors.warning
                              : AppColors.income,
                          size: 22,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Đồng bộ dữ liệu cục bộ',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.lightTextPrimary,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: (pendingSyncCount > 0
                                ? AppColors.warning
                                : AppColors.income)
                            .withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        pendingSyncCount > 0
                            ? '$pendingSyncCount mục chờ'
                            : 'Đã đồng bộ',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: pendingSyncCount > 0
                              ? AppColors.warning
                              : AppColors.income,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Ứng dụng hoạt động Offline-First. Toàn bộ giao dịch và thiết lập được lưu trữ an toàn trên thiết bị của bạn.',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Section 1: Financial Utilities
          Text(
            'Tiện ích tài chính',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _buildSettingTile(
                  context,
                  iconAsset: AppIcons3D.subscription,
                  title: 'Gói thuê bao & Định kỳ',
                  subtitle: 'Quản lý Netflix, Spotify, iCloud...',
                  trailing: const Icon(Icons.chevron_right_rounded, size: 20),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const SubscriptionsPage(),
                      ),
                    );
                  },
                ),
                const Divider(height: 1, indent: 56),
                _buildSettingTile(
                  context,
                  iconAsset: AppIcons3D.download,
                  title: 'Xuất dữ liệu CSV',
                  subtitle: 'Mở trên Excel, Google Sheets',
                  trailing: const Icon(Icons.chevron_right_rounded, size: 20),
                  onTap: () => _exportData(context, ref, isCsv: true),
                ),
                const Divider(height: 1, indent: 56),
                _buildSettingTile(
                  context,
                  iconAsset: AppIcons3D.category,
                  title: 'Xuất dữ liệu JSON',
                  subtitle: 'Sao lưu dự phòng hoàn chỉnh',
                  trailing: const Icon(Icons.chevron_right_rounded, size: 20),
                  onTap: () => _exportData(context, ref, isCsv: false),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Section 2: Preferences
          Text(
            'Cài đặt ứng dụng',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _buildSettingTile(
                  context,
                  iconAsset: AppIcons3D.insight,
                  title: 'Giao diện tối (Dark Mode)',
                  subtitle: 'Bật / tắt chế độ nền tối',
                  trailing: Switch(
                    value: currentThemeMode == ThemeMode.dark,
                    activeThumbColor: AppColors.primary,
                    onChanged: (val) {
                      ref.read(themeModeProvider.notifier).state =
                          val ? ThemeMode.dark : ThemeMode.light;
                    },
                  ),
                ),
                const Divider(height: 1, indent: 56),
                _buildSettingTile(
                  context,
                  iconAsset: AppIcons3D.cash,
                  title: 'Đơn vị tiền tệ chính',
                  trailing: const Text(
                    'VND (₫)',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const Divider(height: 1, indent: 56),
                _buildSettingTile(
                  context,
                  iconAsset: AppIcons3D.calendar,
                  title: 'Nhắc nhở ghi chép hàng ngày',
                  trailing: const Text(
                    '20:00',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Logout Button
          AppButton(
            text: 'Đăng xuất tài khoản',
            variant: AppButtonVariant.danger,
            onPressed: () {
              ref.read(authControllerProvider.notifier).logout();
            },
          ),
          const SizedBox(height: AppSpacing.md),
          const Center(
            child: Text(
              'Finly v1.0.0 • Production Ready Fintech Edition',
              style: TextStyle(fontSize: 11, color: AppColors.darkTextMuted),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingTile(
    BuildContext context, {
    required String iconAsset,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    final isDark = context.isDarkMode;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              App3DIcon(assetPath: iconAsset, size: 26),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightTextPrimary,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              ?trailing,
            ],
          ),
        ),
      ),
    );
  }

  void _exportData(BuildContext context, WidgetRef ref, {required bool isCsv}) {
    final txList = ref.read(transactionsStreamProvider).valueOrNull ?? [];
    const exporter = ExportDataUseCase();
    final content = isCsv
        ? exporter.exportToCsv(txList)
        : exporter.exportToJson(txList);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isCsv ? 'Xuất dữ liệu CSV' : 'Xuất dữ liệu JSON'),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Text(
              content.isNotEmpty ? content : 'Chưa có giao dịch nào để xuất.',
              style: const TextStyle(fontSize: 11, fontFamily: 'monospace'),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Đóng'),
          ),
          TextButton.icon(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: content));
              Navigator.of(ctx).pop();
              context.showSnackBar('Đã sao chép dữ liệu vào Clipboard!');
            },
            icon: const Icon(Icons.copy, size: 16),
            label: const Text('Sao chép'),
          ),
        ],
      ),
    );
  }
}
