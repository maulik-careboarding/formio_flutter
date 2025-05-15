/// A Flutter widget that renders a date and/or time picker based on a Form.io "datetime" component.
///
/// Supports label, placeholder, required validation, default value, and configuration for date, time, or both.

import 'package:flutter/material.dart';

import '../../models/component.dart';

class DateTimeComponent extends StatefulWidget {
  /// The Form.io component definition.
  final ComponentModel component;

  /// The current selected DateTime value.
  final DateTime? value;

  /// Callback triggered when the user selects a new date/time.
  final ValueChanged<DateTime?> onChanged;

  const DateTimeComponent({Key? key, required this.component, required this.value, required this.onChanged}) : super(key: key);

  @override
  State<DateTimeComponent> createState() => _DateTimeComponentState();
}

class _DateTimeComponentState extends State<DateTimeComponent> {
  late TextEditingController _controller;

  /// Whether the field is marked as required.
  bool get _isRequired => widget.component.required;

  /// Placeholder text for the input field.
  String? get _placeholder => widget.component.raw['placeholder'];

  /// Determines if the picker should include time selection.
  bool get _enableTime => widget.component.raw['enableTime'] ?? false;

  /// Determines if the picker should include date selection.
  bool get _enableDate => widget.component.raw['enableDate'] ?? true;

  /// The display format for the date/time.
  // String get _format => widget.component.raw['format'] ?? 'yyyy-MM-dd';

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value != null ? _formatDateTime(widget.value!) : '');
  }

  @override
  void didUpdateWidget(covariant DateTimeComponent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _controller.text = widget.value != null ? _formatDateTime(widget.value!) : '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Formats the DateTime object into a string based on the specified format.
  String _formatDateTime(DateTime dateTime) {
    // You can use intl package for more advanced formatting.
    return '${dateTime.toLocal()}'.split(' ')[0];
  }

  /// Parses a string into a DateTime object.
  // DateTime? _parseDateTime(String input) {
  //   try {
  //     return DateTime.parse(input);
  //   } catch (_) {
  //     return null;
  //   }
  // }

  /// Validates the input based on requirement.
  String? _validator(String? input) {
    if (_isRequired && (input == null || input.isEmpty)) {
      return '${widget.component.label} is required.';
    }
    return null;
  }

  /// Handles the date/time picker dialog.
  Future<void> _handlePick(BuildContext context) async {
    DateTime? selectedDate = widget.value ?? DateTime.now();

    if (_enableDate) {
      final date = await showDatePicker(context: context, initialDate: selectedDate, firstDate: DateTime(1900), lastDate: DateTime(2100));
      if (date != null) {
        selectedDate = DateTime(date.year, date.month, date.day, selectedDate.hour, selectedDate.minute);
      } else {
        return;
      }
    }

    if (_enableTime) {
      final time = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(selectedDate));
      if (time != null) {
        selectedDate = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, time.hour, time.minute);
      } else {
        return;
      }
    }

    widget.onChanged(selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: widget.component.label,
        hintText: _placeholder,
        border: const OutlineInputBorder(),
        suffixIcon: const Icon(Icons.calendar_today),
      ),
      validator: _validator,
      onTap: () => _handlePick(context),
    );
  }
}
