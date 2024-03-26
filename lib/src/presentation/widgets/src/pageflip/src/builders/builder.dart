import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

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
    required this.orientation,
    required this.imageDataCache,
  }) : super(key: key);

  final Animation<double> amount;
  final int pageIndex;
  final Color? backgroundColor;
  final Widget child;
  final bool isRightSwipe;
  final Orientation orientation;
  final List<Uint8List?> imageDataCache;

  @override
  State<PageFlipBuilder> createState() => PageFlipBuilderState();
}

class PageFlipBuilderState extends State<PageFlipBuilder> with SingleTickerProviderStateMixin {
  final _boundaryKey = GlobalKey();

  void _captureImage(Duration timeStamp, int index) async {

    if (widget.imageDataCache[index] == null) return;
    // await Future.delayed(const Duration(milliseconds: 100));
    ui.Codec codec = await ui.instantiateImageCodec(widget.imageDataCache[index]!);
    ui.FrameInfo frameInfo = await codec.getNextFrame();
    ui.Image image = frameInfo.image;
    if (mounted) {

      setState(() {
        // imageData[index] = image;

        imageData[index] = image;
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
          final bool isLandscape = (widget.orientation==Orientation.landscape);
          return CustomPaint(
            painter: PageFlipEffect(
              amount: widget.amount,
              image: imageData[widget.pageIndex]!,
              backgroundColor: widget.backgroundColor,
              isRightSwipe: widget.isRightSwipe,
              isLanscape:isLandscape,
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