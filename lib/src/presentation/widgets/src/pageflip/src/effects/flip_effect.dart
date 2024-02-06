import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PageFlipEffect extends CustomPainter {
  PageFlipEffect({
    required this.amount,
    required this.image,
    this.backgroundColor,
    this.radius = 0.18,
    required this.isRightSwipe,
  }) : super(repaint: amount);

  final Animation<double> amount;
  final ui.Image image;
  final Color? backgroundColor;
  final double radius;
  final bool isRightSwipe;

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    final pos = isRightSwipe ? 1.0 - amount.value : amount.value;
    final movX = isRightSwipe ? pos : (1.0 - pos) * 0.85;
    final calcR = (movX < 0.20) ? radius * movX * 5 : radius;
    final wHRatio = 1 - calcR;
    final hWRatio = image.height / image.width;
    final hWCorrection = (hWRatio - 1.0) / 2.0;

    final w = size.width.toDouble();
    final h = size.height.toDouble();
    final c = canvas;
    final shadowXf = (wHRatio - movX);
    final shadowSigma = isRightSwipe
        ? Shadow.convertRadiusToSigma(8.0 + (32.0 * shadowXf))
        : Shadow.convertRadiusToSigma(8.0 + (32.0 * (1.0 - shadowXf)));
    final pageRect = isRightSwipe
        ? Rect.fromLTRB(w, 0.0, w * movX, h)
        : Rect.fromLTRB(0.0, 0.0, w * shadowXf, h);

    final canvasAspectRatio = size.width / size.height;
    final imageAspectRatio = image.width / image.height;

    // Determine the scaling factor
    double scaleFactor;
    if (canvasAspectRatio > imageAspectRatio) {
      scaleFactor = size.height / image.height;
    } else {
      scaleFactor = size.width / image.width;
    }

    // Calculate the width and height to draw the image
    final scaledImageWidth = image.width * scaleFactor;
    final scaledImageHeight = image.height * scaleFactor;

    // Calculate offsets to center the image
    final xOffset = (size.width - scaledImageWidth) / 2;
    final yOffset = (size.height - scaledImageHeight) / 2;

    // if (isRightSwipe ? amount.value != 0 : pos != 0) {
    //   c.drawRect(
    //     pageRect,
    //     Paint()
    //       ..color = Colors.transparent
    //       ..maskFilter = MaskFilter.blur(BlurStyle.outer, shadowSigma),
    //   );
    // }

    final ip = Paint() ..filterQuality = FilterQuality.high;
    for (double x = 0; x < size.width; x=x+0.25) {
      final xf = (x / w);
      final baseValue = isRightSwipe
          ? math.cos(math.pi / 0.5 * (xf + pos))
          : math.sin(math.pi / 0.5 * (xf - (1.0 - pos)));
      final v = calcR * (baseValue + 1.1);
      final xv = isRightSwipe ? (xf * wHRatio) + movX : (xf * wHRatio) - movX;
      // final sx = (xf * image.width);
      // final sr = Rect.fromLTRB(sx, 0.0, sx + 1.0, image.height.toDouble());
      final yv = ((h * calcR * movX) * hWRatio) - hWCorrection;
      final ds = (yv * v);
      // final dr = Rect.fromLTRB(xv * w, 0.0 - ds, xv * w + 1.1, h + ds);

      // Adjust source rect (sr) and destination rect (dr) to include offsets for centering
      final sx = (x / scaledImageWidth) * image.width;
      final sy = 0.0;
      // Adjust source rect (sr) and destination rect (dr) to include offsets for centering
      final sr = Rect.fromLTRB(sx, 0.0, sx + 1.0, image.height.toDouble());
      final dr = Rect.fromLTRB(xOffset + xv * w, yOffset - ds, xOffset + xv * w + 1.1, h-yOffset );


      // Draw the image

      c.drawImageRect(image, sr, dr, ip);
    }
  }

  @override
  bool shouldRepaint(PageFlipEffect oldDelegate) {
    return oldDelegate.image != image ||
        oldDelegate.amount.value != amount.value;
  }
}

class PageFlipClipper extends CustomClipper<Path> {
  final double animationValue; // Represents the current state of the flip animation
  final bool isRightSwipe;
  final double radius;

  PageFlipClipper({required this.animationValue, this.radius = 0.18, required this.isRightSwipe});

  @override
  Path getClip(Size size) {
    final Path path = Path();

    final pos = isRightSwipe ? 1.0 - animationValue : animationValue;
    final movX = isRightSwipe ? pos : (1.0 - pos) * 0.85;
    final calcR = (movX < 0.20) ? radius * movX * 5 : radius;
    final wHRatio = 1 - calcR;

    final w = size.width.toDouble();
    final h = size.height.toDouble();

    // Define the clipping path based on the current animation state
    if (isRightSwipe) {
      // For right swipe
      path.moveTo(w * movX, 0);
      path.lineTo(w, 0);
      path.lineTo(w, h);
      path.lineTo(w * movX, h);
    } else {
      // For left swipe or normal flip
      path.moveTo(0, 0);
      path.lineTo(w * movX, 0);
      path.lineTo(w * movX, h);
      path.lineTo(0, h);
    }

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    // Reclip when the animation value changes
    return (oldClipper as PageFlipClipper).animationValue != animationValue;
  }
}