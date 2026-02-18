
import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:medusa/medusa.dart';
import 'package:medusa/src/widgets/private/ScreenerWidget/screener_widget.dart';
part 'view.dart';

class MedusaScreenerPanel extends StatefulWidget {

  /// The configuration for the MedusaScreenerPanel widget.
  final PanelConfig? panelConfig;

  final Widget child;

  const MedusaScreenerPanel({
    super.key,
    this.panelConfig,
    required this.child,
  });

  @override
  State<MedusaScreenerPanel> createState() {
    return _MedusaScreenerPanelState();
  }
}

class _MedusaScreenerPanelState extends State<MedusaScreenerPanel> with _DesktopViewMixin {

  StreamSubscription<Uint8List?>? _captureSubscription;

  bool _isPanelOpen = false;

  final GlobalKey<ScreenerWidgetState> _screenerKey = GlobalKey();
  bool _isCapturing = false;
  Uint8List? _capturedImage;

  bool _isPublishing = false;

  @override
  void initState() {
    super.initState();
    _onInit();
  }

  @override
  void dispose() {
    super.dispose();
    _onDispose();
  }

  /// to call when the widget is initialized.
  void _onInit() {
     _captureSubscription = ScreenerController.instance.captureResults.listen(
      (bytes) async {
        debugPrint("[MedusaScreenerPanel] 🔍 Capture event received: ${bytes == null ? 'REQUEST' : 'RESULT'}");

        if (bytes == null) {
          // Capture requested
          final capturedBytes = await _captureCurrentView();
          ScreenerController.instance.setCaptureResult(capturedBytes);
        } else {
          // Capture result received
          setState(() {
            _capturedImage = bytes;
            _isPanelOpen = true;
            _isCapturing = false;
          });
        }
      },
      onError: (e) => debugPrint("[MedusaScreenerPanel] ❌ Capture error: $e"),
    );
  }

  /// to call when the widget is disposed.
  void _onDispose() {
    _capturedImage?.clear();
    _captureSubscription?.cancel();
  }

  Future<Uint8List?> _captureCurrentView() async {
    try {
      final ScreenerWidgetState screenerState = _screenerKey.currentState!;
      return await screenerState.captureCurrentView();
    } catch (e) {
      debugPrint("Erreur lors de la capture: $e");
      return null;
    }
  }

  /// Publishes the captured image and fields to the backend
  Future<void> _publish() async {
    setState(() {
      _isPublishing = true;
    });

    // TODO: Implement publish functionality

    if(!mounted) return;
    setState(() {
      _isPublishing = false;
    });
  }

  /// Ferme le panneau.
  void _closePanel() {
    setState(() {
      _isPanelOpen = false;
      _capturedImage = null;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return _renderDesktop(context, this);
  }
}
