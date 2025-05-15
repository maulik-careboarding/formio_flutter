/// A Flutter widget that renders static HTML content based on a
/// Form.io "htmlelement" component.
///
/// This component is read-only and used for displaying custom HTML
/// such as paragraphs, headers, separators, and basic formatting.

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../models/component.dart';

class HtmlElementComponent extends StatelessWidget {
  /// The Form.io component definition.
  final ComponentModel component;

  const HtmlElementComponent({Key? key, required this.component}) : super(key: key);

  /// Raw HTML content to display.
  String get _htmlContent => component.raw['tag'] == 'hr' ? '<hr/>' : component.raw['content']?.toString() ?? '';

  /// Optional CSS class (unused by default).
  // String? get _cssClass => component.raw['className'];

  @override
  Widget build(BuildContext context) {
    if (_htmlContent.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Html(
        data: _htmlContent,
        style: {
          // Optionally apply styling based on tag types
          'h1': Style(fontSize: FontSize.xxLarge),
          'p': Style(fontSize: FontSize.medium),
          'hr': Style(margin: Margins.only(top: 12, bottom: 12)),
        },
      ),
    );
  }
}
