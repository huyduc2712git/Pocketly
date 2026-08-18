import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../shared/widgets/app_bottom_sheet.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../wallet/domain/entities/wallet_entity.dart';
import '../../../wallet/presentation/controllers/wallets_controller.dart';
import '../../domain/entities/subscription_entity.dart';
import '../controllers/subscriptions_controller.dart';

class AddSubscriptionSheet extends ConsumerStatefulWidget {
  const AddSubscriptionSheet({super.key});

  static Future<void> show(BuildContext context) {
    return AppBottomSheet.show(
      context: context,
      title: 'Thêm Gói Thuê Bao Định Kỳ',
      child: const AddSubscriptionSheet(),
    );
  }

  @override
  ConsumerState<AddSubscriptionSheet> createState() =>
      _AddSubscriptionSheetState();
}

class _AddSubscriptionSheetState extends ConsumerState<AddSubscriptionSheet> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  SubscriptionBillingCycle _billingCycle = SubscriptionBillingCycle.monthly;
  WalletEntity? _selectedWallet;
  DateTime _nextBillingDate = DateTime.now().add(const Duration(days: 30));
  bool _isLoading = false;

  final List<Map<String, String>> _popularServices = [
    {'name': 'Netflix', 'amount': '260000', 'icon': 'movie_rounded'},
    {'name': 'Spotify Premium', 'amount': '59000', 'icon': 'entertainment'},
    {
      'name': 'ChatGPT Plus',
      'amount': '500000',
      'icon': 'phone_android_rounded',
    },
    {
      'name': 'iCloud 200GB',
      'amount': '59000',
      'icon': 'phone_android_rounded',
    },
    {'name': 'YouTube Premium', 'amount': '79000', 'icon': 'movie_rounded'},
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _onSave() async {
    final name = _nameController.text.trim();
    final amountText = _amountController.text.replaceAll(
      RegExp(r'[^0-9.]'),
      '',
    );
    final amount = double.tryParse(amountText);

    if (name.isEmpty) {
      context.showSnackBar('Vui lòng nhập tên dịch vụ thuê bao', isError: true);
      return;
    }
    if (amount == null || amount <= 0) {
      context.showSnackBar('Vui lòng nhập số tiền hợp lệ (> 0)', isError: true);
      return;
    }
    if (_selectedWallet == null) {
      context.showSnackBar('Vui lòng chọn ví thanh toán', isError: true);
      return;
    }

    final newSub = SubscriptionEntity(
      id: '',
      name: name,
      amount: amount,
      currency: _selectedWallet!.currency,
      walletId: _selectedWallet!.id,
      billingCycle: _billingCycle,
      nextBillingDate: _nextBillingDate,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    setState(() => _isLoading = true);
    final success = await ref
        .read(subscriptionsControllerProvider.notifier)
        .createSubscription(newSub);
    setState(() => _isLoading = false);

    if (success && mounted) {
      Navigator.of(context).pop();
      context.showSnackBar(
        'Đã thêm thuê bao "$name" (${CurrencyFormatter.format(amount)}) thành công!',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final walletsAsync = ref.watch(walletsStreamProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Quick Presets Chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _popularServices.map((preset) {
              return Padding(
                padding: const EdgeInsets.only(right: AppSpacing.xs),
                child: ActionChip(
                  label: Text(preset['name']!),
                  avatar: const Icon(
                    Icons.flash_on_rounded,
                    size: 14,
                    color: AppColors.primary,
                  ),
                  onPressed: () {
                    _nameController.text = preset['name']!;
                    _amountController.text = preset['amount']!;
                  },
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        AppTextField(
          controller: _nameController,
          label: 'Tên dịch vụ thuê bao',
          hint: 'Netflix, Spotify, iCloud...',
          autofocus: true,
          prefixIcon: const Icon(
            Icons.subscriptions_outlined,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),

        AppTextField(
          controller: _amountController,
          label: 'Số tiền định kỳ (₫)',
          hint: '0',
          keyboardType: TextInputType.number,
          prefixIcon: const Icon(
            Icons.payments_outlined,
            color: AppColors.income,
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        // Billing Cycle Chips
        Text(
          'Chu kỳ thanh toán',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.lightTextSecondary,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Row(
          children: SubscriptionBillingCycle.values.map((cycle) {
            final isSelected = _billingCycle == cycle;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: ChoiceChip(
                  label: Center(child: Text(cycle.displayName)),
                  selected: isSelected,
                  onSelected: (val) {
                    if (val) setState(() => _billingCycle = cycle);
                  },
                  selectedColor: AppColors.primary,
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: AppSpacing.md),

        // Wallet and Date Selector Row
        walletsAsync.when(
          loading: () => const SizedBox.shrink(),
          error: (err, _) => Text('Lỗi: $err'),
          data: (wallets) {
            if (wallets.isNotEmpty && _selectedWallet == null) {
              _selectedWallet = wallets.first;
            }
            return Row(
              children: [
                Expanded(
                  child: _buildSelectorTile(
                    label: 'Ví thanh toán',
                    value: _selectedWallet?.name ?? 'Chọn ví',
                    icon: Icons.account_balance_wallet_outlined,
                    onTap: () {
                      // Select wallet
                      showModalBottomSheet(
                        context: context,
                        builder: (ctx) => SafeArea(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: wallets
                                .map(
                                  (w) => ListTile(
                                    title: Text(w.name),
                                    onTap: () {
                                      Navigator.of(ctx).pop();
                                      setState(() => _selectedWallet = w);
                                    },
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: _buildSelectorTile(
                    label: 'Ngày gia hạn kế tiếp',
                    value: DateFormatter.formatDate(_nextBillingDate),
                    icon: Icons.calendar_today_outlined,
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _nextBillingDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(
                          const Duration(days: 365 * 5),
                        ),
                      );
                      if (picked != null) {
                        setState(() => _nextBillingDate = picked);
                      }
                    },
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: AppSpacing.lg),

        AppButton(
          text: 'Lưu gói thuê bao',
          onPressed: _onSave,
          isLoading: _isLoading,
        ),
      ],
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
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: 10,
        ),
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
                    ),
                  ),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
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
