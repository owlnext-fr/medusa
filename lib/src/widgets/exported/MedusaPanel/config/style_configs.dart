import 'package:flutter/material.dart';


/// Configuration for the panel that displays the fields user must fill in after the capture.
/// This includes styling options like elevation, background color, and padding.
class PanelConfig {
  final String? title;
  final BoxDecoration? decoration;
  final EdgeInsetsGeometry? padding;
  final double? width;

  PanelConfig({
    this.title,
    this.decoration,
    this.padding,
    this.width,
  });
}

/// Configuration for the capture button (CTA) that triggers the capture action.
/// Includes options for the icon, color, size, and positioning of the button on the screen.
class CaptureButtonConfig {
  final String? buttonText;
  final IconData? icon;
  final Color? iconColor;
  final double? iconSize;

  final Widget? customChild;

  CaptureButtonConfig({
    this.buttonText,
    this.icon,
    this.iconColor,
    this.iconSize,
    this.customChild,
  });
}