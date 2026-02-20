
import 'package:flutter/material.dart';
import 'package:medusa/src/notifiers/screener_notifier.dart';
import 'package:medusa/src/widgets/exported/MedusaCaptureButton/styling/capture_button_style.dart';
part 'view.dart';

class MedusaCaptureButtonWidget extends StatefulWidget {

  /// The configuration for the MedusaCaptureButtonWidget widget.
  final CaptureButtonStyle? config;

  const MedusaCaptureButtonWidget({
    super.key,
    this.config,
  });

  @override
  State<MedusaCaptureButtonWidget> createState() {
    return _MedusaCaptureButtonWidgetState();
  }
}

class _MedusaCaptureButtonWidgetState extends State<MedusaCaptureButtonWidget> with _DesktopViewMixin {


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onPressed() {
    try {
      ScreenerController.instance.triggerCapture();
    } catch (e) {
      debugPrint("Error during capture: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return _render(context, this);
  }
}
