
part of 'view_model.dart';


mixin _DesktopViewMixin {
  Widget render(BuildContext context, _TextFieldInputState state) {
    final TextTheme tt = Theme.of(context).textTheme;
    final ColorScheme cs = Theme.of(context).colorScheme;
    return TextFormField(
      controller: state._controller,
      minLines: state.widget.minLines,
      maxLines: state.widget.minLines,
      style: tt.bodyMedium,
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelText: state.widget.label,
        hintText: state.widget.hint,
        prefixIcon: state.widget.prefixIcon,
        suffixIcon: state.widget.suffixIcon,
        contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        border: OutlineInputBorder(),
        labelStyle: tt.bodyMedium,
        hintStyle: tt.bodyMedium?.copyWith(color: tt.bodyMedium?.color?.withValues(alpha: 0.6)),
        errorStyle: tt.bodySmall?.copyWith(color: cs.error),
        floatingLabelStyle: tt.bodyMedium?.copyWith(),
      ),
      onChanged: state.widget.onChanged,
      validator: state._validator,
    );
  }
}