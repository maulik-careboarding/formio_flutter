/// A Flutter widget that renders a titled container panel based on a
/// Form.io "panel" component.
///
/// Used to visually group related form fields under a common section with
/// an optional title and collapsible behavior (if configured).

import 'package:flutter/material.dart';

import '../../models/component.dart';
import '../component_factory.dart';

class PanelComponent extends StatelessWidget {
  /// The Form.io panel definition.
  final ComponentModel component;

  /// Nested values passed into the panel’s child components.
  final Map<String, dynamic> value;

  /// Callback triggered when any child component inside the panel changes.
  final ValueChanged<Map<String, dynamic>> onChanged;

  const PanelComponent({Key? key, required this.component, required this.value, required this.onChanged}) : super(key: key);

  /// List of components inside the panel.
  List<ComponentModel> get _children {
    final components = component.raw['components'] as List? ?? [];
    return components.map((c) => ComponentModel.fromJson(c)).toList();
  }

  /// Optional description shown below the title.
  String? get _description => component.raw['description'];

  /// Updates the form value for a child component inside the panel.
  void _updateChild(String key, dynamic fieldValue) {
    final updated = Map<String, dynamic>.from(value);
    updated[key] = fieldValue;
    onChanged(updated);
  }

  @override
  Widget build(BuildContext context) {
    final title = component.label;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title.isNotEmpty) Text(title, style: Theme.of(context).textTheme.displaySmall, textAlign: TextAlign.left),
            if (_description != null)
              Padding(padding: const EdgeInsets.only(top: 4, bottom: 12), child: Text(_description!, style: Theme.of(context).textTheme.bodySmall)),
            ..._children.map(
              (child) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: ComponentFactory.build(component: child, value: value[child.key], onChanged: (val) => _updateChild(child.key, val)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
