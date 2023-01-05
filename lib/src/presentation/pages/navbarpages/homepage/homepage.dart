import 'dart:async';
import 'dart:typed_data';

import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shaky_animated_listview/widgets/animated_listview.dart';
import 'package:sharemagazines_flutter/src/blocs/navbar/navbar_bloc.dart';
import 'package:sharemagazines_flutter/src/blocs/reader/reader_bloc.dart';
import 'package:sharemagazines_flutter/src/models/location_model.dart';
import 'package:sharemagazines_flutter/src/presentation/pages/reader/readerpage.dart';
import 'package:sharemagazines_flutter/src/presentation/widgets/photohero.dart';
import 'package:sharemagazines_flutter/src/presentation/widgets/routes/toreader.dart';
import 'package:sharemagazines_flutter/src/presentation/widgets/routes/toreaderoption.dart';
import 'package:sharemagazines_flutter/src/resources/location_repository.dart';

import '../../../../blocs/searchpage/search_bloc.dart' as searchBloc;
import '../../../../resources/magazine_repository.dart';
import '../../../widgets/news_aus_deiner_Region.dart';
import '../../player/player.dart';

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
  int index_News_aus_deiner_Region = 0;
  Timer? _timer;
  static const _indicatorSize = 150.0;
  bool _renderCompleteState = false;
  List<Uint8List> meistgelesene_Artikel = [];
  List<String> items = ["1", "2", "3", "4", "5", "6", "7", "8"];
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    // await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()

    // BlocProvider.of<NavbarBloc>(context).add(LocationRefresh(_timer));
    await BlocProvider.of<NavbarBloc>(context).checkLocation(_timer);

    _refreshController.refreshCompleted();
  }

  // void _onLoading() async {
  //   // monitor network fetch
  //   await Future.delayed(Duration(milliseconds: 10000));
  //   // if failed,use loadFailed(),if no data return,use LoadNodata()
  //   // items.add((items.length + 1).toString());
  //   // if (mounted) setState(() {});
  //   // _refreshController.loadComplete();
  // }

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
        // print("Navbar state is $state");
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
                  child: SmartRefresher(
                    enablePullDown: true,
                    // enablePullUp: true,

                    header: ClassicHeader(),
                    // footer: CustomFooter(
                    //   builder: (BuildContext context, LoadStatus? mode) {
                    //     Widget body;
                    //     if (mode == LoadStatus.idle) {
                    //       body = Text("pull up load");
                    //     } else if (mode == LoadStatus.loading) {
                    //       body = CupertinoActivityIndicator();
                    //     } else if (mode == LoadStatus.failed) {
                    //       body = Text("Load Failed!Click retry!");
                    //     } else if (mode == LoadStatus.canLoading) {
                    //       body = Text("release to load more");
                    //     } else {
                    //       body = Text("No more Data");
                    //     }
                    //     return Container(
                    //       height: 55.0,
                    //       child: Center(child: body),
                    //     );
                    //   },
                    // ),
                    controller: _refreshController,
                    onRefresh: _onRefresh,
                    // onLoading: _onLoading,
                    child: ListView(
                      // duration: 00,

                      physics: ClampingScrollPhysics(),
                      // spaceBetween: 20,
                      // shrinkWrap: true,
                      shrinkWrap: false,
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
                                      // IconData(0xe9a9, fontFamily: ‘icomoon’);
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
                        if (NavbarState.getTopMagazines!.length != 0)
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
                                  // Positioned(
                                  //   bottom: -70,
                                  //   right: 100, //60 because of padding
                                  //   child: Column(
                                  //     children: [
                                  //       Card(
                                  //         color: Colors.grey[900],
                                  //         shape: RoundedRectangleBorder(
                                  //           side: BorderSide(color: Colors.white70, width: 0),
                                  //           borderRadius: BorderRadius.circular(100),
                                  //         ),
                                  //         margin: EdgeInsets.all(10.0),
                                  //         child: Icon(
                                  //           Icons.ac_unit,
                                  //           size: 80,
                                  //           color: Colors.amber,
                                  //         ),
                                  //       ),
                                  //       RichText(
                                  //         text: TextSpan(
                                  //           children: [
                                  //             TextSpan(
                                  //               text: "Hamburger Morgenpost ",
                                  //               // text: state.magazinePublishedGetLastWithLimit!.response![_index1].name!
                                  //             ),
                                  //             WidgetSpan(
                                  //               child: Icon(Icons.navigate_next_outlined, color: Colors.white, size: 14),
                                  //             ),
                                  //           ],
                                  //         ),
                                  //       ),
                                  //       RichText(
                                  //         text: TextSpan(
                                  //           children: [
                                  //             TextSpan(text: "11. Januar 2022", style: TextStyle(color: Colors.grey, fontSize: 12)),
                                  //           ],
                                  //         ),
                                  //       )
                                  //     ],
                                  //   ),
                                  // ),
                                  // SizedBox(
                                  //   height: 350, // card height
                                  //   child: PageView.builder(
                                  //     itemCount: NavbarState.getTopMagazines!.length,
                                  //     // padEnds: true,
                                  //
                                  //     controller: PageController(viewportFraction: 0.707),
                                  //     // onPageChanged: (int index) => setState(() => index_News_aus_deiner_Region = index),
                                  //     onPageChanged: (int index) => index_News_aus_deiner_Region = index,
                                  //     itemBuilder: (_, i) {
                                  //       return FutureBuilder<Uint8List>(
                                  //           future: NavbarState.getTopMagazines?[i],
                                  //           builder: (context, snapshot) {
                                  //             return Transform.scale(
                                  //               scale: i == index_News_aus_deiner_Region ? 1 : 0.85,
                                  //               // scale: 1,
                                  //               alignment: Alignment.bottomCenter,
                                  //               child: Card(
                                  //                   color: Colors.transparent,
                                  //                   // clipBehavior: Clip.hardEdge,
                                  //                   borderOnForeground: true,
                                  //                   margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
                                  //                   elevation: 0,
                                  //
                                  //                   ///maybe 0?
                                  //                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  //                   child: Stack(
                                  //                     // clipBehavior: Clip.antiAlias,
                                  //                     children: [
                                  //                       Align(
                                  //                         alignment: Alignment.center,
                                  //                         child: Hero(
                                  //                           //sizedbox after this w550 h300
                                  //                           key: UniqueKey(),
                                  //                           tag: 'News_aus_deiner_Region_$i',
                                  //                           // transitionOnUserGestures: true,
                                  //
                                  //                           child: (snapshot.hasData)
                                  //                               ? GestureDetector(
                                  //                                   behavior: HitTestBehavior.translucent,
                                  //                                   onTap: () => {
                                  //                                     // Navigator.of(context).push(
                                  //                                     //   PageRouteBuilder(
                                  //                                     //     transitionDuration: Duration(milliseconds: 1000),
                                  //                                     //     pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
                                  //                                     //       return StartReader(
                                  //                                     //         id: state.magazinePublishedGetLastWithLimit!.response![i + 1].idMagazinePublication!,
                                  //                                     //         index: i.toString(),
                                  //                                     //         cover: snapshot.data!,
                                  //                                     //         noofpages: state.magazinePublishedGetLastWithLimit!.response![i + 1].pageMax!,
                                  //                                     //         readerTitle: state.magazinePublishedGetLastWithLimit!.response![i + 1].name!,
                                  //                                     //
                                  //                                     //         // noofpages: 5,
                                  //                                     //       );
                                  //                                     //     },
                                  //                                     //     transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
                                  //                                     //       return Align(
                                  //                                     //         child: FadeTransition(
                                  //                                     //           opacity: new CurvedAnimation(parent: animation, curve: Curves.easeIn),
                                  //                                     //           child: child,
                                  //                                     //         ),
                                  //                                     //       );
                                  //                                     //     },
                                  //                                     //   ),
                                  //                                     // )
                                  //                                     Navigator.push(
                                  //                                       context,
                                  //                                       PageRouteBuilder(
                                  //                                         // transitionDuration:
                                  //                                         // Duration(seconds: 2),
                                  //                                         pageBuilder: (_, __, ___) => StartReader(
                                  //                                           id: NavbarState.magazinePublishedGetTopLastByRange!.response![i].idMagazinePublication!,
                                  //                                           index: i.toString(),
                                  //                                           cover: snapshot.data!,
                                  //                                           noofpages: NavbarState.magazinePublishedGetTopLastByRange!.response![i].pageMax!,
                                  //                                           readerTitle: NavbarState.magazinePublishedGetTopLastByRange!.response![i].name!,
                                  //                                           heroTag: 'News_aus_deiner_Region_$i',
                                  //                                           // noofpages: 5,
                                  //                                         ),
                                  //                                       ),
                                  //                                     ),
                                  //                                   },
                                  //                                   child: ClipRRect(
                                  //                                     borderRadius: BorderRadius.circular(8.0),
                                  //                                     child: Image.memory(
                                  //                                       // state.bytes![i],
                                  //                                       snapshot.data!,
                                  //                                     ),
                                  //                                   ),
                                  //                                 )
                                  //                               : Container(
                                  //                                   color: Colors.grey.withOpacity(0.1),
                                  //                                   child: SpinKitFadingCircle(
                                  //                                     color: Colors.white,
                                  //                                     size: 50.0,
                                  //                                   ),
                                  //                                 ),
                                  //                         ),
                                  //                       ),
                                  //                     ],
                                  //                   )),
                                  //             );
                                  //           });
                                  //     },
                                  //   ),
                                  // )
                                ],
                              ),

                              // Positioned(
                              //   bottom: -70,
                              //   right: 100, //60 because of padding
                              //   child: Column(
                              //     children: [
                              //       Card(
                              //         color: Colors.grey[900],
                              //         shape: RoundedRectangleBorder(
                              //           side: BorderSide(color: Colors.white70, width: 0),
                              //           borderRadius: BorderRadius.circular(100),
                              //         ),
                              //         margin: EdgeInsets.all(10.0),
                              //         child: Icon(
                              //           Icons.ac_unit,
                              //           size: 80,
                              //           color: Colors.amber,
                              //         ),
                              //       ),
                              //       RichText(
                              //         text: TextSpan(
                              //           children: [
                              //             TextSpan(
                              //               text: "Hamburger Morgenpost ",
                              //               // text: state.magazinePublishedGetLastWithLimit!.response![_index1].name!
                              //             ),
                              //             WidgetSpan(
                              //               child: Icon(Icons.navigate_next_outlined, color: Colors.white, size: 14),
                              //             ),
                              //           ],
                              //         ),
                              //       ),
                              //       RichText(
                              //         text: TextSpan(
                              //           children: [
                              //             TextSpan(text: "11. Januar 2022", style: TextStyle(color: Colors.grey, fontSize: 12)),
                              //           ],
                              //         ),
                              //       )
                              //     ],
                              //   ),
                              // ),
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
                                padding: EdgeInsets.fromLTRB(25, NavbarState.getTopMagazines!.length != 0 ? 100 : 20, 25, 20),
                                child: Text(
                                  'Meistgelesene Artikel',
                                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ),
                            SizedBox(
                                height: 300, // card height
                                child: PageView.builder(
                                  itemCount: state.languageResultsALL_HomeState?.length,
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
                                      // key: UniqueKey(),
                                      tag: 'Meistgelesene_Artikel_$i',
                                      child: FutureBuilder<Uint8List>(
                                        // future: state.languageResultsALL_HomeState?[i],
                                        future: NavbarState.languageResultsALL?[i],
                                        builder: (context, snapshot) {
                                          // print("Meistgelesene_Artikel_ ${snapshot.data}");
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
                                                            // behavior: HitTestBehavior.translucent,
                                                            onTap: () => {
                                                              Navigator.push(
                                                                context,
                                                                PageRouteBuilder(
                                                                  // transitionDuration: Duration(seconds: 2),
                                                                  opaque: true,
                                                                  pageBuilder: (_, __, ___) => StartReader(
                                                                    id: state.magazinePublishedGetLastWithLimit_HomeState!.response![i].idMagazinePublication!,
                                                                    index: i.toString(),
                                                                    heroTag: 'Meistgelesene_Artikel_$i',
                                                                    cover: snapshot.data!,
                                                                    noofpages: state.magazinePublishedGetLastWithLimit_HomeState!.response![i].pageMax!,
                                                                    readerTitle: state.magazinePublishedGetLastWithLimit_HomeState!.response![i].name!,

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
                                                        : Container(
                                                            color: Colors.grey.withOpacity(0.1),
                                                            child: SpinKitFadingCircle(
                                                              color: Colors.white,
                                                              size: 50.0,
                                                            ),
                                                          ),
                                                  ],
                                                )),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                )),
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
                                  'Widget3',
                                  style: TextStyle(color: Colors.white, fontSize: 16),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ),
                            SizedBox(
                                height: 300, // card height
                                child: PageView.builder(
                                  itemCount: state.languageResultsALL_HomeState?.length,
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
                                      tag: 'Widget3_$i',
                                      child: FutureBuilder<Uint8List>(
                                        future: state.languageResultsALL_HomeState?[i],
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
                                                              Navigator.push(
                                                                context,
                                                                PageRouteBuilder(
                                                                  // transitionDuration: Duration(seconds: 2),
                                                                  opaque: true,
                                                                  pageBuilder: (_, __, ___) => StartPlayer(),
                                                                  // pageBuilder: (_, __, ___) => StartReader(
                                                                  //   id: state.magazinePublishedGetLastWithLimit!.response![i].idMagazinePublication!,
                                                                  //   index: i.toString(),
                                                                  //   heroTag: 'Meistgelesene_Artikel_$i',
                                                                  //   cover: snapshot.data!,
                                                                  //   noofpages: state.magazinePublishedGetLastWithLimit!.response![i].pageMax!,
                                                                  //   readerTitle: state.magazinePublishedGetLastWithLimit!.response![i].name!,
                                                                  //
                                                                  //   // noofpages: 5,
                                                                  // ),
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
                                                        : Container(
                                                            color: Colors.grey.withOpacity(0.1),
                                                            child: SpinKitFadingCircle(
                                                              color: Colors.white,
                                                              size: 50.0,
                                                            ),
                                                          ),
                                                  ],
                                                )),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                )),
                          ],
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.fromLTRB(0, 0, 0, 200),
                        //   child: Column(
                        //     children: [
                        //       Align(
                        //         alignment: Alignment.centerLeft,
                        //         child: Padding(
                        //           padding: const EdgeInsets.fromLTRB(25, 40, 25, 20),
                        //           child: Text(
                        //             'Mit deinem Profil weiterstöbern',
                        //             style: TextStyle(color: Colors.white, fontSize: 16),
                        //             textAlign: TextAlign.right,
                        //           ),
                        //         ),
                        //       ),
                        //       SizedBox(
                        //         height: 200, // card height
                        //
                        //         child: PageView.builder(
                        //           itemCount: 5,
                        //           // padEnds: true,
                        //
                        //           controller: PageController(viewportFraction: 0.45),
                        //           onPageChanged: (int index) => setState(() => _index2 = index),
                        //           itemBuilder: (_, i) {
                        //             return Transform.scale(
                        //               // origin: Offset(100, 50),
                        //               // BlocProvider.of<auth.AuthBloc>(context).add(
                        //               //   auth.SignInRequested(_emailController.text, _passwordController.text),
                        //               // );
                        //               scale: i == _index2 ? 1 : 1,
                        //               alignment: Alignment.bottomCenter,
                        //               // alignment: AlignmentGeometry(),
                        //               child: GestureDetector(
                        //                 onTap: () => {
                        //                   // BlocProvider.of<ReaderBloc>(context)
                        //                   //     .add(
                        //                   //   OpenReader(),
                        //                   // ),
                        //                   // Navigator.of(context,
                        //                   //         rootNavigator: true)
                        //                   //     .push(// ensures fullscreen
                        //                   //         CupertinoPageRoute(builder:
                        //                   //             (BuildContext context) {
                        //                   //   return Reader();
                        //                   // }))
                        //                 },
                        //                 child: Card(
                        //                   clipBehavior: Clip.antiAliasWithSaveLayer,
                        //                   margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
                        //                   elevation: 6,
                        //                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                        //                   child: Column(
                        //                     children: [
                        //                       SizedBox(
                        //                         width: 200,
                        //                         height: 150,
                        //                         child: Image.network(
                        //                           'https://via.placeholder.com/300?text=DITTO',
                        //                           fit: BoxFit.fill,
                        //                         ),
                        //                       ),
                        //                     ],
                        //                   ),
                        //                 ),
                        //               ),
                        //             );
                        //           },
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
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
}