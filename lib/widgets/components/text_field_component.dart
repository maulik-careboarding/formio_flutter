/// A Flutter widget that renders a text field based on a Form.io "textfield" component.
///
/// Supports placeholder, label, default value, and required validation.

import 'package:flutter/material.dart';

import '../../models/component.dart';

class TextFieldComponent extends StatelessWidget {
  /// The Form.io component definition.
  final ComponentModel component;

  /// The current value of the field.
  final String? value;

  /// Callback called when the user changes the input value.
  final ValueChanged<String> onChanged;

  const TextFieldComponent({Key? key, required this.component, required this.value, required this.onChanged}) : super(key: key);

  /// Retrieves a placeholder value if available in the raw JSON.
  String? get _placeholder => component.raw['placeholder'];

  /// Returns true if the field is required.
  bool get _isRequired => component.required;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: value ?? component.defaultValue?.toString(),
      decoration: InputDecoration(labelText: component.label, hintText: _placeholder, border: const OutlineInputBorder()),
      onChanged: onChanged,
      validator: _isRequired ? (val) => (val == null || val.isEmpty) ? '${component.label} is required.' : null : null,
    );
  }
}
