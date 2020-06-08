import 'package:flutter/material.dart';

import 'package:flutter_custom_paint_playground/node.dart';

class GraphCustomPainter extends CustomPainter {
  final List<Node> _nodes;

  GraphCustomPainter(this._nodes);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Colors.blueGrey;

    Paint paintLine = Paint()
      ..color = Colors.blueGrey
      ..strokeWidth = 2.0;

    for (Node node in _nodes) {
      if (node != null) {
        _drawArcs(node, canvas, paintLine);
      }
    }

    for (Node node in _nodes) {
      if (node != null) {
        _drawNodes(canvas, node, paint);
      }
    }
  }

  void _drawNodes(Canvas canvas, Node node, Paint paint) {
    canvas.drawCircle(node.position, 16.0, paint);

    TextSpan textSpan = TextSpan(
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      text: node.name,
    );

    TextPainter textPainter = TextPainter(
      text: textSpan,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();

    textPainter.paint(
      canvas,
      Offset(
        node.position.dx - textPainter.width / 2,
        node.position.dy - 8,
      ),
    );
  }

  void _drawArcs(Node node, Canvas canvas, Paint paintLine) {
    if (node.neighbors != null) {
      for (Node neighbor in node.neighbors) {
        canvas.drawLine(node.position, neighbor.position, paintLine);
      }
    }
  }

  @override
  bool shouldRepaint(GraphCustomPainter other) => other != this;
}
