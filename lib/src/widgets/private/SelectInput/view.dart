
part of 'view_model.dart';


mixin _DesktopViewMixin {
  Widget render(BuildContext context, _SelectInputState state) {
    final TextTheme tt = Theme.of(context).textTheme;
    final ColorScheme cs = Theme.of(context).colorScheme;
    return DropdownButtonFormField<String>(
        value: state.widget.items.any((item) => item.value == state.widget.value)
      ? state.widget.value
      : null, //secured mapping
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
      items: state.widget.items.map((SelectItem item) {
        return DropdownMenuItem<String>(
          value: item.value,
          child: Text(item.label, style: tt.bodyMedium),
        );
      }).toList(),
      onChanged: state.widget.onChanged,
      validator: state._validator,
    );
  }
}
