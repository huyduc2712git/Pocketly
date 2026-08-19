import 'package:flutter/material.dart';
import 'package:finly/app/theme/app_colors.dart';
import 'package:finly/app/theme/app_spacing.dart';
import 'package:finly/core/extensions/context_extensions.dart';
import 'package:finly/shared/widgets/amount_text.dart';
import 'package:finly/shared/widgets/app_3d_icon.dart';

enum SparklineType { income, expense, savings }

class MetricSparklineCard extends StatelessWidget {
  final String title;
  final double amount;
  final String currency;
  final SparklineType type;
  final String? iconAsset;
  final IconData? iconData;
  final VoidCallback? onTap;

  const MetricSparklineCard({
    super.key,
    required this.title,
    required this.amount,
    required this.currency,
    required this.type,
    this.iconAsset,
    this.iconData,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;

    final (Color primaryColor, Color bgColor, String prefix) = switch (type) {
      SparklineType.income => (
        AppColors.income,
        isDark ? const Color(0xFF0D2818) : AppColors.pastelMint,
        '+',
      ),
      SparklineType.expense => (
        AppColors.expense,
        isDark ? const Color(0xFF2E0F1A) : AppColors.pastelPink,
        '-',
      ),
      SparklineType.savings => (
        AppColors.savings,
        isDark ? const Color(0xFF1E132D) : AppColors.pastelPurple,
        '',
      ),
    };

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.3)
                : Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md - 2,
              vertical: AppSpacing.md - 2,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top Icon Badge
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: iconAsset != null
                        ? App3DIcon(assetPath: iconAsset!, size: 22)
                        : Icon(
                            iconData ?? Icons.account_balance_wallet_rounded,
                            color: primaryColor,
                            size: 18,
                          ),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),

                // Title
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: 3),

                // Amount
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (prefix.isNotEmpty)
                      Text(
                        prefix,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: primaryColor,
                        ),
                      ),
                    Flexible(
                      child: AmountText(
                        amount: amount,
                        currency: currency,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Mini Wave Sparkline Curve
                SizedBox(
                  height: 22,
                  width: double.infinity,
                  child: CustomPaint(
                    painter: _SparklineWavePainter(
                      color: primaryColor,
                      type: type,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SparklineWavePainter extends CustomPainter {
  final Color color;
  final SparklineType type;

  _SparklineWavePainter({required this.color, required this.type});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    final w = size.width;
    final h = size.height;

    switch (type) {
      case SparklineType.income:
        // Rising wave
        path.moveTo(0, h * 0.8);
        path.cubicTo(w * 0.25, h * 0.9, w * 0.45, h * 0.5, w * 0.65, h * 0.55);
        path.cubicTo(w * 0.8, h * 0.6, w * 0.9, h * 0.15, w, h * 0.1);
        break;
      case SparklineType.expense:
        // Fluctuating wave
        path.moveTo(0, h * 0.3);
        path.cubicTo(w * 0.2, h * 0.2, w * 0.35, h * 0.7, w * 0.55, h * 0.65);
        path.cubicTo(w * 0.7, h * 0.6, w * 0.85, h * 0.85, w, h * 0.6);
        break;
      case SparklineType.savings:
        // Gentle steady wave
        path.moveTo(0, h * 0.7);
        path.cubicTo(w * 0.3, h * 0.85, w * 0.5, h * 0.35, w * 0.75, h * 0.4);
        path.cubicTo(w * 0.85, h * 0.45, w * 0.95, h * 0.2, w, h * 0.25);
        break;
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _SparklineWavePainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.type != type;
}
