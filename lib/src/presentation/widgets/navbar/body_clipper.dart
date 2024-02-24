import 'package:flutter/material.dart';

class BodyClipper extends CustomClipper<Path> {
  final int index;
  final BuildContext context;
  final GlobalKey? navbarkey;
  final GlobalKey fabkey;

  const BodyClipper({required this.index, required this.context, required this.navbarkey,required this.fabkey});

  @override
  getClip(Size size) {


    double bendWidth = 15.0;
    double bezierWidth = 10.0;

    double startofBend = ((((index + 1) / 4) * size.width) - ((1 / 4) * size.width) / 2) - 1 - bendWidth / 2;
    double startofBezier = startofBend - bezierWidth;
    double endofBend = (((((index + 1) / 4) * size.width) - ((1 / 4) * size.width) / 2) + 1) + bendWidth / 2;
    double endofBezier = endofBend + bezierWidth;

    double controlHeight = 9;
    double centerPoint = (((index + 1) / 4) * size.width) - ((1 / 4) * size.width) / 2;

    double leftControlPoint1 = startofBend;
    double leftControlPoint2 = startofBend;
    double rightControlPoint1 = endofBend;
    double rightControlPoint2 = endofBend;

    Path path = Path()..fillType = PathFillType.evenOdd;
    if (navbarkey != null && navbarkey!.currentContext !=null) {
      final RenderBox renderBoxNavbar = navbarkey!.currentContext!.findRenderObject() as RenderBox;
      // final RenderBox fabRenderBox = fabkey.currentContext!.findRenderObject() as RenderBox;
      // final fabSize = fabRenderBox.size;

      path.lineTo(0.0, 0.0);
      // print("render");
      // print(size.height);

      path.lineTo(0, size.height - renderBoxNavbar.size.height);
      path.lineTo(startofBezier, size.height - renderBoxNavbar.size.height);
      path.cubicTo(leftControlPoint1, size.height - renderBoxNavbar.size.height, leftControlPoint2,
          controlHeight + (size.height - renderBoxNavbar.size.height), centerPoint, controlHeight + size.height - renderBoxNavbar.size.height);
      path.cubicTo(rightControlPoint1, controlHeight + size.height - renderBoxNavbar.size.height, rightControlPoint2,
          size.height - renderBoxNavbar.size.height, endofBezier, size.height - renderBoxNavbar.size.height);
      // if(fabkey?.currentContext !=null)

      // {
      //   // Positioning for the center notch
      //   // double centerNotchWidth = fabSize.width+70;  // Get width from FAB size
      //   double centerNotchWidth = size.width / 5; // Get width from FAB size
      //   double centerStart = (size.width / 2) - centerNotchWidth / 2;
      //   double centerEnd = (size.width / 2) + centerNotchWidth / 2;
      //   // double centerNotchDepth = fabSize.height / 2;  // Half of the FAB's height
      //   double centerNotchDepth = renderBoxNavbar.size.height * 0.2; // Half of the FAB's height
      //
      //   // Drawing the center notch for FloatingActionButton to match its circular shape
      //   path.lineTo(centerStart, size.height - renderBoxNavbar.size.height);
      //   path.cubicTo(centerStart + centerNotchWidth / 4, size.height - renderBoxNavbar.size.height, centerStart + centerNotchWidth / 4,
      //       size.height - renderBoxNavbar.size.height + centerNotchDepth, size.width / 2, size.height - renderBoxNavbar.size.height + centerNotchDepth);
      //   path.cubicTo(centerEnd - centerNotchWidth / 4, size.height - renderBoxNavbar.size.height + centerNotchDepth, centerEnd - centerNotchWidth / 4,
      //       size.height - renderBoxNavbar.size.height, centerEnd, size.height - renderBoxNavbar.size.height);
      // }

      path.lineTo(size.width, size.height - renderBoxNavbar.size.height);
      path.lineTo(size.width, 0);
      return path;
    }else{
    // path.lineTo(0, 0);
      path.lineTo(0.0, 0.0);
      path.lineTo(0, size.height);
      path.lineTo(size.width, size.height );
      path.lineTo(size.width, 0);
      return path;}
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}