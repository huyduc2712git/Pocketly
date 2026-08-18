import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/utils/icon_helper.dart';
import '../../../../shared/widgets/app_bottom_sheet.dart';
import '../../../../shared/widgets/app_loading.dart';
import '../../domain/entities/category_entity.dart';
import '../controllers/categories_controller.dart';

class CategoryPickerSheet extends ConsumerStatefulWidget {
  final String? selectedCategoryId;
  final String type; // 'expense' or 'income'
  final ValueChanged<CategoryEntity> onCategorySelected;

  const CategoryPickerSheet({
    super.key,
    this.selectedCategoryId,
    required this.type,
    required this.onCategorySelected,
  });

  static Future<CategoryEntity?> show(
    BuildContext context, {
    String? selectedCategoryId,
    String type = 'expense',
  }) {
    CategoryEntity? selected;
    return AppBottomSheet.show<CategoryEntity>(
      context: context,
      title: type == 'income' ? 'Chọn Danh Mục Thu' : 'Chọn Danh Mục Chi',
      child: CategoryPickerSheet(
        selectedCategoryId: selectedCategoryId,
        type: type,
        onCategorySelected: (cat) {
          selected = cat;
          Navigator.of(context).pop(selected);
        },
      ),
    );
  }

  @override
  ConsumerState<CategoryPickerSheet> createState() => _CategoryPickerSheetState();
}

class _CategoryPickerSheetState extends ConsumerState<CategoryPickerSheet> {
  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoriesStreamProvider(widget.type));
    final isDark = context.isDarkMode;

    return categoriesAsync.when(
      loading: () => const SizedBox(
        height: 200,
        child: AppLoading(message: 'Đang tải danh mục...'),
      ),
      error: (err, _) => Center(child: Text('Lỗi: $err')),
      data: (categories) {
        if (categories.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(AppSpacing.xl),
            child: Center(child: Text('Chưa có danh mục nào.')),
          );
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.85,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            final isSelected = widget.selectedCategoryId == category.id;
            final iconData = IconHelper.getIcon(category.icon);
            final color = IconHelper.getColor(category.color);

            return InkWell(
              onTap: () => widget.onCategorySelected(category),
              borderRadius: AppRadius.borderMd,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: isSelected
                      ? color.withValues(alpha: 0.2)
                      : (isDark ? AppColors.darkCard : AppColors.lightCard),
                  borderRadius: AppRadius.borderMd,
                  border: Border.all(
                    color: isSelected ? color : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(iconData, color: color, size: 20),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      category.name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
