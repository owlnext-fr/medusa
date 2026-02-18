
part of 'view_model.dart';


mixin _DesktopViewMixin {
  Widget render(BuildContext context, _MedusaSelectState state) {
    return SizedBox(
      height: state.widget.height ?? 56, // Hauteur uniforme
      child: DropdownButtonFormField<String>(
        value: state.widget.value,
        decoration: InputDecoration(
          labelText: state.widget.label,
          hintText: state.widget.hint,
          prefixIcon: state.widget.prefixIcon,
          suffixIcon: state.widget.suffixIcon,
          contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          border: OutlineInputBorder(),
        ),
        items: state.widget.items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: state.widget.onChanged,
      ),
    );
  }
}
