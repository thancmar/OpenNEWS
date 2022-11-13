import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:sharemagazines_flutter/src/blocs/reader_bloc.dart';
import 'package:sharemagazines_flutter/src/presentation/pages/readerpage.dart';
import 'package:sharemagazines_flutter/src/presentation/widgets/readeroptionspages.dart';
import 'package:sharemagazines_flutter/src/presentation/widgets/marquee.dart';

class ReaderOptionsPage extends StatefulWidget {
  final ReaderBloc bloc;

  final Reader reader;
  Function callback;
  bool isOnPageTurning;
  // print("dsfs");
  int current = 0;
  ReaderOptionsPage({required this.callback, required this.isOnPageTurning, required this.reader, required this.bloc}) : super();
  @override
  State<ReaderOptionsPage> createState() => _ReaderOptionsPageState();
}

class _ReaderOptionsPageState extends State<ReaderOptionsPage> with AutomaticKeepAliveClientMixin {
  static Matrix4 matrix4 = Matrix4(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1);
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
          onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
        ),
        title: MarqueeWidget(
          // child: Text("sfd"),
          child: Text(widget.reader.readerTitle ?? "Title"),
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
              if (widget.isOnPageTurning = true) {Navigator.of(context).pop(), print("single tap reader")}
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

                Align(alignment: Alignment.bottomCenter, child: ReaderOptionsPages(isOnPageTurning: widget.isOnPageTurning, callback: widget.callback, reader: widget.reader, bloc: widget.bloc)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}