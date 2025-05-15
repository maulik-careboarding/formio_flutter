/// A simple ChangeNotifier-based state manager for Form.io dynamic forms.
///
/// Stores form field values and provides methods to update/reset them.
/// Suitable for use with Provider, Riverpod, or as a base for BLoC architecture.

import 'package:flutter/material.dart';

class FormProvider with ChangeNotifier {
  /// Stores current form field values (key-value pairs).
  Map<String, dynamic> _formData = {};

  /// Returns the current state of all form fields.
  Map<String, dynamic> get formData => _formData;

  /// Returns a specific field's value by key.
  dynamic getValue(String key) => _formData[key];

  /// Updates a single field’s value and notifies listeners.
  void updateField(String key, dynamic value) {
    _formData[key] = value;
    notifyListeners();
  }

  /// Bulk update multiple values (e.g., from saved draft or submission).
  void updateFields(Map<String, dynamic> values) {
    _formData.addAll(values);
    notifyListeners();
  }

  /// Resets the form to an empty state.
  void reset() {
    _formData = {};
    notifyListeners();
  }

  /// Checks if a required field is empty.
  bool isFieldEmpty(String key) {
    final value = _formData[key];
    return value == null || (value is String && value.trim().isEmpty);
  }

  /// Returns true if form has any data.
  bool get isFilled => _formData.isNotEmpty;

  /// Removes a field from the form data.
  void removeField(String key) {
    _formData.remove(key);
    notifyListeners();
  }
}
