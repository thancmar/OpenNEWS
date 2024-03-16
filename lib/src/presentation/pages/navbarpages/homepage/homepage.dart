import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

// import 'package:rive/rive.dart';
import 'package:sharemagazines/src/blocs/navbar/navbar_bloc.dart';
import 'package:sharemagazines/src/models/audioBooksForLocationGetAllActive.dart';
import 'package:sharemagazines/src/models/locationOffers_model.dart';
import 'package:sharemagazines/src/models/location_model.dart';
import '../../../../models/ebooksForLocationGetAllActive.dart';
import '../../../../models/magazinePublishedGetAllLastByHotspotId_model.dart';
import '../../../widgets/news_aus_deiner_Region.dart';
import '../../../widgets/src/coversverticallist.dart';
import '../../../widgets/src/customCover.dart';
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
        // MagazinePublishedGetAllLastByHotspotId items = MagazinePublishedGetAllLastByHotspotId(
        //     response: NavbarState.magazinePublishedGetLastWithLimit.response()!
        //         .where((element) => element.idsMagazineCategory?.contains('20') == true)
        //         .toList());
        return state is NavbarLoaded
            ? SafeArea(
                child: ValueListenableBuilder<CategoryStatus>(
                    valueListenable: NavbarState.categoryStatus,
                    builder: (context, categoryStatus, child) {

                      // _scrollController.animateTo(1.0, duration: Duration(milliseconds: 250), curve: Curves.easeInOut);
                      MagazinePublishedGetAllLastByHotspotId magazines = MagazinePublishedGetAllLastByHotspotId(response: []);
                      MagazinePublishedGetAllLastByHotspotId bookmarks;

                      EbooksForLocationGetAllActive ebooks = EbooksForLocationGetAllActive(response: []);
                      AudioBooksForLocationGetAllActive audiobooks = AudioBooksForLocationGetAllActive(response: []);

                      if (categoryStatus == CategoryStatus.presse)
                        magazines = MagazinePublishedGetAllLastByHotspotId(
                            response: NavbarState.magazinePublishedGetLastWithLimit.response()!
                                .where((element) => element.idsMagazineCategory?.contains('20') == true)
                                .toList());
                      if (categoryStatus == CategoryStatus.ebooks)
                        ebooks = EbooksForLocationGetAllActive(
                            response: NavbarState.ebooks
                                .response()!
                                .where((element) =>
                            element.idsEbookCategory?.contains(NavbarState.ebookCategoryGetAllActiveByLocale!.response![1].id!) == true)
                            // .toSet()
                                .toList());
                      if (categoryStatus == CategoryStatus.hoerbuecher)
                        audiobooks = AudioBooksForLocationGetAllActive(
                            response: NavbarState.audiobooks
                                .response()!
                                .where((element) =>
                            element.idsAudiobookCategory?.contains(NavbarState.audioBooksCategoryGetAllActiveByLocale!.response![1].id!) == true)
                            // .toSet()
                                .toList());
                      // print(NavbarState.audioBooksCategoryGetAllActiveByLocale!.response![9].name);
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
                              if (
                              categoryStatus == CategoryStatus.presse &&
                                  NavbarState.magazinePublishedGetTopLastByRange != null &&
                                  NavbarState.magazinePublishedGetTopLastByRange?.response()!.length != 0)
                                SliverToBoxAdapter(child: News_aus_deiner_Region(state: state)),
                              // if (value == CategoryStatus.presse)
                              SliverToBoxAdapter(
                                child: Container(
                                  // height: size.height * 0.12, // Adjust the height as needed
                                  color: Colors.transparent, // Set any color if needed
                                  child:  Align(
                                    alignment: Alignment.centerLeft,
                                    // alignment: tablet?Alignment.center: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(25, 20, 25, 10),
                                      child: Text(
                                        // ("Top-title").tr(),
                                        ("Top Titel"),
                                        style:  Theme.of(context).textTheme.bodyLarge,
                                        // textAlign:tablet?TextAlign.center: TextAlign.right,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                                VerticalListCover(
                                    items:categoryStatus==CategoryStatus.ebooks? ebooks:categoryStatus==CategoryStatus.hoerbuecher?audiobooks:magazines,
                                    scrollController: _scrollController,
                                    height_News_aus_deiner_Region: MediaQuery.of(context).size.aspectRatio * 1000),
                              SliverToBoxAdapter(
                                child: Container(
                                  height: size.height * 0.2, // Adjust the height as needed
                                  color: Colors.transparent, // Set any color if needed
                                ),
                              ),
                            ],
                          ));
                    }),
              )
            : Container();
      },
    );
  }
}

class ebookDescription extends StatelessWidget {
  final BuildContext context;
  // final int index;
  final ResponseEbook? ebook;
  final ResponseAudioBook? audiobook;
  final AnimationController? spinKitController;
  const ebookDescription({
    Key? key, this.audiobook, this.ebook, required this.context,required this.spinKitController
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [

            // CustomCachedNetworkImage(
            //   mag:res,
            //
            //   thumbnail: true,
            //   // covers: widget.cover,
            //   heroTag: "dasd",
            //   pageNo: 0,
            //   spinKitController: spinKitController,
            //   height_News_aus_deiner_Region: 0,
            // ),
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
                      Container(height: ebook!=null?250:200,width: 200,child: CachedNetworkImage(
                        // key: ValueKey(
                        //     // widget._networklHasErrorNotifier != null && widget.index < widget._networklHasErrorNotifier.length
                        //     // ?
                        //     widget._networklHasErrorNotifier[widget.index].value
                        //     // :
                        //     // 'defaultKey'
                        //     ),
                        imageUrl: (ebook?.id! ?? audiobook?.id)! + // idMagazinePublication! +
                            "_" +
                            (ebook?.dateOfPublication!?? audiobook?.dateOfPublication)!+(ebook!=null?"ebook":"audiobook")
                        //+ '_thumbnail',
                        ,
                        // imageUrl: NavbarState.magazinePublishedGetLastWithLimit!.response!.where((i) => i.magazineLanguage == "de").toList()[index].idMagazinePublication! +
                        //     "_" +
                        //     NavbarState.magazinePublishedGetLastWithLimit!.response!.where((i) => i.magazineLanguage == "de").toList()[index].dateOfPublication!,
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
                        // imageRenderMethodForWeb: ,
                        imageBuilder: (context, imageProvider) => Container(
                          // decoration: BoxDecoration(
                          //   // border: Border.all(color: Colors.black, width: 2.0), // Outer border
                          //   borderRadius: BorderRadius.circular(5.0),
                          // ),
                          child: ClipRRect(
                            // This will clip any child widget going outside its bounds
                            borderRadius: BorderRadius.circular(8.0), // Same rounded corners as the outer border
                            child: Transform.translate(
                              offset: Offset(0, 0),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  // border: Border.all(color: Colors.black, width: 2.0), // Outer border
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.fill,
                                  ),
                                  // borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                ),
                              ),
                            ),
                          ),
                        ),

                        // filterQuality: widget.reader ? FilterQuality.high : FilterQuality.low,
                        filterQuality: FilterQuality.low,
                        // useOldImageOnUrlChange: true,
                        // very important: keep both placeholder and errorWidget
                        // placeholder: (context, url) => Container(
                        //   // color: Colors.grey.withOpacity(0.1),
                        //   decoration: BoxDecoration(
                        //     // image: DecorationImage(image: imageProvider, fit: BoxFit.fill),
                        //     borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        //     // color: Colors.grey.withOpacity(0.05),
                        //     color: Colors.grey.withOpacity(0.1),
                        //   ),
                        //   child: SpinKitFadingCircle(
                        //     color: Colors.white,
                        //     size: 50.0,
                        //     controller: widget.spinKitController,
                        //   ),
                        // ),
                        placeholder: (context, url) => ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          child: Container(
                            // color: Colors.grey.withOpacity(0.1),

                            decoration: BoxDecoration(
                              // image: DecorationImage(image: imageProvider, fit: BoxFit.fill),
                              borderRadius: BorderRadius.all(Radius.circular(8.0)),
                              // color: Colors.grey.withOpacity(0.1),
                            ),
                            child: SpinKitFadingCircle(
                              color: Colors.white,
                              size: 50.0,
                              controller: spinKitController,
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                              color: Colors.grey.withOpacity(0.1),
                            ),
                            child: Icon(
                              Icons.error,
                              color: Colors.red.withOpacity(0.8),
                            )),
                      )),

                      Text(
                       ( ebook?.title!?? audiobook?.title)!,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .copyWith(color: Colors.black,fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: Text(
                          (ebook?.author!?? audiobook?.author)!,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Text(
                       ( ebook?.description!?? audiobook?.description)!,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
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
                        ebook!=null?"No. of pages":"Runtime",
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .copyWith(color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        ( ebook?.pageMax!?? audiobook?.runtime)!,

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
                      DateFormat("yyyy").format(DateTime.parse(( ebook?.dateOfPublication!?? audiobook?.dateOfPublication)!)),

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
                      ( ebook?.ebookLanguage!?? audiobook?.audiobookLanguage)!,

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
                if(ebook !=null){
                Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (context) =>
                        // Ebookreader1(ebook: res,)
                        Ebookreader(
                      ebook: ebook!,
                      // magazine: widget.items.response![index],
                      // heroTag: "toptitle${index}",

                      // noofpages: 5,
                    ),
                  ),
                );}else{
                  // Navigator.of(context).push(
                  //     CupertinoPageRoute(
                  //       builder: (context) =>
                  //       // Ebookreader1(ebook: res,)
                  //       Ebookreader(
                  //         ebook: ebook!,
                  //         // magazine: widget.items.response![index],
                  //         // heroTag: "toptitle${index}",
                  //
                  //         // noofpages: 5,
                  //       ),
                  //     ));
                }
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
    (ebook!=null?"Jetzt Lesen":"jetzt Hören").toUpperCase(),
                style:  Theme.of(context).textTheme.titleMedium,
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
                          elevation: 2,

                          child: FloatingActionButton.extended(
                            // heroTag: 'offer_title$i',
                            heroTag: snapshot.data!.locationOffer![i].shm2Offer![0].title!,
                            elevation: 2,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8)), side: BorderSide(color: Colors.white, width: 0.2)),
                            label: Text(
                              snapshot.data!.locationOffer![i].shm2Offer![0].title!,
                              // 'Speisekarte',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            // <-- Text
                            backgroundColor: Colors.grey.withOpacity(0.15),

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