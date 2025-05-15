/// A Flutter widget that renders a visual container for grouping content
/// based on a Form.io "well" layout component.
///
/// Used to emphasize or separate form sections without borders or titles.
/// The well wraps child components in a subtle gray box.

import 'package:flutter/material.dart';

import '../../models/component.dart';
import '../component_factory.dart';

class WellComponent extends StatelessWidget {
  /// The Form.io component definition.
  final ComponentModel component;

  /// Current form values of all nested fields inside the well.
  final Map<String, dynamic> value;

  /// Callback triggered when a nested field changes.
  final ValueChanged<Map<String, dynamic>> onChanged;

  const WellComponent({Key? key, required this.component, required this.value, required this.onChanged}) : super(key: key);

  /// List of nested child components inside the well.
  List<ComponentModel> get _children {
    final comps = component.raw['components'] as List? ?? [];
    return comps.map((c) => ComponentModel.fromJson(c)).toList();
  }

  /// Updates value of a specific field inside the well.
  void _updateField(String key, dynamic val) {
    final updated = Map<String, dynamic>.from(value);
    updated[key] = val;
    onChanged(updated);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(6)),
      child: Column(
        children:
            _children.map((child) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: ComponentFactory.build(component: child, value: value[child.key], onChanged: (val) => _updateField(child.key, val)),
              );
            }).toList(),
      ),
    );
  }
}
