/// Renders a dynamic form in Flutter based on a Form.io form definition.
///
/// This widget receives a [FormModel] and builds a corresponding widget tree
/// based on its list of components. It supports dynamic user input handling,
/// required field validation, and data collection for form submission.
///
/// When a component of type "button" and action "submit" is tapped,
/// the form data is validated and submitted via [onSubmit].

import 'package:flutter/material.dart';

import '../core/exceptions.dart';
import '../models/component.dart';
import '../models/form.dart';
import '../network/api_client.dart';
import '../services/submission_service.dart';
import 'component_factory.dart';

typedef OnFormChanged = void Function(Map<String, dynamic> data);
typedef OnFormSubmitted = void Function(Map<String, dynamic> data);
typedef OnFormSubmitFailed = void Function(String error);

class FormRenderer extends StatefulWidget {
  final FormModel form;
  final OnFormChanged? onChanged;
  final OnFormSubmitted? onSubmit;
  final OnFormSubmitFailed? onError;
  final Map<String, dynamic>? initialData;

  const FormRenderer({
    Key? key,
    required this.form,
    this.onChanged,
    this.onSubmit,
    this.onError,
    this.initialData,
  }) : super(key: key);

  @override
  State<FormRenderer> createState() => _FormRendererState();
}

class _FormRendererState extends State<FormRenderer> {
  late Map<String, dynamic> _formData;
  final Map<String, String?> _errors = {};
  final _submissionService = SubmissionService(ApiClient());
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _formData = widget.initialData != null ? Map<String, dynamic>.from(widget.initialData!) : {};
  }

  void _updateField(String key, dynamic value) {
    setState(() {
      _formData[key] = value;
    });
    widget.onChanged?.call(_formData);
  }

  bool _validateForm() {
    bool isValid = true;
    _errors.clear();

    for (final component in widget.form.components) {
      if (_shouldShowComponent(component) && component.required) {
        final value = _formData[component.key];
        final isEmpty = value == null || (value is String && value.trim().isEmpty) || (value is Map && value.isEmpty) || (value is List && value.isEmpty);

        if (isEmpty) {
          _errors[component.key] = '${component.label} is required.';
          isValid = false;
        }
      }
    }

    setState(() {});
    return isValid;
  }

  Future<void> _handleSubmit() async {
    final isValid = _validateForm();
    if (!isValid) return;

    setState(() => _isSubmitting = true);

    try {
      await _submissionService.submit(widget.form.path, _formData);
      widget.onSubmit?.call(_formData);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Form submitted successfully!')),
      );
    } catch (e) {
      final error = e is ApiException ? e.message : 'Unknown error';
      widget.onError?.call(error);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Submission failed: $error')),
      );
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  /// Checks whether a component should be shown based on its conditional logic.
  bool _shouldShowComponent(ComponentModel component) {
    final condition = component.raw['conditional'];
    if (condition is! Map<String, dynamic>) return true;

    final when = condition['when'];
    final eq = condition['eq'];
    final show = condition['show'];

    if (when == null || when.toString().isEmpty) return true;

    final value = _formData[when];
    final matches = value?.toString() == eq?.toString();

    // Default behavior is to show if matched
    final shouldShow = (show == true || show == 'true') ? matches : !matches;

    return shouldShow;
  }

  Widget _buildComponent(ComponentModel component) {
    if (!_shouldShowComponent(component)) {
      return const SizedBox.shrink();
    }

    if (component.type == 'button' && (component.raw['action'] == 'submit' || component.raw['action'] == null)) {
      return ElevatedButton(
        onPressed: _isSubmitting ? null : _handleSubmit,
        child: _isSubmitting ? const CircularProgressIndicator() : Text(component.label.isNotEmpty ? component.label : 'Submit'),
      );
    }

    final fieldWidget = ComponentFactory.build(
      component: component,
      value: _formData[component.key],
      onChanged: (value) => _updateField(component.key, value),
    );

    final errorText = _errors[component.key];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        fieldWidget,
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 4),
            child: Text(
              errorText,
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.form.title.isNotEmpty) Text(widget.form.title, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 12),
        ...widget.form.components.map((component) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: _buildComponent(component),
          );
        }).toList(),
      ],
    );
  }
}
