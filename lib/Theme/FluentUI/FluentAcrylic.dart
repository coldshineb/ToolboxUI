import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class FluentAcrylic extends StatelessWidget {
  final Widget? child;
  final double blurSigma;
  final Color tintColor;
  final double noiseOpacity;

  const FluentAcrylic({
    super.key,
    this.child,
    this.blurSigma = 30.0,
    this.tintColor = const Color(0xCC2C2C2C),
    this.noiseOpacity = 0.03,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      // 3. 最后再剪裁，这时候拿到的是已经完整模糊过的图层
      child: Stack(
        fit: StackFit.expand,
        children: [
          // 1. 模糊层：向四周延伸，确保边缘采样点都在模糊范围内
          Positioned(
            top: -100,
            bottom: -100,
            left: -100,
            right: -100,
            child: ImageFiltered(
                imageFilter:
                    ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
                child: child),
          ),

          // 着色层 (Tint) - 必须严格对齐，不能溢出
          Container(
            color: tintColor,
          ),

          // 噪点层
          Opacity(
            opacity: noiseOpacity,
            child: const IgnorePointer(
              child: CustomPaint(
                painter: _NoisePainter(),
              ),
            ),
          ),

          // Fluent 亮线细节
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: 0.5,
              color: Colors.white.withValues(alpha: 0.12),
            ),
          ),
        ],
      ),
    );
  }
}

class _NoisePainter extends CustomPainter {
  const _NoisePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final random = Random();
    for (double x = 0; x < size.width; x += 4) {
      for (double y = 0; y < size.height; y += 4) {
        if (random.nextDouble() > 0.85) {
          paint.color =
              Colors.white.withValues(alpha: random.nextDouble() * 0.15);
          canvas.drawRect(Rect.fromLTWH(x, y, 2, 2), paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
