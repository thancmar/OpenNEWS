import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../../../../pages/reader/page.dart';
import '../effects/flip_effect.dart';

Map<int, ui.Image?> imageData = {};
ValueNotifier<int> currentPage = ValueNotifier(-1);
ValueNotifier<Widget> currentWidget = ValueNotifier(Container());
ValueNotifier<int> currentPageIndex = ValueNotifier(0);
ValueNotifier<Map<int, Size>> imageSizes = ValueNotifier({});

class PageFlipBuilder2 extends StatefulWidget {
  const PageFlipBuilder2(
      {Key? key,
      required this.amount,
      this.backgroundColor,
      required this.child,
      required this.pageIndex,
      required this.isRightSwipe,
      required this.bKey,
      required this.imageSize})
      : super(key: key);

  final Animation<double> amount;
  final int pageIndex;
  final Color? backgroundColor;
  final Widget child;
  final bool isRightSwipe;
  final GlobalKey bKey;
  final Size imageSize;

  @override
  State<PageFlipBuilder2> createState() => PageFlipBuilder2State();
}

class PageFlipBuilder2State extends State<PageFlipBuilder2> {
  final _boundaryKey = GlobalKey();

  void _captureImage(Duration timeStamp, int index) async {
    // widget.child.repaintBoundaryKey.
    // _

    if (widget.bKey.currentContext == null) return;
    await Future.delayed(const Duration(milliseconds: 100));
    if (mounted) {
      final boundary = widget.bKey.currentContext!.findRenderObject()! as RenderRepaintBoundary;
      final image = await boundary.toImage();
      setState(() {
        imageData[index] = image.clone();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: currentPage,
      builder: (context, value, child) {
        if (imageData[widget.pageIndex] != null && value >= 0) {
          return ValueListenableBuilder<Map<int, Size>>(
              valueListenable: imageSizes,
              builder: (context, sizes, child) {
                final boundary = widget.bKey.currentContext!.findRenderObject()! as RenderRepaintBoundary;
                final image =  boundary.toImage();
                // final image =  image.;
                print("image size ${sizes[widget.pageIndex]}");
                Size imageSize = sizes[widget.pageIndex] ?? Size.zero; // Default size if not yet determined
                // imageSize = Size(1600, 2240);
                return imageSize != Size.zero
                    ?Positioned(

                  child: SizedBox(
                          width: imageSize.width,
                          height: imageSize.height,
                          child: CustomPaint(
                      painter: PageFlipEffect2(
                        amount: widget.amount,
                        image: imageData[widget.pageIndex+1]!,
                        backgroundColor: widget.backgroundColor,
                        isRightSwipe: widget.isRightSwipe,
                        imageSize: imageSize
                      ),
                      size: imageSize,
                    ),
                  ),
                )
                    : Container(
                        color: Colors.transparent,
                      );
              });
        } else {
          if (value == widget.pageIndex || (value == (widget.pageIndex + 1))) {
            WidgetsBinding.instance.addPostFrameCallback(
              (timeStamp) => _captureImage(timeStamp, currentPageIndex.value),
            );
          }
          if (widget.pageIndex == currentPageIndex.value || (widget.pageIndex == (currentPageIndex.value + 1))) {
            Size imageSize = Size(1600, 2035);
            return Positioned(
              child: SizedBox(
                // width: imageSize.width,
                // height: imageSize.height*05,
                child: ColoredBox(
                  color: widget.backgroundColor ?? Colors.blue,
                  child: RepaintBoundary(
                    // key: widget.bKey,
                    // key: _boundaryKey,
                    // key: widget.child.repaintBoundaryKey,
                    child: widget.child,
                    // child: Container(color: Colors.red,)
                  ),
                ),
              ),
            );
          } else {
            return Container();
          }
        }
      },
    );
  }
}