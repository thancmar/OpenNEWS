import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sharemagazines_flutter/src/blocs/navbar/navbar_bloc.dart';

import '../pages/reader/readerpage.dart';

class News_aus_deiner_Region extends StatefulWidget {
  late int index1;
  final NavbarState state;

  News_aus_deiner_Region({Key? key, required this.index1, required this.state}) : super(key: key);

  @override
  State<News_aus_deiner_Region> createState() => News_aus_deiner_RegionState();
}

class News_aus_deiner_RegionState extends State<News_aus_deiner_Region> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400, // card height
      // width: 30,
      child: PageView.builder(
        itemCount: NavbarState.getTopMagazines!.length,
        // padEnds: true,

        controller: PageController(viewportFraction: 0.707),
        onPageChanged: (int index) => setState(() => widget.index1 = index),
        itemBuilder: (_, i) {
          return FutureBuilder<Uint8List>(
              future: NavbarState.getTopMagazines![i],
              builder: (context, snapshot) {
                return Transform.scale(
                  scale: i == widget.index1 ? 1 : 0.85,

                  alignment: Alignment.bottomCenter,
                  // alignment: AlignmentGeometry(),
                  // child: Card(
                  //   shadowColor: Colors.black,
                  //   elevation: 6,
                  //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                  //   child: Center(
                  //     child: Text(
                  //       // state.magazinePublishedGetLastWithLimit.response!
                  //       "Card ${i + 1}",
                  //       style: TextStyle(fontSize: 32),
                  //     ),
                  //   ),
                  // ),
                  child: Stack(
                    children: [
                      Card(
                          color: Colors.transparent,
                          // clipBehavior: Clip.hardEdge,
                          borderOnForeground: true,
                          margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          elevation: 0,
                          // key: stickyKey,

                          ///maybe 0?
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          child: Stack(
                            // clipBehavior: Clip.antiAlias,
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: Hero(
                                  //sizedbox after this w550 h300
                                  key: UniqueKey(),
                                  tag: 'News_aus_deiner_Region_$i',
                                  transitionOnUserGestures: true,

                                  child: (snapshot.hasData)
                                      ? GestureDetector(
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
                                            Navigator.push(
                                              context,
                                              PageRouteBuilder(
                                                // transitionDuration:
                                                // Duration(seconds: 2),
                                                pageBuilder: (_, __, ___) => StartReader(
                                                  id: NavbarState.magazinePublishedGetTopLastByRange!.response![i].idMagazinePublication!,
                                                  index: i.toString(),
                                                  cover: snapshot.data!,
                                                  noofpages: NavbarState.magazinePublishedGetTopLastByRange!.response![i].pageMax!,
                                                  readerTitle: NavbarState.magazinePublishedGetTopLastByRange!.response![i].name!,
                                                  heroTag: 'News_aus_deiner_Region_$i',
                                                  // noofpages: 5,
                                                ),
                                              ),
                                            ),
                                          },
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(8.0),
                                            child: Image.memory(
                                              // state.bytes![i],
                                              snapshot.data!,
                                            ),
                                          ),
                                        )
                                      : Container(
                                          color: Colors.grey.withOpacity(0.1),
                                          child: SpinKitFadingCircle(
                                            color: Colors.white,
                                            size: 50.0,
                                          ),
                                        ),
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
                          ),
                      Positioned(
                        bottom: 0,
                        left: 20,
                        right: 20,
                        // right: MediaQuery.of(context).size.heigh / 2, //60 because of padding
                        child: Column(
                          children: [
                            Card(
                              color: Colors.grey[900],
                              shape: RoundedRectangleBorder(
                                side: BorderSide(color: Colors.white70, width: 0),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              margin: EdgeInsets.all(10.0),
                              child: Icon(
                                Icons.ac_unit,
                                size: 80,
                                color: Colors.amber,
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Hamburger Morgenpost ",
                                    // text: state.magazinePublishedGetLastWithLimit!.response![_index1].name!
                                  ),
                                  WidgetSpan(
                                    child: Icon(Icons.navigate_next_outlined, color: Colors.white, size: 14),
                                  ),
                                ],
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(text: "11. Januar 2022", style: TextStyle(color: Colors.grey, fontSize: 12)),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              });
        },
      ),
    );
    // return Container();
  }
}