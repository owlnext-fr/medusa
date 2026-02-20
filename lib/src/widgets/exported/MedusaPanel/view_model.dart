
import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:medusa/medusa.dart';
import 'package:medusa/src/widgets/private/ScreenerWidget/screener_widget.dart';
import 'package:medusa/src/widgets/private/SelectInput/view_model.dart';
import 'package:medusa/src/widgets/private/TextfieldInput/view_model.dart';
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

  final double _gap = 8.0;

  /// --- Screen capture ----
  StreamSubscription<Uint8List?>? _captureSubscription;
  final GlobalKey<ScreenerWidgetState> _screenerKey = GlobalKey();
  Uint8List? _capturedImage;

  /// ---- State -----
  bool _isPanelOpen = false;
  bool _isCapturing = false;
  bool _isPublishing = false;
  String? _error;

  /// ---- Form Fields -----
  final _formKey = GlobalKey<FormState>(); // form key for validation
  String _path = '';
  String _summary = '';
  String _description = '';
  String _steps = '';
  String _expectedBehavior = '';
  String? _severity;

  final List<SelectItem> _severityItems = [
    //SelectItem(value: null, label: '-'),
    SelectItem(value: 'minor', label: 'Mineur'),
    SelectItem(value: 'medium', label: 'Médian'),
    SelectItem(value: 'major', label: 'Majeur'),
    SelectItem(value: 'blocking', label: 'Bloquant'),
  ];

  @override
  void initState() {
    super.initState();
    _initCaptureSubscription();
  }

  @override
  void dispose() {
    super.dispose();
    _onDispose();
  }

  /// to call when the widget is disposed.
  void _onDispose() {
    _capturedImage?.clear();
    _captureSubscription?.cancel();
  }

  /// to call when the widget is initialized.
  void _initCaptureSubscription() {
     _captureSubscription = ScreenerController.instance.captureResults.listen(
      (bytes) async {
        _print("🔍 Capture event received: ${bytes == null ? 'REQUEST' : 'RESULT'}");

        if(mounted) {
          setState(() {
            _isCapturing = true;
            _isPanelOpen = false;
          });
        }
        // Capture requested
        final Uint8List? capturedBytes = await _captureRequest();
        
        if(mounted) {
          // Capture result received
          setState(() {
            _path = ModalRoute.of(context)?.settings.name ?? '';
            _capturedImage = capturedBytes;
            _isPanelOpen = true;
            _isCapturing = false;
          });
        }
      },
      onError: (e) {
        _print("❌ Capture error: $e");
        if (mounted) {
          setState(() {
            _capturedImage = null;
            _isCapturing = false;
            _isPanelOpen = true;
            _error = "Erreur lors de la capture d'écran";
          });
        }
      },
    );
  }

  Future<Uint8List?> _captureRequest() async {
    try {
      final ScreenerWidgetState screenerState = _screenerKey.currentState!;
      return await screenerState.captureCurrentView();
    } catch (e) {
      _print("Error during _captureRequest(): $e");
      return null;
    }
  }

  void _removeCapturedImage() {
    if(mounted) {
      setState(() {
        _capturedImage = null;
      });
    }
  }

  /// Publishes the captured image and fields to the backend
  Future<void> _publish() async {

    if(!_formKey.currentState!.validate() && mounted) {
      setState(() {
        _error = "Veuillez remplir tous les champs obligatoires";
      });
      return;
    }

    setState(() {
      _isPublishing = true;
      _error = null;
    });

    try {
      int issueId = await Medusa.createIssue(
        path: _path,
        summary: _summary,
        issueDescription: _description,
        stepToReproduce: _steps,
        expectedBehavior: _expectedBehavior,
        severity: _severity!,
        fileData: _capturedImage,
      );

      _print("Success published issue: $issueId");
      _handleClosePanel();

    } catch (e) {
      _print("Error during publishing: $e");
      if(mounted) {
        setState(() {
          _error = "Error during publishing";
        });
      }
    } finally {
      if(mounted) {
        setState(() {
          _isPublishing = false;
        });
      }
    }
  }

  /// Method to clear all input fields and reset the captured image.
  void _clearFields() {
    if(mounted) {
      setState(() {
        _path = '';
        _summary = '';
        _description = '';
        _steps = '';
        _expectedBehavior = '';
        _severity = '';
        _capturedImage = null;
      });
    }
  }

  /// on click of close button, clear fields and close the panel.
  void _handleClosePanel() {
    _clearFields();
    if(!mounted) return;
    setState(() {
      _isPanelOpen = false;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return _renderDesktop(context, this);
  }

  void _print(String message) {
    if(kDebugMode && MedusaDebugger.kDebugMedusa) {
      // ignore: avoid_print
      print("[MedusaScreenerPanel] $message");
    }
  }
}
