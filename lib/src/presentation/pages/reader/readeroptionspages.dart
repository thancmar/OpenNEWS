import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sharemagazines_flutter/src/blocs/reader/reader_bloc.dart';

import 'readerpage.dart';

class ReaderOptionsPages extends StatefulWidget {
  final ReaderBloc bloc;
  final Reader reader;
  ValueNotifier<bool> isOnPageTurning;
  ValueNotifier<int> currentPage;
  ReaderOptionsPages({Key? key, required this.isOnPageTurning, required this.bloc, required this.reader, required this.currentPage}) : super(key: key);

  @override
  State<ReaderOptionsPages> createState() => _ReaderOptionsPagesState();
}

class _ReaderOptionsPagesState extends State<ReaderOptionsPages> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin<ReaderOptionsPages> {
  int _index = 0;
  late final controller = PageController(viewportFraction: 0.4, initialPage: widget.currentPage.value);
  static late List<ValueNotifier<int>> _networklHasErrorNotifier;

  late List<bool> toggleImageLoaded = List.filled(int.parse(widget.reader.magazine.pageMax!), false);
  late List<Key> _reloader = List.filled(int.parse(widget.reader.magazine.pageMax!), GlobalKey());
  // int current = 0;
  // bool isOnPageTurning = false;
  Timer? timer;
  late AnimationController? _spinKitController;
  List<int> visitedPages = [];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _networklHasErrorNotifier = List.filled(int.parse(widget.reader.magazine.pageMax!), ValueNotifier(0), growable: true);
    super.initState();
    _spinKitController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
    controller.addListener(scrollListener);
    var visitedPages = [];
  }

  void scrollListener() {
    // print(controller.page?.round());
    if (visitedPages.contains(controller.page?.round()) == false) {
      visitedPages.add(controller.page!.round());
      // widget.bloc.add(DownloadPage(magazine: widget.reader.magazine, pageNo: controller.page!.round()));
      // widget.bloc.add(DownloadPage(magazine: widget.reader.magazine, pageNo: controller.page!.round() + 1));
      // widget.bloc.add(DownloadPage(magazine: widget.reader.magazine, pageNo: controller.page!.round() + 2));
      // widget.bloc.add(DownloadPage(magazine: widget.reader.magazine, pageNo: controller.page!.round() + 3));
      widget.bloc.add(DownloadThumbnail(magazine: widget.reader.magazine, pageNo: controller.page!.round()));
      widget.bloc.add(DownloadThumbnail(magazine: widget.reader.magazine, pageNo: controller.page!.round() + 1));
      widget.bloc.add(DownloadThumbnail(magazine: widget.reader.magazine, pageNo: controller.page!.round() + 2));
      widget.bloc.add(DownloadThumbnail(magazine: widget.reader.magazine, pageNo: controller.page!.round() + 3));
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    _spinKitController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // print(ImageSizeGetter.getSize(MemoryInput(widget.reader.cover)).height);
    return SizedBox(
      // width: 500,
      // width: double.infinity,

      // height: double.infinity,
      height: MediaQuery.of(context).size.aspectRatio * 450,
      width: MediaQuery.of(context).size.aspectRatio * 1550,
      // width: 50,
      // height: 250, // card height
      // height: ImageSizeGetter.getSize(MemoryInput(widget.reader.cover)).height.floorToDouble(),
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
        // padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
        // shape: ,
        child: PageView.builder(
          itemCount: int.parse(widget.reader.magazine.pageMax!),
          padEnds: false,
          // allowImplicitScrolling: false,
// findChildIndexCallback: ,
          controller: controller,

          // onPageChanged: (int index) => setState(() => {}),
          // allowImplicitScrolling: false,
          pageSnapping: false,
          itemBuilder: (_, i) {
            // print(widget.magazine.idMagazinePublication! + "_" + widget.magazine.dateOfPublication! + "_" + i.toString());
            return Transform.scale(
              // origin: Offset(00, 100),
              // scaleX: 1,
              // scaleY: 1,
              scale: 1,
              origin: Offset(1000, 0),
              // scale: i == _index1 ? 1 : 1,
              // alignment: FractionalOffset.bottomLeft,
              alignment: Alignment.bottomLeft,
              // transform: Matrix4.skewY(0),
              child: Card(
                color: Colors.transparent,
                // clipBehavior: Clip.hardE,
                margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.aspectRatio * 10, 10, MediaQuery.of(context).size.aspectRatio * 10, 0),
                elevation: 0,

                // shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                child: Stack(
                  children: [
                    BlocBuilder<ReaderBloc, ReaderState>(
                      bloc: widget.bloc,
                      builder: (context, state) {
                        // print(state);
                        if (state is ReaderOpened) {
                          // return ClipRRect(
                          //   borderRadius: BorderRadius.circular(5.0),
                          //   child: Image.memory(
                          //     state.doc[i],
                          //   ),
                          // );
                          // return Container();
                          return Stack(children: [
                            GestureDetector(
                              onTap: () => {
                                // widget.callback(i),
                                // widget.reader.currentPage = i,
                                print("page $i"),
                                widget.bloc.add(DownloadPage(magazine: widget.reader.magazine, pageNo: i)),

                                setState(() {
                                  widget.reader.currentPage.value = i;
                                }),
                              },
                              child: Stack(children: <Widget>[
                                //To give the blue frame to the selected page
                                ValueListenableBuilder(
                                    valueListenable: widget.reader.currentPage,
                                    builder: (BuildContext context, int pageNo, Widget? child) {
                                      return CachedNetworkImage(
                                          key: ValueKey(_networklHasErrorNotifier[i].value),
                                          filterQuality: FilterQuality.high,
                                          // height: double.infinity,
                                          imageUrl: widget.reader.magazine.idMagazinePublication! + "_" + widget.reader.magazine.dateOfPublication! + "_" + i.toString() + "_" + "thumbnail",
                                          imageBuilder: (context, imageProvider) {
                                            return ClipRRect(
                                              // borderRadius: BorderRadius.circular(15.0),
                                              child: Container(
                                                height: MediaQuery.of(context).size.aspectRatio * 450,
                                                // width: MediaQuery.of(context).size.width,
                                                // alignment: Alignment.center,
                                                // margin: EdgeInsets.all(MediaQuery.of(context).size.aspectRatio * 0),
                                                clipBehavior: Clip.hardEdge,
                                                // padding: EdgeInsets.all(400), // Border width
                                                // padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                                // color: Colors.red,
                                                decoration: BoxDecoration(
                                                  // color: Colors.blue,
                                                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                  // border: i == pageNo ? Border.all(color: Colors.blueAccent, width: 4.10) : Border.all(color: Colors.transparent, width: 0),
                                                  color: i == pageNo ? Colors.blue : Colors.transparent,
                                                  // shape: BoxShape.rectangle,
                                                  border: Border.all(
                                                    color: Colors.red,
                                                    width: 5.25,
                                                  ),
                                                  image: DecorationImage(
                                                    image: imageProvider,
                                                    // scale: i == pageNo ? MediaQuery.of(context).size.aspectRatio * 4 : 1,
                                                    scale: i == pageNo ? 2 : 1,
                                                    // fit: i == pageNo ? BoxFit.fitWidth : BoxFit.fitWidth
                                                    // fit: BoxFit.cover

                                                    // onError: (obj, errDetailsTrace) {
                                                    //   Future.delayed(const Duration(milliseconds: 500), () {
                                                    //     setState(() {
                                                    //       _networklHasErrorNotifier[i].value++;
                                                    //     });
                                                    //   });
                                                    // }
                                                  ),
                                                  // borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                ),
                                                child: Align(
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
                                                            border: i == pageNo ? Border.all(color: Colors.transparent, width: 5.10) : Border.all(color: Colors.transparent, width: 0)),
                                                        // color: Colors.black.withOpacity(0.8),
                                                        // height: constraints.maxHeight * 0.10,
                                                        // width: constraints.maxWidth * 0.10,

                                                        padding: EdgeInsets.fromLTRB(4, 4, 4, 4),
                                                        child: Text((i + 1).toString(), textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
                                                      ),
                                                    );
                                                  }),
                                                ),
                                                // child: Container(color: Colors.red, child: Padding(padding: i == pageNo ? EdgeInsets.all(8.0) : EdgeInsets.all(0))),
                                                // child: Stack(children: <Widget>[]),
                                              ),
                                            );
                                          },
                                          // useOldImageOnUrlChange: true,
                                          // very important: keep both placeholder and errorWidget
                                          placeholder: (context, url) => Container(
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
                                          errorWidget: (context, url, error) {
                                            Future.delayed(const Duration(milliseconds: 500), () {
                                              setState(() {
                                                _networklHasErrorNotifier[i].value++;
                                              });
                                            });
                                            return Container(
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
                                            );
                                          });
                                    }),
                              ]),
                            ),
                          ]);
                        } else {
                          return Container(
                            color: Colors.grey.withOpacity(0.2),
                            child: SpinKitFadingCircle(
                              color: Colors.white,
                              size: 50.0,
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}