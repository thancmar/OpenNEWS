// import 'package:flip_widget/flip_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sharemagazines_flutter/src/blocs/reader/reader_bloc.dart';
import 'package:sharemagazines_flutter/src/presentation/pages/reader/page.dart';
import 'package:sharemagazines_flutter/src/presentation/pages/reader/pdf_view_pinch.dart';
import 'package:sharemagazines_flutter/src/presentation/pages/reader/readeroptionspage.dart';
import 'package:sharemagazines_flutter/src/presentation/widgets/routes/toreaderoption.dart';
import 'package:sharemagazines_flutter/src/resources/magazine_repository.dart';

import '../../../models/magazinePublishedGetAllLastByHotspotId_model.dart' as model;
import '../../widgets/src/pageflip/src/page_flip_widget.dart';
import '../../widgets/src/pageflip2/src/page_flip_widget.dart';


class StartReader extends StatelessWidget {
  final model.ResponseMagazine magazine;
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
          // currentPage: ValueNotifier<double>(0.0),
          heroTag: this.heroTag,
        ));
  }
//   return Container();
}

class Reader extends StatefulWidget {
  final model.ResponseMagazine magazine;
  final String heroTag;
  final controllerflip = GlobalKey<PageFlipWidgetState>();
  late PageController pageController;

  // ValueNotifier<double> currentPage;
  static Matrix4 matrix4 = Matrix4(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1);
  TransformationController transformationController = TransformationController(matrix4);
  bool pageScrollEnabled = true;

  Reader({Key? key, required this.magazine, required this.heroTag}) : super(key: key);

  @override
  State<Reader> createState() => _ReaderState();
}

class _ReaderState extends State<Reader> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin<Reader> {
  late final CustumPdfControllerPinch pdfPinchController;
  late List<ReaderPage> pages = [];
  List<int> visitedPages = [];
  late double pageScale;
  late List<GlobalKey> pageKeys;

  // static Matrix4 matrix4 = Matrix4(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1);
  // TransformationController _controller = TransformationController(matrix4);
  // static ValueNotifier<int> _networklHasErrorNotifier = ValueNotifier(0);
  late AnimationController? _spinKitController;

  get math => null;

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
    pageKeys = List.generate(int.parse(widget.magazine.pageMax!), (index) => GlobalKey());
    widget.pageController = PageController(initialPage: 0);
    // widget.pageController.addListener(() {
    //   widget.currentPage.value = widget.pageController.page!;
    // });
    widget.transformationController.addListener(() {
      if (widget.transformationController.value.getMaxScaleOnAxis() > 1.0) {
        // Disable PageView scroll
        if (widget.pageScrollEnabled) {
          if (mounted) {
            setState(() {
              widget.pageScrollEnabled = false;
            });
          }
        }
      } else {
        // Enable PageView scroll
        if (!widget.pageScrollEnabled) {
          if (mounted) {
            setState(() {
              widget.pageScrollEnabled = true;
            });
          }
        }
      }
    });
    // widget.currentPage.addListener( widget.pageController) ;
    pageScale = widget.transformationController.value.getMaxScaleOnAxis();
// _controllerflip.currentState./
    // widget.pageController.addListener(onScroll);
    // _controllerflip.
    BlocProvider.of<ReaderBloc>(context).add(
      // OpenReader(idMagazinePublication: widget.magazine.idMagazinePublication!, dateofPublicazion: widget.magazine.dateOfPublication!, pageNo: widget.magazine.pageMax!),
      OpenReader(magazine: widget.magazine),
    );

    // for (var i = 1; i <= int.parse(widget.magazine.pageMax!); i++) {
    //   // for (int i = 0; i <= 5; i++) {
    //   pages.add(ReaderPage(
    //     reader: this.widget,
    //     pageNumber: i,
    //   ));
    // }
    // ;

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



  void onScroll() {
    // This is where you can react to the scrolling.
    // print("Scroll position: ${widget.pageController.page}");
    if (visitedPages.contains(widget.controllerflip.currentState?.pageNumber.round()) == false) {
      visitedPages.add(widget.controllerflip.currentState!.pageNumber.round());
      BlocProvider.of<ReaderBloc>(context)
          .add(DownloadPage(magazine: widget.magazine, pageNo: widget.controllerflip.currentState!.pageNumber.round()));
    }
  }

  @override
  void dispose() {
    // _controller.dispose();
    // pdfController.dispose();
    // widget.pageController.removeListener(onScroll);
    // widget.pageController.dispose();
    _spinKitController?.dispose();
    super.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        // Positioned.fill(
        //   child: Hero(
        //       tag: 'bg',
        //       // flightShuttleBuilder: (flightContext, animation, flightDirection, fromHeroContext, toHeroContext) {
        //       //   return Stack(children: [
        //       //     // Positioned.fill(child: FadeTransition(opacity: animation, child: fromHeroContext.widget)),
        //       //     Positioned.fill(
        //       //       child: FadeTransition(
        //       //         opacity: animation.drive(
        //       //           Tween<double>(begin: 0.0, end: 1.0).chain(
        //       //             CurveTween(
        //       //               curve: Interval(
        //       //                 0.0, 1.0,
        //       //                 // curve: ValleyQuadraticCurve()
        //       //               ),
        //       //             ),
        //       //           ),
        //       //         ),
        //       //       ),
        //       //     )
        //       //   ]);
        //       // },
        //       child: Image.asset("assets/images/background/Background.png", fit: BoxFit.cover)),
        // ),
        OrientationBuilder(builder: (context, orientation) {
          return GestureDetector(
              onTap: () => {
                    print("ds"),
                    Navigator.push(
                        context,
                        ReaderOptionRoute(
                            widget: ReaderOptionsPage(
                          reader: this.widget,
                          bloc: BlocProvider.of<ReaderBloc>(context),
                          // currentPage: widget.currentPage,
                        ))),
                  },
              // onDoubleTapDown: (details) {
              //   final RenderBox renderBox = context.findRenderObject() as RenderBox;
              //   final Offset localPosition = renderBox.globalToLocal(details.globalPosition);
              //
              //   final Matrix4 currentMatrix = widget.transformationController.value;
              //   final double currentScale = currentMatrix.getMaxScaleOnAxis();
              //
              //   if (currentScale == 1.0) {
              //     // Define your desired zoom-in scale
              //     final double zoomInScale = 3.0;
              //
              //     // Get the position of the double tap in the viewport
              //     final RenderBox renderBox = context.findRenderObject() as RenderBox;
              //     final Offset localPosition = renderBox.globalToLocal(details.globalPosition);
              //
              //     // Calculate the translation needed to get the tap location to the center of the viewport
              //     final Size viewportSize = MediaQuery.of(context).size;
              //     final double dx = (viewportSize.width / 2 - zoomInScale * localPosition.dx);
              //     final double dy = (viewportSize.height / 2 - zoomInScale * localPosition.dy);
              //
              //     // Create the zoom-in transformation matrix
              //     final Matrix4 zoomInMatrix = Matrix4.identity()
              //       ..translate(dx, dy)
              //       ..scale(zoomInScale);
              //
              //     widget.transformationController.value = zoomInMatrix;
              //   } else {
              //     // If the image is zoomed in, reset to the original scale
              //     widget.transformationController.value = Matrix4.identity();
              //   }
              // },
              // onHorizontalDragEnd: ,

              // onDoubleTap: () => {
              //       // if (widget.isOnPageTurning = true) {Navigator.of(context).pop(), print("double tap reader")}
              //       print("controller"),
              //       widget.transformationController.value = Matrix4.identity(),
              //       // setState(() {
              //       // setState(() {
              //       //   pageScale = _controller.value.getMaxScaleOnAxis();
              //       // }),
              //       // });
              //     },
              child: BlocListener<ReaderBloc, ReaderState>(
                listener: (context, state) {
                  if (state is ReaderClosed) {
                    print("state.ReaderClosed");
                    // Navigator.of(context).popUntil((route) => route.isFirst);
                    setState(() {
                      // widget.pageController.jumpToPage(0) ;
                      widget.controllerflip.currentState!.pageNumber = 0;
                      // widget.transformationController.value = Matrix4.identity();
                      // widget.pageController.animateToPage(0, duration: Duration(milliseconds: 200), curve: Curves.ease);
                    });
                    WidgetsBinding.instance!.addPostFrameCallback((_) {
                      int count = 0;
                      Navigator.popUntil(context, (route) {
                        return count++ == 2;
                      });
                    });
                    // int count = 0;
                    // Navigator.popUntil(context, (route) {
                    //   return count++ == 2;
                    // });
                  }
                },
                child: new  PageFlipWidget2(
                  key: widget.controllerflip,
                  backgroundColor: Colors.transparent,
                  reader: this.widget,
                  pageMax:int.parse( widget.magazine.pageMax!),

                  // isRightSwipe: true,
                  // lastPage: Container(color: Colors.transparent, child: const Center(child: Text('Last Page!'))),
//                       children: <ReaderPage>[
//                         for (var index = 0; index < int.parse(widget.magazine.pageMax!); index++)
//                           new ReaderPage(
//                             key: ValueKey(index),
//                             // key: pageKeys[index],
//                             reader: this.widget,
//                             pageNumber: index,
//                             repaintBoundaryKey: pageKeys[index],
// // repaintBoundaryKey: Key(index),
// // repaintBoundaryKey: ValueKey(index),
//                           ),
//                       ],
                ),
              ));
        }),
      ],
    );
  }
}