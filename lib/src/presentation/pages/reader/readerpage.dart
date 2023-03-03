import 'dart:async';

import 'dart:typed_data';

import 'package:dismissible_page/dismissible_page.dart';
import 'package:flip_widget/flip_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf_render/pdf_render_widgets.dart';
import 'package:pdfx/pdfx.dart';

import 'package:sharemagazines_flutter/src/blocs/reader/reader_bloc.dart';
import 'package:sharemagazines_flutter/src/presentation/pages/reader/pdfWidget.dart';
import 'package:sharemagazines_flutter/src/presentation/pages/reader/pdf_view_pinch.dart';
import 'package:sharemagazines_flutter/src/presentation/pages/reader/readeroptionspage.dart';
import 'package:sharemagazines_flutter/src/presentation/widgets/routes/toreaderoption.dart';
import 'package:sharemagazines_flutter/src/resources/magazine_repository.dart';

//Reader is divided into 3 parts
//1. (Reader) The Actual reader
//2. (ReaderOptionsPage) The screen with opaque background
//3. (ReaderOptionsPage) The widget that contains all the pages

// class StartReader extends StatelessWidget {
//   final String id;
//   final String index;
//   final Uint8List coverURL;
//   final String noofpages;
//   final String readerTitle;
//   final String heroTag;
//   StartReader({Key? key, required this.id, required this.index, required this.coverURL, required this.noofpages, required this.readerTitle, required this.heroTag}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     print("StartReader readerTitle $readerTitle");
//     return BlocProvider(
//         create: (BuildContext context) => ReaderBloc(
//               magazineRepository: RepositoryProvider.of<MagazineRepository>(context),
//             ),
//         child: Reader(
//           id: this.id,
//           index: this.index,
//           cover: this.coverURL,
//           noofpages: this.noofpages,
//           readerTitle: this.readerTitle,
//           currentPage: 0,
//           heroTag: this.heroTag,
//         ));
//   }
//   //   return Container();
// }
class StartReader extends StatelessWidget {
  final String id;
  final String index;
  final Uint8List coverURL;
  final String noofpages;
  final String readerTitle;
  final String heroTag;
  StartReader({Key? key, required this.id, required this.index, required this.coverURL, required this.noofpages, required this.readerTitle, required this.heroTag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("StartReader readerTitle $readerTitle");
    return BlocProvider(
        create: (BuildContext context) => ReaderBloc(
              magazineRepository: RepositoryProvider.of<MagazineRepository>(context),
            ),
        child: Reader(
          id: this.id,
          index: this.index,
          cover: this.coverURL,
          noofpages: this.noofpages,
          readerTitle: this.readerTitle,
          currentPage: 0,
          heroTag: this.heroTag,
        ));
  }
//   return Container();
}

class Reader extends StatefulWidget {
  final String id;
  final String index;
  final Uint8List cover;
  final String noofpages;
  final String? readerTitle;
  int currentPage;
  final String heroTag;
  Reader({Key? key, required this.id, required this.index, required this.cover, required this.noofpages, required this.readerTitle, required this.currentPage, required this.heroTag})
      : super(key: key);

  @override
  State<Reader> createState() => _ReaderState();
}

class _ReaderState extends State<Reader> with AutomaticKeepAliveClientMixin<Reader> {
  bool isOnPageTurning = false;
  late final CustumPdfControllerPinch pdfPinchController;
  GlobalKey<FlipWidgetState> _flipKey = GlobalKey();
  // late final PdfController pdfController;

  get math => null;
  late double pageScale;
  static Matrix4 matrix4 = Matrix4(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1);
  TransformationController _controller = TransformationController(matrix4);

  callback(newValue) {
    setState(() {
      print("reader callback function");
      widget.currentPage = newValue;
      _controller.value = matrix4;
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    print(widget.id);
    pageScale = _controller.value.getMaxScaleOnAxis();
    BlocProvider.of<ReaderBloc>(context).add(
      OpenReader(idMagazinePublication: widget.id, pageNo: widget.noofpages),
    );
    // final pdfPinchController = CustumPdfControllerPinch(document: PdfDocument.openData(ReaderState.doc));
    super.initState();
    // controller.addListener(zoomListener);
  }

  @override
  void dispose() {
    // _controller.dispose();
    // pdfController.dispose();
    super.dispose();
  }

  // @override
  // Widget build(BuildContext context) {
  // super.build(context);

  // return SizedBox(
  //
  //   child: BlocBuilder<ReaderBloc, ReaderState>(builder: (context, state) {
  //     if (state is ReaderOpened) {
  //       // final pdfPinchController = CustumPdfControllerPinch(document: PdfDocument.openData(ReaderState.doc), viewportFraction: 0.5);
  //       return Stack(children: [
  //         Positioned.fill(
  //           child: Image.asset("assets/images/Background.png"),
  //         ),
  //         Positioned.fill(
  //           // top: 50,
  //           // left: 20,
  //
  //           // height: MediaQuery.of(context).size.height,
  //           // width: MediaQuery.of(context).size.width,
  //           // child: PdfViewer.openAsset(
  //           //   'assets/PDFtest.pdf',
  //           //   params: PdfViewerParams(pageNumber: 2), // show the page-2
  //           // ),
  //           child: CustumPdfViewPinch(
  //             // backgroundDecoration: BoxDecoration(color: Colors.transparent, image: DecorationImage(image: AssetImage("assets/images/Background.png"))),
  //             controller: pdfPinchController,
  //             scrollDirection: Axis.horizontal,
  //             // padding: 10,
  //             builders: CustumPdfViewPinchBuilders<DefaultBuilderOptions>(
  //               options: DefaultBuilderOptions(
  //                 loaderSwitchDuration: Duration(seconds: 1),
  //                 transitionBuilder: PDFWidget.transitionBuilder,
  //               ),
  //               documentLoaderBuilder: (_) => Center(child: CircularProgressIndicator()),
  //               pageLoaderBuilder: (_) => Center(child: CircularProgressIndicator()),
  //               errorBuilder: (_, error) => Center(child: Text(error.toString())),
  //               builder: PDFWidget.builder,
  //             ),
  //           ),
  //         ),
  //       ]);
  //     }
  //     return Container(
  //       color: Colors.amber,
  //     );
  //   }),
  // );
  // }
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/Background.png"),
          fit: BoxFit.fill,
        ),
      ),
      child: OrientationBuilder(builder: (context, orientation) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Positioned.fill(
            //   child: Image.asset("assets/images/Background.png"),
            // ),
            GestureDetector(
                onTap: () => Navigator.push(
                    context, ReaderOptionRoute(widget: ReaderOptionsPage(isOnPageTurning: isOnPageTurning, callback: this.callback, reader: this.widget, bloc: BlocProvider.of<ReaderBloc>(context)))),
                onDoubleTap: () => {
                      // if (widget.isOnPageTurning = true) {Navigator.of(context).pop(), print("double tap reader")}
                      print("controller"),
                      _controller.value = Matrix4.identity(),
                      // setState(() {
                      setState(() {
                        pageScale = _controller.value.getMaxScaleOnAxis();
                      }),
                      // });
                    },
                child: BlocListener<ReaderBloc, ReaderState>(
                  listener: (context, state) {
                    if (state is ReaderClosed) {
                      print("state.ReaderClosed");
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    }
                  },
                  child: BlocBuilder<ReaderBloc, ReaderState>(
                    builder: (context, state) {
                      // if (state is ReaderOpened) {
                      return DismissiblePage(
                        backgroundColor: Colors.transparent,
                        onDismissed: () {
                          Navigator.of(context).pop();
                        },
                        key: UniqueKey(),
                        disabled: pageScale <= 1.0 && widget.currentPage == 0 ? false : true,
                        direction: pageScale <= 1.0 ? DismissiblePageDismissDirection.vertical : DismissiblePageDismissDirection.none,
                        child: InteractiveViewer(
                          clipBehavior: Clip.hardEdge,
                          alignPanAxis: true,
                          transformationController: _controller,
                          minScale: 0.01,
                          maxScale: 3.5,
                          key: _flipKey,
                          // constrained: false,

                          onInteractionUpdate: (ScaleUpdateDetails details) {
                            // get the scale from the ScaleUpdateDetails callback
                            setState(() {
                              pageScale = _controller.value.getMaxScaleOnAxis();
                            });
                            print(pageScale);
                            // print the scale here
                          },
                          child: Container(
                            // width: MediaQuery.of(context).size.width,
                            width: MediaQuery.of(context).size.width,
                            // height: MediaQuery.of(context).size.height + 100,
                            // color: Colors.cyan,
                            // height: MediaQuery.of(context).size.height,
                            //Need to calculate page width minus minus padding
                            padding: orientation == Orientation.portrait ? EdgeInsets.only(top: 150, bottom: 150) : EdgeInsets.only(right: 150, left: 150), //have to adjust later
                            child: Hero(
                              tag: '${widget.heroTag}',
                              child: Card(
                                  color: Colors.transparent,
                                  clipBehavior: Clip.hardEdge,
                                  margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  elevation: 0,
                                  // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                                  child: state is ReaderOpened
                                      ? FutureBuilder<Uint8List>(
                                          // future: state.futureFuncAllPages?[widget.currentPage],
                                          future: ReaderState.pagesAll?[widget.currentPage],
                                          builder: (context, snapshot) {
                                            // return Hero(key: UniqueKey(), tag: '${widget.heroTag}', child: (snapshot.hasData) ? Image.memory(snapshot.data!) : Container(child: Image.memory(widget.cover)));
                                            return AnimatedSwitcher(
                                              // key: UniqueKey(),
                                              duration: Duration(milliseconds: 0),
                                              switchOutCurve: Threshold(0),

                                              child: Image.memory((snapshot.hasData) && widget.currentPage != 0 ? snapshot.data! : widget.cover),
                                            );
                                          })
                                      : Image.memory(widget.cover)),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )),
            Positioned(
                bottom: 20,
                right: 20,
                child: FloatingActionButton(
                  key: UniqueKey(),
                  heroTag: "FAB",
                  onPressed: () => {},
                  backgroundColor: Colors.white.withOpacity(0.2),
                  child: Icon(
                    Icons.chrome_reader_mode_outlined,
                  ),
                )),
          ],
        );
      }),
    );
  }

//   PhotoViewGalleryPageOptions _pageBuilder(
//     BuildContext context,
//     Future<PdfPageImage> pageImage,
//     int index,
//     PdfDocument document,
//   ) {
//     return PhotoViewGalleryPageOptions(
//       imageProvider: PdfPageImageProvider(
//         pageImage,
//         index,
//         document.id,
//       ),
//       minScale: PhotoViewComputedScale.contained * 1,
//       maxScale: PhotoViewComputedScale.contained * 3,
//       initialScale: PhotoViewComputedScale.contained * 1.0,
//       heroAttributes: PhotoViewHeroAttributes(tag: '${document.id}-$index'),
//     );
//   }
}
// }