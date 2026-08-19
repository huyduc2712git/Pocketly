import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../domain/entities/wallet_entity.dart';

class FintechCardWidget extends StatelessWidget {
  final WalletEntity wallet;
  final String userName;
  final int cardIndex;
  final VoidCallback? onDelete;

  const FintechCardWidget({
    super.key,
    required this.wallet,
    this.userName = 'Người dùng Finly',
    this.cardIndex = 0,
    this.onDelete,
  });

  // Generate 4-digit blocks for virtual card number
  String get _cardNumber {
    final hex = wallet.id.replaceAll(RegExp(r'[^0-9a-fA-F]'), '');
    final numStr = hex.isEmpty
        ? '0156021484540124'
        : ('${hex}0156021484540124').substring(0, 16);
    return '${numStr.substring(0, 4)} ${numStr.substring(4, 8)} ${numStr.substring(8, 12)} ${numStr.substring(12, 16)}';
  }

  // Generate distinct pastel gradient schemes per card
  List<Color> get _gradientColors {
    final palettes = [
      // 1. Soft Rose-Lavender Pastel (Mockup reference)
      [
        const Color(0xFFFFF0F5),
        const Color(0xFFFCE4EC),
        const Color(0xFFF3E8FF),
      ],
      // 2. Mint & Sky Pastel
      [
        const Color(0xFFE8F8F0),
        const Color(0xFFE0F2FE),
        const Color(0xFFF0FDF4),
      ],
      // 3. Warm Peach & Amber Pastel
      [
        const Color(0xFFFFF8E1),
        const Color(0xFFFFEDD5),
        const Color(0xFFFEE2E2),
      ],
      // 4. Cool Lavender & Indigo Pastel
      [
        const Color(0xFFF5F3FF),
        const Color(0xFFEDE9FE),
        const Color(0xFFE0E7FF),
      ],
    ];
    return palettes[cardIndex % palettes.length];
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      height: 215,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [
                  const Color(0xFF241424),
                  const Color(0xFF1F1B2C),
                  const Color(0xFF16161E),
                ]
              : _gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.12)
              : Colors.white.withValues(alpha: 0.85),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.4)
                : const Color(0xFFFE4696).withValues(alpha: 0.12),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // Background Curved Wave Watermark Lines
            Positioned.fill(
              child: CustomPaint(
                painter: _CardWaveWatermarkPainter(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.04)
                      : const Color(0xFFFE4696).withValues(alpha: 0.06),
                ),
              ),
            ),

            // Card Inner Contents
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Top Row: Mastercard / Logo + Wallet Name + 3-dots Menu
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Mastercard Overlapping Circles Logo
                      _buildMastercardLogo(),

                      // Wallet / Card Name & Type
                      Row(
                        children: [
                          Text(
                            wallet.name,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: isDark
                                  ? AppColors.darkTextPrimary
                                  : AppColors.lightTextPrimary,
                              letterSpacing: -0.2,
                            ),
                          ),
                          const SizedBox(width: 4),
                          PopupMenuButton<String>(
                            icon: Icon(
                              Icons.more_horiz_rounded,
                              size: 20,
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary,
                            ),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onSelected: (val) {
                              if (val == 'delete' && onDelete != null) {
                                onDelete!();
                              }
                            },
                            itemBuilder: (ctx) => [
                              const PopupMenuItem(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.delete_outline_rounded,
                                      color: AppColors.error,
                                      size: 18,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Xóa ví này',
                                      style: TextStyle(color: AppColors.error),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),

                  // Middle Row: Formatted Masked Card Number
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _cardNumber,
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 2.2,
                          fontFamily: 'monospace',
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.lightTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        userName,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),

                  // Bottom Row: Balance / Expiry date & Golden EMV Chip
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Số dư khả dụng',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: isDark
                                  ? AppColors.darkTextMuted
                                  : AppColors.lightTextMuted,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            CurrencyFormatter.format(
                              wallet.balance,
                              currency: wallet.currency,
                            ),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: isDark
                                  ? AppColors.darkTextPrimary
                                  : AppColors.lightTextPrimary,
                              letterSpacing: -0.3,
                            ),
                          ),
                        ],
                      ),

                      // Golden EMV Smart Chip Graphic
                      _buildEmvChip(isDark),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMastercardLogo() {
    return SizedBox(
      width: 38,
      height: 24,
      child: Stack(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              color: Color(0xFFEB001B),
              shape: BoxShape.circle,
            ),
          ),
          Positioned(
            left: 14,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: const Color(0xFFF79E1B).withValues(alpha: 0.9),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmvChip(bool isDark) {
    return Container(
      width: 38,
      height: 28,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFFFDF7A),
            Color(0xFFD4AF37),
            Color(0xFFAA8010),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: const Color(0xFFFFF3A8),
          width: 0.8,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFD4AF37).withValues(alpha: 0.35),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          Center(
            child: Container(
              width: 20,
              height: 14,
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color(0xFF8A6700).withValues(alpha: 0.5),
                  width: 0.8,
                ),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Center(
            child: Container(
              width: 1,
              height: 28,
              color: const Color(0xFF8A6700).withValues(alpha: 0.4),
            ),
          ),
          Center(
            child: Container(
              width: 38,
              height: 1,
              color: const Color(0xFF8A6700).withValues(alpha: 0.4),
            ),
          ),
        ],
      ),
    );
  }
}

class _CardWaveWatermarkPainter extends CustomPainter {
  final Color color;

  _CardWaveWatermarkPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.6
      ..style = PaintingStyle.stroke;

    final w = size.width;
    final h = size.height;

    // Draw flowing abstract bank card decorative lines
    for (int i = 0; i < 4; i++) {
      final path = Path();
      final offset = i * 22.0;
      path.moveTo(w * 0.4 + offset, 0);
      path.cubicTo(
        w * 0.6 + offset,
        h * 0.3,
        w * 0.7 + offset,
        h * 0.7,
        w + offset,
        h * 0.9,
      );
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _CardWaveWatermarkPainter oldDelegate) =>
      oldDelegate.color != color;
}
