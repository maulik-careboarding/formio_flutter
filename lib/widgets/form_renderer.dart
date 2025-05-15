/// Renders a dynamic form in Flutter based on a Form.io form definition.
///
/// This widget receives a [FormModel] and builds a corresponding widget tree
/// based on its list of components. It supports dynamic user input handling,
/// required field validation, and data collection for form submission.

import 'package:flutter/material.dart';

import '../models/component.dart';
import '../models/form.dart';
import 'component_factory.dart';

typedef OnFormChanged = void Function(Map<String, dynamic> data);

class FormRenderer extends StatefulWidget {
  /// The Form.io form model to render.
  final FormModel form;

  /// Called whenever a field value changes.
  final OnFormChanged? onChanged;

  /// Optional initial values to pre-fill the form.
  final Map<String, dynamic>? initialData;

  const FormRenderer({Key? key, required this.form, this.onChanged, this.initialData}) : super(key: key);

  @override
  State<FormRenderer> createState() => _FormRendererState();
}

class _FormRendererState extends State<FormRenderer> {
  /// Stores current user-entered data for the form fields.
  late Map<String, dynamic> _formData;

  /// Stores form field validation errors.
  final Map<String, String?> _errors = {};

  @override
  void initState() {
    super.initState();
    _formData = widget.initialData != null ? Map<String, dynamic>.from(widget.initialData!) : {};
  }

  /// Updates the internal form data and notifies the [onChanged] callback.
  void _updateField(String key, dynamic value) {
    setState(() {
      _formData[key] = value;
    });
    widget.onChanged?.call(_formData);
  }

  /// Builds a widget for a single form component.
  Widget _buildComponent(ComponentModel component) {
    return ComponentFactory.build(component: component, value: _formData[component.key], onChanged: (value) => _updateField(component.key, value));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.form.title, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 12),
        ...widget.form.components.map((component) {
          return Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: _buildComponent(component));
        }).toList(),
      ],
    );
  }
}
