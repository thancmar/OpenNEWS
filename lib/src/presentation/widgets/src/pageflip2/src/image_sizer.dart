

import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';


import 'package:flutter/material.dart';

import 'builders/builder.dart';

class ImageSizer extends StatefulWidget {
  final Uint8List imageData;
  final int index;
  final GlobalKey bKey;

  const ImageSizer({Key? key, required this.imageData, required this.index,required this.bKey})
      : super(key: key);

  @override
  _ImageSizerState createState() => _ImageSizerState();
}

class _ImageSizerState extends State<ImageSizer> {
  ImageStreamListener? _imageListener;
  final GlobalKey _imageKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    // _imageListener = ImageStreamListener(
    //       (ImageInfo image, bool synchronousCall) {
    //     final Size imageSize = Size(image.image.width.toDouble(), image.image.height.toDouble());
    //     imageSizes.value = Map.from(imageSizes.value)..[widget.index] = imageSize;
    //   },
    // );
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      final RenderBox renderBox = _imageKey.currentContext?.findRenderObject() as RenderBox;
      final Size size = renderBox.size; // Size on screen
      print('Size on screen: $size');

      // Store the size
      imageSizes.value = Map.from(imageSizes.value)..[widget.index] = size;
    });
    // _loadAndListenToImage();
  }

  void _loadAndListenToImage() {
    final ImageStream imageStream = MemoryImage(widget.imageData).resolve(ImageConfiguration.empty);
    imageStream.addListener(_imageListener!);
  }

  @override
  void dispose() {
    final ImageStream imageStream = MemoryImage(widget.imageData).resolve(ImageConfiguration.empty);
    imageStream.removeListener(_imageListener!);
    super.dispose();
  }

  @override

  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var screenWidth = screenSize.width;
    var screenHeight = screenSize.height;

    return LayoutBuilder(

      builder: (context, constraints) {
        // Constrain the image to the screen size
        double maxWidth = min(constraints.maxWidth, screenWidth);
        double maxHeight = min(constraints.maxHeight, screenHeight);
        print(
            "scaffold -> width : ${constraints.maxWidth}, height: ${constraints.maxHeight}");

        return Align(
          alignment: Alignment.topLeft,
          // height: 100,
          child: Center(
            child: RepaintBoundary(
              key: widget.bKey,
              child: widget.imageData.isNotEmpty
                  ? Image.memory(
                widget.imageData,
                key: _imageKey,
                width: maxWidth,
                height: maxHeight,
                fit: BoxFit.contain, // Ensures the image does not exceed bounds
              )
                  : Container(
                width: maxWidth,
                height: maxHeight,
                child: Center(
                  child: Text('No Image'), // Placeholder for empty Uint8List
                ),
              ),
            ),
          ),
        );
      },
    );
  }

// Widget build(BuildContext context) {
  //   return SizedBox(
  //     child: LayoutBuilder(
  //       builder: (context, constraints) {
  //         return RepaintBoundary(
  //           key: widget.bKey,
  //           child: IntrinsicWidth(
  //             child: IntrinsicHeight(
  //
  //               child: Image.memory(widget.imageData),
  //             ),
  //           ),
  //         );
  //       },
  //     ),
  //   );
  //   return RepaintBoundary(
  //     key: widget.bKey,
  //     child: UnconstrainedBox(
  //       child: Center(
  //         child: Container(color: Colors.red,height: 100  ,width: 100,),
  //         // child: Image.memory(widget.imageData),
  //       ),
  //     ),
  //   );
  // }
}