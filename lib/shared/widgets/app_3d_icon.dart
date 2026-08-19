import 'package:flutter/material.dart';

class App3DIcon extends StatelessWidget {
  final String assetPath;
  final double size;
  final BoxFit fit;

  const App3DIcon({
    super.key,
    required this.assetPath,
    this.size = 28.0,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      assetPath,
      width: size,
      height: size,
      fit: fit,
      errorBuilder: (context, error, stackTrace) =>
          Icon(Icons.category_rounded, size: size),
    );
  }
}
