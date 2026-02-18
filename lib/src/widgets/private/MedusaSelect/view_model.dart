
import 'package:flutter/material.dart';
part 'view.dart';

class MedusaSelect extends StatefulWidget {

  final String? value;
  final List<String> items;
  final ValueChanged<String?>? onChanged;
  final String? label;
  final String? hint;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final double? height;

  const MedusaSelect({
    super.key,
    required this.value,
    required this.items,
    this.onChanged,
    this.label,
    this.hint,
    this.prefixIcon,
    this.suffixIcon,
    this.height,
  });

  @override
  State<MedusaSelect> createState() {
    return _MedusaSelectState();
  }
}

class _MedusaSelectState extends State<MedusaSelect> with _DesktopViewMixin {
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
    return render(context, this);
  }
}
