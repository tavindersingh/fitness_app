// Renders the FitTrack logo to the PNGs used for the launcher icon and the
// native splash screen. Run it after changing the logo, then regenerate:
//
//   flutter test tool/generate_brand_assets_test.dart
//   dart run flutter_launcher_icons
//   dart run flutter_native_splash:create
import 'dart:io';
import 'dart:ui' as ui;

import 'package:fitness_app/branding/fittrack_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const _outputDir = 'assets/branding';

Future<void> _render(
  String name,
  double canvasSize,
  FitTrackLogoPainter painter, {
  double? logoSize,
}) async {
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  final size = logoSize ?? canvasSize;
  final offset = (canvasSize - size) / 2;

  canvas.translate(offset, offset);
  painter.paint(canvas, Size.square(size));

  final image = await recorder.endRecording().toImage(
    canvasSize.toInt(),
    canvasSize.toInt(),
  );
  final png = await image.toByteData(format: ui.ImageByteFormat.png);
  File('$_outputDir/$name').writeAsBytesSync(png!.buffer.asUint8List());
}

void main() {
  testWidgets('generate brand assets', (tester) async {
    await tester.runAsync(() async {
      Directory(_outputDir).createSync(recursive: true);

      // Legacy launcher icon: the rounded tile.
      await _render('app_icon.png', 1024, const FitTrackLogoPainter());

      // Adaptive icon (Android 8+): Android masks and scales these itself.
      // The visible area is about two thirds of the canvas, so the dumbbell
      // is scaled to match how it sits on the tile.
      await _render(
        'icon_background.png',
        1024,
        const FitTrackLogoPainter(
          drawTile: false,
          fullBleedBackground: true,
          drawGlyph: false,
        ),
      );
      await _render(
        'icon_foreground.png',
        1024,
        const FitTrackLogoPainter(drawTile: false, glyphScale: 0.66),
      );

      // Native splash: shown at 4x density, so 480px = 120dp, the same size
      // as the logo on the in-app splash screen.
      await _render('splash_logo.png', 480, const FitTrackLogoPainter());

      // Android 12+ splash: the icon area is 288dp (1152px) and is masked to
      // a circle, so the 120dp tile sits in the middle.
      await _render(
        'splash_logo_android12.png',
        1152,
        const FitTrackLogoPainter(),
        logoSize: 480,
      );
    });
  });
}
