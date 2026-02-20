import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:medusa/medusa.dart';

/// Controller for managing screenshot captures using Streams.
/// Uses proper singleton pattern with `instance` getter.
class ScreenerController {
  // Singleton private constructor
  ScreenerController._internal();

  // Singleton instance
  static final ScreenerController _instance = ScreenerController._internal();

  /// Public accessor for the singleton instance
  static ScreenerController get instance => _instance;

  // Broadcast stream to support multiple listeners
  final StreamController<Uint8List?> _captureController =
      StreamController<Uint8List?>.broadcast();

  /// Stream to listen for capture results.
  /// Emits `null` when a capture is requested, and `Uint8List` when complete.
  Stream<Uint8List?> get captureResults => _captureController.stream;

  /// Triggers a new capture. Call this from anywhere in the app.
  void triggerCapture() {
    _print("[ScreenerController] ✅ Capture triggered");
    _captureController.add(null); // null = new capture request
  }

  /// Cleans up resources. Call this when the app is disposed.
  void dispose() {
    _captureController.close();
    _print("[ScreenerController] 🗑️ Disposed");
  }

  void _print(String message) {
    if(kDebugMode && MedusaDebugger.kDebugMedusa) {
      // ignore: avoid_print
      print("[ScreenerController] $message");
    }
  }
}
