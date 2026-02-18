import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

typedef CaptureCallback = Future<Uint8List?> Function();

class ScreenerWidget extends StatefulWidget {
  final Widget child;

  const ScreenerWidget({
    super.key,
    required this.child,
  });

  @override
  ScreenerWidgetState createState() => ScreenerWidgetState();
}

class ScreenerWidgetState extends State<ScreenerWidget> {
  final GlobalKey _repaintKey = GlobalKey(); // Clé pour RepaintBoundary

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: _repaintKey,
      child: widget.child,
    );
  }

  /// Capture le widget TEL QU'IL EST AFFICHÉ À L'INSTANT T
  Future<Uint8List?> captureCurrentView() async {
    try {
      final boundary = _repaintKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: MediaQuery.of(context).devicePixelRatio);
      final byteData = await image.toByteData(format: ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (e) {
      debugPrint("Erreur lors de la capture: $e");
      return null;
    }
  }
}