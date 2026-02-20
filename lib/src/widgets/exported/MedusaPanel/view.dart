
part of 'view_model.dart';


mixin _DesktopViewMixin {
  Widget _renderDesktop(BuildContext context, _MedusaScreenerPanelState state) {

    if(state._isPanelOpen == true) {
      /// If the panel is not open, we just render the child widget without the Stack 
      /// to avoid unnecessary rebuilds and potential performance issues.
      return Stack(
        clipBehavior: Clip.none,
        children: [
          state.widget.child,
          /// app-side child widget
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

    return ScreenerWidget(
      key: state._screenerKey,
      child: state.widget.child,
    );
  }

  /// Affiche le panneau avec l'image capturée.
  Widget _renderPanel(BuildContext context, _MedusaScreenerPanelState state) {
    final ColorScheme cs = Theme.of(context).colorScheme;

    return Container(
      width: state.widget.panelConfig?.width ?? 600,
      padding: state.widget.panelConfig?.padding ?? EdgeInsets.all(state._gap * 2),
      decoration: state.widget.panelConfig?.decoration ?? BoxDecoration(
        color: cs.surface,
        boxShadow: [
          BoxShadow(
            color: cs.surface.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: Offset(-2, 4),
          ),
        ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: state._gap,
        children: [
          _renderTitle(context, state),
          /// Errors
          if(state._error != null)
          _renderError(context, state),
          // Fields list
          if(state._isPublishing)
          Expanded(child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: state._gap * 2),
              Center(child: CircularProgressIndicator()),
            ],
          ))
          else
          Expanded(
            child: ListView(
              padding: EdgeInsets.only(right: 8.0), // add some right padding for scrollbar
              children: [
                _renderFields(context, state),
              ],
            ),
          ), 
          /// Actions
          _renderBottomActions(context, state),
        ],
      ),
    );
  }

  /// Display the captured image in the panel with a delete button
  // ignore: unused_element
  Widget _renderCapturedImage(BuildContext context, _MedusaScreenerPanelState state) {
    final TextTheme tt = Theme.of(context).textTheme;
    final ColorScheme cs = Theme.of(context).colorScheme;
    if (state._capturedImage == null) return const SizedBox.shrink();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Titre
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Image Capturée',
              style: tt.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            // Bouton de suppression
            IconButton(
              icon: Icon(Icons.delete_outline, color: cs.error),
              tooltip: 'Supprimer l\'image',
              onPressed: state._removeCapturedImage,
              splashRadius: 20,
            ),
          ],
        ),
        SizedBox(height: state._gap),
        // Image
        Container(
          constraints: BoxConstraints(
            maxHeight: 300,
            maxWidth: double.infinity,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.memory(
              state._capturedImage!,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const Center(
                  child: Icon(Icons.broken_image, size: 48, color: Colors.grey),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _renderTitle(BuildContext context, _MedusaScreenerPanelState state) {
    final TextTheme tt = Theme.of(context).textTheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: state._gap,
      children: [
        Text(
          'Signaler un problème',
          style: tt.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        //Text("Merci de fournir un maximum de détails pour aider l'équipe à comprendre et résoudre le problème."),
      ],
    );
  }

  /// Renders the input fields for the issue details (e.g., path, summary, description).
  Widget _renderFields(BuildContext context, _MedusaScreenerPanelState state) {
    return Form(
      key: state._formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: state._gap * 2,
        children: [
          SizedBox(height: state._gap),
          TextFieldInput(
            value: state._summary,
            label: 'Résumé',
            isMandatory: true,
            onChanged: (val) => state._summary = val ?? '',
          ),
          TextFieldInput(
            value: state._description,
            label: 'Description',
            isMandatory: true,
            onChanged: (val) => state._description = val ?? '',
          ),
          TextFieldInput(
            value: state._steps,
            label: 'Étapes pour reproduire',
            isMandatory: true,
            minLines: 4,
            onChanged: (val) => state._steps = val ?? '',
          ),
          TextFieldInput(
            value: state._expectedBehavior,
            label: 'Comportement attendu',
            isMandatory: true,
            minLines: 4,
            onChanged: (val) => state._expectedBehavior = val ?? '',
          ),
          SelectInput(
            label: 'Sévérité',
            value: state._severity,
            items: state._severityItems,
            onChanged: (val) => state._severity = val,
          ),
          /*
          if(state._capturedImage!= null)
          _renderCapturedImage(context, state),
          */
        ],
      ),
    );
  }

  Widget _renderError(BuildContext context, _MedusaScreenerPanelState state) {
    final TextTheme tt = Theme.of(context).textTheme;
    final ColorScheme cs = Theme.of(context).colorScheme;
    if(state._error == null) return SizedBox.shrink();
    return Container(
      padding: EdgeInsets.all(state._gap),
      decoration: BoxDecoration(
        color: cs.error.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        spacing: state._gap,
        children: [
          Icon(Icons.error_outlined, color: cs.error),
          Text(
            state._error!,
            overflow: TextOverflow.ellipsis,
            style: tt.bodyMedium?.copyWith(color: cs.error),
          ),
        ],
      ),
    );
  }

  /// Renders the action buttons at the bottom of the panel (e.g., Publish, Close).
  Widget _renderBottomActions(BuildContext context, _MedusaScreenerPanelState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      spacing: 12.0,
      children: [
        ElevatedButton(
          onPressed: state._handleClosePanel,
          child: Text('Fermer'),
        ),
        Spacer(),
        IgnorePointer(
          ignoring: state._isPublishing,
          child: ElevatedButton(
            onPressed: state._publish,
            child: Text('Publier'),
          ),
        ),
      ],
    );
  }
}
