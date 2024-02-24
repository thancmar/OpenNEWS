import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

// import 'package:rive/rive.dart';
import 'package:sharemagazines/src/blocs/navbar/navbar_bloc.dart';
import 'package:sharemagazines/src/models/locationOffers_model.dart';
import 'package:sharemagazines/src/models/location_model.dart';
import '../../../../models/magazinePublishedGetAllLastByHotspotId_model.dart';
import '../../../widgets/news_aus_deiner_Region.dart';
import '../../../widgets/src/coversverticallist.dart';
import '../ebookreader/ebookreader.dart';
import '../map/offerpage.dart';

class HomePage extends StatefulWidget {
  // static  int index1 = 0;
  // final NavbarBloc navbarBloc;//= RefreshController(initialRefresh: false);
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin<HomePage> {
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  ScrollController _scrollController = ScrollController();

  void _onRefresh(LocationData currentLocation) async {
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

  @override
  void initState() {
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    super.build(context);
    return BlocBuilder<NavbarBloc, NavbarState>(
      builder: (BuildContext context, state) {
        MagazinePublishedGetAllLastByHotspotId items = MagazinePublishedGetAllLastByHotspotId(
            response: NavbarState.magazinePublishedGetLastWithLimit.response()!
                .where((element) => element.idsMagazineCategory?.contains('20') == true)
                .toList());
        return state is NavbarLoaded
            ? SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: ValueListenableBuilder<CategoryStatus>(
                          valueListenable: NavbarState.categoryStatus,
                          builder: (context, value, child) {
                            return SmartRefresher(
                                enablePullDown: true,
                                header: ClassicHeader(
                                  // Customize your header's appearance here
                                  refreshingIcon: CircularProgressIndicator(
                                    strokeWidth: 2.0,
                                    color: Colors.grey,
                                  ),
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
                                controller: _refreshController,
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

                                    if (value == CategoryStatus.presse &&
                                        NavbarState.magazinePublishedGetTopLastByRange != null &&
                                        NavbarState.magazinePublishedGetTopLastByRange?.response()!.length != 0)
                                      SliverToBoxAdapter(child: News_aus_deiner_Region(state: state, categoryName: 'Top Titel')),
                                    if (value == CategoryStatus.presse)
                                      VerticalListCover(
                                          items: items,
                                          scrollController: _scrollController,
                                          height_News_aus_deiner_Region: MediaQuery.of(context).size.aspectRatio * 1000),

                                    if (value == CategoryStatus.ebooks)
                                      SliverToBoxAdapter(
                                          child: Column(
                                        children: [
                                          Align(
                                              alignment: Alignment.center,
                                              child: Container(
                                                // color: Colors.red,
                                                height: size.height * 0.9,
                                                child: ListView.builder(
                                                  itemCount: NavbarState.ebooks.response()!.length,
                                                  itemBuilder: (_, int index) => ListTile(
                                                    // leading: NavbarState.ebooks.response[index].leading,

                                                    title: GestureDetector(
                                                      onTap: () => {
                                                        showModalBottomSheet(
                                                          context: context,
                                                          shape: const RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius.only(topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
                                                          ),
                                                          isScrollControlled: true,
                                                          constraints: BoxConstraints.tight(
                                                              Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height * .8)),
                                                          builder: (ctx) {
                                                            return ebookDescription(context: ctx,index: index,);
                                                          },
                                                        )
                                                      },
                                                      child: Column(
                                                        children: [
                                                          Text(
                                                            NavbarState.ebooks.response()![index].title!,
                                                            style: Theme.of(context).textTheme.titleMedium,
                                                          ),
                                                          Text(
                                                            NavbarState.ebooks.response()![index].dateOfPublication!,
                                                            style: Theme.of(context).textTheme.titleSmall!.copyWith(color: Colors.grey),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    // onTap: () => _pushPage(context, pages[index]),
                                                  ),
                                                ),
                                              )),
                                        ],
                                      )),

                                    SliverToBoxAdapter(
                                      child: Container(
                                        height: size.height * 0.2, // Adjust the height as needed
                                        color: Colors.transparent, // Set any color if needed
                                      ),
                                    ),
                                  ],
                                ));
                          }),
                    ),
                  ],
                ),
              )
            : Container();
      },
    );
  }
}

class ebookDescription extends StatelessWidget {
  final BuildContext context;
  final int index;
  const ebookDescription({
    Key? key, required this.index, required this.context
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context); // This will close the modal bottom sheet
              },
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.close,
                  color: Colors.black54,
                  size: 40,
                ),
              ),
            )
          ],
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Align(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Text(
                        NavbarState.ebooks.response()![index].title!,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .copyWith(color: Colors.black,fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: Text(
                          NavbarState.ebooks.response()![index].author!,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Text(
                        NavbarState.ebooks.response()![index].description!,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(color: Colors.black),
                        textAlign: TextAlign.left,
                      ),
                      // Divider(
                      //   color: Colors.black,
                      // ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     Expanded(
                      //       child: Padding(
                      //         padding:  EdgeInsets.all(8.0),
                      //         child: Align(
                      //           alignment: Alignment.center,
                      //           child: Column(
                      //             children: [
                      //               Text(
                      //                 "No. of pages",
                      //                 style: Theme.of(context)
                      //                     .textTheme
                      //                     .titleSmall!
                      //                     .copyWith(color: Colors.grey),
                      //                 textAlign: TextAlign.center,
                      //               ),
                      //               Text(
                      //                 NavbarState.ebooks.response![index].pageMax!,
                      //
                      //                 style: Theme.of(context)
                      //                     .textTheme
                      //                     .titleMedium!
                      //                     .copyWith(color: Colors.black,fontWeight: FontWeight.w800),
                      //                 textAlign: TextAlign.center,
                      //               ),
                      //             ],
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //     Container(
                      //       width: 1, // Adjust the width as needed
                      //       height: 20, // Adjust the height as needed
                      //       color: Colors.black,
                      //     ),
                      //     Expanded(
                      //       child: Padding(
                      //         padding:  EdgeInsets.all(8.0),
                      //         child: Column(
                      //           children: [
                      //             Text(
                      //               "Date",
                      //               style: Theme.of(context)
                      //                   .textTheme
                      //                   .titleSmall!
                      //                   .copyWith(color: Colors.grey),
                      //               textAlign: TextAlign.center,
                      //             ),
                      //             Text(
                      //                 DateFormat("yyyy").format(DateTime.parse(NavbarState.ebooks.response![index].dateOfPublication!)),
                      //
                      //               style: Theme.of(context)
                      //                   .textTheme
                      //                   .titleMedium!
                      //                   .copyWith(color: Colors.black,fontWeight: FontWeight.w800),
                      //               textAlign: TextAlign.center,
                      //             ),
                      //           ],
                      //         ),
                      //       ),
                      //     ),
                      //     Container(
                      //       width: 1, // Adjust the width as needed
                      //       height: 20, // Adjust the height as needed
                      //       color: Colors.black,
                      //     ),
                      //     Expanded(
                      //       child: Padding(
                      //         padding:  EdgeInsets.all(8.0),
                      //         child: Column(
                      //           children: [
                      //             Text(
                      //               "Language",
                      //               style: Theme.of(context)
                      //                   .textTheme
                      //                   .titleSmall!
                      //                   .copyWith(color: Colors.grey),
                      //               textAlign: TextAlign.center,
                      //             ),
                      //             Text(
                      //              NavbarState.ebooks.response![index].ebookLanguage!.toUpperCase(),
                      //
                      //               style: Theme.of(context)
                      //                   .textTheme
                      //                   .titleMedium!
                      //                   .copyWith(color: Colors.black,fontWeight: FontWeight.w800),
                      //               textAlign: TextAlign.center,
                      //             ),
                      //           ],
                      //         ),
                      //       ),
                      //     ),
                      //     // Divider(
                      //     //   color: Colors.black,
                      //     // ),
                      //     // Text(
                      //     //   "No. of pages",
                      //     //   style: Theme.of(context)
                      //     //       .textTheme
                      //     //       .headlineSmall!
                      //     //       .copyWith(color: Colors.black),
                      //     //   textAlign: TextAlign.center,
                      //     // ),
                      //   ],
                      // ),
                    ],
                  )),
            ),
          ),
        ),
        Divider(
          color: Colors.black,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding:  EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Text(
                        "No. of pages",
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        NavbarState.ebooks.response()![index].pageMax!,

                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: Colors.black,fontWeight: FontWeight.w800),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              width: 1, // Adjust the width as needed
              height: 40, // Adjust the height as needed
              color: Colors.black,
            ),
            Expanded(
              child: Padding(
                padding:  EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      "Date",
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall!
                          .copyWith(color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      DateFormat("yyyy").format(DateTime.parse(NavbarState.ebooks.response()![index].dateOfPublication!)),

                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(color: Colors.black,fontWeight: FontWeight.w800),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: 1, // Adjust the width as needed
              height: 40, // Adjust the height as needed
              color: Colors.black,
            ),
            Expanded(
              child: Padding(
                padding:  EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      "Language",
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall!
                          .copyWith(color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      NavbarState.ebooks.response()![index].ebookLanguage!.toUpperCase(),

                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(color: Colors.black,fontWeight: FontWeight.w800),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            // Divider(
            //   color: Colors.black,
            // ),
            // Text(
            //   "No. of pages",
            //   style: Theme.of(context)
            //       .textTheme
            //       .headlineSmall!
            //       .copyWith(color: Colors.black),
            //   textAlign: TextAlign.center,
            // ),
          ],
        ),
        SafeArea(
          child: Padding(
            padding:  EdgeInsets.fromLTRB(20.0, 20, 20.0, 10.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (context) => Ebookreader(
                      // magazine: widget.items.response![index],
                      // heroTag: "toptitle${index}",

                      // noofpages: 5,
                    ),
                  ),
                );
                // FirebaseAuth.instance
                //     .authStateChanges()
                //     .listen((User? user) {
                //   if (user == null) {
                //     print('User is currently signed out!');
                //   } else {
                //     print('User is signed in!');
                //   }
                // });
                // _authenticateWithEmailAndPassword(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                // onPrimary: Colors.white,
                shadowColor: Colors.blueAccent,
                elevation: 3,
                // side: BorderSide(width: 0.10, color: Colors.white),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)),
                minimumSize: Size(300, 60), //////// HERE
              ),
              child: Text(
                "Jetzt Lesen".toLowerCase(),
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
                  //fontStyle: FontStyle.,
                ),
              ),
            ),
          ),
        ),
      ],
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
                  // height: MediaQuery.of(context).size.aspectRatio * 060.09,
                  height: 38,

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
                              style: Theme.of(context).textTheme.bodyMedium,
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