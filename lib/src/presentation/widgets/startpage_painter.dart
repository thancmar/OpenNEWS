import 'package:flutter/material.dart';

class TsClip1 extends CustomClipper<Path> {
  final GlobalKey key;
  TsClip1(this.key);
  @override
  Path getClip(Size size) {
    final RenderBox renderBox = key.currentContext?.findRenderObject() as RenderBox;
    Offset position = renderBox.localToGlobal(Offset.zero);
    // print(renderBox);
    // final path = Path()
    //   ..fillType = PathFillType.evenOdd
    //   ..moveTo(0, renderBox.size.height);
    //
    // path.lineTo(0, 0);
    // path.lineTo(size.height, 90);
    // path.lineTo(size.height, size.width);
    // // path.lineTo(0, size.height);
    // path.close();
    //
    // return path;
    final rect = Rect.fromLTRB(0, 0, size.width, size.height);
    print("renderbox height ${renderBox.size.width}");
    print(" height ${size.width}");
    final path = Path()
      ..fillType = PathFillType.evenOdd
      // ..moveTo(100, renderBox.size.height + 100)
      ..addRRect(
          RRect.fromRectAndRadius(Rect.fromLTRB(position.dx, position.dy, (size.width - renderBox.size.width) / 2 + renderBox.size.width, renderBox.size.height + position.dy), Radius.circular(20))
          // Rect.fromCenter(center: renderBox.size.center(Offset(size.width / 2, size.height / 2)), width: renderBox.size.width, height: renderBox.size.height),
          )
      // ..addRect(
      //   // RRect.fromRectAndRadius(rect, Radius.circular(10))
      //   Rect.fromCenter(center: renderBox.size.center(Offset(size.width / 2, size.height / 2)), width: renderBox.size.width, height: renderBox.size.height),
      // )
      ..addRect(rect);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}