import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_radius.dart';
import '../../app/theme/app_spacing.dart';

enum QuickActionType { expense, income, transfer }

class QuickActionFab extends StatefulWidget {
  final ValueChanged<QuickActionType> onActionSelected;

  const QuickActionFab({
    super.key,
    required this.onActionSelected,
  });

  @override
  State<QuickActionFab> createState() => _QuickActionFabState();
}

class _QuickActionFabState extends State<QuickActionFab>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _expandAnimation;
  late Animation<double> _rotateAnimation;
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );
    _rotateAnimation = Tween<double>(begin: 0.0, end: 0.125).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _isOpen = !_isOpen;
      if (_isOpen) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  void _handleAction(QuickActionType type) {
    _toggle();
    widget.onActionSelected(type);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (_isOpen) ...[
          _buildActionButton(
            label: 'Chuyển tiền',
            icon: Icons.swap_horiz_rounded,
            color: AppColors.transfer,
            onPressed: () => _handleAction(QuickActionType.transfer),
            offset: 3,
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildActionButton(
            label: 'Khoản thu',
            icon: Icons.arrow_downward_rounded,
            color: AppColors.income,
            onPressed: () => _handleAction(QuickActionType.income),
            offset: 2,
          ),
          const SizedBox(height: AppSpacing.sm),
          _buildActionButton(
            label: 'Khoản chi',
            icon: Icons.arrow_upward_rounded,
            color: AppColors.expense,
            onPressed: () => _handleAction(QuickActionType.expense),
            offset: 1,
          ),
          const SizedBox(height: AppSpacing.md),
        ],
        // Main FAB
        Container(
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.4),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: _toggle,
              child: SizedBox(
                width: 58,
                height: 58,
                child: RotationTransition(
                  turns: _rotateAnimation,
                  child: const Icon(
                    Icons.add_rounded,
                    size: 32,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
    required int offset,
  }) {
    return ScaleTransition(
      scale: _expandAnimation,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.darkSurface,
              borderRadius: AppRadius.borderSm,
              border: Border.all(color: AppColors.darkBorder, width: 1),
            ),
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          Material(
            color: color,
            shape: const CircleBorder(),
            elevation: 4,
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onPressed,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Icon(icon, size: 20, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
