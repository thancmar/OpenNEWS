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
// import 'package:rive/rive.dart';
import 'package:sharemagazines_flutter/src/blocs/navbar/navbar_bloc.dart';
import 'package:sharemagazines_flutter/src/models/locationOffers_model.dart';
import 'package:sharemagazines_flutter/src/models/location_model.dart';
import 'package:sharemagazines_flutter/src/presentation/pages/reader/readerpage.dart';
import 'package:sharemagazines_flutter/src/resources/magazine_repository.dart';
import '../../../../models/magazinePublishedGetAllLastByHotspotId_model.dart';
import '../../../widgets/loading.dart';
import '../../../widgets/marquee.dart';
import '../../../widgets/navbar/body_clipper.dart';
import '../../../widgets/news_aus_deiner_Region.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../widgets/src/coversverticallist.dart';
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
  // final NavbarBloc navbarBloc;//= RefreshController(initialRefresh: false);
   HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin<HomePage> {
  // static MagazinePublishedGetAllLastByHotspotId items = MagazinePublishedGetAllLastByHotspotId(
  //     response:
  //     []
  //         // NavbarState.magazinePublishedGetLastWithLimit!.response!.where((element) => element.idsMagazineCategory!.contains('20') == true).toList()
  // );

  // Timer? _timer;
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  ScrollController _scrollController = ScrollController();

  void _onRefresh(Data currentLocation) async {
    // monitor network fetch
    await BlocProvider.of<NavbarBloc>(context).checkLocation(currentLocation);
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
    // _refreshController.
    // triggerAnimationLoop();
    // items = MagazinePublishedGetAllLastByHotspotId(
    //     response: NavbarState.magazinePublishedGetLastWithLimit!.response!
    //         .where((element) => element.idsMagazineCategory!.contains('20') == true)
    //         .toList());
    // BlocProvider.of<searchBloc.SearchBloc>(context).add(searchBloc.Initialize(context));
  }

  @override
  bool get wantKeepAlive => true;

  void dispose() {
   _refreshController.dispose();
    super.dispose();
    print("_HomePageState dispose");
    // this._dispatchEvent(
    //     context); // This will dispatch the navigateToHomeScreen event.
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    super.build(context);
    return BlocBuilder<NavbarBloc, NavbarState>(
      builder: (BuildContext context, state) {
        MagazinePublishedGetAllLastByHotspotId items = MagazinePublishedGetAllLastByHotspotId(
            response: NavbarState.magazinePublishedGetLastWithLimit!.response!
                .where((element) => element.idsMagazineCategory?.contains('20') == true)
                .toList());
        return state is NavbarLoaded? SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SmartRefresher(

                  enablePullDown: true,
                  header: ClassicHeader(
                    // Customize your header's appearance here
                    refreshingIcon: CircularProgressIndicator(strokeWidth: 2.0,color: Colors.grey,),
                    completeIcon: Icon(Icons.done, color: Colors.grey),
                    idleIcon: Icon(Icons.arrow_downward, color: Colors.grey),
                    releaseIcon: Icon(Icons.refresh, color: Colors.grey),

                    idleText: 'Pull down to refresh',
                    refreshingText: 'Loading...',
                    completeText: 'Refresh Completed',
                    failedText: 'Refresh Failed',
                    textStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.grey),
                    refreshStyle: RefreshStyle.Follow,

                    // Add a BoxDecoration to give a grey background
                    // decoration: BoxDecoration(
                    //   color: Colors.grey[300], // Choose the shade of grey you want
                    // ),
                  ),
                  controller:  _refreshController,
                  // enableTwoLevel: ,
                  onRefresh: () => _onRefresh(state.appbarlocation),

                  child: CustomScrollView(
                    scrollDirection: Axis.vertical,
                    // clipBehavior: Clip.hardEdge,
                    controller: _scrollController,
                    slivers: <Widget>[
                      // You can add a SliverAppBar here if needed
                      // SliverAppBar(
                      //   title: Text('Sliver App Bar'),
                      //   floating: true,
                      //   pinned: true,
                      //   expandedHeight: 200.0,
                      //   flexibleSpace: FlexibleSpaceBar(
                      //     background: Image.network("URL_TO_YOUR_IMAGE", fit: BoxFit.cover),
                      //   ),
                      // ),
                      // if (NavbarState.magazinePublishedGetTopLastByRange != null &&
                      //     NavbarState.magazinePublishedGetTopLastByRange?.response!.length != 0)
                      // Align(
                      //   alignment: Alignment.centerLeft,
                      //   child: Padding(
                      //     padding: const EdgeInsets.fromLTRB(25, 20, 25, 20),
                      //     child: Text(
                      //       ("regionalTitle").tr(),
                      //       style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      //       textAlign: TextAlign.right,
                      //     ),
                      //   ),
                      // ),

                      if (NavbarState.magazinePublishedGetTopLastByRange != null &&
                          NavbarState.magazinePublishedGetTopLastByRange?.response!.length != 0)
                        SliverToBoxAdapter(child: News_aus_deiner_Region(state: state, categoryName: 'Top Titel')),
                      VerticalListCover(
                          items: items,
                          scrollController: _scrollController,
                          height_News_aus_deiner_Region: MediaQuery.of(context).size.aspectRatio * 1000),
                      SliverToBoxAdapter(
                        child: Container(
                          height: size.height * 0.2, // Adjust the height as needed
                          color: Colors.transparent, // Set any color if needed
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ):Container();
        // }
        return Container();
      },
    );
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
                            heroTag: snapshot.data!.locationOffer![i].shm2Offer![0].title!,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(8)), side: BorderSide(color: Colors.white, width: 0.2)),
                            label: Text(
                              snapshot.data!.locationOffer![i].shm2Offer![0].title!,
                              // 'Speisekarte',
                              style:  Theme.of(context).textTheme.bodyMedium,
                            ),
                            // <-- Text
                            backgroundColor: Colors.grey.withOpacity(0.1),

                            onPressed: () => {
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