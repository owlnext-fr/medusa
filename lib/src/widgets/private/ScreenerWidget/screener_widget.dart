import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:medusa/medusa.dart';

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
  final GlobalKey _repaintKey = GlobalKey();
  bool _isCapturing = false;

  @override
  Widget build(BuildContext context) {
    // Wrap the child with RepaintBoundary 
    // only when capturing to minimize performance impact
    return _isCapturing
        ? RepaintBoundary(
            key: _repaintKey,
            child: widget.child,
          )
        : widget.child;
  }

  /// Capture widget image as Uint8List (PNG format) and return it. 
  /// Returns null if capture fails or if the widget is not mounted.
  Future<Uint8List?> captureCurrentView() async {
    if (!mounted) return null;

    try {
      
      if(mounted) {
        setState(() => _isCapturing = true);
      }

      // Wait to ensure the RepaintBoundary is rendered
      await Future.delayed(const Duration(milliseconds: 50));

      // Verify again that the widget is still mounted before accessing context
      if (!mounted) return null;
      final context = this.context;
      if(!context.mounted) return null;
      final boundaryContext = _repaintKey.currentContext;
      if (boundaryContext == null) {
        _print("RepaintBoundary not found in the widget tree");
        return null;
      }

      final renderObject = boundaryContext.findRenderObject();
      if (renderObject is! RenderRepaintBoundary) {
        _print("The RenderObject is not a RenderRepaintBoundary");
        return null;
      }

      // Capture the image
      final image = await renderObject.toImage(pixelRatio: MediaQuery.of(context).devicePixelRatio);
      final byteData = await image.toByteData(format: ImageByteFormat.png);

      // Disable capture mode (if still mounted)
      if (mounted) {
        setState(() => _isCapturing = false);
      }

      return byteData?.buffer.asUint8List();
    } catch (e) {
      // Disable capture mode (if still mounted)
      if (mounted) {
        setState(() => _isCapturing = false);
      }
      _print("Error during captureCurrentView(): $e");
      return null;
    }
  }

  void _print(String message) {
    if(kDebugMode && MedusaDebugger.kDebugMedusa) {
      // ignore: avoid_print
      print("[ScreenerController] $message");
    }
  }
}
