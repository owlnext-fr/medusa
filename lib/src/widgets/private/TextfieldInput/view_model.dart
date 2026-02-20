
import 'package:flutter/material.dart';
part 'view.dart';

class TextFieldInput extends StatefulWidget {

  final String? value;
  final ValueChanged<String?>? onChanged;
  final String? label;
  final String? hint;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final double? height;
  final int minLines;
  final bool isMandatory;

  const TextFieldInput({
    super.key,
    required this.value,
    this.onChanged,
    this.label,
    this.hint,
    this.prefixIcon,
    this.suffixIcon,
    this.height,
    this.minLines = 1,
    this.isMandatory = false,
  });

  @override
  State<TextFieldInput> createState() {
    return _TextFieldInputState();
  }
}

class _TextFieldInputState extends State<TextFieldInput> with _DesktopViewMixin {

  TextEditingController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void dispose() {
    _controller?.dispose();
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
