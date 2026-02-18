
import 'package:flutter/material.dart';
import 'package:medusa/src/notifiers/screener_notifier.dart';
import 'package:medusa/src/widgets/exported/MedusaPanel/config/style_configs.dart';
part 'view.dart';

class MedusaCaptureButton extends StatefulWidget {

  /// The configuration for the MedusaCaptureButton widget.
  final CaptureButtonConfig? config;

  const MedusaCaptureButton({
    super.key,
    this.config,
  });

  @override
  State<MedusaCaptureButton> createState() {
    return _MedusaCaptureButtonState();
  }
}

class _MedusaCaptureButtonState extends State<MedusaCaptureButton> with _DesktopViewMixin {


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return _render(context, this);
  }
}
