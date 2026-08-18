import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../shared/widgets/app_bottom_sheet.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../domain/entities/wallet_entity.dart';
import '../controllers/wallets_controller.dart';

class AddWalletSheet extends ConsumerStatefulWidget {
  const AddWalletSheet({super.key});

  static Future<void> show(BuildContext context) {
    return AppBottomSheet.show(
      context: context,
      title: 'Thêm Ví / Tài Khoản Mới',
      child: const AddWalletSheet(),
    );
  }

  @override
  ConsumerState<AddWalletSheet> createState() => _AddWalletSheetState();
}

class _AddWalletSheetState extends ConsumerState<AddWalletSheet> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _balanceController = TextEditingController();
  WalletType _selectedType = WalletType.cash;
  bool _isExcluded = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _balanceController.dispose();
    super.dispose();
  }

  Future<void> _onSave() async {
    final name = _nameController.text.trim();
    final balanceText = _balanceController.text.replaceAll(RegExp(r'[^0-9.]'), '');
    final balance = double.tryParse(balanceText) ?? 0.0;

    if (name.isEmpty) {
      context.showSnackBar('Vui lòng nhập tên ví', isError: true);
      return;
    }

    setState(() => _isLoading = true);
    final success = await ref.read(walletsControllerProvider.notifier).createWallet(
          name: name,
          type: _selectedType,
          initialBalance: balance,
          isExcludedFromTotal: _isExcluded,
        );
    setState(() => _isLoading = false);

    if (success && mounted) {
      Navigator.of(context).pop();
      context.showSnackBar('Đã thêm ví "$name" thành công!');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        AppTextField(
          controller: _nameController,
          label: 'Tên ví / Tài khoản',
          hint: 'Ví chính, Techcombank, MoMo...',
          autofocus: true,
          prefixIcon: const Icon(Icons.account_balance_wallet_outlined, color: AppColors.primary),
        ),
        const SizedBox(height: AppSpacing.md),

        AppTextField(
          controller: _balanceController,
          label: 'Số dư ban đầu (₫)',
          hint: '0',
          keyboardType: TextInputType.number,
          prefixIcon: const Icon(Icons.payments_outlined, color: AppColors.income),
        ),
        const SizedBox(height: AppSpacing.md),

        Text(
          'Loại tài khoản',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),

        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: WalletType.values.map((type) {
            final isSelected = _selectedType == type;
            return ChoiceChip(
              label: Text(type.displayName),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) setState(() => _selectedType = type);
              },
              selectedColor: AppColors.primary,
              backgroundColor: isDark ? AppColors.darkCard : AppColors.lightCard,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                fontSize: 13,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: AppRadius.borderMd,
                side: BorderSide(
                  color: isSelected ? AppColors.primary : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: AppSpacing.md),

        // Exclude from total checkbox
        SwitchListTile(
          title: const Text(
            'Không tính vào tổng số dư',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          subtitle: const Text(
            'Thích hợp cho quỹ vay nợ, tiền người khác gửi...',
            style: TextStyle(fontSize: 12, color: AppColors.darkTextMuted),
          ),
          value: _isExcluded,
          onChanged: (val) => setState(() => _isExcluded = val),
          contentPadding: EdgeInsets.zero,
          activeThumbColor: AppColors.primary,
        ),
        const SizedBox(height: AppSpacing.lg),

        AppButton(
          text: 'Tạo ví mới',
          onPressed: _onSave,
          isLoading: _isLoading,
        ),
      ],
    );
  }
}
