import 'dart:async';
import 'dart:typed_data';

import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shaky_animated_listview/widgets/animated_listview.dart';
import 'package:sharemagazines_flutter/src/blocs/navbar_bloc.dart';
import 'package:sharemagazines_flutter/src/blocs/reader_bloc.dart';
import 'package:sharemagazines_flutter/src/models/location_model.dart';
import 'package:sharemagazines_flutter/src/presentation/pages/readerpage.dart';
import 'package:sharemagazines_flutter/src/presentation/widgets/photohero.dart';
import 'package:sharemagazines_flutter/src/presentation/widgets/routes/toreader.dart';
import 'package:sharemagazines_flutter/src/presentation/widgets/routes/toreaderoption.dart';
import 'package:sharemagazines_flutter/src/resources/location_repository.dart';

import '../../blocs/search_bloc.dart' as searchBloc;
import '../../resources/magazine_repository.dart';
import '../widgets/news_aus_deiner_Region.dart';

// class HomePageState extends StatelessWidget {
//   const HomePageState({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(create: (context) => ReaderBloc(), child: HomePage());
//   }
// }
// class HomePageState extends StatelessWidget {
//   final NavbarBloc navbarBloc;
//   const HomePageState({Key? key, required this.navbarBloc}) : super(key: key);
//
//   // MapBloc _bloc = MapBloc(
//   //   hotspotRepository: HotspotRepository(),
//   // );
//   @override
//   Widget build(BuildContext context) {
//     // Future<HotspotsGetAllActive>hp = RepositoryProvider.of<HotspotRepository>(context);
//     return BlocProvider.value(
//       value: navbarBloc,
//       child: HomePage(),
//     );
//   }
// }

class HomePage extends StatefulWidget {
  // final NavbarBloc navbarBloc;
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin<HomePage> {
  int _index1 = 0;
  int _index2 = 1;
  static const _indicatorSize = 150.0;
  bool _renderCompleteState = false;
  List<Uint8List> meistgelesene_Artikel = [];
  // final Stream<int> _bids = (() {
  //   late final StreamController<int> controller;
  //   controller = StreamController<int>(
  //     onListen: () async {
  //       await Future<void>.delayed(const Duration(seconds: 1));
  //       controller.add(1);
  //       await Future<void>.delayed(const Duration(seconds: 1));
  //       await controller.close();
  //     },
  //   );
  //   return controller.stream;
  // })();
  late Localization locationupdate;

  // late Future futureRecords;

  @override
  void initState() {
    super.initState();
    print("_HomePageState init");
    // BlocProvider.of<searchBloc.SearchBloc>(context).add(searchBloc.Initialize(context));
  }

  @override
  bool get wantKeepAlive => true;

  void dispose() {
    super.dispose();
    // print("_HomePageState dispose");
    // this._dispatchEvent(
    //     context); // This will dispatch the navigateToHomeScreen event.
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<NavbarBloc, NavbarState>(
      // buildWhen: (p, c) => p.navbarItem.name != c.navbarItem.name,
      builder: (BuildContext context, state) {
        // print("state is home");
        print("Navbar state is $state");
        if (state is GoToHome) {
          // BlocProvider.of<searchBloc.SearchBloc>(context).add(searchBloc.Initialize(context));
          // print(state.magazinePublishedGetLastWithLimit!.response![0].idMagazinePublication!);
          //
          // print(state.location?.data![0].nameApp);
          // Uint8List bytes123 = state.bytes as Uint8List;
          // print(state.bytes);
          // print(state.magazinePublishedGetLastWithLimit.response!.iterator
          //     .current.idMagazine!);
          return SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: CustomRefreshIndicator(
                    onRefresh: () => _updatelocation(),
                    // onRefresh: () => Future.delayed(const Duration(seconds: 2)),
                    offsetToArmed: _indicatorSize,
                    onStateChanged: (change) {
                      /// set [_renderCompleteState] to true when controller.state become completed
                      if (change.didChange(to: IndicatorState.complete)) {
                        setState(() {
                          _renderCompleteState = true;
                        });

                        /// set [_renderCompleteState] to false when controller.state become idle
                      } else if (change.didChange(to: IndicatorState.idle)) {
                        setState(() {
                          _renderCompleteState = false;
                        });
                      }
                    },
                    builder: (
                      BuildContext context,
                      Widget child,
                      IndicatorController controller,
                    ) {
                      return AnimatedBuilder(
                        animation: controller,
                        builder: (BuildContext context, _) {
                          return Stack(
                            alignment: Alignment.topCenter,
                            children: <Widget>[
                              if (!controller.isIdle)
                                Positioned(
                                  top: 35.0 * controller.value,
                                  child: SizedBox(
                                    height: 30,
                                    width: 30,
                                    child: _renderCompleteState
                                        ? const Icon(
                                            Icons.check,
                                            color: Colors.white,
                                          )
                                        : SizedBox(
                                            height: 30,
                                            width: 30,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor: const AlwaysStoppedAnimation(Colors.white),
                                              value: controller.isDragging || controller.isArmed ? controller.value.clamp(0.0, 1.0) : null,
                                            ),
                                          ),
                                  ),
                                ),
                              Transform.translate(
                                offset: Offset(0, 100.0 * controller.value),
                                child: child,
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: ListView(
                      // duration: 00,
                      padding: EdgeInsets.all(0),
                      physics: ClampingScrollPhysics(),
                      // spaceBetween: 20,
                      shrinkWrap: true,
                      // crossAxisCount: 2,
                      // mainAxisExtent: 256,
                      // crossAxisSpacing: 8,
                      // mainAxisSpacing: 8,
                      // children: Column(
                      children: [
                        SingleChildScrollView(
                          physics: RangeMaintainingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(20, 0, 10, 5),
                                child: Container(
                                  width: MediaQuery.of(context).size.width * 0.40,
                                  height: MediaQuery.of(context).size.width * 0.1,
                                  child: FloatingActionButton.extended(
                                    // heroTag: 'location_offers',
                                    heroTag: null,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8)), side: BorderSide(color: Colors.white, width: 0.2)),
                                    label: Text(
                                      'Speisekarte',
                                      style: TextStyle(fontSize: 12),
                                    ), // <-- Text
                                    backgroundColor: Colors.grey.withOpacity(0.1),
                                    icon: Icon(
                                      // <-- Icon
                                      Icons.menu_book,
                                      size: 16.0,
                                    ),
                                    onPressed: () {},
                                    // extendedPadding: EdgeInsets.all(50),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 10, 5),
                                child: Container(
                                  width: MediaQuery.of(context).size.width * 0.40,
                                  height: MediaQuery.of(context).size.width * 0.1,
                                  child: FloatingActionButton.extended(
                                    // heroTag: 'location_offers',
                                    heroTag: null,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8)), side: BorderSide(color: Colors.white, width: 0.2)),

                                    label: Text(
                                      'Unser Barista',
                                      style: TextStyle(fontSize: 12),
                                    ), // <-- Text
                                    backgroundColor: Colors.grey.withOpacity(0.1),
                                    icon: Icon(
                                      // <-- Icon
                                      Icons.account_box,
                                      size: 16.0,
                                    ),
                                    onPressed: () {},
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 10, 5),
                                child: Container(
                                  width: MediaQuery.of(context).size.width * 0.40,
                                  height: MediaQuery.of(context).size.width * 0.1,
                                  child: FloatingActionButton.extended(
                                    // heroTag: 'location_offers',
                                    heroTag: null,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8)), side: BorderSide(color: Colors.white, width: 0.2)),
                                    label: Text(
                                      'Kaffeesorten',
                                      style: TextStyle(fontSize: 12),
                                    ), // <-- Text
                                    backgroundColor: Colors.grey.withOpacity(0.1),
                                    icon: Icon(
                                      // <-- Icon
                                      Icons.coffee,
                                      size: 16.0,
                                    ),
                                    onPressed: () {},
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Column(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(25, 20, 25, 20),
                                    child: Text(
                                      "News aus deiner Region",
                                      style: TextStyle(color: Colors.white, fontSize: 16),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                ),
                                News_aus_deiner_Region(index1: _index1, state: state),
                              ],
                            ),

                            Positioned(
                              bottom: -70,
                              right: 100, //60 because of padding
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
                            // Positioned(
                            //   left: 20.0,
                            //   child: Padding(
                            //     padding: const EdgeInsets.fromLTRB(25, 0, 25, 20),
                            //     child: Text(
                            //       "News aus deiner Region",
                            //       style:
                            //           TextStyle(color: Colors.white, fontSize: 16),
                            //       textAlign: TextAlign.right,
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                        Column(
                          // crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(25, 100, 25, 20),
                                child: Text(
                                  'Meistgelesene Artikel',
                                  style: TextStyle(color: Colors.white, fontSize: 16),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ),
                            SizedBox(
                                height: 300, // card height
                                child: PageView.builder(
                                  // itemCount: state.magazinePublishedGetLastWithLimit?.response?.length ?? 0 + 10,
                                  // itemCount: state.magazinePublishedGetLastWithLimit.response!.length! + 10,
                                  // itemCount: 10,
                                  // padEnds: true,
                                  allowImplicitScrolling: false,
                                  controller: PageController(
                                    viewportFraction: 0.65,
                                  ),
                                  // onPageChanged: (int index) => setState(() => _index2 = index),
                                  onPageChanged: (int index) => _index2 = index,
                                  pageSnapping: false,
                                  itemBuilder: (context, i) {
                                    // if (state.bytes.isEmpty) {
                                    //   setState(() {});
                                    // }
                                    // print("Herooo $i");
                                    return Hero(
                                      key: UniqueKey(),
                                      tag: 'Meistgelesene_Artikel_$i',
                                      child: FutureBuilder<Uint8List>(
                                        future: state.futureFunc?[i],
                                        builder: (context, snapshot) {
                                          return Transform.scale(
                                            // origin: Offset(100, 50),

                                            // scale: i == _index1 ? 1 : 1,
                                            scale: 1,

                                            alignment: Alignment.bottomCenter,
                                            // alignment: AlignmentGeometry(),
                                            child: Card(
                                                color: Colors.transparent,
                                                // clipBehavior: Clip.hardEdge,
                                                borderOnForeground: true,
                                                margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
                                                elevation: 0,

                                                ///maybe 0?
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                                                child: Stack(
                                                  children: [
                                                    (snapshot.hasData)
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
                                                                  // transitionDuration: Duration(seconds: 2),
                                                                  opaque: true,
                                                                  pageBuilder: (_, __, ___) => StartReader(
                                                                    id: state.magazinePublishedGetLastWithLimit!.response![i].idMagazinePublication!,
                                                                    index: i.toString(),
                                                                    heroTag: 'Meistgelesene_Artikel_$i',
                                                                    cover: snapshot.data!,
                                                                    noofpages: state.magazinePublishedGetLastWithLimit!.response![i].pageMax!,
                                                                    readerTitle: state.magazinePublishedGetLastWithLimit!.response![i].name!,

                                                                    // noofpages: 5,
                                                                  ),
                                                                ),
                                                              ),
                                                            },
                                                            child: ClipRRect(
                                                              borderRadius: BorderRadius.circular(5.0),
                                                              child: Image.memory(
                                                                  // state.bytes![i],
                                                                  snapshot.data!),
                                                            ),
                                                          )
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
                                                            color: Colors.grey.withOpacity(0.1),
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
                                                ),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                )
                                // child: PageView.builder(
                                //   // itemCount: state.magazinePublishedGetLastWithLimit.response!.length! + 1,
                                //   itemCount: state.magazinePublishedGetLastWithLimit.response!.length! + 1,
                                //   // itemCount: 10,
                                //   // padEnds: true,
                                //   allowImplicitScrolling: false,
                                //   controller: PageController(viewportFraction: 0.65),
                                //   onPageChanged: (int index) => setState(() => _index2 = index),
                                //   pageSnapping: false,
                                //   itemBuilder: (context, i) {
                                //     // if (state.bytes.isEmpty) {
                                //     //   setState(() {});
                                //     // }
                                //     return Transform.scale(
                                //       // origin: Offset(100, 50),
                                //
                                //       // scale: i == _index1 ? 1 : 1,
                                //       scale: 1,
                                //
                                //       alignment: Alignment.bottomCenter,
                                //       // alignment: AlignmentGeometry(),
                                //       child: Card(
                                //         color: Colors.transparent,
                                //         clipBehavior: Clip.antiAliasWithSaveLayer,
                                //         margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
                                //         elevation: 0,
                                //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                //         child: state.bytes.isNotEmpty
                                //             ? Stack(
                                //                 children: [
                                //                   Hero(
                                //                     tag: '$i',
                                //                     transitionOnUserGestures: true,
                                //                     child: SizedBox(
                                //                       width: 450,
                                //                       height: 300,
                                //                       child: GestureDetector(
                                //                         behavior: HitTestBehavior.translucent,
                                //                         onTap: () => {
                                //                           // Navigator.push(
                                //                           //     context,
                                //                           //     new ReaderRoute(
                                //                           //         widget: StartReader(
                                //                           //       id: state
                                //                           //           .magazinePublishedGetLastWithLimit
                                //                           //           .response![i + 1]
                                //                           //           .idMagazinePublication!,
                                //                           //       tagindex: i,
                                //                           //       cover: state.bytes[i],
                                //                           //     ))),
                                //                           // print('Asf'),
                                //                           Navigator.push(
                                //                             context,
                                //                             PageRouteBuilder(
                                //                               // transitionDuration:
                                //                               // Duration(seconds: 2),
                                //                               pageBuilder: (_, __, ___) => StartReader(
                                //                                 id: state.magazinePublishedGetLastWithLimit.response![i + 1].idMagazinePublication!,
                                //
                                //                                 index: i.toString(),
                                //                                 cover: state.bytes![i],
                                //                                 noofpages: state.magazinePublishedGetLastWithLimit.response![i + 1].pageMax!,
                                //                                 readerTitle: state.magazinePublishedGetLastWithLimit.response![i + 1].name!,
                                //
                                //                                 // noofpages: 5,
                                //                               ),
                                //                             ),
                                //                           )
                                //                           // Navigator.push(context,
                                //                           //     MaterialPageRoute(
                                //                           //         builder: (context) {
                                //                           //   return StartReader(
                                //                           //     id: state
                                //                           //         .magazinePublishedGetLastWithLimit
                                //                           //         .response![i + 1]
                                //                           //         .idMagazinePublication!,
                                //                           //     index: i,
                                //                           //   );
                                //                           // }))
                                //                         },
                                //                         child: Image.memory(
                                //                           state.bytes![i],
                                //                           // fit: BoxFit.fill,
                                //                           // frameBuilder: ((context, child, frame, wasSynchronouslyLoaded) {
                                //                           //   if (wasSynchronouslyLoaded) return child;
                                //                           //   return AnimatedSwitcher(
                                //                           //     duration: const Duration(milliseconds: 200),
                                //                           //     child: frame != null
                                //                           //         ? child
                                //                           //         : SizedBox(
                                //                           //             height: 60,
                                //                           //             width: 60,
                                //                           //             child: CircularProgressIndicator(strokeWidth: 6),
                                //                           //           ),
                                //                           //   );
                                //                           // }),
                                //                         ),
                                //                       ),
                                //                       // child: Image.network(
                                //                       //   'https://via.placeholder.com/300?text=DITTO',
                                //                       //   fit: BoxFit.fill,
                                //                       // ),
                                //                     ),
                                //                   ),
                                //                   // Align(
                                //                   //   alignment: Alignment.bottomCenter,
                                //                   //   child: Text(
                                //                   //     state.magazinePublishedGetLastWithLimit.response![i + 1].name!,
                                //                   //     // " asd",
                                //                   //     // "Card ${i + 1}",
                                //                   //     textAlign: TextAlign.center,
                                //                   //
                                //                   //     style: TextStyle(fontSize: 32, color: Colors.white, backgroundColor: Colors.transparent),
                                //                   //   ),
                                //                   // ),
                                //                 ],
                                //               )
                                //             : Container(
                                //                 color: Colors.grey.withOpacity(0.2),
                                //                 child: SpinKitFadingCircle(
                                //                   color: Colors.white,
                                //                   size: 50.0,
                                //                 ),
                                //               ),
                                //       ),
                                //     );
                                //   },
                                // )
                                ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 200),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(25, 40, 25, 20),
                                  child: Text(
                                    'Mit deinem Profil weiterstöbern',
                                    style: TextStyle(color: Colors.white, fontSize: 16),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 200, // card height

                                child: PageView.builder(
                                  itemCount: 5,
                                  // padEnds: true,

                                  controller: PageController(viewportFraction: 0.45),
                                  onPageChanged: (int index) => setState(() => _index2 = index),
                                  itemBuilder: (_, i) {
                                    return Transform.scale(
                                      // origin: Offset(100, 50),
                                      // BlocProvider.of<auth.AuthBloc>(context).add(
                                      //   auth.SignInRequested(_emailController.text, _passwordController.text),
                                      // );
                                      scale: i == _index2 ? 1 : 1,
                                      alignment: Alignment.bottomCenter,
                                      // alignment: AlignmentGeometry(),
                                      child: GestureDetector(
                                        onTap: () => {
                                          // BlocProvider.of<ReaderBloc>(context)
                                          //     .add(
                                          //   OpenReader(),
                                          // ),
                                          // Navigator.of(context,
                                          //         rootNavigator: true)
                                          //     .push(// ensures fullscreen
                                          //         CupertinoPageRoute(builder:
                                          //             (BuildContext context) {
                                          //   return Reader();
                                          // }))
                                        },
                                        child: Card(
                                          clipBehavior: Clip.antiAliasWithSaveLayer,
                                          margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
                                          elevation: 6,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                width: 200,
                                                height: 150,
                                                child: Image.network(
                                                  'https://via.placeholder.com/300?text=DITTO',
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        return Container();
      },
    );
  }

  // Widget _News_aus_deiner_Region(BuildContext context, NavbarState state) {
  //   return SizedBox(
  //     height: 350, // card height
  //     child: PageView.builder(
  //       itemCount: 5,
  //       // padEnds: true,
  //
  //       controller: PageController(viewportFraction: 0.707),
  //       onPageChanged: (int index) => setState(() => _index1 = index),
  //       itemBuilder: (_, i) {
  //         return FutureBuilder<Uint8List>(
  //             future: state.futureFunc?[i],
  //             builder: (context, snapshot) {
  //               return Transform.scale(
  //                 scale: i == _index1 ? 1 : 0.85,
  //
  //                 alignment: Alignment.bottomCenter,
  //                 // alignment: AlignmentGeometry(),
  //                 // child: Card(
  //                 //   shadowColor: Colors.black,
  //                 //   elevation: 6,
  //                 //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
  //                 //   child: Center(
  //                 //     child: Text(
  //                 //       // state.magazinePublishedGetLastWithLimit.response!
  //                 //       "Card ${i + 1}",
  //                 //       style: TextStyle(fontSize: 32),
  //                 //     ),
  //                 //   ),
  //                 // ),
  //                 child: Card(
  //                     color: Colors.transparent,
  //                     // clipBehavior: Clip.hardEdge,
  //                     borderOnForeground: true,
  //                     margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
  //                     elevation: 0,
  //
  //                     ///maybe 0?
  //                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  //                     child: Stack(
  //                       // clipBehavior: Clip.antiAlias,
  //                       children: [
  //                         Align(
  //                           alignment: Alignment.center,
  //                           child: Hero(
  //                             //sizedbox after this w550 h300
  //                             key: UniqueKey(),
  //                             tag: '$i',
  //                             transitionOnUserGestures: true,
  //
  //                             child: (snapshot.hasData)
  //                                 ? GestureDetector(
  //                                     behavior: HitTestBehavior.translucent,
  //                                     onTap: () => {
  //                                       // Navigator.of(context).push(
  //                                       //   PageRouteBuilder(
  //                                       //     transitionDuration: Duration(milliseconds: 1000),
  //                                       //     pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
  //                                       //       return StartReader(
  //                                       //         id: state.magazinePublishedGetLastWithLimit!.response![i + 1].idMagazinePublication!,
  //                                       //         index: i.toString(),
  //                                       //         cover: snapshot.data!,
  //                                       //         noofpages: state.magazinePublishedGetLastWithLimit!.response![i + 1].pageMax!,
  //                                       //         readerTitle: state.magazinePublishedGetLastWithLimit!.response![i + 1].name!,
  //                                       //
  //                                       //         // noofpages: 5,
  //                                       //       );
  //                                       //     },
  //                                       //     transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
  //                                       //       return Align(
  //                                       //         child: FadeTransition(
  //                                       //           opacity: new CurvedAnimation(parent: animation, curve: Curves.easeIn),
  //                                       //           child: child,
  //                                       //         ),
  //                                       //       );
  //                                       //     },
  //                                       //   ),
  //                                       // )
  //                                       Navigator.push(
  //                                         context,
  //                                         PageRouteBuilder(
  //                                           // transitionDuration:
  //                                           // Duration(seconds: 2),
  //                                           pageBuilder: (_, __, ___) => StartReader(
  //                                             id: state.magazinePublishedGetLastWithLimit!.response![i].idMagazinePublication!,
  //                                             index: i.toString(),
  //                                             cover: snapshot.data!,
  //                                             noofpages: state.magazinePublishedGetLastWithLimit!.response![i].pageMax!,
  //                                             readerTitle: state.magazinePublishedGetLastWithLimit!.response![i].name!,
  //
  //                                             // noofpages: 5,
  //                                           ),
  //                                         ),
  //                                       ),
  //                                     },
  //                                     child: ClipRRect(
  //                                       borderRadius: BorderRadius.circular(8.0),
  //                                       child: Image.memory(
  //                                         // state.bytes![i],
  //                                         snapshot.data!,
  //                                       ),
  //                                     ),
  //                                   )
  //                                 // return GestureDetector(
  //                                 //   behavior: HitTestBehavior.translucent,
  //                                 //   onTap: () => {
  //                                 //     // Navigator.push(
  //                                 //     //     context,
  //                                 //     //     new ReaderRoute(
  //                                 //     //         widget: StartReader(
  //                                 //     //       id: state
  //                                 //     //           .magazinePublishedGetLastWithLimit
  //                                 //     //           .response![i + 1]
  //                                 //     //           .idMagazinePublication!,
  //                                 //     //       tagindex: i,
  //                                 //     //       cover: state.bytes[i],
  //                                 //     //     ))),
  //                                 //     // print('Asf'),
  //                                 //     Navigator.push(
  //                                 //       context,
  //                                 //       PageRouteBuilder(
  //                                 //         // transitionDuration:
  //                                 //         // Duration(seconds: 2),
  //                                 //         pageBuilder: (_, __, ___) => StartReader(
  //                                 //           id: state.magazinePublishedGetLastWithLimit.response![i + 1].idMagazinePublication!,
  //                                 //
  //                                 //           index: i.toString(),
  //                                 //           cover: state.bytes![i],
  //                                 //           noofpages: state.magazinePublishedGetLastWithLimit.response![i + 1].pageMax!,
  //                                 //           readerTitle: state.magazinePublishedGetLastWithLimit.response![i + 1].name!,
  //                                 //
  //                                 //           // noofpages: 5,
  //                                 //         ),
  //                                 //       ),
  //                                 //     )
  //                                 //     // Navigator.push(context,
  //                                 //     //     MaterialPageRoute(
  //                                 //     //         builder: (context) {
  //                                 //     //   return StartReader(
  //                                 //     //     id: state
  //                                 //     //         .magazinePublishedGetLastWithLimit
  //                                 //     //         .response![i + 1]
  //                                 //     //         .idMagazinePublication!,
  //                                 //     //     index: i,
  //                                 //     //   );
  //                                 //     // }))
  //                                 //   },
  //                                 //   child: Image.memory(
  //                                 //       // state.bytes![i],
  //                                 //       snapshot.data!
  //                                 //       // fit: BoxFit.fill,
  //                                 //       // frameBuilder: ((context, child, frame, wasSynchronouslyLoaded) {
  //                                 //       //   if (wasSynchronouslyLoaded) return child;
  //                                 //       //   return AnimatedSwitcher(
  //                                 //       //     duration: const Duration(milliseconds: 200),
  //                                 //       //     child: frame != null
  //                                 //       //         ? child
  //                                 //       //         : SizedBox(
  //                                 //       //             height: 60,
  //                                 //       //             width: 60,
  //                                 //       //             child: CircularProgressIndicator(strokeWidth: 6),
  //                                 //       //           ),
  //                                 //       //   );
  //                                 //       // }),
  //                                 //       ),
  //                                 // );
  //
  //                                 : Container(
  //                                     color: Colors.grey.withOpacity(0.1),
  //                                     child: SpinKitFadingCircle(
  //                                       color: Colors.white,
  //                                       size: 50.0,
  //                                     ),
  //                                   ),
  //                           ),
  //                         ),
  //                         // Align(
  //                         //   alignment: Alignment.bottomCenter,
  //                         //   child: Text(
  //                         //     state.magazinePublishedGetLastWithLimit.response![i + 1].name!,
  //                         //     // " asd",
  //                         //     // "Card ${i + 1}",
  //                         //     textAlign: TextAlign.center,
  //                         //
  //                         //     style: TextStyle(fontSize: 32, color: Colors.white, backgroundColor: Colors.transparent),
  //                         //   ),
  //                         // ),
  //                       ],
  //                     )
  //                     // : Container(
  //                     //     color: Colors.grey.withOpacity(0.1),
  //                     //     child: SpinKitFadingCircle(
  //                     //       color: Colors.white,
  //                     //       size: 50.0,
  //                     //     ),
  //                     //   ),
  //                     ),
  //               );
  //             });
  //       },
  //     ),
  //   );
  // }

  Future<void> _updatelocation() async {
    //client error
    // locationupdate = await RepositoryProvider.of<LocationRepository>(context).checklocation();

    // await locationupdate.then((data) {}, onError: (e) {
    //   // print(data);
    //   print(e);
    // });
    // BlocProvider.of<NavbarBloc>(context).add(Home());
    print('locationupdate');
    print(locationupdate.data?[0].nameApp);
    // return locationupdate;
  }
// _updatelocation() {
//   locationupdate =
//       RepositoryProvider.of<LocationRepository>(context).checklocation();
//   locationupdate.then((data) {}, onError: (e) {
//     print("fsadfs");
//     print(e);
//   });
// }
// Widget _buildas(BuildContext context) {
//   return AnimatedListView(
//     duration: 100,
//     scrollDirection: Axis.horizontal,
//     children: List.generate(
//       21,
//       (index) => const Card(
//         elevation: 50,
//         margin: EdgeInsets.symmetric(horizontal: 10),
//         shadowColor: Colors.black,
//         color: Colors.grey,
//         child: SizedBox(
//           height: 300,
//           width: 200,
//         ),
//       ),
//     ),
//   );
// }
}

// class _MenuPageState extends State<MenuPage> {
//   @override
//   Widget build(BuildContext context) {
//     return ExpandableNotifier(
//         child: Padding(
//       padding: const EdgeInsets.all(40),
//       child: Card(
//         color: Colors.blue, //transparent
//         clipBehavior: Clip.antiAlias,
//         child: Column(
//           children: <Widget>[
//             // SizedBox(
//             //   height: 150,
//             //   child: Container(
//             //     decoration: BoxDecoration(
//             //       color: Colors.orange,
//             //       shape: BoxShape.rectangle,
//             //     ),
//             //   ),
//             // ),
//             ScrollOnExpand(
//               scrollOnExpand: true,
//               scrollOnCollapse: false,
//               child: ExpandablePanel(
//                 theme: const ExpandableThemeData(
//                   headerAlignment: ExpandablePanelHeaderAlignment.center,
//                   hasIcon: true,
//                   iconPlacement: ExpandablePanelIconPlacement.left,
//                   // tapBodyToCollapse: true,
//                   // hasIcon: true,
//                 ),
//                 header: Padding(
//                     padding: EdgeInsets.all(10),
//                     child: Row(
//                       children: [
//                         Icon(
//                           Icons.circle,
//                           color: Colors.white,
//                           size: 70,
//                         ),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
//                               child: Container(
//                                 child: Text(
//                                   "data",
//                                   style: TextStyle(
//                                       fontSize: 20, color: Colors.red),
//                                   // textAlign: TextAlign.left,
//                                 ),
//                               ),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.fromLTRB(20, 5, 0, 0),
//                               child: Container(
//                                 child: Text(
//                                   "data afd",
//                                   style: TextStyle(
//                                       fontSize: 16, color: Colors.red),
//                                   // textAlign: TextAlign.right,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         Icon(
//                           Icons.search,
//                           color: Colors.white,
//                           size: 40,
//                         ),
//                       ],
//                     )),
//                 collapsed: Text(
//                   "loremIpsum",
//                   softWrap: true,
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//                 expanded: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     for (var _ in Iterable.generate(5))
//                       Padding(
//                           padding: EdgeInsets.only(bottom: 10),
//                           child: Text(
//                             "loremIpsum",
//                             softWrap: true,
//                             overflow: TextOverflow.fade,
//                           )),
//                   ],
//                 ),
//                 builder: (_, collapsed, expanded) {
//                   return Padding(
//                     padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
//                     child: Expandable(
//                       collapsed: collapsed,
//                       expanded: expanded,
//                       theme: const ExpandableThemeData(crossFadePoint: 0),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     ));
//   }
// }

// class _MenuPageState extends State<MenuPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         child: Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.fromLTRB(35, 50, 35, 35),
//           child: Row(
//             children: [
//               Icon(
//                 Icons.circle,
//                 color: Colors.white,
//                 size: 70,
//               ),
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
//                 child: Container(
//                   child: Text(
//                     "data",
//                     style: TextStyle(fontSize: 20, color: Colors.red),
//                     textAlign: TextAlign.right,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         )
//       ],
//     ));
//   }
// }