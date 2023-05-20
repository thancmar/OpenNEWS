import 'package:flutter/material.dart';

class BodyClipper extends CustomClipper<Path> {
  final int index;
  final BuildContext context;
  final GlobalKey key;
  const BodyClipper(
      {required this.index, required this.context, required this.key});

  @override
  getClip(Size size) {
    double bendWidth = 15.0;
    double bezierWidth = 10.0;

    double startofBend =
        ((((index + 1) / 4) * size.width) - ((1 / 4) * size.width) / 2) -
            1 -
            bendWidth / 2;
    double startofBezier = startofBend - bezierWidth;
    double endofBend =
        (((((index + 1) / 4) * size.width) - ((1 / 4) * size.width) / 2) + 1) +
            bendWidth / 2;
    double endofBezier = endofBend + bezierWidth;

    double controlHeight = 9;
    double centerPoint =
        (((index + 1) / 4) * size.width) - ((1 / 4) * size.width) / 2;

    double leftControlPoint1 = startofBend;
    double leftControlPoint2 = startofBend;
    double rightControlPoint1 = endofBend;
    double rightControlPoint2 = endofBend;

    Path path = Path()..fillType = PathFillType.evenOdd;
    final RenderBox renderBoxNavbar =
        key.currentContext!.findRenderObject() as RenderBox;
    path.lineTo(0.0, 0.0);
    // print("render");
    // print(size.height);

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
