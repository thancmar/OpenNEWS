import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sharemagazines_flutter/src/presentation/pages/navbarpages/homepage/homepage.dart';
import 'package:sharemagazines_flutter/src/presentation/pages/reader/readerpage.dart';

import '../../../blocs/navbar/navbar_bloc.dart';

class ReaderPage extends StatefulWidget {
  final Reader reader;
  final GlobalKey layoutKey = GlobalKey();
  final int pageNumber;

// Global or scoped to a relevant part of your widget tree
  final ValueNotifier<Size?> readerPageSizeNotifier = ValueNotifier<Size?>(null);

  // GlobalKey repaintBoundaryKey = GlobalKey();
  final GlobalKey repaintBoundaryKey;

  // final Function(Size)? onSizeDetermined;

  ReaderPage({Key? key, required this.reader, required this.pageNumber, required this.repaintBoundaryKey}) : super(key: key);

  @override
  State<ReaderPage> createState() => _ReaderPageState();
}

class _ReaderPageState extends State<ReaderPage> with SingleTickerProviderStateMixin // , AutomaticKeepAliveClientMixin<ReaderPage>
{
  late AnimationController? _spinKitController;
  Size? imageSize;
  late Uint8List imageData;

  // late GlobalKey _repaintBoundaryKey;

  // @override
  // bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // widget.repaintBoundaryKey = GlobalKey(); // Initialize the GlobalKey
    _spinKitController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _loadImage();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if (widget.layoutKey.currentContext != null) {
    //     final RenderBox renderBox = widget.layoutKey.currentContext!.findRenderObject() as RenderBox;
    //     // Now you can safely use renderBox
    //   }
    // });
  }

  void _loadImage() async {
    // Using your getCover method to load the image
    imageData = await BlocProvider.of<NavbarBloc>(context).getCover(widget.reader.magazine.idMagazinePublication!,
        widget.reader.magazine.dateOfPublication!, widget.pageNumber.toString(), false, true // Assuming preloadneighbor is false
        );

    if (imageData != null) {
      // Decode the image to get its dimensions
      final image = await decodeImageFromList(imageData);
      setState(() {
        imageSize = Size(image.width.toDouble(), image.height.toDouble());
      });
    }
    final viewportWidth = MediaQuery.of(context).size.width;
    final scaleFactor = viewportWidth / imageSize!.width;
    // Assuming you have these values or a way to calculate them
    final childWidth = imageSize!.width; // width of your child content;
    final childHeight = imageSize!.height; // height of your child content;
    final viewerWidth = MediaQuery.of(context).size.width;
    final viewerHeight = MediaQuery.of(context).size.height * 2.5;

    final scaledChildWidth = childWidth * scaleFactor;
    final scaledChildHeight = childHeight * scaleFactor;

    // Calculate the translation to center the child
    final translateX = (viewerWidth - scaledChildWidth) / 2;
    final translateY = (viewerHeight - scaledChildHeight) / 2;

    widget.reader.transformationController.value = Matrix4.identity()
      ..scale(scaleFactor)
      ..translate(translateX, translateY);
    ;
    // Set the initial scale of the transformationController
    // widget.reader.transformationController.value = Matrix4.identity()..scale(scaleFactor*0.9,scaleFactor*1.5);
    // widget.reader.transformationController.value = Matrix4.identity()..scale(0.250);
  }

  @override
  void dispose() {
    // _controller.dispose();
    // pdfController.dispose();
    // _networklHasErrorNotifier.dispose();// forEach((element) {element.dispose();});
    _spinKitController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // widget.reader.transformationController.value = Matrix4.identity();
    // ..scale(0.250);
    print("Rebuilding ReaderPage for Page Number: ${widget.pageNumber} key: ${widget.repaintBoundaryKey}");

    return InteractiveViewer(
      clipBehavior: Clip.antiAlias,
      // alignPanAxis: true,
      transformationController: widget.reader.transformationController,

      minScale: 1.901,
      // minScale: 1.901,
      // maxScale: 1.5,
      constrained: false,

      // child: Stack(
      //   children: [
      //     Align(
      //         alignment: Alignment.center,
      //         child: Container(
      //           color: Colors.blue,
      //           height: 2000,
      //           width: 200,
      //         )),
      //   ],
      // ),
      // boundaryMargin:EdgeInsets.all(20),
      // Orientation == Orientation.portrait
      //     ? EdgeInsets.only(right: 150, bottom: 500)
      //     :
      // EdgeInsets.only(right: -MediaQuery.of(context).size.width * 0.3, left: -MediaQuery.of(context).size.width * 0.3),
      // ,
      // key: _flipKey,
      // constrained: false,

      // onInteractionUpdate: (ScaleUpdateDetails details) {
      //   // get the scale from the ScaleUpdateDetails callback
      //   setState(() {
      //     pageScale = _controller.value.getMaxScaleOnAxis();
      //   });
      //   // print(pageScale);
      //   // print the scale here
      // },
      child: Hero(
        // key: widget.layoutKey,
        tag: widget.pageNumber == 0 ? widget.reader.heroTag : "etwas_${widget.pageNumber}",
        //   child:
        //   CustomCachedNetworkImage(reader:true,pageNo: widget.pageNumber, heroTag:null, spinKitController: _spinKitController, mag: widget.reader.magazine, thumbnail: false),
        // )
        child: FutureBuilder<Uint8List?>(
            future: BlocProvider.of<NavbarBloc>(context).getCover(
                widget.reader.magazine.idMagazinePublication!, widget.reader.magazine.dateOfPublication!, widget.pageNumber.toString(), false, true),
            builder: (context, snapshot) {
              if (imageSize == null) {
                return Center(child: CircularProgressIndicator());
              }
             ;
              // Building the container with dynamic size
              return RepaintBoundary(
                key: widget.repaintBoundaryKey,
                child: LayoutBuilder(builder: (context, constraints) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    widget.readerPageSizeNotifier.value = Size(constraints.maxWidth, constraints.maxHeight);
                  });
                  return Container(
                    key: widget.layoutKey,
                    height: imageSize!.height,
                    width: imageSize!.width,
                    // color: Colors.red,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: MemoryImage(
                          imageData,
                        ), // Using the loaded image
                        // fit: BoxFit.contain,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      color: Colors.red,
                    ),
                  );
                }),
              );
            }
            // return Stack(
            //   children: [
            //
            //     // (!snapshot.hasData)?
            //     // Container(
            //     // CachedNetworkImage(
            //     //     filterQuality: FilterQuality.none,
            //     //     imageUrl: widget.reader.magazine.idMagazinePublication! +
            //     //         "_" +
            //     //         widget.reader.magazine.dateOfPublication! +
            //     //         "_" +
            //     //         widget.pageNumber.toString() +
            //     //         "_" +
            //     //         "thumbnail",
            //     //
            //     //     // placeholderFadeInDuration: const Duration(seconds: 50),
            //     //     // fadeOutCurve: Curves.bounceOut,
            //     //     // fadeOutDuration: Duration(milliseconds: 4),
            //     //     // fadeInDuration:  Duration(seconds: 4),
            //     //     imageBuilder: (context, imageProvider) => Container(
            //     //           height: MediaQuery.of(context).size.height,
            //     //           width: MediaQuery.of(context).size.width,
            //     //           // color: Colors.red,
            //     //           decoration: BoxDecoration(
            //     //             image: DecorationImage(image: imageProvider, fit: BoxFit.contain),
            //     //             borderRadius: BorderRadius.all(Radius.circular(5.0)),
            //     //
            //     //           ),
            //     //         ),
            //     //
            //     //
            //     //     errorWidget: (context, url, error) {
            //     //       return Padding(
            //     //         padding: EdgeInsets.all(8.0),
            //     //         child: Container(
            //     //           // color: Colors.grey.withOpacity(0.1),
            //     //
            //     //           decoration: BoxDecoration(
            //     //             // image: DecorationImage(image: imageProvider, fit: BoxFit.fill),
            //     //
            //     //             borderRadius: BorderRadius.all(Radius.circular(5.0)),
            //     //             // color: Colors.grey.withOpacity(0.1),
            //     //           ),
            //     //           child:  !snapshot.hasData
            //     //               ?SpinKitFadingCircle(
            //     //             color: Colors.white,
            //     //             size: 50.0,
            //     //             controller: _spinKitController,
            //     //             // itemBuilder: (BuildContext context, int value) => {},
            //     //           ):Container(),
            //     //         ),
            //     //       );
            //     //     }),
            //     // Container(color: Colors.green,)
            //     snapshot.hasData
            //         ? CachedNetworkImage(
            //             filterQuality: FilterQuality.none,
            //             // placeholderFadeInDuration: const Duration(milliseconds: 3000),
            //             // fadeInDuration: Duration(milliseconds: 300),
            //             // fadeOutDuration: const Duration(milliseconds: 300),
            //             imageUrl: widget.reader.magazine.idMagazinePublication! +
            //                 "_" +
            //                 widget.reader.magazine.dateOfPublication! +
            //                 "_" +
            //                 widget.pageNumber.toString(),
            //
            //             imageBuilder: (context, imageProvider) {
            //               return Container(
            //                 // height: MediaQuery.of(context).size.height,
            //                 // width: MediaQuery.of(context).size.width,
            //                 // color: Colors.red,
            //                 decoration: BoxDecoration(
            //                   image: DecorationImage(image: imageProvider, fit: BoxFit.contain),
            //                   borderRadius: BorderRadius.all(Radius.circular(5.0)),
            //                   color: Colors.blueAccent
            //                 ),
            //               );
            //             },
            //
            //
            //             errorWidget: (context, url, error) {
            //               return Padding(
            //                 padding: EdgeInsets.all(8.0),
            //                 child: Container(
            //                   // color: Colors.grey.withOpacity(0.1),
            //
            //                   decoration: BoxDecoration(
            //                     // image: DecorationImage(image: imageProvider, fit: BoxFit.fill),
            //
            //                     borderRadius: BorderRadius.all(Radius.circular(5.0)),
            //                     // color: Colors.grey.withOpacity(0.1),
            //                   ),
            //                   child: SpinKitFadingCircle(
            //                     color: Colors.red,
            //                     size: 50.0,
            //                     controller: _spinKitController,
            //                     // itemBuilder: (BuildContext context, int value) => {},
            //                   ),
            //                 ),
            //               );
            //             }
            //
            //
            //             )
            //         : Container(),
            //   ],
            // );
            // }

            ),
      ),
    );
  }
}