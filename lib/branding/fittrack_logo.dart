import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Brand colours for FitTrack.
class FitTrackColors {
  static const background = Color(0xFF0B0D0F);
  static const tileTop = Color(0xFF7286FF);
  static const tileBottom = Color(0xFF3D4FE0);
}

/// The FitTrack logo: a white dumbbell, tilted upwards like a rising trend,
/// on a rounded indigo tile.
///
/// The same painter generates the launcher icon and splash images (see
/// `tool/generate_brand_assets_test.dart`), so the app and its icon match.
class FitTrackLogo extends StatelessWidget {
  final double size;

  const FitTrackLogo({super.key, this.size = 120});

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: const CustomPaint(painter: FitTrackLogoPainter()),
    );
  }
}

class FitTrackLogoPainter extends CustomPainter {
  /// Draw the rounded indigo tile behind the dumbbell.
  final bool drawTile;

  /// Draw the indigo gradient as a full square, with no rounded corners
  /// (for the adaptive icon background, which Android masks itself).
  final bool fullBleedBackground;

  /// Draw the dumbbell.
  final bool drawGlyph;

  /// How large the dumbbell is compared with the canvas.
  final double glyphScale;

  const FitTrackLogoPainter({
    this.drawTile = true,
    this.fullBleedBackground = false,
    this.drawGlyph = true,
    this.glyphScale = 1,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.shortestSide;
    final rect = Offset.zero & size;

    if (drawTile || fullBleedBackground) {
      final paint = Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [FitTrackColors.tileTop, FitTrackColors.tileBottom],
        ).createShader(rect);
      if (fullBleedBackground) {
        canvas.drawRect(rect, paint);
      } else {
        final tile = RRect.fromRectAndRadius(rect, Radius.circular(s * 0.27));
        canvas.drawRRect(tile, paint);
        // Soft highlight in the top-left corner for a little depth, kept
        // inside the tile's rounded corners.
        canvas.save();
        canvas.clipRRect(tile);
        canvas.drawCircle(
          Offset(s * 0.18, s * 0.12),
          s * 0.55,
          Paint()
            ..shader =
                RadialGradient(
                  colors: [
                    Colors.white.withAlpha(46),
                    Colors.white.withAlpha(0),
                  ],
                ).createShader(
                  Rect.fromCircle(
                    center: Offset(s * 0.18, s * 0.12),
                    radius: s * 0.55,
                  ),
                ),
        );
        canvas.restore();
      }
    }

    if (drawGlyph) {
      _paintDumbbell(canvas, size.center(Offset.zero), s * glyphScale);
    }
  }

  void _paintDumbbell(Canvas canvas, Offset center, double s) {
    final white = Paint()..color = Colors.white;

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(-math.pi / 6);

    RRect pill(double cx, double width, double height) =>
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset(cx, 0), width: width, height: height),
          Radius.circular(width * 0.5),
        );

    // Bar.
    canvas.drawRRect(pill(0, s * 0.52, s * 0.075), white);
    for (final side in [-1.0, 1.0]) {
      // Inner (big) plate.
      canvas.drawRRect(pill(side * s * 0.16, s * 0.10, s * 0.40), white);
      // Outer (small) plate.
      canvas.drawRRect(pill(side * s * 0.27, s * 0.075, s * 0.27), white);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(FitTrackLogoPainter oldDelegate) =>
      oldDelegate.drawTile != drawTile ||
      oldDelegate.fullBleedBackground != fullBleedBackground ||
      oldDelegate.drawGlyph != drawGlyph ||
      oldDelegate.glyphScale != glyphScale;
}
