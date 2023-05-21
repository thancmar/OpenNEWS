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
          currentPage: ValueNotifier<double>(0.0),
          heroTag: this.heroTag,
        ));
  }
//   return Container();
}

class Reader extends StatefulWidget {
  final model.ResponseMagazine magazine;
  final String heroTag;
  late PageController pageController;
  ValueNotifier<double> currentPage;
  static Matrix4 matrix4 = Matrix4(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1);
  TransformationController transformationController = TransformationController(matrix4);
  bool pageScrollEnabled = true;

  Reader({Key? key, required this.magazine, required this.currentPage, required this.heroTag}) : super(key: key);

  @override
  State<Reader> createState() => _ReaderState();
}

class _ReaderState extends State<Reader> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin<Reader> {
  late final CustumPdfControllerPinch pdfPinchController;
  late List<ReaderPage> pages = [];
  List<int> visitedPages = [];
  late double pageScale;

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
    widget.pageController = PageController(initialPage: 0);
    widget.pageController.addListener(() {
      widget.currentPage.value = widget.pageController.page!;
    });
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

    widget.pageController.addListener(onScroll);
    BlocProvider.of<ReaderBloc>(context).add(
      // OpenReader(idMagazinePublication: widget.magazine.idMagazinePublication!, dateofPublicazion: widget.magazine.dateOfPublication!, pageNo: widget.magazine.pageMax!),
      OpenReader(magazine: widget.magazine),
    );

    for (var i = 1; i <= int.parse(widget.magazine.pageMax!); i++) {
      // for (int i = 0; i <= 5; i++) {
      pages.add(ReaderPage(
        reader: this.widget,
        pageNumber: i,
      ));
    }
    ;

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
    if (visitedPages.contains(widget.pageController.page?.round()) == false) {
      visitedPages.add(widget.pageController.page!.round());
      BlocProvider.of<ReaderBloc>(context).add(DownloadPage(magazine: widget.magazine, pageNo: widget.pageController.page!.round()));
    }
  }

  @override
  void dispose() {
    // _controller.dispose();
    // pdfController.dispose();
    widget.pageController.dispose();
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
      children: [
        Positioned.fill(
            child:
                Hero(
                          tag: 'bg',
                // flightShuttleBuilder: (flightContext, animation, flightDirection, fromHeroContext, toHeroContext) {
                //   return Stack(children: [
                //     // Positioned.fill(child: FadeTransition(opacity: animation, child: fromHeroContext.widget)),
                //     Positioned.fill(
                //       child: FadeTransition(
                //         opacity: animation.drive(
                //           Tween<double>(begin: 0.0, end: 1.0).chain(
                //             CurveTween(
                //               curve: Interval(
                //                 0.0, 1.0,
                //                 // curve: ValleyQuadraticCurve()
                //               ),
                //             ),
                //           ),
                //         ),
                //       ),
                //     )
                //   ]);
                // },
                child:
                Image.asset("assets/images/background/Background.png", fit: BoxFit.cover)),
        ),
        OrientationBuilder(builder: (context, orientation) {
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
                        widget.transformationController.value = Matrix4.identity(),
                        // setState(() {
                        // setState(() {
                        //   pageScale = _controller.value.getMaxScaleOnAxis();
                        // }),
                        // });
                      },
                  child: BlocListener<ReaderBloc, ReaderState>(
                    listener: (context, state) {
                      if (state is ReaderClosed) {
                        print("state.ReaderClosed");
                        // Navigator.of(context).popUntil((route) => route.isFirst);
                        setState(() {
                          widget.pageController.jumpToPage(0) ;

                          widget.transformationController.value = Matrix4.identity();
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
                    child: BlocBuilder<ReaderBloc, ReaderState>(
                      builder: (context, state) {
                        // if (state is ReaderOpened) {
                        return PageView.builder(
                            controller: widget.pageController,
                            itemCount: int.parse(widget.magazine.pageMax!),
                            physics: widget.pageScrollEnabled ? AlwaysScrollableScrollPhysics() : NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) => ReaderPage(
                                  reader: this.widget,
                                  pageNumber: index,
                                ));
                      },
                    ),
                  )),
              // Positioned(
              //     bottom: 20,
              //     right: 20,
              //     child: FloatingActionButton(
              //       // key: UniqueKey(),
              //       // heroTag: "FAB",
              //       onPressed: () => {},
              //       backgroundColor: Colors.white.withOpacity(0.2),
              //       child: Icon(
              //         Icons.chrome_reader_mode_outlined,
              //       ),
              //     )),
            ],
          );
        }),
      ],
    );
  }
}