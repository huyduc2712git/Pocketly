import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/extensions/context_extensions.dart';
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

    return Scaffold(
      appBar: AppBar(title: const Text('Cá Nhân & Cài Đặt')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          // User Avatar & Details Card
          AppCard(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: const BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      user?.name.isNotEmpty == true
                          ? user!.name[0].toUpperCase()
                          : 'U',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
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
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: AppColors.darkTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        user?.email ?? 'Chế độ ngoại tuyến (Offline)',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.darkTextSecondary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'Finly Member Pro',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryLight,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Offline Sync Status Card
          AppCard(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: pendingSyncCount > 0
                        ? AppColors.warning.withValues(alpha: 0.15)
                        : AppColors.income.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    pendingSyncCount > 0
                        ? Icons.cloud_upload_rounded
                        : Icons.cloud_done_rounded,
                    color: pendingSyncCount > 0
                        ? AppColors.warning
                        : AppColors.income,
                    size: 20,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pendingSyncCount > 0
                            ? 'Chờ đồng bộ ($pendingSyncCount tác vụ)'
                            : 'Đã đồng bộ an toàn',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        pendingSyncCount > 0
                            ? 'Dữ liệu được lưu trữ offline cục bộ'
                            : 'Tất cả dữ liệu đã được bảo vệ',
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.darkTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    context.showSnackBar('Đang đồng bộ dữ liệu...');
                    final count = await ref
                        .read(syncControllerProvider.notifier)
                        .syncNow();
                    if (context.mounted) {
                      context.showSnackBar(
                        'Đã đồng bộ thành công $count tác vụ!',
                      );
                    }
                  },
                  child: const Text('Đồng bộ'),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Section 1: Financial Utilities
          const Text(
            'Tiện ích tài chính',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.darkTextSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.subscriptions_outlined,
                    color: AppColors.primaryLight,
                  ),
                  title: const Text(
                    'Gói thuê bao & Định kỳ',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  subtitle: const Text(
                    'Quản lý Netflix, Spotify, iCloud...',
                    style: TextStyle(fontSize: 11),
                  ),
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
                ListTile(
                  leading: const Icon(
                    Icons.download_rounded,
                    color: AppColors.income,
                  ),
                  title: const Text(
                    'Xuất dữ liệu CSV',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  subtitle: const Text(
                    'Mở trên Excel, Google Sheets',
                    style: TextStyle(fontSize: 11),
                  ),
                  trailing: const Icon(Icons.chevron_right_rounded, size: 20),
                  onTap: () => _exportData(context, ref, isCsv: true),
                ),
                const Divider(height: 1, indent: 56),
                ListTile(
                  leading: const Icon(
                    Icons.code_rounded,
                    color: AppColors.transfer,
                  ),
                  title: const Text(
                    'Xuất dữ liệu JSON',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  subtitle: const Text(
                    'Sao lưu dự phòng hoàn chỉnh',
                    style: TextStyle(fontSize: 11),
                  ),
                  trailing: const Icon(Icons.chevron_right_rounded, size: 20),
                  onTap: () => _exportData(context, ref, isCsv: false),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Section 2: Preferences
          const Text(
            'Cài đặt ứng dụng',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.darkTextSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.dark_mode_outlined,
                    color: AppColors.primaryLight,
                  ),
                  title: const Text(
                    'Giao diện tối (Dark Mode)',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  trailing: Switch(
                    value: true,
                    activeThumbColor: AppColors.primary,
                    onChanged: (val) {
                      context.showSnackBar(
                        'Finly đã được tối ưu hóa chuẩn Obsidian Dark Mode.',
                      );
                    },
                  ),
                ),
                const Divider(height: 1, indent: 56),
                const ListTile(
                  leading: Icon(
                    Icons.monetization_on_outlined,
                    color: AppColors.income,
                  ),
                  title: Text(
                    'Đơn vị tiền tệ chính',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  trailing: Text(
                    'VND (₫)',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryLight,
                    ),
                  ),
                ),
                const Divider(height: 1, indent: 56),
                const ListTile(
                  leading: Icon(
                    Icons.notifications_outlined,
                    color: AppColors.warning,
                  ),
                  title: Text(
                    'Nhắc nhở ghi chép hàng ngày',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  trailing: Text(
                    '20:00',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryLight,
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
