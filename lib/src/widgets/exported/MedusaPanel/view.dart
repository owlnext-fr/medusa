
part of 'view_model.dart';


mixin _DesktopViewMixin {
  Widget _renderDesktop(BuildContext context, _MedusaScreenerPanelState state) {
    return  Stack(
      children: [
        ScreenerWidget(
          key: state._screenerKey,
          child: state.widget.child,
        ), /// app-side child widget
        if(state._isPanelOpen)
        Positioned(
          top: 0,
          right: 0,
          bottom: 0,
          left: null,
          child: _renderPanel(context, state)
        ),
      ],
    );
  }

  /// Affiche le panneau avec l'image capturée.
  Widget _renderPanel(BuildContext context, _MedusaScreenerPanelState state) {
    final TextTheme tt = Theme.of(context).textTheme;
    final ColorScheme cs = Theme.of(context).colorScheme;

    return Container(
      padding: state.widget.panelConfig?.padding ?? EdgeInsets.all(16),
      decoration: state.widget.panelConfig?.decoration ?? BoxDecoration(
        color: cs.surface,
      ),
      child: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                Text(
                  state.widget.panelConfig?.title ?? 'Panneau de Capture', 
                  style: tt.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                if (state._capturedImage != null)
                  _renderCapturedImage(context, state),
              ],
            ),
          ),
          _renderBottomActions(context, state),
        ],
      ),
    );
  }

  /// Display the captured image in the panel
  Widget _renderCapturedImage(BuildContext context, _MedusaScreenerPanelState state) {
    final TextTheme tt = Theme.of(context).textTheme;
    return Column(
      children: [
        Text(
          'Image Capturée',
          style: tt.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        Container(
          constraints: BoxConstraints(
            maxHeight: 300,
            maxWidth: double.infinity,
          ),
          child: Image.memory(state._capturedImage!),
        ),
      ],
    );
  }

  /// Renders the action buttons at the bottom of the panel (e.g., Publish, Close).
  Widget _renderBottomActions(BuildContext context, _MedusaScreenerPanelState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton(
          onPressed: state._closePanel,
          child: Text('Fermer'),
        ),
        ElevatedButton(
          onPressed: state._publish,
          child: Text('Publier'),
        ),
      ],
    );
  }
}
