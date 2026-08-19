import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:finly/app/theme/app_colors.dart';
import 'package:finly/app/theme/app_3d_icons.dart';
import 'package:finly/shared/widgets/app_3d_icon.dart';
import 'package:finly/shared/widgets/quick_action_fab.dart';

class AppShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  final ValueChanged<QuickActionType>? onQuickAction;

  const AppShell({
    super.key,
    required this.navigationShell,
    this.onQuickAction,
  });

  void _onItemTapped(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    const navItems = [
      _NavItem(
        label: 'Tổng quan',
        asset: AppIcons3D.dashboard,
        iconData: Icons.home_rounded,
      ),
      _NavItem(
        label: 'Sổ thu chi',
        asset: AppIcons3D.transactions,
        iconData: Icons.account_balance_wallet_outlined,
      ),
      _NavItem(
        label: 'Ngân sách',
        asset: AppIcons3D.budget,
        iconData: Icons.pie_chart_outline_rounded,
      ),
      _NavItem(
        label: 'Báo cáo',
        asset: AppIcons3D.analytics,
        iconData: Icons.bar_chart_rounded,
      ),
      _NavItem(
        label: 'Cá nhân',
        asset: AppIcons3D.profile,
        iconData: Icons.person_outline_rounded,
      ),
    ];

    return Scaffold(
      extendBody: true,
      body: navigationShell,
      floatingActionButton: onQuickAction != null
          ? Padding(
              padding: const EdgeInsets.only(bottom: 72),
              child: QuickActionFab(onActionSelected: onQuickAction!),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        decoration: BoxDecoration(
          color: isDark
              ? const Color(0xFF16161E).withValues(alpha: 0.95)
              : Colors.white.withValues(alpha: 0.96),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.08)
                : const Color(0xFFF0F1F5),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.06),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              child: Row(
                children: List.generate(navItems.length, (index) {
                  final item = navItems[index];
                  final isSelected = navigationShell.currentIndex == index;

                  return Expanded(
                    child: _buildTabButton(
                      context,
                      item: item,
                      isSelected: isSelected,
                      onTap: () => _onItemTapped(index),
                      isDark: isDark,
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabButton(
    BuildContext context, {
    required _NavItem item,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? const Color(0xFF2D1222) : AppColors.pastelPink)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 28,
              height: 28,
              child: Center(
                child: isSelected
                    ? App3DIcon(assetPath: item.asset, size: 26)
                    : Opacity(
                        opacity: 0.6,
                        child: App3DIcon(assetPath: item.asset, size: 22),
                      ),
              ),
            ),
            const SizedBox(height: 3),
            Text(
              item.label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected
                    ? AppColors.primary
                    : (isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem {
  final String label;
  final String asset;
  final IconData iconData;

  const _NavItem({
    required this.label,
    required this.asset,
    required this.iconData,
  });
}
