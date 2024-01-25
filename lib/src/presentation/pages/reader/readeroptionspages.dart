import 'dart:async';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sharemagazines_flutter/src/blocs/reader/reader_bloc.dart';
import 'package:sharemagazines_flutter/src/presentation/pages/navbarpages/homepage/homepage.dart';

import '../../../blocs/navbar/navbar_bloc.dart';
import 'readerpage.dart';

class ReaderOptionsPages extends StatefulWidget {
  final ReaderBloc bloc;
  final Reader reader;
  ValueNotifier<bool> isOnPageTurning;
  // ValueNotifier<double> currentPage;

  ReaderOptionsPages({Key? key, required this.isOnPageTurning, required this.bloc, required this.reader})
      : super(key: key);

  @override
  State<ReaderOptionsPages> createState() => _ReaderOptionsPagesState();
}

class _ReaderOptionsPagesState extends State<ReaderOptionsPages>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin<ReaderOptionsPages> {
  static late PageController controller = PageController();

  late List<bool> toggleImageLoaded = List.filled(int.parse(widget.reader.magazine.pageMax!), false);
  int _currentPage = 0;

  Timer? timer;
  late AnimationController? _spinKitController;
  List<int> visitedPages = [];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _spinKitController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    // controller.addListener(scrollListener);
    // controller.jumpTo(5);
    // controller = PageController(viewportFraction: 0.7, initialPage: widget.reader.currentPage.value.round());

    var visitedPages = [];
  }

  @override
  void dispose() {
    timer?.cancel();
    _spinKitController?.dispose();

    // controller.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // controller = PageController(viewportFraction: 0.7, initialPage: widget.reader.currentPage.value);
    // print(ImageSizeGetter.getSize(MemoryInput(widget.reader.cover)).height);
    return OrientationBuilder(builder: (context, orientation) {
      // controller = PageController(viewportFraction: MediaQuery.of(context).orientation == Orientation.portrait ? 0.4 : 0.15);
      controller = PageController(
          viewportFraction: MediaQuery.of(context).orientation == Orientation.portrait ? 0.45 : 0.15,
          // initialPage: widget.reader.controllerflip.currentState!.pageNumber.round() - 1
          initialPage:0

      );

      return SizedBox(
        // width: 500,
        // width: double.infinity,

        // height: double.infinity,
        height: (MediaQuery.of(context).orientation == Orientation.portrait
            ? MediaQuery.of(context).size.height * 0.28
            : MediaQuery.of(context).size.height * 0.450),
        // width: MediaQuery.of(context).size.width + 01000,
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
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: PageView.builder(
              itemCount: int.parse(widget.reader.magazine.pageMax!),
              padEnds: false,

              // allowImplicitScrolling: false,
// findChildIndexCallback: ,
              controller: controller,
// clipBehavior: Clip.hardEdge,
              // onPageChanged: (int index) => setState(() => {}),
              allowImplicitScrolling: false,
              pageSnapping: false,
              itemBuilder: (_, i) {
                // print(widget.magazine.idMagazinePublication! + "_" + widget.magazine.dateOfPublication! + "_" + i.toString());
                return BlocBuilder<ReaderBloc, ReaderState>(
                  bloc: widget.bloc,
                  builder: (context, state) {
                    // print(state);
                    // if (state is ReaderOpened) {
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
                          // if (mounted)
                          //   {
                              // widget.reader.transformationController.value== Matrix4.identity(),
                              // widget.bloc.add(DownloadPage(magazine: widget.reader.magazine, pageNo: i)),
                              setState(() {
                                // widget.reader.currentPage == i;
                                // widget.reader.controllerflip.currentState!. goToPage(i);
// widget.reader.transformationController.value== Matrix4.identity();
//                                 widget.reader.pageController.animateToPage(i, duration: Duration(milliseconds: 200), curve: Curves.ease);
                                setState(() {
                                  _currentPage = i;
                                  widget.reader.pageController.animateToPage(i, duration: Duration(milliseconds: 200), curve: Curves.ease);
                                });
                              })
                            // }
                        },
                        // child: CustomCachedNetworkImage(mag:widget.reader.magazine,
                        //     reader:true,
                        //     pageNo: i,
                        //     thumbnail: true,
                        //     // covers:  widget.reader,
                        //     heroTag: "page$i", spinKitController: _spinKitController),
                        child: FutureBuilder<Uint8List?>(
                            future: BlocProvider.of<NavbarBloc>(context).getCover(widget.reader.magazine.idMagazinePublication!,
                                widget.reader.magazine.dateOfPublication!,i.toString(), true,false),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return CachedNetworkImage(
                                    // key: ValueKey(_networklHasErrorNotifier[i].value),
                                    filterQuality: FilterQuality.low,
                                    // height: double.infinity,
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
                                              i == _currentPage
                                                  ? EdgeInsets.fromLTRB(10, 10, 10, 10)
                                                  :
                                              EdgeInsets.fromLTRB(5, 0, 5, 0),
                                              // padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                              // decoration: i == pageNo
                                              decoration: i ==_currentPage
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
                                                      border: i == widget.reader.pageController.page
                                                          ? Border.all(color: Colors.transparent, width: 5.10)
                                                          : Border.all(color: Colors.transparent, width: 0)),
                                                  // color: Colors.black.withOpacity(0.8),
                                                  // height: constraints.maxHeight * 0.10,
                                                  // width: constraints.maxWidth * 0.10,

                                                  padding: EdgeInsets.fromLTRB(4, 4, 4, 4),
                                                  child: Text((i + 1).toString(),
                                                      textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
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
                                    }
                                    );
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
                    // } else {
                    //   return Container(
                    //     color: Colors.grey.withOpacity(0.2),
                    //     child: SpinKitFadingCircle(
                    //       color: Colors.white,
                    //       size: 50.0,
                    //     ),
                    //   );
                    // }
                  },
                );
              },
            ),
          ),
//           child: PageView.builder(
//             itemCount: int.parse(widget.reader.magazine.pageMax!),
//             scrollDirection: Axis.horizontal,
//
// // controller: controller,
//             controller: controller,
// //             padEnds: false,
// //
// //             // allowImplicitScrolling: false,
// // // findChildIndexCallback: ,
// //             controller: controller,
// // // clipBehavior: Clip.hardEdge,
// //             // onPageChanged: (int index) => setState(() => {}),
//             allowImplicitScrolling: false,
//             pageSnapping: false,
//             itemBuilder: (_, i) {
//               // print(widget.magazine.idMagazinePublication! + "_" + widget.magazine.dateOfPublication! + "_" + i.toString());
//               return ValueListenableBuilder<double>(
//                   valueListenable: widget.reader.currentPage,
//                   builder: (BuildContext context, double pageNo, Widget? child) {
//                     return BlocBuilder<ReaderBloc, ReaderState>(
//                       bloc: widget.bloc,
//                       // padding: EdgeInsets.symmetric(horizontal: i % 2 == 0 ? 0.0 : 0.0),
//                       // padding: widget.reader.magazine.singlePageOnly == false
//                       //     ? EdgeInsets.only(right: i % 2 == 0 ? 20.0 : 0.0)
//                       //     : EdgeInsets.only(right: 10.0, left: 10),
//                       builder: (context, state) {
//                         return SizedBox(
//                           // width: double.infinity,
//                           child: Stack(children: [
//                             GestureDetector(
//                               onTap: () => {
//                                 // widget.callback(i),
//                                 // widget.reader.currentPage = i,
//                                 print("page $i"),
//                                 if (i > 0) widget.bloc.add(DownloadPage(magazine: widget.reader.magazine, pageNo: i - 1)),
//                                 widget.bloc.add(DownloadPage(magazine: widget.reader.magazine, pageNo: i)),
//                                 if (i < int.parse(widget.reader.magazine.pageMax!))
//                                   widget.bloc.add(DownloadPage(magazine: widget.reader.magazine, pageNo: i + 1)),
//
//                                 setState(() {
//                                   // widget.reader.currentPage.value = i;
//
//                                   widget.reader.transformationController.value = Matrix4.identity();
//                                   widget.reader.pageController.animateToPage(i, duration: Duration(milliseconds: 200), curve: Curves.ease);
//                                 }),
//                               },
//                               child: CachedNetworkImage(
//                                   key: ValueKey(_networklHasErrorNotifier[i].value),
//                                   filterQuality: FilterQuality.low,
//                                   // height: double.infinity,
//                                   imageUrl: widget.reader.magazine.idMagazinePublication! +
//                                       "_" +
//                                       widget.reader.magazine.dateOfPublication! +
//                                       "_" +
//                                       i.toString() +
//                                       "_" +
//                                       "thumbnail",
//                                   imageBuilder: (context, imageProvider) {
//                                     return Stack(
//                                       alignment: Alignment.center,
//                                       children: [
//                                         Align(
//                                           alignment: Alignment.center,
//                                           child: Container(
//                                             // padding: i == widget.reader.pageController.page
//                                             //     ?
//                                             // EdgeInsets.fromLTRB(10, 10, 10, 10)
//                                             //     : EdgeInsets.fromLTRB(0, 0, 0, 0),
//                                             // padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
//                                             // decoration: i == pageNo
//
//                                             decoration:
//                                                 // i == widget.reader.pageController.page ?
//                                                 BoxDecoration(
//                                               borderRadius: BorderRadius.all(Radius.circular(5.0)),
//                                               // color: Colors.blue,
//                                               // border: Border.symmetric(
//                                               //   vertical: BorderSide(color: Colors.red, width: 2),
//                                               //   horizontal: BorderSide(color: Colors.green, width: 2),
//                                               // ),
//                                               // border: Border.all(
//                                               //   color: i == widget.reader.pageController.page? Colors.red:Colors.transparent, // Border color
//                                               //   width: 8.0, // Border width
//                                               // ),
//                                             ),
//                                             // : BoxDecoration(),
//                                             // decoration: BoxDecoration(color: Colors.green, image: DecorationImage(image: imageProvider, fit: BoxFit.cover)),
//                                             child: ClipRRect(
//                                               // borderRadius: BorderRadius.all(Radius.circular(5.0)),
//                                               child: Material(
//                                                 elevation: 5,
//                                                 child: Image(
//                                                     alignment: Alignment.center,
//                                                     image: imageProvider,
//                                                     width: 100,
//                                                     // color: Colors.red,
//                                                     // scale: i == pageNo ? MediaQuery.of(context).size.aspectRatio * 4 : 1,
//                                                     //   scale: i == pageNo ? 2 : 1,
//                                                     //   // fit: i == pageNo ? BoxFit.fitWidth : BoxFit.fitWidth
//                                                     // scale:0.5,
//                                                     fit: BoxFit.fitWidth),
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                         Align(
//                                           alignment: Alignment.bottomCenter,
//                                           child: LayoutBuilder(builder: (ctx, constraints) {
//                                             return Padding(
//                                               padding: const EdgeInsets.all(15.0),
//                                               child: Container(
//                                                 // padding: EdgeInsets.only(bottom: 20),
//                                                 // alignment: Alignment.center,
//                                                 // constraints: flase,
//
//                                                 decoration: BoxDecoration(
//                                                     borderRadius: BorderRadius.all(Radius.circular(5)),
//                                                     // color: Colors.black.withOpacity(0.8),
//                                                     color: i == widget.reader.pageController.page ? Colors.blue : Colors.black.withOpacity(0.8),
//                                                     border: i == pageNo
//                                                         ? Border.all(color: Colors.transparent, width: 5.10)
//                                                         : Border.all(color: Colors.transparent, width: 0)),
//                                                 // color: Colors.black.withOpacity(0.8),
//                                                 // height: constraints.maxHeight * 0.10,
//                                                 // width: constraints.maxWidth * 0.10,
//
//                                                 padding: EdgeInsets.fromLTRB(4, 4, 4, 4),
//                                                 child: Text((i + 1).toString(), textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
//                                               ),
//                                             );
//                                           }),
//                                         ),
//                                       ],
//                                     );
//                                   },
//                                   // useOldImageOnUrlChange: true,
//                                   // very important: keep both placeholder and errorWidget
//                                   placeholder: (context, url) => Padding(
//                                         padding: EdgeInsets.all(8.0),
//                                         child: Container(
//                                           margin: EdgeInsets.all(40),
//                                           // color: Colors.grey.withOpacity(0.1),
//                                           // width: MediaQuery.of(context).size.height * 0.28,
//                                           decoration: BoxDecoration(
//                                             // image: DecorationImage(image: imageProvider, fit: BoxFit.fill),
//                                             borderRadius: BorderRadius.all(Radius.circular(5.0)),
//                                             color: Colors.grey.withOpacity(0.1),
//                                           ),
//                                           child: SpinKitFadingCircle(
//                                             color: Colors.white,
//                                             size: 50.0,
//                                             controller: _spinKitController,
//                                           ),
//                                         ),
//                                       ),
//                                   errorWidget: (context, url, error) {
//                                     Future.delayed(const Duration(milliseconds: 500), () {
//                                       if (mounted) {
//                                         setState(() {
//                                           _networklHasErrorNotifier[i].value++;
//                                         });
//                                       }
//                                     });
//                                     return Padding(
//                                       padding: EdgeInsets.all(40.0),
//                                       child: Container(
//                                         margin: EdgeInsets.all(8),
//                                         // color: Colors.grey.withOpacity(0.1),
//                                         // width: 200,
//                                         // width: MediaQuery.of(context).size.height * 0.28,
//                                         decoration: BoxDecoration(
//                                           // image: DecorationImage(image: imageProvider, fit: BoxFit.fill),
//
//                                           borderRadius: BorderRadius.all(Radius.circular(5.0)),
//                                           color: Colors.grey.withOpacity(0.1),
//                                         ),
//                                         child: SpinKitFadingCircle(
//                                           color: Colors.white,
//                                           size: 50.0,
//                                           controller: _spinKitController,
//                                           // itemBuilder: (BuildContext context, int value) => {},
//                                         ),
//                                       ),
//                                     );
//                                   }),
//                             ),
//                           ]),
//                         );
//                         // } else {
//                         //   return Container(
//                         //     color: Colors.grey.withOpacity(0.2),
//                         //     child: SpinKitFadingCircle(
//                         //       color: Colors.white,
//                         //       size: 50.0,
//                         //     ),
//                         //   );
//                         // }
//                       },
//                     );
//                   });
//             },
//           ),
        ),
      );
    });
  }
}