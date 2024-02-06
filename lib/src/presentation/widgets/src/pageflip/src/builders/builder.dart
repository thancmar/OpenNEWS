import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../../../../pages/reader/page.dart';
import '../effects/flip_effect.dart';

Map<int, ui.Image?> imageData = {};
ValueNotifier<int> currentPage = ValueNotifier(-1);
// ValueNotifier<Widget> currentWidget = ValueNotifier(Container());
ValueNotifier<int> currentPageIndex = ValueNotifier(0);

class PageFlipBuilder extends StatefulWidget {
  const PageFlipBuilder({
    Key? key,
    required this.amount,
    this.backgroundColor,
    required this.child,
    required this.pageIndex,
    required this.isRightSwipe,
  }) : super(key: key);

  final Animation<double> amount;
  final int pageIndex;
  final Color? backgroundColor;
  final ReaderPage child;
  final bool isRightSwipe;

  @override
  State<PageFlipBuilder> createState() => PageFlipBuilderState();
}

class PageFlipBuilderState extends State<PageFlipBuilder> with SingleTickerProviderStateMixin {
  final _boundaryKey = GlobalKey();

  // void _captureImage(Duration timeStamp, int index) async {
  //   // widget.child.repaintBoundaryKey.
  //   // _
  //
  //   if (widget.child.repaintBoundaryKey.currentContext == null) return;
  //   await Future.delayed(const Duration(milliseconds: 100));
  //   if (mounted) {
  //     final boundary = widget.child.repaintBoundaryKey.currentContext!.findRenderObject()! as RenderRepaintBoundary;
  //     final image = await boundary.toImage();
  //     setState(() {
  //       imageData[index] = image.clone();
  //     });
  //   }
  // }
  Future<ui.Image> resizeImage(ui.Image originalImage, Size newSize) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final paint = Paint()..filterQuality = FilterQuality.high;
    final src = Rect.fromLTWH(0, 0, originalImage.width.toDouble(), originalImage.height.toDouble());
    final dst = Rect.fromLTWH(0, 0, newSize.width, newSize.height);
    canvas.drawImageRect(originalImage, src, dst, paint);
    final picture = recorder.endRecording();
    return picture.toImage(newSize.width.toInt(), newSize.height.toInt());
  }

  void _captureImage(Duration timeStamp, int index) async {
    // if (_boundaryKey.currentContext == null) return;
    // await Future.delayed(const Duration(milliseconds: 100));
    // if (mounted) {
    //   // final boundary = _boundaryKey.currentContext!.findRenderObject()!
    //   final boundary = widget.child.reader.allImagekey[widget.pageIndex].currentContext!.findRenderObject()!
    //   as RenderRepaintBoundary;
    //   final image = await boundary.toImage();
    //   setState(() {
    //     imageData[index] = image.clone();
    //   });
    // }

    // return picture.toImage(newSize.width.toInt(), newSize.height.toInt());

    // if (_boundaryKey.currentContext == null) return;
    // if (widget.child.reader.allImagekey[widget.pageIndex].currentContext == null) return;
    if (widget.child.reader.allImageData![index] == null) return;
    // await Future.delayed(const Duration(milliseconds: 100));
    ui.Codec codec = await ui.instantiateImageCodec(widget.child.reader.allImageData![index]!);
    ui.FrameInfo frameInfo = await codec.getNextFrame();
    ui.Image image = frameInfo.image;
    if (mounted) {
      // final RenderRepaintBoundary boundary = _boundaryKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      // final double pixelRatio = MediaQuery.of(context).devicePixelRatio;
      // final ui.Image image = await boundary.toImage(pixelRatio: pixelRatio);
      // final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      // final Uint8List pngBytes = byteData!.buffer.asUint8List();

      // final RenderBox renderBox =  widget.child.reader.allImagekey[widget.pageIndex].currentContext?.findRenderObject() as RenderBox;
      // print("image is ${renderBox.size}");

      // ui.Image resizedImage = await resizeImage(image , Size(800,800));

      setState(() {
        if (imageData != null) {
          // imageData[index] = image;

          imageData[index] = image;
        }
        // Convert the Uint8List to an Image widget
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: currentPage,
      builder: (context, value, child) {

        if (imageData[widget.pageIndex] != null ) {
          return CustomPaint(
            painter: PageFlipEffect(
              amount: widget.amount,
              image: imageData[widget.pageIndex]!,
              backgroundColor: widget.backgroundColor,
              isRightSwipe: widget.isRightSwipe,
            ),
            size: Size.infinite,
          );
        } else {
          if (value == widget.pageIndex || (value == (widget.pageIndex + 1))) {
            WidgetsBinding.instance.addPostFrameCallback(
                  (timeStamp) => _captureImage(timeStamp, currentPageIndex.value),
            );
          }
          if (widget.pageIndex == currentPageIndex.value ||
              (widget.pageIndex == (currentPageIndex.value + 1))) {
            return ColoredBox(
              color: widget.backgroundColor ?? Colors.black12,
              child: RepaintBoundary(
                key: _boundaryKey,
                child: widget.child,
              ),
            );
          } else {
            return Container();
          }
        }
      },
    );
    // Size size = MediaQuery.of(context).size;
    // // bool shouldShowCustomPaint = imageData[widget.pageIndex] != null && value >= 0;
    //
    // // print("screen is ${size}");
    // return ValueListenableBuilder<int>(
    //   valueListenable: currentPage,
    //   builder: (context, value, child) {
    //     Widget content;
    //
    //     if (imageData[widget.pageIndex] != null && value >= 0) {
    //       content = CustomPaint(
    //         painter: PageFlipEffect(
    //           amount: widget.amount,
    //           image: imageData[widget.pageIndex]!,
    //           backgroundColor: widget.backgroundColor,
    //           isRightSwipe: widget.isRightSwipe,
    //         ),
    //         size: Size.infinite,
    //       );
    //     } else {
    //       if (value == widget.pageIndex || (value == (widget.pageIndex + 1))) {
    //         WidgetsBinding.instance.addPostFrameCallback(
    //               (timeStamp) => _captureImage(timeStamp, currentPageIndex.value),
    //         );
    //       }
    //       if (widget.pageIndex == currentPageIndex.value ) {
    //         content = ColoredBox(
    //           color: widget.backgroundColor ?? Colors.black12,
    //           child: RepaintBoundary(
    //             key: _boundaryKey,
    //             child: widget.child,
    //           ),
    //         );
    //       } else {
    //         content = Container();
    //       }
    //     }
    //     // Wrap the content in an AnimatedSwitcher for smooth transitions
    //     return Visibility(
    //       visible: widget.pageIndex == currentPageIndex.value||(widget.pageIndex == (currentPageIndex.value + 1)),
    //       child: AnimatedSwitcher(
    //         duration: const Duration(milliseconds: 500),
    //         child: content,
    //         transitionBuilder: (Widget child, Animation<double> animation) {
    //           return FadeTransition(
    //             opacity: animation,
    //             child: child,
    //           );
    //         },
    //       ),
    //     );
    //       // ],
    //     // );
    //     // } else {
    //     //   if (value == widget.pageIndex || (value == (widget.pageIndex + 1))) {
    //     //     WidgetsBinding.instance.addPostFrameCallback(
    //     //       (timeStamp) => _captureImage(
    //     //         timeStamp,
    //     //         currentPageIndex.value,
    //     //       ), //size),
    //     //     );
    //     //   }
    //     //   if (widget.pageIndex == currentPageIndex.value || (widget.pageIndex == (currentPageIndex.value + 1))) {
    //     //     //
    //     //     // if (widget.pageIndex == currentPageIndex.value ) {
    //     //     print("flik");
    //     //     // return ColoredBox(
    //     //     //   color: widget.backgroundColor ?? Colors.black12,
    //     //     //   child: RepaintBoundary(
    //     //     //     // key: widget.child.reader.allImagekey[widget.pageIndex],
    //     //     //     // key: _boundaryKey,
    //     //     //     // key: widget.child.repaintBoundaryKey,
    //     //     //     child: widget.child,
    //     //     //   ),
    //     //     // );
    //     //     return AnimatedOpacity(
    //     //       duration: Duration(milliseconds: 500), // Set the desired duration
    //     //       opacity: 1, // Set the desired opacity value here (0.0 to 1.0)
    //     //
    //     //       child: Container(
    //     //         color: Colors.red,
    //     //         child: widget.child,
    //     //       ),
    //     //     );
    //     //   } else {
    //     //     return Container(
    //     //       color: Colors.green,
    //     //       height: 100,
    //     //     );
    //     //   }
    //     // }
    //   },
    // );
  }
}