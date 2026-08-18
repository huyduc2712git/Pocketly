import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:finly/app/theme/app_colors.dart';
import 'package:finly/app/theme/app_icons.dart';
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

    return Scaffold(
      extendBody: true,
      body: navigationShell,
      floatingActionButton: onQuickAction != null
          ? Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: QuickActionFab(onActionSelected: onQuickAction!),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: Container(
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF0D131F).withValues(alpha: 0.82)
                  : Colors.white.withValues(alpha: 0.85),
              border: Border(
                top: BorderSide(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.08)
                      : Colors.black.withValues(alpha: 0.06),
                  width: 1,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.45 : 0.08),
                  blurRadius: 24,
                  offset: const Offset(0, -6),
                ),
              ],
            ),
            child: SafeArea(
              child: NavigationBar(
                selectedIndex: navigationShell.currentIndex,
                onDestinationSelected: _onItemTapped,
                backgroundColor: Colors.transparent,
                indicatorColor: AppColors.primary.withValues(alpha: 0.22),
                elevation: 0,
                height: 68,
                labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
                destinations: const [
                  NavigationDestination(
                    icon: Icon(AppIcons.dashboard, size: 22),
                    selectedIcon: Icon(
                      AppIcons.dashboard,
                      color: AppColors.primaryLight,
                      size: 24,
                    ),
                    label: 'Tổng quan',
                  ),
                  NavigationDestination(
                    icon: Icon(AppIcons.transactions, size: 22),
                    selectedIcon: Icon(
                      AppIcons.transactions,
                      color: AppColors.primaryLight,
                      size: 24,
                    ),
                    label: 'Sổ thu chi',
                  ),
                  NavigationDestination(
                    icon: Icon(AppIcons.budget, size: 22),
                    selectedIcon: Icon(
                      AppIcons.budget,
                      color: AppColors.primaryLight,
                      size: 24,
                    ),
                    label: 'Ngân sách',
                  ),
                  NavigationDestination(
                    icon: Icon(AppIcons.analytics, size: 22),
                    selectedIcon: Icon(
                      AppIcons.analytics,
                      color: AppColors.primaryLight,
                      size: 24,
                    ),
                    label: 'Báo cáo',
                  ),
                  NavigationDestination(
                    icon: Icon(AppIcons.profile, size: 22),
                    selectedIcon: Icon(
                      AppIcons.profile,
                      color: AppColors.primaryLight,
                      size: 24,
                    ),
                    label: 'Cá nhân',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
