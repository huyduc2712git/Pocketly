import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';

class CandleData {
  final String label;
  final double open;
  final double close;
  final double high;
  final double low;

  const CandleData({
    required this.label,
    required this.open,
    required this.close,
    required this.high,
    required this.low,
  });

  bool get isBullish => close >= open;
}

class FinancialCandleChart extends StatefulWidget {
  final List<CandleData> candlePoints;
  final String currency;

  const FinancialCandleChart({
    super.key,
    required this.candlePoints,
    this.currency = '₫',
  });

  @override
  State<FinancialCandleChart> createState() => _FinancialCandleChartState();
}

class _FinancialCandleChartState extends State<FinancialCandleChart> {
  int _selectedCandleIndex = 3; // Default highlighted candle (e.g., 'Tue')

  List<CandleData> get _effectivePoints {
    if (widget.candlePoints.isNotEmpty) {
      return widget.candlePoints;
    }
    // Default 7-day fintech financial data matching mockup
    return const [
      CandleData(label: 'Sat', open: 14, close: 22, high: 26, low: 10),
      CandleData(label: 'Sun', open: 18, close: 25, high: 28, low: 15),
      CandleData(label: 'Mon', open: 24, close: 16, high: 27, low: 12),
      CandleData(label: 'Tue', open: 20, close: 32, high: 36, low: 16),
      CandleData(label: 'Wed', open: 30, close: 22, high: 32, low: 18),
      CandleData(label: 'Thu', open: 26, close: 18, high: 28, low: 14),
      CandleData(label: 'Fri', open: 19, close: 15, high: 22, low: 11),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final points = _effectivePoints;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.3)
                : Colors.black.withValues(alpha: 0.03),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Filter Dropdown Pill
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkSurface
                      : const Color(0xFFF4F5F9),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark
                        ? AppColors.darkBorder
                        : const Color(0xFFE5E7EB),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Tuần này (Week)',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightTextPrimary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 16,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ],
                ),
              ),

              // Mini Legend: Green = Thu, Pink = Chi
              Row(
                children: [
                  _buildLegendItem('Thu', const Color(0xFF10B981)),
                  const SizedBox(width: 10),
                  _buildLegendItem('Chi', const Color(0xFFFE4696)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Interactive Chart Canvas
          SizedBox(
            height: 195,
            width: double.infinity,
            child: GestureDetector(
              onTapDown: (details) {
                final RenderBox box = context.findRenderObject() as RenderBox;
                final localX = details.localPosition.dx;
                final chartWidth = box.size.width - 32;
                final candleSlot = chartWidth / points.length;
                final tappedIdx = (localX / candleSlot).floor().clamp(
                      0,
                      points.length - 1,
                    );
                setState(() => _selectedCandleIndex = tappedIdx);
              },
              child: CustomPaint(
                size: Size.infinite,
                painter: _CandleChartPainter(
                  points: points,
                  selectedIndex: _selectedCandleIndex,
                  isDark: isDark,
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Bottom Day Labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(points.length, (i) {
              final isSelected = i == _selectedCandleIndex;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedCandleIndex = i),
                  child: Center(
                    child: Text(
                      points[i].label,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight:
                            isSelected ? FontWeight.w800 : FontWeight.w500,
                        color: isSelected
                            ? AppColors.primary
                            : (isDark
                                ? AppColors.darkTextMuted
                                : AppColors.lightTextMuted),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppColors.darkTextSecondary,
          ),
        ),
      ],
    );
  }
}

class _CandleChartPainter extends CustomPainter {
  final List<CandleData> points;
  final int selectedIndex;
  final bool isDark;

  _CandleChartPainter({
    required this.points,
    required this.selectedIndex,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    final double w = size.width;
    final double h = size.height;
    const double rightPadding = 42.0;
    final double plotWidth = w - rightPadding;

    // Y-Axis Min & Max
    double maxVal = 38.0;
    double minVal = 8.0;
    for (final p in points) {
      maxVal = math.max(maxVal, p.high);
      minVal = math.min(minVal, p.low);
    }
    final range = maxVal - minVal;

    // Draw horizontal dashed grid lines & Y labels
    final gridLevels = [32, 26, 20, 14];
    final gridPaint = Paint()
      ..color = (isDark ? Colors.white : Colors.black).withValues(alpha: 0.05)
      ..strokeWidth = 1;

    final textStyle = TextStyle(
      fontSize: 9,
      fontWeight: FontWeight.w500,
      color: isDark ? AppColors.darkTextMuted : const Color(0xFF94A3B8),
    );

    for (final level in gridLevels) {
      final y = h - ((level - minVal) / range) * (h - 20) - 10;
      canvas.drawLine(Offset(0, y), Offset(plotWidth, y), gridPaint);

      final textSpan = TextSpan(text: '\$${level}k', style: textStyle);
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      )..layout();
      textPainter.paint(canvas, Offset(plotWidth + 8, y - 5));
    }

    final candleSlot = plotWidth / points.length;
    final candleWidth = candleSlot * 0.46;

    // Draw Candlesticks
    for (int i = 0; i < points.length; i++) {
      final p = points[i];
      final centerX = i * candleSlot + candleSlot / 2;

      final isBullish = p.isBullish;
      final color = isBullish ? const Color(0xFF10B981) : const Color(0xFFFE4696);

      final yHigh = h - ((p.high - minVal) / range) * (h - 20) - 10;
      final yLow = h - ((p.low - minVal) / range) * (h - 20) - 10;
      final yOpen = h - ((p.open - minVal) / range) * (h - 20) - 10;
      final yClose = h - ((p.close - minVal) / range) * (h - 20) - 10;

      final yTop = math.min(yOpen, yClose);
      final yBottom = math.max(yOpen, yClose);
      final bodyHeight = math.max(4.0, yBottom - yTop);

      // Wick Line
      final wickPaint = Paint()
        ..color = color
        ..strokeWidth = 1.8
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(Offset(centerX, yHigh), Offset(centerX, yLow), wickPaint);

      // Candle Body Box
      final bodyPaint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;

      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(
          centerX - candleWidth / 2,
          yTop,
          candleWidth,
          bodyHeight,
        ),
        const Radius.circular(4),
      );
      canvas.drawRRect(rect, bodyPaint);

      // Selected Candle Glow Shadow
      if (i == selectedIndex) {
        final glowPaint = Paint()
          ..color = color.withValues(alpha: 0.25)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4;
        canvas.drawRRect(rect, glowPaint);
      }
    }

    // Draw Floating Tooltip on Selected Index
    if (selectedIndex >= 0 && selectedIndex < points.length) {
      final p = points[selectedIndex];
      final centerX = selectedIndex * candleSlot + candleSlot / 2;
      final yHigh = h - ((p.high - minVal) / range) * (h - 20) - 10;

      _drawFloatingTooltip(canvas, centerX, yHigh - 8, p);
    }
  }

  void _drawFloatingTooltip(
    Canvas canvas,
    double x,
    double y,
    CandleData p,
  ) {
    const double tipW = 86;
    const double tipH = 34;
    final double left = (x - tipW / 2).clamp(4.0, 220.0);
    final double top = math.max(4.0, y - tipH - 4);

    final bgPaint = Paint()
      ..color = isDark ? const Color(0xFF221626) : Colors.white
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = (isDark ? Colors.white : Colors.black).withValues(alpha: 0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.08)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(left, top, tipW, tipH),
      const Radius.circular(8),
    );

    canvas.drawRRect(rrect.shift(const Offset(0, 2)), shadowPaint);
    canvas.drawRRect(rrect, bgPaint);
    canvas.drawRRect(rrect, borderPaint);

    // Tooltip High Text
    final highSpan = TextSpan(
      children: [
        const TextSpan(
          text: '● ',
          style: TextStyle(color: Color(0xFF10B981), fontSize: 9),
        ),
        TextSpan(
          text: 'High: \$${p.high.toStringAsFixed(0)}k',
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF1E293B),
            fontSize: 9,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );

    // Tooltip Low Text
    final lowSpan = TextSpan(
      children: [
        const TextSpan(
          text: '● ',
          style: TextStyle(color: Color(0xFFFE4696), fontSize: 9),
        ),
        TextSpan(
          text: 'Low: \$${p.low.toStringAsFixed(0)}k',
          style: TextStyle(
            color: isDark ? AppColors.darkTextSecondary : const Color(0xFF64748B),
            fontSize: 9,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );

    final highPainter = TextPainter(
      text: highSpan,
      textDirection: TextDirection.ltr,
    )..layout();
    highPainter.paint(canvas, Offset(left + 6, top + 4));

    final lowPainter = TextPainter(
      text: lowSpan,
      textDirection: TextDirection.ltr,
    )..layout();
    lowPainter.paint(canvas, Offset(left + 6, top + 17));
  }

  @override
  bool shouldRepaint(covariant _CandleChartPainter oldDelegate) =>
      oldDelegate.selectedIndex != selectedIndex ||
      oldDelegate.isDark != isDark ||
      oldDelegate.points != points;
}
