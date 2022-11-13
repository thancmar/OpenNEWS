import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_size_getter/image_size_getter.dart';
import 'package:sharemagazines_flutter/src/blocs/reader_bloc.dart';

import '../pages/readerpage.dart';

class ReaderOptionsPages extends StatefulWidget {
  final ReaderBloc bloc;
  final Reader reader;
  Function callback;
  bool isOnPageTurning;
  int current = 0;
  ReaderOptionsPages({Key? key, required this.callback, required this.isOnPageTurning, required this.bloc, required this.reader}) : super(key: key);

  @override
  State<ReaderOptionsPages> createState() => _ReaderOptionsPagesState();
}

class _ReaderOptionsPagesState extends State<ReaderOptionsPages> with AutomaticKeepAliveClientMixin {
  int _index = 0;
  final controller = PageController(viewportFraction: 0.4);
  // int current = 0;
  // bool isOnPageTurning = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    controller.addListener(scrollListener);

    // controller.page

    // BlocProvider.of(context)
  }

  void scrollListener() {
    print(controller.offset);
    if (widget.isOnPageTurning && controller.page == controller.page?.roundToDouble()) {
      setState(() {
        print("false");

        widget.current = controller.page!.toInt();
        widget.isOnPageTurning = false;
      });
    } else if (!widget.isOnPageTurning && widget.current.toDouble() != controller.page) {
      if ((widget.current.toDouble() - controller.page!).abs() > 0.1) {
        setState(() {
          widget.isOnPageTurning = true;
          print("true");
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    print(ImageSizeGetter.getSize(MemoryInput(widget.reader.cover)).height);
    return SizedBox(
      // width: 500,
      // width: double.infinity,
      height: ImageSizeGetter.getSize(MemoryInput(widget.reader.cover)).height / 12,
      // width: 50,

      // height: 250, // card height
      // height: ImageSizeGetter.getSize(MemoryInput(widget.reader.cover)).height.floorToDouble(),
      child: PageView.builder(
        itemCount: int.parse(widget.reader.noofpages),
        // padEnds: true,
        // allowImplicitScrolling: true,

        controller: controller,
        onPageChanged: (int index) => setState(() => _index = index),
        pageSnapping: false,
        itemBuilder: (_, i) {
          return Transform.scale(
            // origin: Offset(20, 1000),
            // scaleX: 1,
            // scaleY: 1,
            scale: 1,
            // scale: i == _index1 ? 1 : 1,
            // alignment: FractionalOffset.bottomLeft,
            // alignment: AlignmentGeometry(),
            // transform: Matrix4.skewY(0),
            child: Card(
              color: Colors.transparent,
              // clipBehavior: Clip.hardE,
              margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
                side: BorderSide(color: Colors.transparent, width: 2),
              ),
              child: Stack(
                children: [
                  SizedBox(
                    // width: 100,
                    // height: 300,
                    // child: Image.memory(bytes),

                    child: BlocBuilder<ReaderBloc, ReaderState>(
                      bloc: widget.bloc,
                      builder: (context, state) {
                        // print(state);
                        if (state is ReaderOpened) {
                          // return ClipRRect(
                          //   borderRadius: BorderRadius.circular(5.0),
                          //   child: Image.memory(
                          //     state.bytes[i],
                          //   ),
                          // );
                          return FutureBuilder<Uint8List>(
                              future: state.futureFuncAllPages?[i],
                              builder: (context, snapshot) {
                                return GestureDetector(
                                  onTap: () => {
                                    widget.callback(i),
                                    setState(() {}),
                                  },
                                  child: Stack(children: <Widget>[
                                    Container(
                                      alignment: Alignment.center,

                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      padding: i == widget.reader.currentPage ? EdgeInsets.all(4) : EdgeInsets.all(0), // Border width
                                      decoration: BoxDecoration(
                                        color: i == widget.reader.currentPage && snapshot.hasData ? Colors.blue : Colors.transparent,
                                        shape: BoxShape.rectangle,
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.all(Radius.circular(1)),
                                        child: SizedBox.fromSize(
                                          // size: Size.fromRadius(500), // Image radius
                                          child: Stack(children: <Widget>[
                                            (snapshot.hasData)
                                                ? Image.memory(
                                                    // state.bytes[i],
                                                    snapshot.data!,
                                                  )
                                                : Container(
                                                    color: Colors.grey.withOpacity(0.2),
                                                    child: SpinKitFadingCircle(
                                                      color: Colors.white,
                                                      size: 50.0,
                                                    ),
                                                  ),
                                          ]),
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: LayoutBuilder(builder: (ctx, constraints) {
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            // padding: EdgeInsets.only(bottom: 20),
                                            // alignment: Alignment.bottomCenter,
                                            decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(3)), color: Colors.black.withOpacity(0.8)),
                                            // color: Colors.black.withOpacity(0.8),
                                            height: constraints.maxHeight * 0.10,
                                            width: constraints.maxWidth * 0.10,
                                            child: Text((i + 1).toString(), textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
                                          ),
                                        );
                                      }),
                                    )
                                  ]),
                                );
                              });
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
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}