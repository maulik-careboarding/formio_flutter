/// A Flutter widget that renders a multi-line text area based on a
/// Form.io "textarea" component.
///
/// Supports label, placeholder, default value, and required validation.

import 'package:flutter/material.dart';

import '../../models/component.dart';

class TextAreaComponent extends StatelessWidget {
  /// The Form.io component definition.
  final ComponentModel component;

  /// The current value of the text area field.
  final String? value;

  /// Callback called when the user updates the text.
  final ValueChanged<String> onChanged;

  const TextAreaComponent({Key? key, required this.component, required this.value, required this.onChanged}) : super(key: key);

  /// Placeholder text shown inside the textarea when empty.
  String? get _placeholder => component.raw['placeholder'];

  /// Returns true if the field is marked as required.
  bool get _isRequired => component.required;

  /// Number of rows/lines to show initially (default is 3).
  int get _rows => component.raw['rows'] ?? 3;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: value ?? component.defaultValue?.toString(),
      maxLines: _rows,
      decoration: InputDecoration(labelText: component.label, hintText: _placeholder, border: const OutlineInputBorder(), alignLabelWithHint: true),
      onChanged: onChanged,
      validator: _isRequired ? (val) => (val == null || val.trim().isEmpty) ? '${component.label} is required.' : null : null,
    );
  }
}
