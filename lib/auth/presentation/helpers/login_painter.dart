import 'package:flutter/material.dart';

class HeaderLoginPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color.fromRGBO(0, 0, 100, 1)
      ..style = PaintingStyle.fill;

    final path = Path()
      ..lineTo(0, size.height * 0.75)
      ..quadraticBezierTo(
          size.width * 0.5, size.height, size.width, size.height * 0.75)
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
