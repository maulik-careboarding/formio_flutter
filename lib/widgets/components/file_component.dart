/// A Flutter widget that renders a file upload input based on
/// a Form.io "file" component.
///
/// Handles file selection, preview, and basic validation.
/// Upload logic (to Form.io or custom storage) must be handled externally.

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../models/component.dart';

class FileComponent extends StatelessWidget {
  /// The Form.io file component definition.
  final ComponentModel component;

  /// Currently selected file paths (may be local or uploaded URLs).
  final List<String> value;

  /// Callback triggered when files are selected or cleared.
  final ValueChanged<List<String>> onChanged;

  const FileComponent({Key? key, required this.component, required this.value, required this.onChanged}) : super(key: key);

  /// Whether multiple file selection is allowed.
  bool get _isMultiple => component.raw['multiple'] == true;

  /// Whether this field is required.
  bool get _isRequired => component.required;

  /// Allowed file types (from accept property, e.g., 'image/*').
  List<String> get _acceptedExtensions {
    final accept = component.raw['fileTypes'] as List? ?? [];
    return accept.map((e) => e['value'].toString()).toList();
  }

  Future<void> _pickFiles(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: _isMultiple,
      type: FileType.custom,
      allowedExtensions: _acceptedExtensions.isNotEmpty ? _acceptedExtensions.map((e) => e.replaceAll(RegExp(r'[^\w]'), '')).toList() : null,
    );

    if (result != null) {
      final paths = result.paths.whereType<String>().toList();
      onChanged(paths);
    }
  }

  void _removeFile(String path) {
    final updated = List<String>.from(value)..remove(path);
    onChanged(updated);
  }

  @override
  Widget build(BuildContext context) {
    final hasError = _isRequired && value.isEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(component.label, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children:
              value.map((filePath) {
                final fileName = filePath.split(Platform.pathSeparator).last;
                return Chip(label: Text(fileName), onDeleted: () => _removeFile(filePath));
              }).toList(),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: () => _pickFiles(context),
          icon: const Icon(Icons.upload_file),
          label: Text(_isMultiple ? 'Upload Files' : 'Upload File'),
        ),
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text('${component.label} is required.', style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 12)),
          ),
      ],
    );
  }
}
