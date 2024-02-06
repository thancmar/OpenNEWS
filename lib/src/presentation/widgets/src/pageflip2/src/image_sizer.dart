

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

  @override
  void initState() {
    super.initState();
    _imageListener = ImageStreamListener(
          (ImageInfo image, bool synchronousCall) {
        final Size imageSize = Size(image.image.width.toDouble(), image.image.height.toDouble());
        imageSizes.value = Map.from(imageSizes.value)..[widget.index] = imageSize;
      },
    );

    _loadAndListenToImage();
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
    return LayoutBuilder(
      builder: (context, constraints) {
        return RepaintBoundary(
          key: widget.bKey,
          child: IntrinsicWidth(
            child: IntrinsicHeight(
              child: Image.memory(widget.imageData),
            ),
          ),
        );
      },
    );
    return RepaintBoundary(
      key: widget.bKey,
      child: UnconstrainedBox(
        child: Center(
          child: Container(color: Colors.red,height: 100  ,width: 100,),
          // child: Image.memory(widget.imageData),
        ),
      ),
    );
  }
}
// class _ImageSizerState extends State<ImageSizer> {
//   ImageStreamListener? _imageListener;
//
//   @override
//   void initState() {
//     super.initState();
//     _imageListener = ImageStreamListener(
//           (ImageInfo image, bool synchronousCall) {
//         final screenSize = MediaQuery.of(context).size;
//         final double widthRatio = screenSize.width / image.image.width;
//         final double heightRatio = screenSize.height / image.image.height;
//         final double scale = min(widthRatio, heightRatio);
//
//         final Size imageSize = Size(
//           image.image.width.toDouble() * scale,
//           image.image.height.toDouble() * scale,
//         );
//
//         imageSizes.value = Map.from(imageSizes.value)
//           ..[widget.index] = imageSize;
//       },
//     );
//
//     _loadAndListenToImage();
//   }
//
//   void _loadAndListenToImage() {
//     final ImageStream imageStream = MemoryImage(widget.imageData).resolve(ImageConfiguration.empty);
//     imageStream.addListener(_imageListener!);
//   }
//
//   @override
//   void dispose() {
//     final ImageStream imageStream = MemoryImage(widget.imageData).resolve(ImageConfiguration.empty);
//     imageStream.removeListener(_imageListener!);
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         final Size? adjustedSize = imageSizes.value[widget.index];
//         return RepaintBoundary(
//           key: widget.bKey,
//           child: adjustedSize == null
//               ? Image.memory(widget.imageData)
//               : SizedBox(
//             width: adjustedSize.width,
//             height: adjustedSize.height,
//             child: Image.memory(widget.imageData),
//           ),
//         );
//       },
//     );
//   }
// }