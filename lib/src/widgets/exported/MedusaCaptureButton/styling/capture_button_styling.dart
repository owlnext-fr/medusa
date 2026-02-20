import 'package:flutter/material.dart';

/// Configuration for the capture button (CTA) that triggers the capture action.
/// Includes options for the icon, color, size, and positioning of the button on the screen.
class CaptureButtonStyle {
  final String? buttonText;
  final IconData? icon;
  final Color? iconColor;
  final double? iconSize;

  final Widget? customChild;

  CaptureButtonStyle({
    this.buttonText,
    this.icon,
    this.iconColor,
    this.iconSize,
    this.customChild,
  });
}