import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/utils/icon_helper.dart';
import '../../../../shared/widgets/app_bottom_sheet.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/quick_action_fab.dart';
import '../../../category/domain/entities/category_entity.dart';
import '../../../category/presentation/controllers/categories_controller.dart';
import '../../../category/presentation/widgets/category_picker_sheet.dart';
import '../../../wallet/domain/entities/wallet_entity.dart';
import '../../../wallet/presentation/controllers/wallets_controller.dart';
import '../../domain/entities/transaction_entity.dart';
import '../controllers/transactions_controller.dart';

class QuickAddTransactionSheet extends ConsumerStatefulWidget {
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
  ConsumerState<QuickAddTransactionSheet> createState() => _QuickAddTransactionSheetState();
}

class _QuickAddTransactionSheetState extends ConsumerState<QuickAddTransactionSheet> {
  late QuickActionType _type;
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  CategoryEntity? _selectedCategory;
  WalletEntity? _selectedWallet;
  WalletEntity? _selectedToWallet;
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;

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

  String get _transactionTypeString {
    switch (_type) {
      case QuickActionType.expense:
        return 'expense';
      case QuickActionType.income:
        return 'income';
      case QuickActionType.transfer:
        return 'transfer';
    }
  }

  Future<void> _onSave() async {
    final amountText = _amountController.text.replaceAll(RegExp(r'[^0-9.]'), '');
    final amount = double.tryParse(amountText);

    if (amount == null || amount <= 0) {
      context.showSnackBar('Vui lòng nhập số tiền hợp lệ (> 0)', isError: true);
      return;
    }

    if (_selectedWallet == null) {
      context.showSnackBar('Vui lòng chọn ví tiền', isError: true);
      return;
    }

    if (_type == QuickActionType.transfer) {
      if (_selectedToWallet == null) {
        context.showSnackBar('Vui lòng chọn ví nhận tiền', isError: true);
        return;
      }
      if (_selectedWallet!.id == _selectedToWallet!.id) {
        context.showSnackBar('Ví chuyển và ví nhận không được trùng nhau', isError: true);
        return;
      }
    }

    final newTx = TransactionEntity(
      id: '',
      type: _transactionTypeString,
      amount: amount,
      currency: _selectedWallet!.currency,
      walletId: _selectedWallet!.id,
      toWalletId: _type == QuickActionType.transfer ? _selectedToWallet?.id : null,
      categoryId: _type != QuickActionType.transfer ? _selectedCategory?.id : null,
      note: _noteController.text.trim().isNotEmpty ? _noteController.text.trim() : null,
      occurredAt: _selectedDate,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    setState(() => _isLoading = true);
    final success = await ref.read(transactionsControllerProvider.notifier).addTransaction(newTx);
    setState(() => _isLoading = false);

    if (success && mounted) {
      Navigator.of(context).pop();
      context.showSnackBar('Đã ghi nhận giao dịch ${CurrencyFormatter.format(amount)} thành công!');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final walletsAsync = ref.watch(walletsStreamProvider);
    final categoriesAsync = ref.watch(categoriesStreamProvider(_transactionTypeString));

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

        // Wallets & Categories Real Data Resolution
        walletsAsync.when(
          loading: () => const SizedBox.shrink(),
          error: (err, _) => Text('Lỗi: $err'),
          data: (wallets) {
            if (wallets.isEmpty) {
              return const Text('Bạn cần tạo ít nhất một ví tiền.');
            }
            _selectedWallet ??= wallets.first;
            if (_type == QuickActionType.transfer && _selectedToWallet == null && wallets.length > 1) {
              _selectedToWallet = wallets[1];
            }

            return categoriesAsync.when(
              loading: () => const SizedBox.shrink(),
              error: (err, _) => Text('Lỗi: $err'),
              data: (categories) {
                if (categories.isNotEmpty && _selectedCategory == null) {
                  _selectedCategory = categories.first;
                }

                return Column(
                  children: [
                    // Category & Wallet Selector Row
                    Row(
                      children: [
                        if (_type != QuickActionType.transfer) ...[
                          Expanded(
                            child: _buildSelectorTile(
                              label: 'Danh mục',
                              value: _selectedCategory?.name ?? 'Chọn danh mục',
                              icon: IconHelper.getIcon(_selectedCategory?.icon),
                              color: IconHelper.getColor(_selectedCategory?.color),
                              onTap: () async {
                                final selected = await CategoryPickerSheet.show(
                                  context,
                                  selectedCategoryId: _selectedCategory?.id,
                                  type: _transactionTypeString,
                                );
                                if (selected != null) {
                                  setState(() => _selectedCategory = selected);
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                        ],
                        Expanded(
                          child: _buildSelectorTile(
                            label: _type == QuickActionType.transfer ? 'Ví nguồn' : 'Ví tiền',
                            value: _selectedWallet?.name ?? 'Chọn ví',
                            icon: IconHelper.getIcon(_selectedWallet?.icon),
                            color: IconHelper.getColor(_selectedWallet?.color),
                            onTap: () => _showWalletPicker(context, wallets, isSource: true),
                          ),
                        ),
                        if (_type == QuickActionType.transfer) ...[
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: _buildSelectorTile(
                              label: 'Ví đích',
                              value: _selectedToWallet?.name ?? 'Chọn ví nhận',
                              icon: IconHelper.getIcon(_selectedToWallet?.icon),
                              color: IconHelper.getColor(_selectedToWallet?.color),
                              onTap: () => _showWalletPicker(context, wallets, isSource: false),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                );
              },
            );
          },
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
          isLoading: _isLoading,
          variant: AppButtonVariant.primary,
        ),
      ],
    );
  }

  void _showWalletPicker(BuildContext context, List<WalletEntity> wallets, {required bool isSource}) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Text(
                isSource ? 'Chọn Ví Nguồn' : 'Chọn Ví Nhận',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
            const Divider(height: 1),
            ...wallets.map(
              (w) => ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: IconHelper.getColor(w.color).withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(IconHelper.getIcon(w.icon), color: IconHelper.getColor(w.color), size: 20),
                ),
                title: Text(w.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text('Số dư: ${CurrencyFormatter.format(w.balance, currency: w.currency)}'),
                onTap: () {
                  Navigator.of(ctx).pop();
                  setState(() {
                    if (isSource) {
                      _selectedWallet = w;
                    } else {
                      _selectedToWallet = w;
                    }
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeTab(String label, QuickActionType type, Color activeColor) {
    final isSelected = _type == type;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _type = type;
            _selectedCategory = null;
          });
        },
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
    Color? color,
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
            Icon(icon, size: 16, color: color ?? AppColors.primary),
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
