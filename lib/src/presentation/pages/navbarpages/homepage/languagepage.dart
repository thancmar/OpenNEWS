import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sharemagazines_flutter/src/blocs/searchpage/search_bloc.dart';

import '../../../../blocs/navbar/navbar_bloc.dart';

class LanguagePage extends StatefulWidget {
  final String titleText;
  const LanguagePage({Key? key, required this.titleText}) : super(key: key);

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<SearchBloc>(context).add(OpenLanguageResults(context, widget.titleText));
    // BlocProvider.of<searchBloc.SearchBloc>(context).add(searchBloc.Initialize(context));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        // color: Colors.red,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/Background.png"),
            fit: BoxFit.fill,
          ),
        ),
        child: Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            automaticallyImplyLeading: false,
            // toolbarHeight: 100,
            leading: Container(
              // width: 35,
              color: Colors.transparent,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  BlocProvider.of<SearchBloc>(context).add(OpenSearch());
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(30, 0, 00, 0),
                  child: Hero(
                    tag: "backbutton",
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ),
            ),
            title: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Container(
                    child: FloatingActionButton.extended(
                      key: UniqueKey(),
                      heroTag: widget.titleText,
                      label: Text(
                        '${widget.titleText}',
                        textAlign: TextAlign.center,

                        // BlocProvider.of<NavbarBloc>(context).state.magazinePublishedGetLastWithLimit!.response!.length.toString(),
                        // style: TextStyle(fontSize: 12),
                      ),
                      onPressed: () {},
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                    ),
                  ),
                )
              ],
            ),
          ),
          body: SafeArea(
            child: Align(
              alignment: Alignment.center,
              child: BlocBuilder<SearchBloc, SearchState>(
                builder: (context, state) {
                  print("$state");
                  if (state is GoToLanguageResults) {
                    return GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 45, crossAxisSpacing: 0, childAspectRatio: 0.7),
                        itemCount: BlocProvider.of<SearchBloc>(context).state.futureLangFunc?.length,
                        physics: RangeMaintainingScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          print("SearchBloc ${BlocProvider.of<SearchBloc>(context).state.futureLangFunc?.length}");
                          return Align(
                            alignment: Alignment.center,
                            child: Card(
                              color: Colors.transparent,
                              elevation: 0,
                              // child: Center(child: Text('$index')),
                              child: FutureBuilder<Uint8List>(
                                  future: BlocProvider.of<SearchBloc>(context).state.futureLangFunc?[index],
                                  builder: (context, snapshot) {
                                    return Card(
                                        color: Colors.transparent,
                                        // clipBehavior: Clip.hardEdge,
                                        borderOnForeground: true,
                                        margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                        elevation: 0,
                                        semanticContainer: false,

                                        ///maybe 0?
                                        // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                        child: Stack(
                                          children: [
                                            (snapshot.hasData)
                                                ? Wrap(children: <Widget>[
                                                    GestureDetector(
                                                      behavior: HitTestBehavior.translucent,
                                                      onTap: () => {
                                                        // Navigator.of(context).push(
                                                        //   PageRouteBuilder(
                                                        //     transitionDuration: Duration(milliseconds: 1000),
                                                        //     pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
                                                        //       return StartReader(
                                                        //         id: state.magazinePublishedGetLastWithLimit!.response![i + 1].idMagazinePublication!,
                                                        //         index: i.toString(),
                                                        //         cover: snapshot.data!,
                                                        //         noofpages: state.magazinePublishedGetLastWithLimit!.response![i + 1].pageMax!,
                                                        //         readerTitle: state.magazinePublishedGetLastWithLimit!.response![i + 1].name!,
                                                        //
                                                        //         // noofpages: 5,
                                                        //       );
                                                        //     },
                                                        //     transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
                                                        //       return Align(
                                                        //         child: FadeTransition(
                                                        //           opacity: new CurvedAnimation(parent: animation, curve: Curves.easeIn),
                                                        //           child: child,
                                                        //         ),
                                                        //       );
                                                        //     },
                                                        //   ),
                                                        // )
                                                        // Navigator.push(
                                                        //   context,
                                                        //   PageRouteBuilder(
                                                        //     // transitionDuration:
                                                        //     // Duration(seconds: 2),
                                                        //     pageBuilder: (_, __, ___) => StartReader(
                                                        //       id: state.magazinePublishedGetLastWithLimit!.response![i].idMagazinePublication!,
                                                        //       index: i.toString(),
                                                        //       cover: snapshot.data!,
                                                        //       noofpages: state.magazinePublishedGetLastWithLimit!.response![i].pageMax!,
                                                        //       readerTitle: state.magazinePublishedGetLastWithLimit!.response![i].name!,
                                                        //
                                                        //       // noofpages: 5,
                                                        //     ),
                                                        //   ),
                                                        // ),
                                                      },
                                                      child: ClipRRect(
                                                        borderRadius: BorderRadius.circular(8.0),
                                                        child: Image.memory(
                                                          // state.bytes![i],
                                                          snapshot.data!,
                                                          // fit: BoxFit.fitHeight,
                                                          // fit: BoxFit.fitWidth,
                                                        ),
                                                      ),
                                                    ),
                                                    Align(
                                                      alignment: Alignment.center,
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Text(
                                                          NavbarState.magazinePublishedGetLastWithLimit!.response![index].name!,
                                                          // "sdfdsfsd",
                                                          // state.magazinePublishedGetLastWithLimit!.response![index].name!,
                                                          style: TextStyle(color: Colors.white),
                                                          textAlign: TextAlign.center,
                                                        ),
                                                      ),
                                                    )
                                                  ])
                                                // return GestureDetector(
                                                //   behavior: HitTestBehavior.translucent,
                                                //   onTap: () => {
                                                //     // Navigator.push(
                                                //     //     context,
                                                //     //     new ReaderRoute(
                                                //     //         widget: StartReader(
                                                //     //       id: state
                                                //     //           .magazinePublishedGetLastWithLimit
                                                //     //           .response![i + 1]
                                                //     //           .idMagazinePublication!,
                                                //     //       tagindex: i,
                                                //     //       cover: state.bytes[i],
                                                //     //     ))),
                                                //     // print('Asf'),
                                                //     Navigator.push(
                                                //       context,
                                                //       PageRouteBuilder(
                                                //         // transitionDuration:
                                                //         // Duration(seconds: 2),
                                                //         pageBuilder: (_, __, ___) => StartReader(
                                                //           id: state.magazinePublishedGetLastWithLimit.response![i + 1].idMagazinePublication!,
                                                //
                                                //           index: i.toString(),
                                                //           cover: state.bytes![i],
                                                //           noofpages: state.magazinePublishedGetLastWithLimit.response![i + 1].pageMax!,
                                                //           readerTitle: state.magazinePublishedGetLastWithLimit.response![i + 1].name!,
                                                //
                                                //           // noofpages: 5,
                                                //         ),
                                                //       ),
                                                //     )
                                                //     // Navigator.push(context,
                                                //     //     MaterialPageRoute(
                                                //     //         builder: (context) {
                                                //     //   return StartReader(
                                                //     //     id: state
                                                //     //         .magazinePublishedGetLastWithLimit
                                                //     //         .response![i + 1]
                                                //     //         .idMagazinePublication!,
                                                //     //     index: i,
                                                //     //   );
                                                //     // }))
                                                //   },
                                                //   child: Image.memory(
                                                //       // state.bytes![i],
                                                //       snapshot.data!
                                                //       // fit: BoxFit.fill,
                                                //       // frameBuilder: ((context, child, frame, wasSynchronouslyLoaded) {
                                                //       //   if (wasSynchronouslyLoaded) return child;
                                                //       //   return AnimatedSwitcher(
                                                //       //     duration: const Duration(milliseconds: 200),
                                                //       //     child: frame != null
                                                //       //         ? child
                                                //       //         : SizedBox(
                                                //       //             height: 60,
                                                //       //             width: 60,
                                                //       //             child: CircularProgressIndicator(strokeWidth: 6),
                                                //       //           ),
                                                //       //   );
                                                //       // }),
                                                //       ),
                                                // );

                                                : Container(
                                                    // color: Colors.grey.withOpacity(0.1),
                                                    color: Colors.transparent,

                                                    child: SpinKitFadingCircle(
                                                      color: Colors.white,
                                                      size: 50.0,
                                                    ),
                                                  ),
                                            // Align(
                                            //   alignment: Alignment.bottomCenter,
                                            //   child: Text(
                                            //     state.magazinePublishedGetLastWithLimit.response![i + 1].name!,
                                            //     // " asd",
                                            //     // "Card ${i + 1}",
                                            //     textAlign: TextAlign.center,
                                            //
                                            //     style: TextStyle(fontSize: 32, color: Colors.white, backgroundColor: Colors.transparent),
                                            //   ),
                                            // ),
                                          ],
                                        )
                                        // : Container(
                                        //     color: Colors.grey.withOpacity(0.1),
                                        //     child: SpinKitFadingCircle(
                                        //       color: Colors.white,
                                        //       size: 50.0,
                                        //     ),
                                        //   ),
                                        );
                                  }),
                            ),
                          );
                        });
                  }
                  return Container();
                },
              ),
            ),
            // body: SafeArea(
            //   child: Align(
            //     alignment: Alignment.center,
            //     child: BlocBuilder<SearchBloc, SearchState>(
            //       builder: (context, state) {
            //         // if (state is GoToLanguageResults) {
            //         //    state.futureFunc.forEach(files, functionThatReturnsAFuture).then((response) => print('All files processed'));
            //         // } else {
            //         //   return Container();
            //         // // return Container();
            //         // }
            //         if (state is GoToLanguageResults) {
            //           return ListView.builder(
            //             itemCount: state.futureFunc!.length,
            //             // prototypeItem: ListTile(
            //             //   title: Text("items.first"),
            //             // ),
            //             itemBuilder: (context, index) {
            //               return Container(
            //                 color: Colors.red,
            //                 // height: 100,
            //               );
            //             },
            //             // child: FutureBuilder<Uint8List>(
            //             //   future: state is OpenLanguageResults ? state.futureFunc : state.futureFunc,
            //             // ),
            //           );
            //         } else {
            //           return Container(
            //             color: Colors.green,
            //             // height: 100,
            //           );
            //         }
            //         // return PageView(
            //         //   child: SizedBox(
            //         //     height: 300,
            //         //     width: MediaQuery.of(context).size.width / 2.1,
            //         //     child: Padding(
            //         //       padding: const EdgeInsets.all(8.0),
            //         //       child: Container(
            //         //         // height: 100,
            //         //         // padding: EdgeInsets.all(8),
            //         //         color: Colors.red,
            //         //       ),
            //         //     ),
            //         //   ),
            //         // );
            //       },
            //     ),
            //     // child: FutureBuilder<Uint8List>(
            //     //   future: BlocProvider.of<NavbarBloc>(context).state.futureFunc?[i],
            //     //   child: Wrap(
            //     //     direction: Axis.horizontal,
            //     //     children: [
            //     //       // SizedBox(
            //     //       //   height: MediaQuery.of(context).size.height,
            //     //       //   child: PageView.builder(
            //     //       //       scrollDirection: Axis.vertical,
            //     //       //       allowImplicitScrolling: false,
            //     //       //       physics: RangeMaintainingScrollPhysics(),
            //     //       //       controller: PageController(
            //     //       //         viewportFraction: 1,
            //     //       //       ),
            //     //       //       // onPageChanged: (int index) => setState(() => _index2 = index),
            //     //       //       pageSnapping: false,
            //     //       //       itemBuilder: (context, i) {
            //     //       //         return FutureBuilder<Uint8List>(
            //     //       //           future: BlocProvider.of<NavbarBloc>(context).state.futureFunc?[i],
            //     //       //           builder: (context, snapshot) {
            //     //       //             return Transform.scale(
            //     //       //               // origin: Offset(0, 0),
            //     //       //
            //     //       //               // scale: i == _index1 ? 1 : 1,
            //     //       //               scale: 0.5,
            //     //       //
            //     //       //               alignment: Alignment.topLeft,
            //     //       //               // alignment: AlignmentGeometry(),
            //     //       //               child: Wrap(
            //     //       //                   alignment: WrapAlignment.start,
            //     //       //                   // verticalDirection: VerticalDirection.down,
            //     //       //                   direction: Axis.vertical,
            //     //       //                   // direction: Axis.horizontal,
            //     //       //                   children: [
            //     //       //                     SizedBox(
            //     //       //                       height: MediaQuery.of(context).size.height / 3,
            //     //       //                       child: Card(
            //     //       //                           color: Colors.red,
            //     //       //                           // clipBehavior: Clip.hardEdge,
            //     //       //                           // borderOnForeground: true,
            //     //       //                           margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
            //     //       //                           elevation: 0,
            //     //       //
            //     //       //                           ///maybe 0?
            //     //       //                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
            //     //       //                           child: Stack(
            //     //       //                             children: [
            //     //       //                               (snapshot.hasData)
            //     //       //                                   ? GestureDetector(
            //     //       //                                       behavior: HitTestBehavior.translucent,
            //     //       //                                       onTap: () => {
            //     //       //                                         // Navigator.push(
            //     //       //                                         //   context,
            //     //       //                                         //   PageRouteBuilder(
            //     //       //                                         //     // transitionDuration:
            //     //       //                                         //     // Duration(seconds: 2),
            //     //       //                                         //     pageBuilder: (_, __, ___) => StartReader(
            //     //       //                                         //       id: state.magazinePublishedGetLastWithLimit!.response![i].idMagazinePublication!,
            //     //       //                                         //       index: i.toString(),
            //     //       //                                         //       cover: snapshot.data!,
            //     //       //                                         //       noofpages: state.magazinePublishedGetLastWithLimit!.response![i].pageMax!,
            //     //       //                                         //       readerTitle: state.magazinePublishedGetLastWithLimit!.response![i].name!,
            //     //       //                                         //
            //     //       //                                         //       // noofpages: 5,
            //     //       //                                         //     ),
            //     //       //                                         //   ),
            //     //       //                                         // ),
            //     //       //                                       },
            //     //       //                                       child: Image.memory(
            //     //       //                                           // state.bytes![i],
            //     //       //                                           snapshot.data!),
            //     //       //                                     )
            //     //       //                                   : Container(
            //     //       //                                       color: Colors.grey.withOpacity(0.1),
            //     //       //                                       child: SpinKitFadingCircle(
            //     //       //                                         color: Colors.white,
            //     //       //                                         size: 50.0,
            //     //       //                                       ),
            //     //       //                                     ),
            //     //       //                             ],
            //     //       //                           )),
            //     //       //                     ),
            //     //       //                   ]),
            //     //       //             );
            //     //       //           },
            //     //       //         );
            //     //       //       }),
            //     //       // ),
            //     //       // Padding(
            //     //       //   padding: const EdgeInsets.fromLTRB(30, 0, 30, 10),
            //     //       //   child: SizedBox(
            //     //       //     height: MediaQuery.of(context).size.height,
            //     //       //     child: GridView.count(
            //     //       //       // crossAxisCount is the number of columns
            //     //       //       crossAxisCount: 2,
            //     //       //       // This creates two columns with two items in each column
            //     //       //       children: List.generate(30, (index) {
            //     //       //         return Center(
            //     //       //             child: FutureBuilder<Uint8List>(
            //     //       //           future: BlocProvider.of<NavbarBloc>(context).state.futureFunc?[index],
            //     //       //           builder: (context, snapshot) {
            //     //       //             return Transform.scale(
            //     //       //                 origin: Offset(0, 0),
            //     //       //
            //     //       //                 // scale: i == _index1 ? 1 : 1,
            //     //       //                 scale: 1,
            //     //       //                 // alignment: Alignment.topLeft,
            //     //       //
            //     //       //                 // alignment: AlignmentGeometry(),
            //     //       //                 child: Card(
            //     //       //                     color: Colors.red,
            //     //       //                     // clipBehavior: Clip.hardEdge,
            //     //       //                     // borderOnForeground: true,
            //     //       //                     margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
            //     //       //                     elevation: 0,
            //     //       //
            //     //       //                     ///maybe 0?
            //     //       //                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
            //     //       //                     child: Stack(
            //     //       //                       children: [
            //     //       //                         (snapshot.hasData)
            //     //       //                             ? GestureDetector(
            //     //       //                                 behavior: HitTestBehavior.translucent,
            //     //       //                                 onTap: () => {
            //     //       //                                   // Navigator.push(
            //     //       //                                   //   context,
            //     //       //                                   //   PageRouteBuilder(
            //     //       //                                   //     // transitionDuration:
            //     //       //                                   //     // Duration(seconds: 2),
            //     //       //                                   //     pageBuilder: (_, __, ___) => StartReader(
            //     //       //                                   //       id: state.magazinePublishedGetLastWithLimit!.response![i].idMagazinePublication!,
            //     //       //                                   //       index: i.toString(),
            //     //       //                                   //       cover: snapshot.data!,
            //     //       //                                   //       noofpages: state.magazinePublishedGetLastWithLimit!.response![i].pageMax!,
            //     //       //                                   //       readerTitle: state.magazinePublishedGetLastWithLimit!.response![i].name!,
            //     //       //                                   //
            //     //       //                                   //       // noofpages: 5,
            //     //       //                                   //     ),
            //     //       //                                   //   ),
            //     //       //                                   // ),
            //     //       //                                 },
            //     //       //                                 child: Image.memory(
            //     //       //
            //     //       //                                     // state.bytes![i],
            //     //       //                                     snapshot.data!),
            //     //       //                               )
            //     //       //                             : Container(
            //     //       //                                 color: Colors.grey.withOpacity(0.1),
            //     //       //                                 child: SpinKitFadingCircle(
            //     //       //                                   color: Colors.white,
            //     //       //                                   size: 50.0,
            //     //       //                                 ),
            //     //       //                               ),
            //     //       //                       ],
            //     //       //                     )));
            //     //       //           },
            //     //       //         ));
            //     //       //       }),
            //     //       //     ),
            //     //       //   ),
            //     //       // ),
            //     //       // Padding(
            //     //       //   padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
            //     //       //   child: SizedBox(
            //     //       //       height: MediaQuery.of(context).size.height,
            //     //       //       // width: MediaQuery.of(context).size.width / 2.5,
            //     //       //       child: ListView.builder(
            //     //       //           scrollDirection: Axis.horizontal,
            //     //       //           controller: PageController(
            //     //       //             viewportFraction: 0.50,
            //     //       //             initialPage: 1,
            //     //       //           ),
            //     //       //           // physics: ,
            //     //       //           // allowImplicitScrolling: false,
            //     //       //           // pageSnapping: false,
            //     //       //
            //     //       //           itemBuilder: (context, i) {
            //     //       //             return FutureBuilder<Uint8List>(
            //     //       //               future: BlocProvider.of<NavbarBloc>(context).state.futureFunc?[i],
            //     //       //               builder: (context, snapshot) {
            //     //       //                 return Transform.scale(
            //     //       //                     origin: Offset(0, 0),
            //     //       //
            //     //       //                     // scale: i == _index1 ? 1 : 1,
            //     //       //                     scale: 0.4,
            //     //       //                     alignment: Alignment.topLeft,
            //     //       //
            //     //       //                     // alignment: AlignmentGeometry(),
            //     //       //                     child: Card(
            //     //       //                         color: Colors.red,
            //     //       //                         // clipBehavior: Clip.hardEdge,
            //     //       //                         // borderOnForeground: true,
            //     //       //                         margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
            //     //       //                         elevation: 0,
            //     //       //
            //     //       //                         ///maybe 0?
            //     //       //                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
            //     //       //                         child: Stack(
            //     //       //                           children: [
            //     //       //                             (snapshot.hasData)
            //     //       //                                 ? GestureDetector(
            //     //       //                                     behavior: HitTestBehavior.translucent,
            //     //       //                                     onTap: () => {
            //     //       //                                       // Navigator.push(
            //     //       //                                       //   context,
            //     //       //                                       //   PageRouteBuilder(
            //     //       //                                       //     // transitionDuration:
            //     //       //                                       //     // Duration(seconds: 2),
            //     //       //                                       //     pageBuilder: (_, __, ___) => StartReader(
            //     //       //                                       //       id: state.magazinePublishedGetLastWithLimit!.response![i].idMagazinePublication!,
            //     //       //                                       //       index: i.toString(),
            //     //       //                                       //       cover: snapshot.data!,
            //     //       //                                       //       noofpages: state.magazinePublishedGetLastWithLimit!.response![i].pageMax!,
            //     //       //                                       //       readerTitle: state.magazinePublishedGetLastWithLimit!.response![i].name!,
            //     //       //                                       //
            //     //       //                                       //       // noofpages: 5,
            //     //       //                                       //     ),
            //     //       //                                       //   ),
            //     //       //                                       // ),
            //     //       //                                     },
            //     //       //                                     child: Image.memory(
            //     //       //
            //     //       //                                         // state.bytes![i],
            //     //       //                                         snapshot.data!),
            //     //       //                                   )
            //     //       //                                 : Container(
            //     //       //                                     color: Colors.grey.withOpacity(0.1),
            //     //       //                                     child: SpinKitFadingCircle(
            //     //       //                                       color: Colors.white,
            //     //       //                                       size: 50.0,
            //     //       //                                     ),
            //     //       //                                   ),
            //     //       //                           ],
            //     //       //                         )));
            //     //       //               },
            //     //       //             );
            //     //       //           })),
            //     //       // ),
            //     //
            //     //       SizedBox(
            //     //         height: 300,
            //     //         width: MediaQuery.of(context).size.width / 2.1,
            //     //         child: Padding(
            //     //           padding: const EdgeInsets.all(8.0),
            //     //           child: Container(
            //     //             // height: 100,
            //     //             // padding: EdgeInsets.all(8),
            //     //             color: Colors.red,
            //     //           ),
            //     //         ),
            //     //       ),
            //     //       SizedBox(
            //     //         height: 300,
            //     //         width: MediaQuery.of(context).size.width / 2.1,
            //     //         child: Padding(
            //     //           padding: const EdgeInsets.all(8.0),
            //     //           child: Container(
            //     //             // height: 100,
            //     //             color: Colors.red,
            //     //           ),
            //     //         ),
            //     //       ),
            //     //       SizedBox(
            //     //         height: 300,
            //     //         width: MediaQuery.of(context).size.width / 2.1,
            //     //         child: Padding(
            //     //           padding: const EdgeInsets.all(8.0),
            //     //           child: Container(
            //     //             // height: 100,
            //     //             color: Colors.red,
            //     //           ),
            //     //         ),
            //     //       ),
            //     //       SizedBox(
            //     //         height: 300,
            //     //         width: MediaQuery.of(context).size.width / 2.1,
            //     //         child: Padding(
            //     //           padding: const EdgeInsets.all(8.0),
            //     //           child: Container(
            //     //             // height: 100,
            //     //             color: Colors.red,
            //     //           ),
            //     //         ),
            //     //       ),
            //     //       SizedBox(
            //     //         height: 300,
            //     //         width: MediaQuery.of(context).size.width / 2.1,
            //     //         child: Padding(
            //     //           padding: const EdgeInsets.all(8.0),
            //     //           child: Container(
            //     //             // height: 100,
            //     //             color: Colors.red,
            //     //           ),
            //     //         ),
            //     //       )
            //     //     ],
            //     //   ),
            //     // ),
            //   ),
            // ),
          ),
        ));
  }
}