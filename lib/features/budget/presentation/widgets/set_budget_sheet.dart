import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/icon_helper.dart';
import '../../../../shared/widgets/app_bottom_sheet.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../category/presentation/controllers/categories_controller.dart';
import '../../domain/entities/budget_entity.dart';
import '../controllers/budget_controller.dart';

class SetBudgetSheet extends ConsumerStatefulWidget {
  final int month;
  final int year;
  final BudgetEntity? existingBudget;

  const SetBudgetSheet({
    super.key,
    required this.month,
    required this.year,
    this.existingBudget,
  });

  static Future<void> show(
    BuildContext context, {
    required int month,
    required int year,
    BudgetEntity? existingBudget,
  }) {
    return AppBottomSheet.show(
      context: context,
      title: 'Thiết Lập Ngân Sách Tháng $month/$year',
      child: SetBudgetSheet(
        month: month,
        year: year,
        existingBudget: existingBudget,
      ),
    );
  }

  @override
  ConsumerState<SetBudgetSheet> createState() => _SetBudgetSheetState();
}

class _SetBudgetSheetState extends ConsumerState<SetBudgetSheet> {
  final TextEditingController _totalLimitController = TextEditingController();
  final Map<String, TextEditingController> _categoryControllers = {};
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.existingBudget != null) {
      _totalLimitController.text = CurrencyFormatter.formatInput(
        widget.existingBudget!.totalLimit,
      );
      for (final item in widget.existingBudget!.items) {
        _categoryControllers[item.categoryId] = TextEditingController(
          text: CurrencyFormatter.formatInput(item.limitAmount),
        );
      }
    }
  }

  @override
  void dispose() {
    _totalLimitController.dispose();
    for (final c in _categoryControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _onSave() async {
    final totalLimit = CurrencyFormatter.parse(_totalLimitController.text);

    if (totalLimit <= 0) {
      context.showSnackBar(
        'Vui lòng nhập tổng hạn mức ngân sách tháng (> 0)',
        isError: true,
      );
      return;
    }

    final List<BudgetItemEntity> items = [];
    _categoryControllers.forEach((catId, controller) {
      final limit = CurrencyFormatter.parse(controller.text);
      if (limit > 0) {
        items.add(
          BudgetItemEntity(
            id: '',
            budgetId: '',
            categoryId: catId,
            limitAmount: limit,
          ),
        );
      }
    });

    setState(() => _isLoading = true);
    final success = await ref
        .read(budgetControllerProvider.notifier)
        .setBudget(
          month: widget.month,
          year: widget.year,
          totalLimit: totalLimit,
          items: items,
        );
    setState(() => _isLoading = false);

    if (success && mounted) {
      Navigator.of(context).pop();
      context.showSnackBar(
        'Đã lưu ngân sách tháng ${widget.month}/${widget.year}: ${CurrencyFormatter.format(totalLimit)}',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final categoriesAsync = ref.watch(categoriesStreamProvider('expense'));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        AppTextField(
          controller: _totalLimitController,
          label: 'Tổng hạn mức chi tiêu tháng (₫)',
          hint: 'Ví dụ: 10.000.000',
          keyboardType: TextInputType.number,
          inputFormatters: [CurrencyInputFormatter()],
          autofocus: true,
          prefixIcon: const Icon(
            Icons.account_balance_wallet_outlined,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        Text(
          'Hạn mức chi tiết theo danh mục (tùy chọn)',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.lightTextSecondary,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),

        categoriesAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Text('Lỗi: $err'),
          data: (categories) {
            return Column(
              children: categories.map((cat) {
                _categoryControllers.putIfAbsent(
                  cat.id,
                  () => TextEditingController(),
                );
                final controller = _categoryControllers[cat.id]!;
                final iconData = IconHelper.getIcon(cat.icon);
                final color = IconHelper.getColor(cat.color);

                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.15),
                          borderRadius: AppRadius.borderSm,
                        ),
                        child: Icon(iconData, color: color, size: 18),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          cat.name,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 130,
                        height: 40,
                        child: TextField(
                          controller: controller,
                          keyboardType: TextInputType.number,
                          inputFormatters: [CurrencyInputFormatter()],
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Hạn mức (₫)',
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 8,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: AppRadius.borderSm,
                              borderSide: BorderSide(
                                color: isDark
                                    ? AppColors.darkBorder
                                    : AppColors.lightBorder,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            );
          },
        ),
        const SizedBox(height: AppSpacing.lg),

        AppButton(
          text: 'Lưu thiết lập ngân sách',
          onPressed: _onSave,
          isLoading: _isLoading,
        ),
      ],
    );
  }
}
