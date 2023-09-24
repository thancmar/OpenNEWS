import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class InnerClipper extends CustomClipper<Path> {
  final double height;
  final double width;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final double borderWidth;

  InnerClipper({
    required this.height,
    required this.width,
    required this.borderRadius,
    required this.padding,
    this.borderWidth = 0.10,
  });

  @override
  Path getClip(Size size) {
    final path = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    final resolvedPadding = padding.resolve(TextDirection.ltr);

    // No need to adjust contentWidth and contentHeight for borderWidth as the border should remain visible.
    final contentWidth = size.width - resolvedPadding.left - resolvedPadding.right;
    final contentHeight = size.height - resolvedPadding.top - resolvedPadding.bottom;

    // No need to add borderWidth to left and top as it should not affect the position of the cut-out area.
    final left = resolvedPadding.left;
    final top = height + resolvedPadding.top;

    // Adjust the width and height of the cut-out rectangle to ensure the border remains visible.
    final rect = Rect.fromLTWH(
        left,
        top,
        width - (resolvedPadding.left + resolvedPadding.right),
        height - (resolvedPadding.top + resolvedPadding.bottom)
    );
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(borderRadius));
    final cutoutPath = Path()..addRRect(rrect);

    return Path.combine(PathOperation.difference, path, cutoutPath);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}