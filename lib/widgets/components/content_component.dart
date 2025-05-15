/// A Flutter widget that renders static content based on a Form.io "content" component.
///
/// Used to display non-interactive information, such as instructions, notes,
/// or markdown/HTML-based explanations inside the form.

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../models/component.dart';

class ContentComponent extends StatelessWidget {
  /// The Form.io component definition.
  final ComponentModel component;

  const ContentComponent({Key? key, required this.component}) : super(key: key);

  /// Extracts the raw HTML or text content from the component.
  String get _content => component.raw['html'] ?? '';

  /// Optional CSS class name from Form.io (ignored in this implementation).
  // String? get _cssClass => component.raw['className'];

  @override
  Widget build(BuildContext context) {
    if (_content.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Html(data: _content, style: {'p': Style(fontSize: FontSize.medium), 'h2': Style(fontSize: FontSize.larger, fontWeight: FontWeight.w600)}),
    );
  }
}
