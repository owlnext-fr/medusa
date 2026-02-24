
import 'dart:async';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:medusa/medusa.dart';
import 'package:medusa/src/notifiers/screener_notifier.dart';
import 'package:medusa/src/widgets/private/SelectInput/view_model.dart';
import 'package:medusa/src/widgets/private/TextfieldInput/view_model.dart';
part 'view.dart';

class MedusaScreenerPanelWidget extends StatefulWidget {

  /// The configuration for the MedusaScreenerPanelWidget widget.
  final MedusaScreenerPanelStyle? panelConfig;

  /// The full path of the current route, used for issue context.
  /// for GoRouter, you can pass 
  /// ```dart
  /// GoRouterState.of(context).fullPath
  /// ``` 
  /// here. 
  /// For Navigator, you can pass 
  /// ```dart 
  /// ModalRoute.of(context)?.settings.name
  /// ```
  /// here.
  final String? matchedLocation;

  final bool isMobileView;

  final Widget child;

  const MedusaScreenerPanelWidget({
    super.key,
    this.panelConfig,
    required this.matchedLocation,
    required this.isMobileView,
    required this.child,
  });

  @override
  State<MedusaScreenerPanelWidget> createState() {
    return _MedusaScreenerPanelWidgetState();
  }
}

class _MedusaScreenerPanelWidgetState extends State<MedusaScreenerPanelWidget> with _DesktopViewMixin {

  final double _gap = 8.0;

  /// --- Screen capture ----
  StreamSubscription<Uint8List?>? _captureSubscription;
  final GlobalKey<_MedusaScreenerPanelWidgetState> _screenerKey = GlobalKey();
  Uint8List? _capturedImage;

  /// ---- State -----
  bool _isPanelOpen = false;
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
      /// When a capture event is received, we first check if it's a request (null) or a result (non-null bytes).
      (bytes) async {
        _print("🔍 Capture event received: ${bytes == null ? 'REQUEST' : 'RESULT'}");

        if(mounted) {
          setState(() {
            _error = null;
            _isPanelOpen = false;
          });
        }
        // Capture requested
        final Uint8List? capturedBytes = await _getScreenCapture();

        if(mounted) {
          // Capture result received
          setState(() {
            _path = widget.matchedLocation ?? 'NA';
            _capturedImage = capturedBytes;
            _isPanelOpen = true;
            _print( "📸 Capture completed, path: $_path, image size: ${capturedBytes != null ? capturedBytes.lengthInBytes : 'null'} bytes");
          });
        }
      },
      onError: (e) {
        _print("❌ Capture error: $e");
        if (mounted) {
          setState(() {
            _capturedImage = null;
            _isPanelOpen = true;
            _error = "Erreur lors de la capture d'écran";
          });
        }
      },
    );
  }

  Future<Uint8List?> _getScreenCapture() async {
    if (!mounted) return null;
    try {
      // Verify again that the widget is still mounted before accessing context
      if (!mounted) return null;
      final context = this.context;
      if(!context.mounted) return null;
      final BuildContext? boundaryContext = _screenerKey.currentContext;
      if (boundaryContext == null) {
        _print("RepaintBoundary not found in the widget tree");
        return null;
      }

      final RenderObject? renderObject = boundaryContext.findRenderObject();
      if (renderObject is! RenderRepaintBoundary) {
        _print("The RenderObject is not a RenderRepaintBoundary");
        return null;
      }

      // Capture the image
      final image = await renderObject.toImage(pixelRatio: MediaQuery.of(context).devicePixelRatio);
      final byteData = await image.toByteData(format: ImageByteFormat.png);

      return byteData?.buffer.asUint8List();
    } catch (e) {
      _print("Error during _getScreenCapture(): $e");
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

  /// Capture widget image as Uint8List (PNG format) and return it. 
  /// Returns null if capture fails or if the widget is not mounted.
  Future<Uint8List?> _captureCurrentView() async {
    
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
          _error = "Erreur lors de la publication";
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
    if(widget.isMobileView) {
      return _renderMobile(context, this);
    }
    return _renderDesktop(context, this);
  }

  void _print(String message) {
    if(kDebugMode && MedusaDebugger.kDebugMedusa) {
      // ignore: avoid_print
      print("[MedusaScreenerPanelWidget] $message");
    }
  }
}
