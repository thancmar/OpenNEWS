import 'package:flutter/material.dart';

class NavbarPainter extends CustomPainter {
  final int index;
  const NavbarPainter(this.index);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey //Color(0x00ffffff)
      ..strokeWidth = 0.2
      ..style = PaintingStyle.stroke;

    double bendWidth = 15.0;
    double bezierWidth = 10.0;

    double startofBend = ((((index + 1) / 4) * size.width) - ((1 / 4) * size.width) / 2) - 1 - bendWidth / 2;
    double startofBezier = startofBend - bezierWidth;
    double endofBend = (((((index + 1) / 4) * size.width) - ((1 / 4) * size.width) / 2) + 1) + bendWidth / 2;
    double endofBezier = endofBend + bezierWidth;

    double controlHeight = 9.0;
    double centerPoint = (((index + 1) / 4) * size.width) - ((1 / 4) * size.width) / 2;

    double leftControlPoint1 = startofBend;
    double leftControlPoint2 = startofBend;
    double rightControlPoint1 = endofBend;
    double rightControlPoint2 = endofBend;

    Path path = Path();
    path.fillType = PathFillType.evenOdd;
    path.moveTo(0, 0);
    path.lineTo(startofBezier, 0);
    path.cubicTo(leftControlPoint1, 0, leftControlPoint2, controlHeight, centerPoint, controlHeight);
    path.cubicTo(rightControlPoint1, controlHeight, rightControlPoint2, 0, endofBezier, 0);
    path.lineTo(size.width, 0);
    // path.lineTo(size.width, size.height);
    // path.lineTo(0, size.height);
    // path.lineTo(0, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class NavbarClipper extends CustomClipper<Path> {
  final int index;
  const NavbarClipper(this.index);

  @override
  getClip(Size size) {
    // final paint = Paint()
    //   ..color = Colors.white //Color(0x00ffffff)
    //   ..strokeWidth = 0.2
    //   ..style = PaintingStyle.stroke;
    double bendWidth = 15.0;
    double bezierWidth = 10.0;

    double startofBend = ((((index + 1) / 4) * size.width) - ((1 / 4) * size.width) / 2) - 1 - bendWidth / 2;
    double startofBezier = startofBend - bezierWidth;
    double endofBend = (((((index + 1) / 4) * size.width) - ((1 / 4) * size.width) / 2) + 1) + bendWidth / 2;
    double endofBezier = endofBend + bezierWidth;

    double controlHeight = 9.0;
    double centerPoint = (((index + 1) / 4) * size.width) - ((1 / 4) * size.width) / 2;

    double leftControlPoint1 = startofBend;
    double leftControlPoint2 = startofBend;
    double rightControlPoint1 = endofBend;
    double rightControlPoint2 = endofBend;

    Path path = Path();
    path.fillType = PathFillType.evenOdd;
    // print(size.height);
    path.moveTo(0, 0);
    path.lineTo(startofBezier, 0);
    path.cubicTo(leftControlPoint1, 0, leftControlPoint2, controlHeight, centerPoint, controlHeight);
    path.cubicTo(rightControlPoint1, controlHeight, rightControlPoint2, 0, endofBezier, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, 0);
    path.close();
    // canvas.drawPath(path, paint);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

// class NavBarPainter extends CustomClipper<Rect> {
//   final int index;
//   const NavBarPainter(this.index);
//   @override
//   Rect getClip(Size size) {
//     Rect rect = Rect.fromLTRB(0, 0, size.width, size.height);
//     double bendWidth = 15.0;
//     double bezierWidth = 30.0;
//
//     double startofBend =
//         ((((index + 1) / 4) * rect.width) - ((1 / 4) * rect.width) / 2) -
//             1 -
//             (bendWidth / 2);
//     double startofBezier = startofBend - bezierWidth;
//     double endofBend =
//         ((((index + 1) / 4) * rect.width) - 2 * ((1 / 4) * rect.width) / 2) +
//             1 +
//             bendWidth / 2;
//     double endofBezier = endofBend + bezierWidth;
//
//     double controlHeight = 15.0;
//     double centerPoint =
//         (((index + 1) / 4) * rect.width) - ((1 / 4) * rect.width) / 2;
//
//     double leftControlPoint1 = startofBend;
//     double leftControlPoint2 = startofBend;
//     double rightControlPoint1 = endofBend;
//     double rightControlPoint2 = endofBend;
//
//     rect;
//     return rect;
//   }
//
//   @override
//   bool shouldReclip(NavBarPainter oldClipper) {
//     return true;
//   }
// }

// class NavBarPainter extends ShapeBorder {
//   final int index;
//   const NavBarPainter(this.index);
//
//   @override
//   EdgeInsetsGeometry get dimensions => EdgeInsets.all(0);
//
//   @override
//   Path getInnerPath(Rect rect, {TextDirection? textDirection}) =>
//       null ?? Path();
//
//   @override
//   Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
//     rect = Rect.fromPoints(rect.topRight, rect.topRight);
//     print("topleft");
//     print(rect.topLeft);
//
//     double bendWidth = 15.0;
//     double bezierWidth = 30.0;
//
//     double startofBend =
//         ((((index + 1) / 4) * rect.width) - ((1 / 4) * rect.width) / 2) -
//             1 -
//             (bendWidth / 2);
//     double startofBezier = startofBend - bezierWidth;
//     double endofBend =
//         ((((index + 1) / 4) * rect.width) - 2 * ((1 / 4) * rect.width) / 2) +
//             1 +
//             bendWidth / 2;
//     double endofBezier = endofBend + bezierWidth;
//
//     double controlHeight = 15.0;
//     double centerPoint =
//         (((index + 1) / 4) * rect.width) - ((1 / 4) * rect.width) / 2;
//
//     double leftControlPoint1 = startofBend;
//     double leftControlPoint2 = startofBend;
//     double rightControlPoint1 = endofBend;
//     double rightControlPoint2 = endofBend;
//
//     Path path = Path();
//     // path.addRRect(RRect.fromRectAndRadius(rect, Radius.circular(rect.height)));
//     // path.moveTo(rect.bottomCenter.dx - 10, rect.bottomCenter.dy);
//     // print(rect.topLeft.dx);
//     // print(rect.topLeft.dy);
//     // print(startofBezier);
//     // print(endofBezier);
//     // print(rect.width);
//     path.relativeMoveTo(0, 760);
//     // path.lineTo(rect.topLeft.dx, rect.topLeft.dy);
//     path.relativeLineTo(startofBezier, rect.topLeft.dy);
//     path.relativeCubicTo(leftControlPoint1, 400, leftControlPoint2,
//         controlHeight, centerPoint, controlHeight);
//     path.relativeCubicTo(rightControlPoint1, 400, rightControlPoint2,
//         -controlHeight, endofBezier, -controlHeight);
//
//     // path.lineTo(rect.width, rect.topLeft.dy);
//     path.lineTo(rect.topRight.dx, rect.topRight.dy);
//     path.lineTo(rect.bottomRight.dx, rect.bottomRight.dy);
//     path.lineTo(rect.bottomLeft.dx, rect.bottomLeft.dy);
//     path.close();
//     return path;
//     // return Path()
//     //   ..addRRect(
//     //       RRect.fromRectAndRadius(rect, Radius.circular(rect.height / 2)))
//     //   ..moveTo(rect.bottomCenter.dx - 10, rect.bottomCenter.dy)
//     //   ..relativeLineTo(10, 20)
//     //   ..relativeLineTo(20, -20)
//     //   ..close();
//
//     // rect = Rect.fromPoints(rect.topLeft, rect.bottomRight - Offset(0, 20));
//     // return Path()
//     //   ..addRRect(
//     //       RRect.fromRectAndRadius(rect, Radius.circular(rect.height / 2)))
//     //   ..moveTo(rect.bottomCenter.dx - 10, rect.bottomCenter.dy)
//     //   ..relativeLineTo(10, 20)
//     //   ..relativeLineTo(20, -20)
//     //   ..close();
//   }
//
//   @override
//   void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
//     final Paint borderPaint = Paint()
//       ..color = Colors.white //Color(0x00ffffff)
//       ..strokeWidth = 0.2
//       ..style = PaintingStyle.stroke;
//
//     double bendWidth = 15.0;
//     double bezierWidth = 10.0;
//
//     double startofBend = ((((index + 1) / 4) * rect.size.width) -
//             ((1 / 4) * rect.size.width) / 2) -
//         1 -
//         bendWidth / 2;
//     double startofBezier = startofBend - bezierWidth;
//     double endofBend = (((((index + 1) / 4) * rect.size.width) -
//                 ((1 / 4) * rect.size.width) / 2) +
//             1) +
//         bendWidth / 2;
//     double endofBezier = endofBend + bezierWidth;
//
//     double controlHeight = 9.0;
//     double centerPoint =
//         (((index + 1) / 4) * rect.size.width) - ((1 / 4) * rect.size.width) / 2;
//
//     double leftControlPoint1 = startofBend;
//     double leftControlPoint2 = startofBend;
//     double rightControlPoint1 = endofBend;
//     double rightControlPoint2 = endofBend;
//
//     Path path = Path();
//     path.moveTo(0, 400);
//     path.lineTo(startofBezier, 400);
//     path.cubicTo(leftControlPoint1, 0, leftControlPoint2, controlHeight,
//         centerPoint, controlHeight);
//     path.cubicTo(rightControlPoint1, controlHeight, rightControlPoint2, 0,
//         endofBezier, 0);
//     path.lineTo(rect.size.width, 0);
//     // path.close();
//     var path1 = getOuterPath(rect.deflate(rect.width / 2.0),
//         textDirection: textDirection);
//     canvas.drawPath(path1, borderPaint);
//
//     // canvas.drawPath(getOuterPath(rect), borderPaint);
//   }
//
//   @override
//   ShapeBorder scale(double t) => this;
// }

// class NavBarPainter extends ShapeBorder {
//   // final int index;
//   NavBarPainter();
//
//   @override
//   EdgeInsetsGeometry get dimensions => EdgeInsets.zero;
//
//   @override
//   Path getInnerPath(Rect rect, {TextDirection? textDirection}) =>
//       null ?? Path();
//
//   double holeSize = 70;
//
//   @override
//   Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
//     print(rect.height);
//     return Path.combine(
//       PathOperation.difference,
//       Path()
//         ..addRRect(
//             RRect.fromRectAndRadius(rect, Radius.circular(rect.height / 2.5)))
//         ..close(),
//       Path()
//         ..addOval(Rect.fromCenter(
//             center: rect.center.translate(0, -rect.height / 2),
//             height: holeSize,
//             width: holeSize))
//         ..close(),
//     );
//   }
//
//   @override
//   void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}
//
//   @override
//   ShapeBorder scale(double t) => this;
// }

// class NavBarPainter extends ShapeBorder {
//   final int index;
//   NavBarPainter(this.index);
//   @override
//   Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
//     Offset controllPoint1 = Offset(100, rect.size.height - 100);
//     Offset endPoint1 = Offset(100, rect.size.height - 100);
//     Offset controllPoint2 = Offset(rect.size.width, rect.size.height - 100);
//     Offset endPoint2 = Offset(rect.size.width, rect.size.height - 200);
//
//     return Path()
//       ..lineTo(0, rect.size.height)
//       ..quadraticBezierTo(
//           controllPoint1.dx, controllPoint1.dy, endPoint1.dx, endPoint1.dy)
//       ..lineTo(rect.size.width - 100, rect.size.height - 100)
//       ..quadraticBezierTo(
//           controllPoint2.dx, controllPoint2.dy, endPoint2.dx, endPoint2.dy)
//       ..lineTo(rect.size.width, 0);
//   }
//
//   @override
//   EdgeInsetsGeometry get dimensions => EdgeInsets.only(bottom: 0);
//
//   @override
//   Path getInnerPath(Rect rect, {TextDirection? textDirection}) =>
//       null ?? Path();
//
//   @override
//   void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}
//
//   @override
//   ShapeBorder scale(double t) => this;
// }