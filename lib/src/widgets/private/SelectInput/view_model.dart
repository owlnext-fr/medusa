
import 'package:flutter/material.dart';
part 'view.dart';

/// A simple data class representing an item in the select input, with a key and a label.
class SelectItem {
  final String? value;
  final String label;

  SelectItem({required this.value, required this.label});
}

class SelectInput extends StatefulWidget {

  final String? value;
  final List<SelectItem> items;
  final ValueChanged<String?>? onChanged;
  final String? label;
  final String? hint;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final double? height;
  final bool isMandatory;

  const SelectInput({
    super.key,
    required this.value,
    required this.items,
    this.onChanged,
    this.label,
    this.hint,
    this.prefixIcon,
    this.suffixIcon,
    this.height,
    this.isMandatory = false,
  });

  @override
  State<SelectInput> createState() {
    return _SelectInputState();
  }
}

class _SelectInputState extends State<SelectInput> with _DesktopViewMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  String? _validator(String? value) {
    // Example validation: field must not be empty
    if (widget.isMandatory && (value == null || value.isEmpty)) {
      return 'Ce champ ne peut pas être vide';
    }
    return null; // Return null if the input is valid
  }
  
  @override
  Widget build(BuildContext context) {
    return render(context, this);
  }
}
