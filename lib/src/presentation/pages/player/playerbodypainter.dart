import 'package:flutter/material.dart';

class PlayerBodyPainter extends CustomClipper<Path> {
  final int index;
  final BuildContext context;
  final GlobalKey key;
  const PlayerBodyPainter(
      {required this.index, required this.context, required this.key});

  @override
  getClip(Size size) {
    double bendWidth = 35.0;
    double bezierWidth = 35.0;

    double startofBend = (size.width * 0.5) - bendWidth;
    double startofBezier = startofBend - bezierWidth;
    double endofBend = (size.width * 0.5) + bendWidth;
    double endofBezier = endofBend + bezierWidth;

    double controlHeight = 40;
    // double centerPoint = (((index + 1) / 4) * size.width) - ((1 / 4) * size.width) / 2;
    double centerPoint = (size.width) / 2;

    double leftControlPoint1 = startofBend;
    double leftControlPoint2 = startofBend;
    double rightControlPoint1 = endofBend;
    double rightControlPoint2 = endofBend;

    Path path = Path()..fillType = PathFillType.evenOdd;
    final RenderBox renderBoxNavbar =
        key.currentContext!.findRenderObject() as RenderBox;
    path.lineTo(0.0, 0.0);
    print("render");
    print(size.height);

    path.lineTo(0, size.height - renderBoxNavbar.size.height);
    path.lineTo(startofBezier, size.height - renderBoxNavbar.size.height);
    path.cubicTo(
        leftControlPoint1,
        size.height - renderBoxNavbar.size.height,
        leftControlPoint2,
        controlHeight + (size.height - renderBoxNavbar.size.height),
        centerPoint,
        controlHeight + size.height - renderBoxNavbar.size.height);
    path.cubicTo(
        rightControlPoint1,
        controlHeight + size.height - renderBoxNavbar.size.height,
        rightControlPoint2,
        size.height - renderBoxNavbar.size.height,
        endofBezier,
        size.height - renderBoxNavbar.size.height);
    path.lineTo(size.width, size.height - renderBoxNavbar.size.height);
    path.lineTo(size.width, 0);
    // path.lineTo(0, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
