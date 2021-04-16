import 'package:flutter/material.dart';

class LinePainter extends CustomPainter {
  final Path path;
  final Color color;

  LinePainter({this.color, this.path}) {
    _paint = Paint()
      ..color = color ?? Colors.black
      ..strokeWidth = 20.0
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round;
  }

  Paint _paint;

  @override
  void paint(Canvas canvas, Size size) {
    // var path = Path();
    // path.moveTo(0, size.height / 2);
    // path.quadraticBezierTo(
    //     size.width / 2, size.height, size.width, size.height / 2);

    // print(size.height / 2);
    //
    // path.moveTo(0, size.height / 2);
    // path.lineTo(size.width * progress, size.height / 2);
    //
    // var circle = Path();
    // circle.addOval(Rect.fromCircle(center: Offset(100, 200), radius: 50));
    //
    // canvas.drawPath(circle, _paint);
    canvas.drawPath(path, _paint);
  }

  @override
  bool shouldRepaint(LinePainter oldDelegate) {
    return true;
    // print("called should");
    // return oldDelegate.path. != path.hashCode;
  }
}
