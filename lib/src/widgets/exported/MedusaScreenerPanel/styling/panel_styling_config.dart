import 'package:flutter/material.dart';


/// Configuration for the panel that displays the fields user must fill in after the capture.
/// This includes styling options like elevation, background color, and padding.
class MedusaScreenerPanelStyle {
  final String? title;
  final BoxDecoration? decoration;
  final EdgeInsetsGeometry? padding;
  final double? width;

  MedusaScreenerPanelStyle({
    this.title,
    this.decoration,
    this.padding,
    this.width,
  });
}