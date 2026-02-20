
part of 'view_model.dart';


mixin _DesktopViewMixin {
  Widget _render(BuildContext context, _MedusaCaptureButtonState state) {

    if(state.widget.config?.customChild != null) {
      return GestureDetector(
        onTap: state._onPressed,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: state.widget.config!.customChild!,
        ),
      );
    }

    return  ElevatedButton(
      onPressed: state._onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        children: [
          Icon(state.widget.config?.icon ?? Icons.camera_alt),
          if(state.widget.config?.buttonText != null)
          Text(state.widget.config!.buttonText!),
        ],
      ),
    );
  }
}
