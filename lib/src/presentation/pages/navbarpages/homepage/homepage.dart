import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rive/rive.dart';
import 'package:sharemagazines_flutter/src/blocs/navbar/navbar_bloc.dart';
import 'package:sharemagazines_flutter/src/models/locationOffers_model.dart';
import 'package:sharemagazines_flutter/src/models/location_model.dart';
import 'package:sharemagazines_flutter/src/presentation/pages/reader/readerpage.dart';
import '../../../../models/magazinePublishedGetAllLastByHotspotId_model.dart';
import '../../../widgets/loading.dart';
import '../../../widgets/marquee.dart';
import '../../../widgets/news_aus_deiner_Region.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../map/offerpage.dart';

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
  // static  int index1 = 0;
  // final NavbarBloc navbarBloc;
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin<HomePage> {
 static  int _index1 = 0;


  // Timer? _timer;
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    await BlocProvider.of<NavbarBloc>(context).checkLocation();
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
    print("_HomePageState dispose");
    // this._dispatchEvent(
    //     context); // This will dispatch the navigateToHomeScreen event.
  }

  @override
  Widget build(BuildContext context) {

    super.build(context);
    Size size = MediaQuery.of(context).size;
    return BlocBuilder<NavbarBloc, NavbarState>(
      builder: (BuildContext context, state) {

        return SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SmartRefresher(
                  enablePullDown: true,
                  // enablePullUp: true,

                  // header: ClassicHeader(),
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
                      // SingleChildScrollView(
                      //   physics: RangeMaintainingScrollPhysics(),
                      //   scrollDirection: Axis.horizontal,
                      //   child:

                      // LocationOffersWidget(),
                      // ),
                      // Container( height: 300,child: LoadingAnimation()),
                      //
                      // if (NavbarState.locationheader != null) LocationOffersWidget(),
                      if (NavbarState.magazinePublishedGetTopLastByRange != null &&
                          NavbarState.magazinePublishedGetTopLastByRange?.response!.length != 0)
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
                                      ("regionalTitle").tr(),
                                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                ),

                                News_aus_deiner_Region( state: state),
                              ],
                            ),
                          ],
                        ),

                      Column(
                        // crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              // padding: EdgeInsets.fromLTRB(25, NavbarState.getTopMagazines!.length != 0 ? 60 : 20, 25, 20),
                              padding: EdgeInsets.fromLTRB(size.aspectRatio*25, size.aspectRatio*30, size.aspectRatio*25, size.aspectRatio*20),
                              child: Text(
                                ("catalog").tr(),
                                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ),
                          ListMagazineCover(cover: NavbarState.magazinePublishedGetLastWithLimit,heroTag: 'catalog_'),
                        ],
                      ),
                      //Add as padding
                      Container(
                        height: 80,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
        // }
        return Container();
      },
    );
  }
}

class ListMagazineCover extends StatefulWidget {
  final MagazinePublishedGetAllLastByHotspotId cover;
  final String heroTag;
  const ListMagazineCover({
    Key? key,
    required this.cover, required String this.heroTag
  }) : super(key: key);

  @override
  State<ListMagazineCover> createState() => _ListMagazineCoverState();
}

class _ListMagazineCoverState extends State<ListMagazineCover> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
        height: size.aspectRatio*800, // card height
        // width: 200,
        child: PageView.builder(
          itemCount: widget.cover.response!.length,
          // itemCount: state.magazinePublishedGetLastWithLimit.response!.length! + 10,
          // itemCount: 10,
          // padEnds: false,
          //IMPORTANT(.down is also good)
          dragStartBehavior: DragStartBehavior.start,

          allowImplicitScrolling: false,
          controller: PageController(
            // viewportFraction: 0.65,
            // initialPage: widget.cover.response.length >0 ?Random().nextInt( widget.cover.response!.length):1,
            initialPage: 1,
            keepPage: true,
            viewportFraction: MediaQuery.of(context).size.aspectRatio * 1.5, //Works?
          ),

          // onPageChanged: (int index) => setState(() => _index2 = index),
          // onPageChanged: (int index) => _index2 = index,
          pageSnapping: false,
          itemBuilder: (context, i) {
            // if (state.bytes.isEmpty) {
            //   setState(() {});
            // }
            // print("Herooo $i");
            return Transform.scale(
              // origin: Offset(100, 50),
              // alignment: Alignment.center,
              // scale: i == _index1 ? 1 : 1,
              scale: 1,

              // alignment: Alignment.bottomCenter,
              // alignment: AlignmentGeometry(),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Card(
                        color: Colors.transparent,
                        // clipBehavior: Clip.hardEdge,
                        // borderOnForeground: true,
                        margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
                        elevation: 0,

                        ///maybe 0?
                        // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(500)),
                        child: Stack(
                          children: [
                            GestureDetector(
                              // behavior: HitTestBehavior.translucent,
                              onTap: () => {
                                Navigator.of(context).push(
                                  CupertinoPageRoute(
                                    builder: (context) => StartReader(
                                      magazine:widget.cover.response![i],
                                      heroTag: "${widget.heroTag}$i",

                                      // noofpages: 5,
                                    ),
                                  ),
                                )
                              },
                              child: CachedNetworkImage(
                                imageUrl:widget.cover.response![i].idMagazinePublication!  +
                                    "_" +
                                    widget.cover.response![i].dateOfPublication! +
                                    "_0",
                                // progressIndicatorBuilder: (context, url, downloadProgress) => Container(
                                //   // color: Colors.grey.withOpacity(0.1),
                                //   decoration: BoxDecoration(
                                //     // image: DecorationImage(image: imageProvider, fit: BoxFit.fill),
                                //     borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                //     color: Colors.grey.withOpacity(0.1),
                                //   ),
                                //   child: SpinKitFadingCircle(
                                //     color: Colors.white,
                                //     size: 50.0,
                                //   ),
                                // ),

                                imageBuilder: (context, imageProvider) => Hero(
                                  tag: "${widget.heroTag}$i",
                                  child: Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(image: imageProvider, fit: BoxFit.fill),
                                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                    ),
                                  ),
                                ),
                                useOldImageOnUrlChange: true,
                                // very important: keep both placeholder and errorWidget
                                placeholder: (context, url) => Container(
                                  // color: Colors.grey.withOpacity(0.1),
                                  decoration: BoxDecoration(
                                    // image: DecorationImage(image: imageProvider, fit: BoxFit.fill),
                                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                    color: Colors.grey.withOpacity(0.1),
                                  ),
                                  child: SpinKitFadingCircle(
                                    color: Colors.white,
                                    size: 50.0,
                                  ),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  // color: Colors.grey.withOpacity(0.1),
                                  decoration: BoxDecoration(
                                    // image: DecorationImage(image: imageProvider, fit: BoxFit.fill),
                                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                    color: Colors.grey.withOpacity(0.1),
                                  ),
                                  child: SpinKitFadingCircle(
                                    color: Colors.white,
                                    size: 50.0,
                                  ),
                                ),
                                // errorWidget: (context, url, error) => Container(
                                //     alignment: Alignment.center,
                                //     child: Icon(
                                //       Icons.error,
                                //       color: Colors.grey.withOpacity(0.8),
                                //     )),
                              ),
                            ),
                          ],
                        )),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 4, 20, 0),
                      //Dumb hack
                      child: AbsorbPointer(
                        absorbing: true,
                        child: MarqueeWidget(
                          child: MarqueeWidget(
                            direction: Axis.vertical,

                            // crossAxisAlignment: CrossAxisAlignment.start,
                            child: Text(
                              // state.magazinePublishedGetLastWithLimit.response![i + 1].name!,
                              widget.cover.response![i].name!,
                              // " asd",
                              // "Card ${i + 1}",
                              textAlign: TextAlign.center,

                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                backgroundColor: Colors.transparent,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                      child: AbsorbPointer(
                        absorbing: true,
                        child: MarqueeWidget(
                          child: MarqueeWidget(
                            direction: Axis.vertical,
                            child: Text(
                              // state.magazinePublishedGetLastWithLimit.response![i + 1].name!,
                              DateFormat("d. MMMM yyyy").format(
                                  DateTime.parse(widget.cover.response![i].dateOfPublication!)),
                              // " asd",
                              // "Card ${i + 1}",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                                backgroundColor: Colors.transparent,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Positioned(
                  //   // top: -50,
                  //   bottom: -100,
                  //   // height: -50,
                  //   width: MediaQuery.of(context).size.width / 2 - 20,
                  //   child: Align(
                  //     alignment: Alignment.center,
                  //     child: MarqueeWidget(
                  //       // crossAxisAlignment: CrossAxisAlignment.start,
                  //       child: Text(
                  //         // state.magazinePublishedGetLastWithLimit.response![i + 1].name!,
                  //         NavbarState.magazinePublishedGetLastWithLimit!.response![i].name!,
                  //         // " asd",
                  //         // "Card ${i + 1}",
                  //         textAlign: TextAlign.center,
                  //
                  //         style: TextStyle(
                  //           fontSize: 14,
                  //           color: Colors.white,
                  //           backgroundColor: Colors.transparent,
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            );
          },
        ));
  }
}

class LocationOffersWidget extends StatelessWidget {
  const LocationOffersWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LocationOffers>(
        future: NavbarState.locationoffers,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
              child: Column(children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.09,

                  // width: 20,
                  // color: Colors.blue,
                  child: ListView.builder(
                      itemCount: snapshot.data!.locationOffer!.length,
                      scrollDirection: Axis.horizontal,

                      // itemCount: 1,
                      // padEnds: false,
                      // pageSnapping: false,
                      // controller: PageController(viewportFraction: 0.5),
                      // onPageChanged: (int index) => setState(() => widget.index1 = index),
                      itemBuilder: (_, i) {
                        return Card(
                          margin: EdgeInsets.fromLTRB(i == 0 ? 20 : 5, 0, i == snapshot.data!.locationOffer!.length - 1 ? 20 : 5, 0),
                          // width: MediaQuery.of(context).size.width * 0.40,
                          // height: MediaQuery.of(context).size.width * 0.1,
                          color: Colors.transparent,
                          elevation: 0,

                          child: FloatingActionButton.extended(
                            // heroTag: 'offer_title$i',
                            heroTag: null,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(8)), side: BorderSide(color: Colors.white, width: 0.2)),
                            label: Text(
                              snapshot.data!.locationOffer![i].shm2Offer![0].title!,
                              // 'Speisekarte',
                              style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w300),
                            ),
                            // <-- Text
                            backgroundColor: Colors.grey.withOpacity(0.1),
                            // icon: Icon(
                            //   // <-- Icon
                            //   Icons.menu_book,
                            //   // IconData(0xe9a9, fontFamily: ‘icomoon’);
                            //   size: 16.0,
                            // ),
                            onPressed: () => {
                              // Navigator.push(
                              //   context,
                              //   PageRouteBuilder(
                              //     pageBuilder: (_, __, ___) => OfferPage(
                              //       locOffer: snapshot.data!.locationOffer![i],
                              //       heroTag: i,
                              //     ),
                              //   ),
                              // )
                              Navigator.of(context).push(
                                CupertinoPageRoute(
                                  builder: (context) => OfferPage(
                                    locOffer: snapshot.data!.locationOffer![i],

                                  ),
                                ),
                              )
                            },
                            // extendedPadding: EdgeInsets.all(50),
                          ),
                        );
                      }),
                ),
              ]),
            );
          } else {
            return Container(
              color: Colors.white,
            );
          }
        });
  }
}