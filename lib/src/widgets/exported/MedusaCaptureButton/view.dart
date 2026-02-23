
part of 'view_model.dart';


mixin _DesktopViewMixin {
  Widget _render(BuildContext context, _MedusaCaptureButtonWidgetState state) {
    if(state.widget.config?.customChild != null) {
      return _renderCustomButton(context, state);
    }
    return _renderBasisButton(context, state);
  }

  Widget _renderCustomButton(BuildContext context, _MedusaCaptureButtonWidgetState state) {
    assert(state.widget.config != null);
    return GestureDetector(
      onTap: state._onPressed,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: state.widget.config!.customChild!,
      ),
    );
  }

  Widget _renderBasisButton(BuildContext context, _MedusaCaptureButtonWidgetState state) {
    final ColorScheme cs = Theme.of(context).colorScheme;
    return ElevatedButton(
      onPressed: state._onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: state.widget.config?.buttonColor ?? Theme.of(context).colorScheme.primary,
        padding: state.widget.config?.buttonPadding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: state.widget.config?.buttonBorderRadius ?? BorderRadius.circular(4),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        children: [
          Icon(
            state.widget.config?.icon ?? Icons.camera_alt, 
            size: state.widget.config?.iconSize ?? 16,
            color: state.widget.config?.iconColor ?? cs.onPrimary,
          ),
          if(state.widget.config?.buttonText != null)
          Text(state.widget.config!.buttonText!),
        ],
      ),
    );
  }
}
