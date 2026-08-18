import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../shared/widgets/app_card.dart';
import '../controllers/auth_controller.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final user = authState is Authenticated ? authState.user : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cá Nhân & Cài Đặt'),
      ),
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
                      user?.name.isNotEmpty == true ? user!.name[0].toUpperCase() : 'U',
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
                        user?.email ?? 'guest@finly.local',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.darkTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit_outlined, size: 20),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          const Text(
            'Quản lý tài chính',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.darkTextSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),

          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _buildSettingTile(
                  icon: Icons.account_balance_wallet_outlined,
                  title: 'Quản lý Ví & Tài khoản',
                  subtitle: '2 ví đang hoạt động',
                  onTap: () => context.push('/wallets'),
                ),
                const Divider(height: 1, indent: 56),
                _buildSettingTile(
                  icon: Icons.category_outlined,
                  title: 'Danh mục thu chi',
                  subtitle: '9 danh mục hệ thống',
                  onTap: () {},
                ),
                const Divider(height: 1, indent: 56),
                _buildSettingTile(
                  icon: Icons.repeat_rounded,
                  title: 'Giao dịch định kỳ & Hóa đơn',
                  subtitle: 'Tự động nhắc nhở',
                  onTap: () {},
                ),
                const Divider(height: 1, indent: 56),
                _buildSettingTile(
                  icon: Icons.subscriptions_outlined,
                  title: 'Gói đăng ký & Dịch vụ',
                  subtitle: 'Theo dõi chi phí định kỳ',
                  onTap: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          const Text(
            'Hệ thống & Đồng bộ',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.darkTextSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),

          AppCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _buildSettingTile(
                  icon: Icons.cloud_sync_outlined,
                  title: 'Đồng bộ Offline-First',
                  subtitle: 'Đã sao lưu cục bộ an toàn',
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.income.withValues(alpha: 0.15),
                      borderRadius: AppRadius.borderXs,
                    ),
                    child: const Text(
                      'Hoàn tất',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.income,
                      ),
                    ),
                  ),
                  onTap: () {},
                ),
                const Divider(height: 1, indent: 56),
                _buildSettingTile(
                  icon: Icons.lock_outline_rounded,
                  title: 'Bảo mật & Mã PIN',
                  onTap: () {},
                ),
                const Divider(height: 1, indent: 56),
                _buildSettingTile(
                  icon: Icons.logout_rounded,
                  title: 'Đăng xuất',
                  iconColor: AppColors.expense,
                  titleColor: AppColors.expense,
                  onTap: () => ref.read(authControllerProvider.notifier).logout(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    Color? iconColor,
    Color? titleColor,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor ?? AppColors.primary, size: 22),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: titleColor ?? AppColors.darkTextPrimary,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: const TextStyle(fontSize: 12, color: AppColors.darkTextMuted),
            )
          : null,
      trailing: trailing ??
          const Icon(
            Icons.chevron_right_rounded,
            size: 20,
            color: AppColors.darkTextMuted,
          ),
      onTap: onTap,
    );
  }
}
