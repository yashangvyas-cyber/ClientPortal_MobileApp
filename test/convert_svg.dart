import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Convert SVG to PNG', (WidgetTester tester) async {
    final String svgPath = 'assets/launcher_icon.svg';
    final String svgString = File(svgPath).readAsStringSync();
    
    final PictureInfo pictureInfo = await vg.loadPicture(SvgStringLoader(svgString), null);
    
    final double size = 1024.0;
    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(recorder);
    
    // Scale and center to fit size
    final double svgViewSize = 63.0;
    final double scale = size / svgViewSize;
    
    // Fill the background with white (or a specific color)
    canvas.drawRect(Rect.fromLTWH(0, 0, size, size), Paint()..color = Colors.white);
    
    canvas.scale(scale);
    canvas.drawPicture(pictureInfo.picture);
    
    final ui.Picture picture = recorder.endRecording();
    final ui.Image img = await picture.toImage(size.toInt(), size.toInt());
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    
    File('assets/launcher_icon.png').writeAsBytesSync(byteData!.buffer.asUint8List());
    print('SVG converted to PNG successfully!');
    pictureInfo.picture.dispose();
  });
}
