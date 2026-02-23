import 'package:flutter/material.dart';


/// Configuration for the panel that displays the fields user must fill in after the capture.
/// This includes styling options like elevation, background color, and padding.
class MedusaScreenerPanelStyle {
  final String? desktopWidth;
  final BoxDecoration? decoration;
  final EdgeInsetsGeometry? padding;
  final double? width;

  MedusaScreenerPanelStyle({
    this.desktopWidth,
    this.decoration,
    this.padding,
    this.width,
  });
}