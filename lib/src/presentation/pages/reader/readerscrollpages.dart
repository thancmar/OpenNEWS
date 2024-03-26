import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../blocs/navbar/navbar_bloc.dart';
import 'readerpage.dart';

class ReaderScrollPages extends StatefulWidget {
  final Reader reader;

  ReaderScrollPages({Key? key, required this.reader}) : super(key: key);

  @override
  State<ReaderScrollPages> createState() => _ReaderScrollPagesState();
}

class _ReaderScrollPagesState extends State<ReaderScrollPages> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin<ReaderScrollPages> {
  PageController controller = PageController();
  late AnimationController? _spinKitController;

  @override
  bool get wantKeepAlive => true;

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
    _spinKitController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return OrientationBuilder(builder: (context, orientation) {
      controller = PageController(
          viewportFraction: MediaQuery.of(context).orientation == Orientation.portrait ? 0.45 : 0.15,
          initialPage: widget.reader.controllerflip.currentState!.pageNumber
          // initialPage: widget.reader.controllerflip.currentState!.pageNumber.round() - 1
          );
      return SizedBox(
        height: (MediaQuery.of(context).orientation == Orientation.portrait
            ? MediaQuery.of(context).size.height * 0.28
            : MediaQuery.of(context).size.height * 0.450),
        child: RawScrollbar(
          controller: controller,
          thickness: 10,
          interactive: true,
          scrollbarOrientation: ScrollbarOrientation.top,
          thumbVisibility: true,
          thumbColor: Colors.grey,
          radius: Radius.circular(20),
          crossAxisMargin: 0,
          minThumbLength: 100,
          trackVisibility: false,
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: PageView.builder(
              itemCount: int.parse(widget.reader.magazine.pageMax!),
              padEnds: false,
              controller: controller,
              allowImplicitScrolling: false,
              pageSnapping: false,
              itemBuilder: (_, i) {
                return Stack(children: [
                  GestureDetector(
                    onTap: () => {
                      setState(() {
                        // widget.reader.currentPage == i;
                        widget.reader.transformationController.value = Matrix4.identity();
                        widget.reader.controllerflip.currentState!.goToPage(i);
                      })
                    },
                    child: FutureBuilder<Uint8List?>(
                        future: BlocProvider.of<NavbarBloc>(context).getCover(
                            widget.reader.magazine.idMagazinePublication!, widget.reader.magazine.dateOfPublication!, i.toString(), true, false),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return CachedNetworkImage(
                                // key: ValueKey(_networklHasErrorNotifier[i].value),
                                filterQuality: FilterQuality.low,
                                imageUrl: widget.reader.magazine.idMagazinePublication! +
                                    "_" +
                                    widget.reader.magazine.dateOfPublication! +
                                    "_" +
                                    i.toString() +
                                    "_" +
                                    "thumbnail",
                                imageBuilder: (context, imageProvider) {
                                  return Stack(
                                    children: [
                                      Align(
                                        alignment: Alignment.center,
                                        child: Container(
                                          padding:
                                              // i == widget.reader.pageController.page
                                              i == widget.reader.controllerflip.currentState!.pageNumber
                                                  ? EdgeInsets.fromLTRB(10, 10, 10, 10)
                                                  : EdgeInsets.fromLTRB(5, 0, 5, 0),
                                          // padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                          // decoration: i == pageNo
                                          decoration: i == widget.reader.controllerflip.currentState!.pageNumber
                                              ? BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5.0)), color: Colors.blue)
                                              : BoxDecoration(),
                                          // decoration: BoxDecoration(color: Colors.green, image: DecorationImage(image: imageProvider, fit: BoxFit.cover)),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                            child: Image(
                                                alignment: Alignment.center,
                                                image: imageProvider,
                                                // scale: i == pageNo ? MediaQuery.of(context).size.aspectRatio * 4 : 1,
                                                //   scale: i == pageNo ? 2 : 1,
                                                //   // fit: i == pageNo ? BoxFit.fitWidth : BoxFit.fitWidth
                                                fit: BoxFit.fitWidth),
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.bottomCenter,
                                        child: LayoutBuilder(builder: (ctx, constraints) {
                                          return Padding(
                                            padding: const EdgeInsets.all(15.0),
                                            child: Container(
                                              // padding: EdgeInsets.only(bottom: 20),
                                              // alignment: Alignment.center,
                                              // constraints: flase,

                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.all(Radius.circular(5)),
                                                  color: Colors.black.withOpacity(0.8),
                                                  border: i == widget.reader.controllerflip.currentState!.pageNumber
                                                      ? Border.all(color: Colors.transparent, width: 5.10)
                                                      : Border.all(color: Colors.transparent, width: 0)),
                                              // color: Colors.black.withOpacity(0.8),
                                              // height: constraints.maxHeight * 0.10,
                                              // width: constraints.maxWidth * 0.10,

                                              padding: EdgeInsets.fromLTRB(4, 4, 4, 4),
                                              child: Text((i + 1).toString(), textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
                                            ),
                                          );
                                        }),
                                      ),
                                    ],
                                  );
                                },
                                // useOldImageOnUrlChange: true,
                                // very important: keep both placeholder and errorWidget
                                placeholder: (context, url) => Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Container(
                                        // color: Colors.grey.withOpacity(0.1),

                                        decoration: BoxDecoration(
                                          // image: DecorationImage(image: imageProvider, fit: BoxFit.fill),
                                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                          color: Colors.grey.withOpacity(0.1),
                                        ),
                                        child: SpinKitFadingCircle(
                                          color: Colors.white,
                                          size: 50.0,
                                          controller: _spinKitController,
                                        ),
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
                                        color: Colors.grey.withOpacity(0.1),
                                      ),
                                      child: SpinKitFadingCircle(
                                        color: Colors.white,
                                        size: 50.0,
                                        controller: _spinKitController,
                                        // itemBuilder: (BuildContext context, int value) => {},
                                      ),
                                    ),
                                  );
                                });
                          }
                          return Container(
                            // color: Colors.grey.withOpacity(0.1),
                            decoration: BoxDecoration(
                              // image: DecorationImage(image: imageProvider, fit: BoxFit.fill),
                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                              // color: Colors.grey.withOpacity(0.1),
                              // color: Colors.red,
                            ),
                            child: SpinKitFadingCircle(
                              color: Colors.white,
                              size: 50.0,
                              controller: _spinKitController,
                            ),
                          );
                        }),
                  ),
                ]);
              },
            ),
          ),
        ),
      );
    });
  }
}