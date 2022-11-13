import 'dart:async';
import 'dart:typed_data';

import 'package:flip_widget/flip_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:sharemagazines_flutter/src/blocs/reader_bloc.dart';
import 'package:sharemagazines_flutter/src/presentation/pages/readeroptionspage.dart';
import 'package:sharemagazines_flutter/src/presentation/widgets/routes/toreaderoption.dart';
import 'package:sharemagazines_flutter/src/resources/magazine_repository.dart';

//Reader is divided into 3 parts
//1. (Reader) The Actual reader
//2. (ReaderOptionsPage) The screen with opaque background
//3. (ReaderOptionsPage) The widget that contains all the pages

class StartReader extends StatelessWidget {
  final String id;
  final String index;
  final Uint8List cover;
  final String noofpages;
  final String readerTitle;
  final String heroTag;
  StartReader({Key? key, required this.id, required this.index, required this.cover, required this.noofpages, required this.readerTitle, required this.heroTag}) : super(key: key);

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
          cover: this.cover,
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

const double _MinNumber = 0.008;
double _clampMin(double v) {
  if (v < _MinNumber && v > -_MinNumber) {
    if (v >= 0) {
      v = _MinNumber;
    } else {
      v = -_MinNumber;
    }
  }
  return v;
}

class _ReaderState extends State<Reader> with AutomaticKeepAliveClientMixin {
  final TransformationController transformationController = TransformationController();
  bool isOnPageTurning = false;

  GlobalKey<FlipWidgetState> _flipKey = GlobalKey();
  Offset _oldPosition = Offset.zero;
  bool _visible = true;

  get math => null;

  callback(newValue) {
    setState(() {
      print("reader callback function");
      widget.currentPage = newValue;
      controller.value = matrix4;
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // SchedulerBinding.instance.addPostFrameCallback((_) async {
    //   Timer(Duration(seconds: 5), () {
    //     setState(() {
    //       transformationController.value = Matrix4.identity()
    //         ..translate(800, 0.0);
    //       transformationController.toScene(Offset(800, 0.0));
    //     });
    //   });
    // });

    print(widget.id);
    BlocProvider.of<ReaderBloc>(context).add(
      OpenReader(idMagazinePublication: widget.id, pageNo: widget.noofpages),
    );
    super.initState();
    // controller.addListener(zoomListener);
  }

  void zoomListener() {
    print(controller.value);
    // if (controller.value == matrix4) {
    //   print("dcs");
    //   //   setState(() {
    //   //     print("false");
    //   //
    //   //     widget.current = controller.page!.toInt();
    //   //     widget.isOnPageTurning = false;
    //   //   });
    //   // } else if (!widget.isOnPageTurning && widget.current.toDouble() != controller.page) {
    //   //   if ((widget.current.toDouble() - controller.page!).abs() > 0.1) {
    //   //     setState(() {
    //   //       widget.isOnPageTurning = true;
    //   //       print("true");
    //   //     });
    // }
    // }
  }

  static Matrix4 matrix4 = Matrix4(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1);
  TransformationController controller = TransformationController(matrix4);

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Size size = Size(256, 256);

    return Stack(
      alignment: Alignment.center,
      children: [
        // Container(
        //   child: new SvgPicture.asset(
        //     "assets/images/background_webreader.svg",
        //     fit: BoxFit.fill,
        //     allowDrawingOutsideViewBox: true,
        //   ),
        // ),
        Positioned.fill(
          child: Image.asset("assets/images/Background.png"),
        ),
        GestureDetector(
          // onTap: () {
          //   showModalBottomSheet<void>(
          //     context: context,
          //     isScrollControlled: true,
          //     // barrierColor: Colors.yellow.withOpacity(0.5),
          //     builder: (BuildContext context) {
          //       return FractionallySizedBox(
          //         heightFactor: 0.9,
          //         child: Container(
          //           // height: 200,
          //           color: Colors.transparent,
          //           child: Center(
          //             child: Column(
          //               mainAxisAlignment: MainAxisAlignment.center,
          //               mainAxisSize: MainAxisSize.min,
          //               children: <Widget>[
          //                 const Text('Modal BottomSheet'),
          //                 ElevatedButton(
          //                   child: const Text('Close BottomSheet'),
          //                   onPressed: () => Navigator.pop(context),
          //                 )
          //               ],
          //             ),
          //           ),
          //         ),
          //       );
          //     },
          //   );
          // },
          // onTap: () => Navigator.of(context).push(PageRouteBuilder(
          //     opaque: false,
          //     pageBuilder: (BuildContext context, _, __) =>
          //         ReaderOptionsPage())),
          // onVerticalDragCancel: () {
          //   // zoom = _scaleFactor;
          //   print(controller.value.getMaxScaleOnAxis());
          // },

          onTap: () => Navigator.push(
              context, ReaderOptionRoute(widget: ReaderOptionsPage(isOnPageTurning: isOnPageTurning, callback: this.callback, reader: this.widget, bloc: BlocProvider.of<ReaderBloc>(context)))),
          onDoubleTap: () => {
            // if (widget.isOnPageTurning = true) {Navigator.of(context).pop(), print("double tap reader")}
            print("controller"),
            controller.value = Matrix4.identity()
          },
          // onHorizontalDragStart: (details) {
          //   _oldPosition = details.globalPosition;
          //   _flipKey.currentState?.startFlip();
          // },
          // onHorizontalDragUpdate: (details) {
          //   Offset off = controller.toScene(details.globalPosition - _oldPosition);
          //
          //   double tilt = 1 / _clampMin((-off.dy + 20) / 100);
          //   double percent = -off.dx / size.width * 1.4;
          //   percent = percent - percent / 2 * (1 - 1 / tilt);
          //
          //   _flipKey.currentState?.flip(percent, tilt);
          // },
          // onHorizontalDragEnd: (details) {
          //   _flipKey.currentState?.stopFlip();
          //   widget.currentPage = int.parse(widget.index) + 1;
          // },
          // onHorizontalDragCancel: () {
          //   _flipKey.currentState?.stopFlip();
          // },

          // onVerticalDragEnd: (details) {
          //   print(details);
          //   Navigator.pop(context);
          // },
          // onPanUpdate: (details) {
          //   if (details.delta.dx > 0) {
          //     // setState(() {
          //     //   widget.currentPage = widget.currentPage - 1;
          //     // });
          //     print("swipe");
          //   }
          // },
          // onHorizontalDragEnd: (dragDetail) {
          //   if (dragDetail.velocity.pixelsPerSecond.dx < 1 && widget.currentPage > 0 && controller.value == matrix4) {
          //     print("right");
          //   } else if (dragDetail.velocity.pixelsPerSecond.dx > 1 && widget.currentPage < int.parse(widget.noofpages) && controller.value == matrix4) {
          //     print("left");
          //   }
          // },
          // onPanUpdate: (details) {
          //   if (details.delta.dx > 0)
          //     print("Dragging in +X direction");
          //   else
          //     print("Dragging in -X direction");
          //
          //   if (details.delta.dy > 0)
          //     print("Dragging in +Y direction");
          //   else
          //     print("Dragging in -Y direction");
          // },
          child: InteractiveViewer(
            // onInteractionUpdate: (v) {
            //   // print(v.localFocalPoint.dx);
            //   // print(v.localFocalPoint.dy);
            // },
            clipBehavior: Clip.antiAliasWithSaveLayer,
            alignPanAxis: true,
            // boundaryMargin: EdgeInsets.all(-20),
            scaleEnabled: true,

            transformationController: controller,
            minScale: 0.01,
            maxScale: 3.5,
            // onInteractionEnd: (details) {
            //   // Details.scale can give values below 0.5 or above 2.0 and resets to 1
            //   // Use the Controller Matrix4 to get the correct scale.
            //   double correctScaleValue = controller.value.getMaxScaleOnAxis();
            // },
            // panEnabled: false,
            // constrained: false,
            // scaleEnabled: true,
            child: Container(
              width: MediaQuery.of(context).size.width,
              // color: Colors.cyan,
              // height: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.only(top: 150, bottom: 150), //have to adjust later
              child: Card(
                color: Colors.transparent,

                // clipBehavior: Clip.antiAliasWithSaveLayer,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                elevation: 0,
                // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                child: BlocBuilder<ReaderBloc, ReaderState>(
                  builder: (context, state) {
                    // return AnimatedSwitcher(
                    //         duration: Duration(milliseconds: 0),
                    //         switchOutCurve: Threshold(0),
                    //         child: Container(
                    //           key: UniqueKey(),
                    //           child: state is Initialized
                    //               ? Hero(
                    //                   tag: '${widget.index}',
                    //                   child: Image.memory(
                    //                     widget.cover,
                    //                     fit: BoxFit.fill,
                    //                   ))
                    //               : state is ReaderOpened
                    //                   ? Hero(
                    //                       tag: '${widget.index}',
                    //                       child: Image.memory(
                    //                         state.bytes[widget.currentPage!],
                    //                         fit: BoxFit.fill,
                    //                       ))
                    //                   : Container(),
                    //         ))
                    // print("reader rebuild");
                    // if (state is Initialized) {
                    //   return AnimatedSwitcher(
                    //     key: UniqueKey(),
                    //     duration: Duration(milliseconds: 250),
                    //     child: Hero(
                    //         tag: '${widget.index}',
                    //         child: Image.memory(
                    //           widget.cover,
                    //           fit: BoxFit.fill,
                    //         )),
                    //   );
                    // } else if (state is ReaderOpened) {
                    //   return AnimatedSwitcher(
                    //     key: 'ds',
                    //     duration: Duration(milliseconds: 250),
                    //     child: Hero(
                    //         tag: '${widget.index}',
                    //         child: Image.memory(
                    //           state.bytes[widget.currentPage!],
                    //           fit: BoxFit.fill,
                    //         )),
                    //   );
                    // }

                    // return GestureDetector(
                    //   child: FlipWidget(
                    //     key: _flipKey,
                    //
                    //     // textureSize: size * 2,
                    //     // child: Container(
                    //     //   color: Colors.blue,
                    //     //   child: Center(
                    //     //     child: Text("hello"),
                    //     //   ),
                    //     // )
                    //     child: Hero(
                    //         tag: '${widget.index}',
                    //         child: Image.memory(
                    //           state is Initialized
                    //               ? widget.cover
                    //               : state is ReaderOpened
                    //                   ? state.bytes[widget.currentPage!]!
                    //                   : widget.cover,
                    //           fit: BoxFit.fill,
                    //         )),
                    //   ),
                    // );

                    // ;
                    // return Hero(
                    //     key: UniqueKey(),
                    //     tag: '${widget.index}',
                    //     child: Image.memory(
                    //       state is Initialized
                    //           ? widget.cover
                    //           : state is ReaderOpened
                    //               ? state.bytes[widget.currentPage!]!
                    //               : widget.cover,
                    //       fit: BoxFit.fill,
                    //     ));

                    // return state is ReaderOpened
                    //     ? FutureBuilder<Uint8List>(
                    //         future: state.futureFuncAllPages?[widget.currentPage],
                    //         builder: (context, snapshot) {
                    //           return (snapshot.hasData)
                    //               ? Hero(key: UniqueKey(), tag: '${widget.index}', child: (snapshot.hasData) ? Image.memory(snapshot.data!) : Container(child: Image.memory(widget.cover)))
                    //               : Container(
                    //                   color: Colors.green,
                    //                 );
                    //         },
                    //       )
                    //     : Container(
                    //         color: Colors.red,
                    //       );
                    return FutureBuilder<Uint8List>(
                        future: state.futureFuncAllPages?[widget.currentPage],
                        builder: (context, snapshot) {
                          return Hero(key: UniqueKey(), tag: '${widget.heroTag}', child: Image.memory(widget.cover));
                        });
                    // );
                    // return PageCurl();
                  },
                ),
              ),
            ),
          ),
        ),
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
        // GestureDetector(
        //   behavior: HitTestBehavior.opaque,
        //   onTap: () => print('Tapped'),
        //   child: Text("cdxs"),
        // )
      ],
    );
  }
}

// import 'dart:async';
// import 'dart:typed_data';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:sharemagazines_flutter/src/blocs/reader_bloc.dart';
// import 'package:sharemagazines_flutter/src/presentation/pages/readeroptionspage.dart';
// import 'package:sharemagazines_flutter/src/presentation/widgets/routes/toreaderoption.dart';
// import 'package:sharemagazines_flutter/src/resources/magazine_repository.dart';
//
// class StartReader extends StatelessWidget {
//   final String id;
//   final int tagindex;
//   final Uint8List cover;
//   const StartReader(
//       {Key? key, required this.id, required this.tagindex, required this.cover})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//         create: (BuildContext context) => ReaderBloc(
//               magazineRepository:
//                   RepositoryProvider.of<MagazineRepository>(context),
//             ),
//         child: Reader(id: this.id, tagindex: this.tagindex, cover: this.cover));
//   }
// }
//
// class Reader extends StatefulWidget {
//   final String id;
//   final int tagindex;
//   final Uint8List cover;
//   Reader(
//       {Key? key, required this.id, required this.tagindex, required this.cover})
//       : super(key: key);
//
//   @override
//   State<Reader> createState() => _ReaderState();
// }
//
// class _ReaderState extends State<Reader> {
//   final TransformationController transformationController =
//       TransformationController();
//
//   @override
//   void initState() {
//     // SchedulerBinding.instance.addPostFrameCallback((_) async {
//     //   Timer(Duration(seconds: 5), () {
//     //     setState(() {
//     //       transformationController.value = Matrix4.identity()
//     //         ..translate(800, 0.0);
//     //       transformationController.toScene(Offset(800, 0.0));
//     //     });
//     //   });
//     // });
//
//     print(widget.id);
//     BlocProvider.of<ReaderBloc>(context).add(
//       OpenReader(widget.id),
//     );
//     super.initState();
//   }
//
//   static Matrix4 matrix4 =
//       Matrix4(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1);
//   TransformationController controller = TransformationController(matrix4);
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       alignment: Alignment.center,
//       children: [
//         Container(
//           child: new SvgPicture.asset(
//             "assets/images/background_webreader.svg",
//             fit: BoxFit.fill,
//             allowDrawingOutsideViewBox: true,
//           ),
//         ),
//         GestureDetector(
//           // onTap: () {
//           //   showModalBottomSheet<void>(
//           //     context: context,
//           //     isScrollControlled: true,
//           //     // barrierColor: Colors.yellow.withOpacity(0.5),
//           //     builder: (BuildContext context) {
//           //       return FractionallySizedBox(
//           //         heightFactor: 0.9,
//           //         child: Container(
//           //           // height: 200,
//           //           color: Colors.transparent,
//           //           child: Center(
//           //             child: Column(
//           //               mainAxisAlignment: MainAxisAlignment.center,
//           //               mainAxisSize: MainAxisSize.min,
//           //               children: <Widget>[
//           //                 const Text('Modal BottomSheet'),
//           //                 ElevatedButton(
//           //                   child: const Text('Close BottomSheet'),
//           //                   onPressed: () => Navigator.pop(context),
//           //                 )
//           //               ],
//           //             ),
//           //           ),
//           //         ),
//           //       );
//           //     },
//           //   );
//           // },
//           // onTap: () => Navigator.of(context).push(PageRouteBuilder(
//           //     opaque: false,
//           //     pageBuilder: (BuildContext context, _, __) =>
//           //         ReaderOptionsPage())),
//           onTap: () => Navigator.push(
//               context, new ReaderOptionRoute(widget: ReaderOptionsPage())),
//           child: InteractiveViewer(
//             clipBehavior: Clip.hardEdge,
//             alignPanAxis: true,
//             // boundaryMargin: EdgeInsets.all(-20),
//             scaleEnabled: true,
//             transformationController: controller,
//             minScale: 0.01,
//             maxScale: 2.5,
//             // constrained: false,
//             // scaleEnabled: true,
//             child: Container(
//               color: Colors.transparent,
//               width: MediaQuery.of(context).size.width - 0,
//               height: MediaQuery.of(context).size.height - 0,
//               // padding: const EdgeInsets.only(top: 100, bottom: 60),
//               child: Card(
//                 color: Colors.transparent,
//                 // semanticContainer: false,
//                 clipBehavior: Clip.antiAliasWithSaveLayer,
//                 margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
//                 elevation: 0,
//
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(50)),
//                 child: BlocBuilder<ReaderBloc, ReaderState>(
//                     builder: (context, state) {
//                   return AnimatedSwitcher(
//                     switchOutCurve: Threshold(0),
//                     duration: Duration(milliseconds: 1000),
//                     child: state is Initialized
//                         ? Hero(
//                             tag: '${widget.tagindex}',
//                             key: UniqueKey(),
//                             child: Image.memory(
//                               widget.cover,
//                               fit: BoxFit.fill,
//                               width: MediaQuery.of(context).size.width,
//                             ),
//                           )
//                         : state is ReaderOpened
//                             ? Hero(
//                                 key: UniqueKey(),
//                                 tag: '${widget.tagindex}',
//                                 child: Image.memory(
//                                   // widget.cover,
//                                   state.bytes,
//                                   fit: BoxFit.fill,
//                                   width: MediaQuery.of(context).size.width,
//                                 ),
//                               )
//                             : Container(),
//                   );
//                   // child: Hero(
//                   //   tag: '${widget.index}',
//                   //   transitionOnUserGestures: true,
//                   //   child: Image.memory(
//                   //     state.bytes,
//                   //     fit: BoxFit.fill,
//                   //   ),
//                 }),
//               ),
//             ),
//           ),
//         ),
//         Positioned(
//             bottom: 20,
//             right: 20,
//             child: FloatingActionButton(
//               heroTag: "FAB",
//               onPressed: () => {},
//               backgroundColor: Colors.white.withOpacity(0.2),
//               child: Icon(
//                 Icons.chrome_reader_mode_outlined,
//               ),
//             )),
//         // GestureDetector(
//         //   behavior: HitTestBehavior.opaque,
//         //   onTap: () => print('Tapped'),
//         //   child: Text("cdxs"),
//         // )
//       ],
//     );
//   }
// }