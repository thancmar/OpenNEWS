import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sharemagazines/src/presentation/pages/navbarpages/homepage/homepage.dart';
import 'package:sharemagazines/src/presentation/pages/reader/readerpage.dart';

import '../../../blocs/navbar/navbar_bloc.dart';

class ReaderPage extends StatefulWidget {
  final Reader reader;
  final GlobalKey layoutKey = GlobalKey();
  final int pageNumber;

// Global or scoped to a relevant part of your widget tree
  final ValueNotifier<Size?> readerPageSizeNotifier = ValueNotifier<Size?>(null);

  // GlobalKey repaintBoundaryKey = GlobalKey();
  // final GlobalKey repaintBoundaryKey;

  // final Function(Size)? onSizeDetermined;

  ReaderPage({
    Key? key,
    required this.reader,
    required this.pageNumber,
    // required this.repaintBoundaryKey
  }) : super(key: key);

  @override
  State<ReaderPage> createState() => _ReaderPageState();
}

class _ReaderPageState extends State<ReaderPage> with SingleTickerProviderStateMixin // , AutomaticKeepAliveClientMixin<ReaderPage>
{
  late AnimationController? _spinKitController;

  // @override
  // bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _spinKitController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    // _controller.dispose();
    // pdfController.dispose();
    // _networklHasErrorNotifier.dispose();// forEach((element) {element.dispose();});
    // widget.reader.transformationController[widget.pageNumber].dispose();
    _spinKitController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.reader.heroTag);
    return Hero(
      tag: widget.pageNumber == 0 ? widget.reader.heroTag : "etwas_${widget.pageNumber}",
      child: FutureBuilder<Uint8List?>(
          future: BlocProvider.of<NavbarBloc>(context).getCover(
              widget.reader.magazine.idMagazinePublication!, widget.reader.magazine.dateOfPublication!, widget.pageNumber.toString(), false, true),
          builder: (context, snapshot) {
            if (snapshot.hasData && widget.reader.allImageData[widget.pageNumber] == null) {
              // print(widget.pageNumber);
              widget.reader.allImageData[widget.pageNumber] = snapshot.data!;
            }
            return ValueListenableBuilder<Orientation>(
              valueListenable: widget.reader.currentOrientation,
              builder: (BuildContext context, Orientation orientation, Widget? child) { return Stack(
              children: [
                // (!snapshot.hasData)?
                // Container(
                CachedNetworkImage(
                    filterQuality: FilterQuality.none,
                    imageUrl: widget.reader.magazine.idMagazinePublication! +
                        "_" +
                        widget.reader.magazine.dateOfPublication! +
                        "_" +
                        widget.pageNumber.toString() +
                        "_" +
                        "thumbnail",

                    // placeholderFadeInDuration: const Duration(seconds: 50),
                    // fadeOutCurve: Curves.bounceOut,
                    // fadeOutDuration: Duration(milliseconds: 4),
                    // fadeInDuration:  Duration(seconds: 4),
                    imageBuilder: (context, imageProvider) => Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      // color: Colors.red,
                      decoration: BoxDecoration(
                        image: DecorationImage(image: imageProvider, fit: BoxFit.contain),
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      ),
                    ),
                    errorWidget: (context, url, error) {
                      return Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Container(
                          // color: Colors.grey.withOpacity(0.1),

                          decoration: BoxDecoration(
                            // image: DecorationImage(image: imageProvider, fit: BoxFit.fill),

                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                            // color: Colors.grey.withOpacity(0.1),
                          ),
                          child: !snapshot.hasData
                              ? SpinKitFadingCircle(
                            color: Colors.white,
                            size: 50.0,
                            controller: _spinKitController,
                            // itemBuilder: (BuildContext context, int value) => {},
                          )
                              : Container(),
                        ),
                      );
                    }),
                // Container(color: Colors.green,)

                if (snapshot.hasData)
                  CachedNetworkImage(
                      key: ValueKey(widget.reader.allImagekey[widget.pageNumber]),
                      filterQuality: FilterQuality.none,
                      // placeholderFadeInDuration: const Duration(milliseconds: 3000),
                      // fadeInDuration: Duration(milliseconds: 300),
                      // fadeOutDuration: const Duration(milliseconds: 300),
                      imageUrl: widget.reader.magazine.idMagazinePublication! +
                          "_" +
                          widget.reader.magazine.dateOfPublication! +
                          "_" +
                          widget.pageNumber.toString(),
                      imageBuilder: (context, imageProvider) {
                        return Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          // color: Colors.red,
                          decoration: BoxDecoration(
                            image: DecorationImage(image: imageProvider, fit:orientation ==Orientation.portrait ? BoxFit.fitWidth:BoxFit.fitHeight),
                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          ),
                        );
                      },
                      errorWidget: (context, url, error) {
                        return Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Container(
                            // color: Colors.grey.withOpacity(0.1),

                            decoration: BoxDecoration(
                              // image: DecorationImage(image: imageProvider, fit: BoxFit.fill),

                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                              // color: Colors.grey.withOpacity(0.1),
                            ),
                            child: SpinKitFadingCircle(
                              color: Colors.green,
                              size: 50.0,
                              controller: _spinKitController,
                              // itemBuilder: (BuildContext context, int value) => {},
                            ),
                          ),
                        );
                      })
                // : Container(),
              ],
            );},

            );
          }),
    );
  }
}