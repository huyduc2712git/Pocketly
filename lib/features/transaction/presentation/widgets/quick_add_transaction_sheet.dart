import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../shared/widgets/app_bottom_sheet.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/quick_action_fab.dart';

class QuickAddTransactionSheet extends StatefulWidget {
  final QuickActionType initialType;

  const QuickAddTransactionSheet({
    super.key,
    this.initialType = QuickActionType.expense,
  });

  static Future<void> show(BuildContext context, {QuickActionType initialType = QuickActionType.expense}) {
    return AppBottomSheet.show(
      context: context,
      title: initialType == QuickActionType.income
          ? 'Thêm Khoản Thu'
          : initialType == QuickActionType.transfer
              ? 'Chuyển Tiền Giữa Các Ví'
              : 'Thêm Khoản Chi',
      child: QuickAddTransactionSheet(initialType: initialType),
    );
  }

  @override
  State<QuickAddTransactionSheet> createState() => _QuickAddTransactionSheetState();
}

class _QuickAddTransactionSheetState extends State<QuickAddTransactionSheet> {
  late QuickActionType _type;
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  final String _selectedCategory = 'Ăn uống';
  final String _selectedWallet = 'Tiền mặt';
  final String _selectedToWallet = 'Tài khoản Ngân hàng';
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _type = widget.initialType;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _onSave() {
    final amountText = _amountController.text.replaceAll(RegExp(r'[^0-9]'), '');
    final amount = double.tryParse(amountText);

    if (amount == null || amount <= 0) {
      context.showSnackBar('Vui lòng nhập số tiền hợp lệ', isError: true);
      return;
    }

    Navigator.of(context).pop();
    context.showSnackBar('Đã ghi nhận giao dịch ${CurrencyFormatter.format(amount)} thành công!');
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Type Switcher
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCardElevated : AppColors.lightCardElevated,
            borderRadius: AppRadius.borderMd,
          ),
          child: Row(
            children: [
              _buildTypeTab('Chi tiêu', QuickActionType.expense, AppColors.expense),
              _buildTypeTab('Thu nhập', QuickActionType.income, AppColors.income),
              _buildTypeTab('Chuyển khoản', QuickActionType.transfer, AppColors.transfer),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        // Amount Input Field
        AppTextField(
          controller: _amountController,
          label: 'Số tiền (₫)',
          hint: '0',
          keyboardType: TextInputType.number,
          autofocus: true,
          prefixIcon: const Icon(Icons.monetization_on_outlined, color: AppColors.primary),
        ),
        const SizedBox(height: AppSpacing.sm),

        // Note Input Field
        AppTextField(
          controller: _noteController,
          label: 'Ghi chú',
          hint: 'Ăn tối, Mua sắm, Đổ xăng...',
          prefixIcon: const Icon(Icons.edit_note_rounded, color: AppColors.darkTextMuted),
        ),
        const SizedBox(height: AppSpacing.md),

        // Category & Wallet Selector Row
        Row(
          children: [
            if (_type != QuickActionType.transfer) ...[
              Expanded(
                child: _buildSelectorTile(
                  label: 'Danh mục',
                  value: _selectedCategory,
                  icon: Icons.category_outlined,
                  onTap: () {
                    // Show category picker in future phase
                  },
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
            ],
            Expanded(
              child: _buildSelectorTile(
                label: _type == QuickActionType.transfer ? 'Ví nguồn' : 'Ví tiền',
                value: _selectedWallet,
                icon: Icons.account_balance_wallet_outlined,
                onTap: () {},
              ),
            ),
            if (_type == QuickActionType.transfer) ...[
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _buildSelectorTile(
                  label: 'Ví đích',
                  value: _selectedToWallet,
                  icon: Icons.move_to_inbox_outlined,
                  onTap: () {},
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: AppSpacing.sm),

        // Date Selector Tile
        _buildSelectorTile(
          label: 'Ngày giao dịch',
          value: DateFormatter.formatFullDate(_selectedDate),
          icon: Icons.calendar_today_outlined,
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: _selectedDate,
              firstDate: DateTime(2020),
              lastDate: DateTime(2030),
            );
            if (picked != null) {
              setState(() => _selectedDate = picked);
            }
          },
        ),
        const SizedBox(height: AppSpacing.lg),

        // Save Button
        AppButton(
          text: 'Lưu giao dịch',
          onPressed: _onSave,
          variant: AppButtonVariant.primary,
        ),
      ],
    );
  }

  Widget _buildTypeTab(String label, QuickActionType type, Color activeColor) {
    final isSelected = _type == type;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _type = type),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? activeColor : Colors.transparent,
            borderRadius: AppRadius.borderSm,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? Colors.white : AppColors.darkTextSecondary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectorTile({
    required String label,
    required String value,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final isDark = context.isDarkMode;
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.borderMd,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 10),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.lightCard,
          borderRadius: AppRadius.borderMd,
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: AppColors.primary),
            const SizedBox(width: 6),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.darkTextMuted,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
