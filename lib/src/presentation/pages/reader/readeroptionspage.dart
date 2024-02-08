import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:sharemagazines_flutter/src/blocs/navbar/navbar_bloc.dart';
import 'package:sharemagazines_flutter/src/blocs/reader/reader_bloc.dart';
import 'package:sharemagazines_flutter/src/presentation/pages/reader/readerpage.dart';
import 'package:sharemagazines_flutter/src/presentation/pages/reader/readeroptionspages.dart';
import 'package:sharemagazines_flutter/src/presentation/widgets/marquee.dart';

import '../../../models/magazinePublishedGetAllLastByHotspotId_model.dart' as model;
import '../../../models/magazinePublishedGetAllLastByHotspotId_model.dart';
import '../../widgets/routes/toreaderoption.dart';

class ReaderOptionsPage extends StatefulWidget {
  // final model.Response magazine;
  final ReaderBloc bloc;

  final Reader reader;

  // final TransformationController controller;
  // Function callback;
  // bool isOnPageTurning;
  // print("dsfs");
  // int current = 0;
  // ValueNotifier<double> currentPage;

  ReaderOptionsPage({
    required this.reader,
    required this.bloc,
    // required this.currentPage,
    // required this.controller
  }) : super();

  @override
  State<ReaderOptionsPage> createState() => _ReaderOptionsPageState();
}

class _ReaderOptionsPageState extends State<ReaderOptionsPage> with AutomaticKeepAliveClientMixin<ReaderOptionsPage> {
  static Matrix4 matrix4 = Matrix4(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1);
  ValueNotifier<bool> isOnPageTurning = ValueNotifier<bool>(false);
  ValueNotifier<bool> showMagazineDetails = ValueNotifier<bool>(false);

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
            color: Colors.white,
            // size: 30,
          ),
          onPressed: () => {
            // Navigator.of(context).pop(),
            // dispose(),
            // Navigator.of(context).popUntil((route) => route.isFirst),
            // widget.bloc.add(CloseReader()),
            // widget.bloc.close(),
            // setState(() {
            //   pageScale = _controller.value.getMaxScaleOnAxis();
            // }),
            if(mounted){
            setState(() {
              // widget.reader.currentPage == i;
              print("gotopage 0");
              widget.reader.controllerflip.currentState!. goToPage(0);
// widget.reader.transformationController.value== Matrix4.identity();
              // widget.reader.pageController.animateToPage(i, duration: Duration(milliseconds: 200), curve: Curves.ease);
            }),},
            // widget.reader.transformationController.value = Matrix4.identity(), //To resize the loading icon

            // widget.bloc.add(CloseReader()),
            if(widget.reader.controllerflip.currentState!.pageNumber==0){
            widget.bloc.add(CloseReader())}
            // BlocProvider.of<ReaderBloc>(context).add(CloseReader()),
            // BlocProvider
            // Navigator.of(context).popUntil((route) => route.isFirst), widget.bloc.add(CloseReader()), widget.bloc.close()
          },
        ),
        title: MarqueeWidget(
          // child: Text("sfd"),
          child: Text(widget.reader.magazine.name! ?? "Title",style: Theme.of(context).textTheme.titleLarge,),
          direction: Axis.horizontal,
          // pauseDuration: Duration(milliseconds: 100),
          // animationDuration: Duration(seconds: 2),
          // backDuration: Duration(seconds: 1),
        ),
        actionsIconTheme: IconThemeData(
          color: Colors.white,
          size: 25,
        ),
        actions: [
          // Padding(
          //   padding: EdgeInsets.all(10.0),
          //   child: Icon(Icons.menu_outlined),
          // ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: GestureDetector(
              onTap: () => {
                setState(() {
                  if (NavbarState.bookmarks.value.response!
                      .any((element) => element.idMagazinePublication == widget.reader.magazine.idMagazinePublication)) {
                    // Removing the item from the list
                    NavbarState.bookmarks.value = MagazinePublishedGetAllLastByHotspotId(
                        response: NavbarState.bookmarks.value.response!
                            .where((element) => element.idMagazinePublication != widget.reader.magazine.idMagazinePublication)
                            .toList());
                  } else {
                    // Adding the item to the list using the spread operator
                    NavbarState.bookmarks.value =
                        MagazinePublishedGetAllLastByHotspotId(response: [...NavbarState.bookmarks.value.response!, widget.reader.magazine]);
                  }
                  BlocProvider.of<NavbarBloc>(context).add(Bookmark());
                })
              },
              child: Icon(NavbarState.bookmarks.value.response!
                      .any((element) => element.idMagazinePublication == widget.reader.magazine.idMagazinePublication)
                  ? Icons.bookmark
                  : Icons.bookmark_outline),
            ),
          ),
          GestureDetector(
            // onTap: () => Navigator.of(context).push(MaterialPageRoute(
            //   settings: RouteSettings(),
            //   builder: (context) => ReaderOptionsPageInformation(
            //     reader: this.widget.reader,
            //     currentPage: widget.currentPage,
            //   ),
            // )),
            onTap: () => {showMagazineDetails.value = !showMagazineDetails.value},
            // onTap: () => Navigator.pushReplacement(
            //     context,
            //     ReaderOptionRoute(
            //         widget: ReaderOptionsPageInformation(
            //       reader: this.widget.reader,
            //       currentPage: widget.currentPage,
            //     ))),
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Icon(Icons.info_outline),
            ),
          ),
        ],
        // titleSpacing: 0,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        //mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.topCenter,
              child: ValueListenableBuilder<bool>(
                  valueListenable: showMagazineDetails,
                  builder: (BuildContext context, bool counterValue, Widget? child) {
                    return counterValue
                        ? BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                            child: Container(
                              // height: double.infinity,
                              width: double.infinity,
                              margin: EdgeInsets.only(bottom: 50), // Create space at the bottom
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(15.0), // This provides the circular corners
                              ),
                              // color: Colors.grey.withOpacity(0.3),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(height: 20.0),
                                  Text(widget.reader.magazine.name!, style: TextStyle(fontSize: 16, color: Colors.white)),
                                  SizedBox(height: 8.0), // Add space
                                  Text("Pages - " + widget.reader.magazine.pageMax!, style: TextStyle(fontSize: 16, color: Colors.white)),
                                  SizedBox(height: 8.0), // Add space
                                  Text("Language - " + widget.reader.magazine.magazineLanguage!, style: TextStyle(fontSize: 16, color: Colors.white)),
                                  SizedBox(height: 8.0),
                                ],
                              ),
                            ),
                          )
                        : Container();
                  }),
            ),
          ),
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
                // Padding(
                //   padding: const EdgeInsets.fromLTRB(0, 20, 20, 10),
                //   child: Align(
                //     alignment: Alignment.bottomRight,
                //     child: FloatingActionButton(
                //       heroTag: "FAB",
                //       onPressed: () => {},
                //       backgroundColor: Colors.white.withOpacity(0.2),
                //       child: Icon(
                //         Icons.chrome_reader_mode_outlined,
                //       ),
                //     ),
                //   ),
                // ),
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
                      // currentPage: widget.currentPage,
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}