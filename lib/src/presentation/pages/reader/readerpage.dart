import 'package:cached_network_image/cached_network_image.dart';
import 'package:flip_widget/flip_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:sharemagazines_flutter/src/blocs/reader/reader_bloc.dart';
import 'package:sharemagazines_flutter/src/presentation/pages/reader/pdf_view_pinch.dart';
import 'package:sharemagazines_flutter/src/presentation/pages/reader/readeroptionspage.dart';
import 'package:sharemagazines_flutter/src/presentation/widgets/routes/toreaderoption.dart';
import 'package:sharemagazines_flutter/src/resources/magazine_repository.dart';

import '../../../models/magazinePublishedGetAllLastByHotspotId_model.dart' as model;

class StartReader extends StatelessWidget {
  final model.Response magazine;
  final String heroTag;
  StartReader({Key? key, required this.magazine, required this.heroTag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) => ReaderBloc(
              magazineRepository: RepositoryProvider.of<MagazineRepository>(context),
            ),
        child: Reader(
          magazine: this.magazine,
          currentPage: ValueNotifier<int>(0),
          heroTag: this.heroTag,
        ));
  }
//   return Container();
}

class Reader extends StatefulWidget {
  final model.Response magazine;
  ValueNotifier<int> currentPage;
  final String heroTag;

  Reader({Key? key, required this.magazine, required this.currentPage, required this.heroTag}) : super(key: key);

  @override
  State<Reader> createState() => _ReaderState();
}

class _ReaderState extends State<Reader> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin<Reader> {
  // bool isOnPageTurning = false;
  late final CustumPdfControllerPinch pdfPinchController;
  GlobalKey<FlipWidgetState> _flipKey = GlobalKey();
  // late final PdfController pdfController;

  get math => null;
  late double pageScale;
  static Matrix4 matrix4 = Matrix4(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1);
  TransformationController _controller = TransformationController(matrix4);
  static ValueNotifier<int> _networklHasErrorNotifier = ValueNotifier(0);
  late AnimationController? _spinKitController;
  callback(newValue) {
    // setState(() {
    //   print("reader callback function");
    //   widget.currentPage = newValue;
    //   _controller.value = matrix4;
    // });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // print(widget.id);
    pageScale = _controller.value.getMaxScaleOnAxis();
    BlocProvider.of<ReaderBloc>(context).add(
      // OpenReader(idMagazinePublication: widget.magazine.idMagazinePublication!, dateofPublicazion: widget.magazine.dateOfPublication!, pageNo: widget.magazine.pageMax!),
      OpenReader(magazine: widget.magazine),
    );
    // final pdfPinchController = CustumPdfControllerPinch(document: PdfDocument.openData(ReaderState.doc));
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _spinKitController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
    super.initState();
    // controller.addListener(zoomListener);
  }

  @override
  void dispose() {
    // _controller.dispose();
    // pdfController.dispose();
    _spinKitController?.dispose();
    super.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
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
                    context,
                    ReaderOptionRoute(
                        widget: ReaderOptionsPage(
                      reader: this.widget,
                      bloc: BlocProvider.of<ReaderBloc>(context),
                      currentPage: widget.currentPage,
                    ))),
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
                      // Navigator.of(context).popUntil((route) => route.isFirst);
                      int count = 0;
                      Navigator.popUntil(context, (route) {
                        return count++ == 2;
                      });
                    }
                  },
                  child: BlocBuilder<ReaderBloc, ReaderState>(
                    builder: (context, state) {
                      // if (state is ReaderOpened) {
                      return InteractiveViewer(
                        clipBehavior: Clip.hardEdge,
                        alignPanAxis: true,
                        transformationController: _controller,
                        minScale: 0.01,
                        maxScale: 3.5,

                        // boundaryMargin: Orientation == Orientation.portrait
                        //     ? EdgeInsets.only(right: 150, bottom: 500)
                        //     : EdgeInsets.only(right: -MediaQuery.of(context).size.width * 0.3, left: -MediaQuery.of(context).size.width * 0.3),
                        // ,
                        key: _flipKey,
                        // constrained: false,

                        onInteractionUpdate: (ScaleUpdateDetails details) {
                          // get the scale from the ScaleUpdateDetails callback
                          setState(() {
                            pageScale = _controller.value.getMaxScaleOnAxis();
                          });
                          // print(pageScale);
                          // print the scale here
                        },
                        child: Container(
                          // width: MediaQuery.of(context).size.width,
                          width: MediaQuery.of(context).size.width,
                          // height: MediaQuery.of(context).size.height - 100,
                          // color: Colors.cyan,
                          // height: MediaQuery.of(context).size.height,
                          //Need to calculate page width minus minus padding
                          padding: orientation == Orientation.portrait
                              ? EdgeInsets.only(top: 150, bottom: 150)
                              : EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.3, left: MediaQuery.of(context).size.width * 0.3),
                          //have to
                          // adjust
                          // later
                          //Remove future pages all from bloc state
                          child: Hero(
                              tag: '${widget.heroTag}',
                              child: Card(
                                color: Colors.transparent,
                                clipBehavior: Clip.hardEdge,
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                elevation: 0,
                                // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                                child: state is ReaderOpened
                                    ? AnimatedSwitcher(
                                        // key: UniqueKey(),
                                        duration: Duration(milliseconds: 100),
                                        switchOutCurve: Threshold(5),
                                        child: ValueListenableBuilder<int>(
                                            valueListenable: widget.currentPage,
                                            builder: (BuildContext context, int pageNo, Widget? child) {
                                              return CachedNetworkImage(
                                                  key: ValueKey(_networklHasErrorNotifier.value),
                                                  filterQuality: FilterQuality.none,
                                                  imageUrl: widget.magazine.idMagazinePublication! + "_" + widget.magazine.dateOfPublication! + "_" + pageNo.toString(),
                                                  // imageUrl: NavbarState.magazinePublishedGetLastWithLimit!.response!.where((i) => i.magazineLanguage == "de").toList()[index].idMagazinePublication! +
                                                  //     "_" +
                                                  //     NavbarState.magazinePublishedGetLastWithLimit!.response!.where((i) => i.magazineLanguage == "de").toList()[index].dateOfPublication!,
                                                  // progressIndicatorBuilder: (context, url, downloadProgress) => Container(
                                                  //   // color: Colors.grey.withOpacity(0.1),
                                                  //   decoration: BoxDecoration(
                                                  //     // image: DecorationImage(image: imageProvider, fit: BoxFit.fill),
                                                  //     borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                  //     color: Colors.grey.withOpacity(0.1),
                                                  //   ),
                                                  //   child: SpinKitFadingCircle(
                                                  //     color: Colors.white,
                                                  //     size: 50.0,
                                                  //   ),
                                                  // ),

                                                  imageBuilder: (context, imageProvider) => Container(
                                                        height: MediaQuery.of(context).size.height,
                                                        width: MediaQuery.of(context).size.width,
                                                        // color: Colors.red,
                                                        decoration: BoxDecoration(
                                                          image: DecorationImage(image: imageProvider, fit: BoxFit.contain),
                                                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                                        ),
                                                      ),
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
                                                    Future.delayed(const Duration(milliseconds: 100), () {
                                                      setState(() {
                                                        _networklHasErrorNotifier.value++;
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
                                                      ),
                                                    );
                                                  }
                                                  // errorWidget: (context, url, error) => Container(
                                                  //     alignment: Alignment.center,
                                                  //     child: Icon(
                                                  //       Icons.error,
                                                  //       color: Colors.grey.withOpacity(0.8),
                                                  //     )),
                                                  );
                                            }),
                                        // child: Image.memory((snapshot.hasData) && widget.currentPage != 0 ? snapshot.data! : widget.cover),
                                      )
                                    : SpinKitFadingCircle(
                                        color: Colors.white,
                                        size: 50.0,
                                      ),
                              )
                              // : Image.memory(widget.cover)),
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