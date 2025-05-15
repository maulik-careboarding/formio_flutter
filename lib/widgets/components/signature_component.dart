/// A Flutter widget that renders a signature input field based on
/// a Form.io "signature" component.
///
/// Allows the user to draw a signature on a canvas. The signature
/// is captured as a base64-encoded PNG image string.

import 'dart:convert';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../models/component.dart';

class SignatureComponent extends StatefulWidget {
  /// The Form.io component definition.
  final ComponentModel component;

  /// The current signature value as a base64-encoded PNG.
  final String? value;

  /// Callback triggered when the signature is drawn.
  final ValueChanged<String?> onChanged;

  const SignatureComponent({Key? key, required this.component, required this.value, required this.onChanged}) : super(key: key);

  @override
  State<SignatureComponent> createState() => _SignatureComponentState();
}

class _SignatureComponentState extends State<SignatureComponent> {
  final _points = <Offset>[];
  final _globalKey = GlobalKey();

  bool get _isRequired => widget.component.required;

  void _clear() {
    setState(() {
      _points.clear();
    });
    widget.onChanged(null);
  }

  Future<void> _saveSignature() async {
    final boundary = _globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    if (boundary != null) {
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = byteData?.buffer.asUint8List();
      if (pngBytes != null) {
        final base64Image = base64Encode(pngBytes);
        widget.onChanged('data:image/png;base64,$base64Image');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasError = _isRequired && (widget.value == null || _points.isEmpty);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.component.label, style: Theme.of(context).textTheme.labelSmall),
        const SizedBox(height: 8),
        RepaintBoundary(
          key: _globalKey,
          child: Container(
            height: 160,
            decoration: BoxDecoration(border: Border.all(color: Colors.grey), color: Colors.white),
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  RenderBox box = context.findRenderObject() as RenderBox;
                  _points.add(box.globalToLocal(details.globalPosition));
                });
              },
              onPanEnd: (_) => _saveSignature(),
              child: CustomPaint(painter: _SignaturePainter(_points)),
            ),
          ),
        ),
        Row(mainAxisAlignment: MainAxisAlignment.end, children: [TextButton(onPressed: _clear, child: const Text('Clear'))]),
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text('${widget.component.label} is required.', style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 12)),
          ),
      ],
    );
  }
}

class _SignaturePainter extends CustomPainter {
  final List<Offset> points;
  _SignaturePainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.black
          ..strokeWidth = 2.0
          ..strokeCap = StrokeCap.round;
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != Offset.zero && points[i + 1] != Offset.zero) {
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(_SignaturePainter oldDelegate) => true;
}
