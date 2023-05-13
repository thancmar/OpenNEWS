import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:sharemagazines_flutter/src/blocs/reader/reader_bloc.dart';
import 'package:sharemagazines_flutter/src/presentation/pages/reader/readerpage.dart';
import 'package:sharemagazines_flutter/src/presentation/pages/reader/readeroptionspages.dart';
import 'package:sharemagazines_flutter/src/presentation/widgets/marquee.dart';

import '../../../models/magazinePublishedGetAllLastByHotspotId_model.dart' as model;

class ReaderOptionsPage extends StatefulWidget {
  // final model.Response magazine;
  final ReaderBloc bloc;

  final Reader reader;
  final TransformationController controller;
  // Function callback;
  // bool isOnPageTurning;
  // print("dsfs");
  // int current = 0;
  ValueNotifier<int> currentPage;
  ReaderOptionsPage({required this.reader, required this.bloc, required this.currentPage,required this.controller}) : super();
  @override
  State<ReaderOptionsPage> createState() => _ReaderOptionsPageState();
}

class _ReaderOptionsPageState extends State<ReaderOptionsPage> with AutomaticKeepAliveClientMixin<ReaderOptionsPage> {
  static Matrix4 matrix4 = Matrix4(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1);
  ValueNotifier<bool> isOnPageTurning = ValueNotifier<bool>(false);

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    // Future(() {
    //   Navigator.of(context).push(PageRouteBuilder(
    //       pageBuilder: (BuildContext context, _, __) => Reader()));
    // });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.40), // this is the main reason of transparency at next screen.
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.navigate_before_outlined,
            size: 30,
          ),
          onPressed: () => {
            // Navigator.of(context).pop(),
            // dispose(),
            // Navigator.of(context).popUntil((route) => route.isFirst), widget.bloc.add(CloseReader()), widget.bloc.close(),
            // setState(() {
            //   pageScale = _controller.value.getMaxScaleOnAxis();
            // }),
            widget.controller.value = Matrix4.identity(),//To resize the loading icon
            widget.bloc.add(CloseReader()),
            // BlocProvider.of<ReaderBloc>(context).add(CloseReader()),
            // BlocProvider
            // Navigator.of(context).popUntil((route) => route.isFirst), widget.bloc.add(CloseReader()), widget.bloc.close()
          },
        ),
        title: MarqueeWidget(
          // child: Text("sfd"),
          child: Text(widget.reader.magazine.name! ?? "Title"),
          direction: Axis.horizontal,
          // pauseDuration: Duration(milliseconds: 100),
          // animationDuration: Duration(seconds: 2),
          // backDuration: Duration(seconds: 1),
        ),
        actionsIconTheme: IconThemeData(
          size: 25,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Icon(Icons.menu_outlined),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Icon(Icons.bookmark_border),
          )
        ],
        // titleSpacing: 0,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        //mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => {
              if (isOnPageTurning.value = true) {Navigator.of(context).pop(), print("single tap reader")}
            },
            // onDoubleTap: () => {
            //   // if (widget.isOnPageTurning = true) {Navigator.of(context).pop(), print("double tap reader")}
            //
            //   widget.controller = TransformationController(matrix4)
            // },
            child: Container(
              color: Colors.transparent,
            ),
          ),
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 20, 10),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: FloatingActionButton(
                      heroTag: "FAB",
                      onPressed: () => {},
                      backgroundColor: Colors.white.withOpacity(0.2),
                      child: Icon(
                        Icons.chrome_reader_mode_outlined,
                      ),
                    ),
                  ),
                ),
                // Text(
                //   "adscxdsa",
                //   style: TextStyle(color: Colors.red),
                // )

                Align(
                    alignment: Alignment.bottomCenter,
                    child: ReaderOptionsPages(
                      isOnPageTurning: isOnPageTurning,
                      reader: widget.reader,
                      bloc: widget.bloc,
                      currentPage: widget.currentPage,
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}