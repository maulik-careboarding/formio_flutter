/// A Flutter widget that renders a dropdown menu based on a Form.io "select" component.
///
/// Supports label, placeholder, required validation, default value,
/// and dynamic value lists from static JSON.

import 'package:flutter/material.dart';

import '../../models/component.dart';

class SelectComponent extends StatelessWidget {
  /// The Form.io component definition.
  final ComponentModel component;

  /// The currently selected value.
  final dynamic value;

  /// Callback triggered when the user selects an option.
  final ValueChanged<dynamic> onChanged;

  const SelectComponent({
    Key? key,
    required this.component,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  /// Whether the field is marked as required.
  bool get _isRequired => component.required;

  /// Placeholder shown when no value is selected.
  String? get _placeholder => component.raw['placeholder'];

  /// Returns the list of available options.
  List<Map<String, dynamic>> get _values => List<Map<String, dynamic>>.from(component.raw['data']?['values'] ?? []);

  /// Validates if a required selection is made.
  String? _validator() {
    if (_isRequired && (value == null || value.toString().isEmpty)) {
      return '${component.label} is required.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final error = _validator();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InputDecorator(
          key: ValueKey(component.key), // ensure proper rebuild when visibility toggles
          decoration: InputDecoration(
            labelText: component.label,
            border: const OutlineInputBorder(),
            errorText: error,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<dynamic>(
              isExpanded: true,
              hint: Text(_placeholder ?? 'Select...'),
              value: value,
              onChanged: onChanged,
              items: _values.map((option) {
                final label = option['label']?.toString() ?? '';
                final val = option['value'];
                return DropdownMenuItem<dynamic>(
                  value: val,
                  child: Text(label),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}