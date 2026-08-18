import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/icon_helper.dart';
import '../../domain/entities/analytics_entity.dart';

class SpendingDonutChart extends StatelessWidget {
  final List<CategorySpending> categories;
  final double totalExpense;
  final String currency;

  const SpendingDonutChart({
    super.key,
    required this.categories,
    required this.totalExpense,
    this.currency = 'VND',
  });

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty || totalExpense <= 0) {
      return const SizedBox(
        height: 180,
        child: Center(
          child: Text(
            'Chưa có dữ liệu chi tiêu trong kỳ này',
            style: TextStyle(color: AppColors.darkTextSecondary, fontSize: 13),
          ),
        ),
      );
    }

    return Column(
      children: [
        SizedBox(
          height: 180,
          width: 180,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: const Size(180, 180),
                painter: _DonutChartPainter(
                  categories: categories,
                  total: totalExpense,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Tổng chi tiêu',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: AppColors.darkTextSecondary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    CurrencyFormatter.formatCompact(
                      totalExpense,
                      currency: currency,
                    ),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.darkTextPrimary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DonutChartPainter extends CustomPainter {
  final List<CategorySpending> categories;
  final double total;

  _DonutChartPainter({required this.categories, required this.total});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;
    const strokeWidth = 18.0;

    final rect = Rect.fromCircle(center: center, radius: radius);

    double startAngle = -math.pi / 2;

    for (final item in categories) {
      final sweepAngle = (item.amount / total) * 2 * math.pi;
      final paint = Paint()
        ..color = IconHelper.getColor(item.categoryColor)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      // Draw segment with small gap
      canvas.drawArc(rect, startAngle + 0.04, sweepAngle - 0.08, false, paint);
      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutChartPainter oldDelegate) {
    return oldDelegate.total != total || oldDelegate.categories != categories;
  }
}
