import 'dart:convert';
import 'dart:typed_data';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:backdrop/backdrop.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sharemagazines_flutter/src/blocs/navbar/navbar_bloc.dart';
import 'package:sharemagazines_flutter/src/models/locationOffers_model.dart';
import 'package:sharemagazines_flutter/src/presentation/pages/navbarpages/homepage/homepage.dart';
import 'package:sharemagazines_flutter/src/presentation/pages/navbarpages/menupage.dart';
import 'package:sharemagazines_flutter/src/presentation/pages/navbarpages/homepage/searchpage.dart';

import 'package:sharemagazines_flutter/src/presentation/pages/navbarpages/accountpage/accountpage.dart';
import 'package:sharemagazines_flutter/src/presentation/pages/startpage.dart';
import 'package:sharemagazines_flutter/src/presentation/widgets/navbar/body_clipper.dart';
import 'package:sharemagazines_flutter/src/presentation/widgets/navbar/custom_navbar.dart';
import 'package:sharemagazines_flutter/src/presentation/widgets/sliding_AppBar.dart';
import 'package:sharemagazines_flutter/src/presentation/widgets/marquee.dart';
import 'package:sharemagazines_flutter/src/presentation/widgets/navbar/navbar_painter_clipper.dart';

import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/splash/splash_bloc.dart';
import '../../models/locationGetHeader_model.dart';
import '../widgets/backdrop/backdrop.dart';

import 'navbarpages/map/mappage.dart';
import 'navbarpages/map/offerpage.dart';

class MainPage extends StatefulWidget {
  MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late final AnimationController _controller;
  late PageController _pageController;
  var showSearchPage = false;
  GlobalKey<ScaffoldState>? backdropState = GlobalKey();
  ValueNotifier<bool> showLocationPage = ValueNotifier<bool>(true);
  GlobalKey _keyheight = GlobalKey();
  List<String> _masForUsing = [];
  int currentIndex = 0;
  late List<Widget> _pages = [
    HomePage(),
    MenuPage(),
    Maps(),
    AccountPage(),
  ];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    print("init_MainPageState");
    _masForUsing.clear(); // = [];
    super.initState();
    //To initialize the Map
    Maps();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void onClicked(int index) {
    print("mainpage onclicked");
    // if (showSearchPage == false) {
    setState(() {
      currentIndex = index;
      _pageController.animateToPage(index,
          duration: Duration(milliseconds: 400), curve: Curves.ease);
    });
    // }
    print(index);

    // if (index == 0) {
    //   print("home page bloc add");
    //   BlocProvider.of<NavbarBloc>(context).add(
    //     Home(),
    //   );
    // } else if (index == 1) {
    //   print("menu page bloc add");
    //   BlocProvider.of<NavbarBloc>(context).add(
    //     Menu(),
    //   );
    // } else if (index == 2) {
    //   print("Mappage bloc add");
    //   BlocProvider.of<NavbarBloc>(context).add(
    //     Map(),
    //   );
    // } else if (index == 3) {
    //   print("Account page bloc add");
    //   BlocProvider.of<NavbarBloc>(context).add(
    //     AccountEvent(),
    //   );
    // }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Size size = MediaQuery.of(context).size;
    return BlocBuilder<NavbarBloc, NavbarState>(builder: (context, state) {
      // int currentIndex = state is GoToHome //|| state is HomeLoaded
      //     ? 0
      //     : state is GoToMenu
      //         ? 1
      //         : state is GoToMap
      //             ? 2
      //             : state is GoToAccount
      //                 ? 3
      //                 // : state is GoToSearch
      //                 // : state is GoToLocationSelection
      //                 //     ? 4
      //                 //     ? 4
      //                 : 0;
      // print("Mainpage blocbuilder $state");
      if (state is NavbarError) {
        BlocProvider.of<AuthBloc>(context).emit(AuthError("error"));
        return StartPage(
          title: "notitle",
        );
      }
      return Stack(
        children: <Widget>[
          // new SvgPicture.asset(
          //   "assets/images/background_webreader.svg",
          //   fit: BoxFit.fill,
          //   allowDrawingOutsideViewBox: true,
          // ),
          Positioned.fill(
            child: Hero(
                tag: 'bg',
                // flightShuttleBuilder: (flightContext, animation, flightDirection, fromHeroContext, toHeroContext) {
                //   return Stack(children: [
                //     // Positioned.fill(child: FadeTransition(opacity: animation, child: fromHeroContext.widget)),
                //     Positioned.fill(
                //       child: FadeTransition(
                //         opacity: animation.drive(
                //           Tween<double>(begin: 0.0, end: 1.0).chain(
                //             CurveTween(
                //               curve: Interval(
                //                 0.0, 1.0,
                //                 // curve: ValleyQuadraticCurve()
                //               ),
                //             ),
                //           ),
                //         ),
                //       ),
                //     )
                //   ]);
                // },
                child: Image.asset("assets/images/background/Background.png",
                    fit: BoxFit.cover)),
          ),
          state is GoToLocationSelection
              ? Center(
                  child: CupertinoActionSheet(
                      title: Text(
                        'You are near these Locations',
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                      message: Text(
                        'Please select one',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      actions: <Widget>[
                        ...List.generate(
                          state.locations_GoToLocationSelection!.length,
                          (index) => GestureDetector(
                            // onTap: () => setState(() => _selectedIndex = index),
                            child: CupertinoActionSheetAction(
                              child: Text(
                                state.locations_GoToLocationSelection![index]
                                    .nameApp!,
                                // "$index",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.black),
                              ),
                              onPressed: () {
                                print(state
                                    .locations_GoToLocationSelection![index]
                                    .nameApp!);
                                // Navigator.of(context, rootNavigator: true).pop();
                                // currentIndex = 0;
                                setState(() {
                                  BlocProvider.of<NavbarBloc>(context).add(
                                      LocationSelected(
                                          location: state
                                                  .locations_GoToLocationSelection![
                                              index]));
                                });
                              },
                            ),
                          ),
                        ),

                        // CupertinoActionSheetAction(
                        //   child: Text(state.location!.data![0].nameApp!),
                        //   onPressed: () {
                        //     print(state.location);
                        //     // Navigator.of(context, rootNavigator: true).pop();
                        //
                        //     setState(() {
                        //       BlocProvider.of<NavbarBloc>(context).add(
                        //         Home(),
                        //       );
                        //       currentIndex = 0;
                        //     });
                        //   },
                        // )
                      ]),
                )
              : Container(),
          state is NavbarLoaded
              ? Center(
                  child:

                      // state is GoToMapOffer
                      //         ? MapOffer()

                      // :
                      BackdropScaffold(
                  // extendBodyBehindAppBar: currentIndex == 0 || currentIndex == 1 || currentIndex == 2 ? true : false,
                  extendBodyBehindAppBar: true,

                  // extendBody: true,
                  // appBar: currentIndex == 0 || currentIndex == 1
                  //     ? PreferredSize(
                  //         preferredSize: const Size(0, 56),
                  appBar: SlidingAppBar(
                    controller: _controller,
                    visible:
                        currentIndex == 0 || currentIndex == 1 ? true : false,
                    child: BackdropAppBar(
                      // primary: false,
                      excludeHeaderSemantics: true,
                      automaticallyImplyLeading: false,

                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      // actions: const <Widget>[
                      //   BackdropToggleButton(
                      //     icon: AnimatedIcons.list_view,
                      //   )
                      // ],
                      // toolbarOpacity: currentIndex == 0 || currentIndex == 1 ? 0 : 0,
                      toolbarHeight: (currentIndex == 0 ||
                              currentIndex == 1 && !showSearchPage)
                          ? size.height * 0.13
                          : 0,
                      flexibleSpace: SafeArea(
                        child: Container(
                          margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: ExpandableNotifier(
                            child: ScrollOnExpand(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  // GestureDetector(onTap: ,),
                                  // GestureDetector(
                                  //     child: Column(children: <Widget>[

                                  // child: Icon(
                                  //   Icons.circle,
                                  //   color: Colors.white,
                                  //   size: 80,
                                  // ),

                                  Expanded(child: Builder(
                                    builder: (BuildContext context) {
                                      return GestureDetector(
                                        onTap: () =>
                                            {Backdrop.of(context).fling()},
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            NavbarState.locationImage != null
                                                ? Padding(
                                                    padding: EdgeInsets.all(8),
                                                    child: Container(
                                                        height:
                                                            size.height * 0.095,
                                                        width:
                                                            size.height * 0.095,

                                                        // color: Colors.red,
                                                        decoration: BoxDecoration(
                                                            boxShadow: <BoxShadow>[
                                                              BoxShadow(
                                                                // offset: Offset(0, 3),
                                                                blurRadius: 5,
                                                                color: Color(
                                                                    0xFF000000),
                                                              ),
                                                            ],
                                                            border: Border.all(
                                                                color: Colors
                                                                    .grey),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        100),
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.2)),
                                                        child:
                                                            FutureBuilder<
                                                                    Uint8List>(
                                                                future: NavbarState
                                                                    .locationImage,
                                                                builder: (context,
                                                                    snapshot) {
                                                                  return (snapshot
                                                                          .hasData)
                                                                      ? ClipRRect(
                                                                          borderRadius:
                                                                              BorderRadius.circular(100.0),
                                                                          child:
                                                                              Image.memory(
                                                                            // state.bytes![i],
                                                                            snapshot.data!,
                                                                            fit:
                                                                                BoxFit.fill,
                                                                            // height: size.height * 0.01,
                                                                            // scale: size.height * 0.9,
                                                                          ),
                                                                        )
                                                                      : Container();
                                                                })),
                                                  )
                                                : Container(),
                                            Flexible(
                                              child: Padding(
                                                padding: NavbarState
                                                            .locationImage ==
                                                        null
                                                    ? EdgeInsets.only(left: 20)
                                                    : EdgeInsets.all(0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: <Widget>[
                                                    MarqueeWidget(
                                                      child: Text(
                                                        // state.access_location.data!.isNotEmpty ==
                                                        //         true
                                                        //     ? "sdf"
                                                        //     : "sdf",
                                                        // "Weser kurier",
                                                        SplashState
                                                                .appbarlocation
                                                                ?.nameApp ??
                                                            "No location",
                                                        // state is GoToHome
                                                        //     ? state.currentLocation.nameApp ?? "No location"
                                                        // : state is GoToMenu
                                                        //     ? NavbarState.currentLocation.data![0].nameApp ?? "No location"
                                                        // : "${state}",
// state.magazinePublishedGetLastWithLimit
//     .response!.first.name!,
//                                         overflow: TextOverflow.e,
//                                         softWrap: true,
//                                         maxLines: 1,
                                                        style: TextStyle(
                                                          fontSize:
                                                              size.aspectRatio *
                                                                  65,
                                                          color: Colors.white,
                                                          // fontWeight: FontWeight.bold
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
// textAlign: TextAlign.left,
                                                      ),
                                                    ),
                                                    Row(
                                                      // mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        Flexible(
                                                          child: MarqueeWidget(
                                                            child: Text(
                                                              "Infos zu deiner Location ",
                                                              // overflow: TextOverflow.fade,
                                                              // softWrap: true,
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      size.aspectRatio *
                                                                          25,
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w200),
                                                              // textAlign: TextAlign.center,
// textAlign: TextAlign.right,
                                                            ),
                                                          ),
                                                        ),
                                                        ValueListenableBuilder(
                                                            valueListenable:
                                                                showLocationPage,
                                                            builder: (BuildContext
                                                                    context,
                                                                bool
                                                                    counterValue,
                                                                Widget? child) {
                                                              return InkWell(
                                                                onTap: () => {
                                                                  // if (!counterValue)
                                                                  Backdrop.of(
                                                                          context)
                                                                      .fling()
                                                                },
                                                                // child: BackdropToggleButton(
                                                                //   // icon: AnimatedIcons.menu_arrow,
                                                                //   // icon:AnimateIcons(),
                                                                //   color: Colors.white,
                                                                // ),
                                                                child: Icon(
                                                                  counterValue
                                                                      ? Icons
                                                                          .arrow_upward
                                                                      : Icons
                                                                          .arrow_downward,
                                                                  color: Colors
                                                                      .white,
                                                                  size:
                                                                      size.aspectRatio *
                                                                          30,
                                                                ),
                                                              );
                                                            }),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                  )),

                                  Container(
                                    color: Colors.transparent,
                                    child: ValueListenableBuilder(
                                        valueListenable: showLocationPage,
                                        builder: (BuildContext context,
                                            bool counterValue, Widget? child) {
                                          return GestureDetector(
                                            onTap: () => {
                                              if (!counterValue)
                                                {
                                                  if (mounted)
                                                    {
                                                      setState(() =>
                                                          showSearchPage = true)
                                                    },
                                                  // setState(() {
                                                  //   showSearchPage = true;
                                                  // }),
                                                  print(
                                                      "before searchpage state $state"),
                                                  Navigator.push(
                                                    context,
                                                    PageRouteBuilder(
                                                        pageBuilder:
                                                            (_, __, ___) =>
                                                                SearchPage(),
                                                        // transitionDuration: Duration(milliseconds: 500),
                                                        transitionsBuilder:
                                                            (context,
                                                                animation,
                                                                secondaryAnimation,
                                                                child) {
                                                          const begin =
                                                              Offset(0, 1.0);
                                                          const end =
                                                              Offset.zero;
                                                          const curve =
                                                              Curves.ease;
                                                          final tween = Tween(
                                                                  begin: begin,
                                                                  end: end)
                                                              .chain(CurveTween(
                                                                  curve:
                                                                      curve));
                                                          final offsetAnimation =
                                                              animation
                                                                  .drive(tween);
                                                          return SlideTransition(
                                                              position: animation
                                                                  .drive(tween),
                                                              child: child);
                                                        }),
                                                  ).then((_) {
                                                    print(
                                                        "after searchpage state $state");
                                                    setState(() {
                                                      showSearchPage = false;
                                                    });
                                                  })
                                                }
                                              else
                                                Backdrop.of(context).fling()
                                            },
                                            child: Padding(
                                              padding:
                                                  EdgeInsets.only(left: 10),
                                              child: Hero(
                                                tag: "search button",
                                                // child: Scaffold_Close_Open_button(
                                                //   context: context,
                                                // ),
                                                child: Icon(
                                                  // Backdrop.of(context).isBackLayerConcealed == false ? Icons.search_sharp : Icons.clear,
                                                  // _counter1 == false ? Icons.search_sharp : Icons.clear,
                                                  !counterValue
                                                      ? Icons.search_sharp
                                                      : Icons.close,
                                                  // Icomoon.fc_logo,
                                                  color: Colors.white,
                                                  size: 40,
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  frontLayerActiveFactor: 1,
                  backgroundColor: Colors.transparent,
                  backLayerBackgroundColor: Colors.transparent,
                  frontLayerBackgroundColor: Colors.transparent,
                  // resizeToAvoidBottomInset: false,
                  subHeaderAlwaysActive: false,
                  // resizeToAvoidBottomInset: false,
                  extendBody: false,

                  // drawerDragStartBehavior: ,
                  headerHeight: 00,
                  frontLayerElevation: 0,
                  revealBackLayerAtStart:
                      false, // state is GoToHome ? true : false, //&& state.currentLocation.idLocation != null
                  // fr

                  // scaffoldKey: backdropState,
                  key: backdropState,
                  frontLayerScrim: Colors.transparent,
                  // stickyFrontLayer: true,
                  onBackLayerRevealed: () => showLocationPage.value = false,
                  onBackLayerConcealed: () => showLocationPage.value = true,

                  // backLayerScrim: Colors.red,
                  // extendBody: true,
                  // subHeaderAlwaysActive: true,
                  frontLayer: Stack(
                    children: [
                      Positioned.fill(
                        //Remove hero
                        child: Hero(
                            tag: 'bg1',
                            child: Image.asset(
                                "assets/images/background/Background.png",
                                fit: BoxFit.cover)),
                      ),
                      NavbarState.locationheader != null
                          ? SafeArea(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  FutureBuilder<LocationGetHeader>(
                                      future: NavbarState.locationheader,
                                      builder: (context, snapshotInfo) {
                                        // if (snapshotInfo.connectionState != ConnectionState.done) {
                                        //   return SpinKitFadingCircle(
                                        //     color: Colors.red,
                                        //     size: 50.0,
                                        //   );
                                        //   ;
                                        // }
                                        // if (snapshotInfo.hasError) {
                                        //   return SpinKitFadingCircle(
                                        //     color: Colors.red,
                                        //     size: 50.0,
                                        //   );
                                        // }
                                        if (snapshotInfo.hasData) {
                                          LineSplitter ls = new LineSplitter();
                                          _masForUsing = ls.convert(
                                              snapshotInfo.data!.text!);
                                          return Column(
                                            children: [
                                              for (int a = 0;
                                                  a < _masForUsing.length;
                                                  a++)
                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      size.width * 0.07,
                                                      size.height * 0.001,
                                                      size.width * 0.07,
                                                      a ==
                                                              _masForUsing
                                                                      .length -
                                                                  1
                                                          ? size.height * 0.001
                                                          : size.height * 0.01),
                                                  child: Text(
                                                    _masForUsing[a],
                                                    // textScaleFactor: ScaleSize.textScaleFactor(context),

                                                    // "datadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadata",
                                                    style: TextStyle(
                                                        fontSize: a == 0
                                                            ? size.aspectRatio *
                                                                50
                                                            : size.aspectRatio *
                                                                40,
                                                        fontWeight: a == 0
                                                            ? FontWeight.w500
                                                            : FontWeight.w300,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                            ],
                                          );
                                        }
                                        return Container();
                                        // return SpinKitFadingCircle(
                                        //   color: Colors.red,
                                        //   size: 50.0,
                                        // );
                                      }),
                                  NavbarState.locationoffersImages != null
                                      ? Expanded(
                                          flex: 5,
                                          // fit: FlexFit.loose,
                                          child: CarouselSlider.builder(
                                              itemCount: NavbarState
                                                  .locationoffersImages!.length,
                                              options: CarouselOptions(
                                                // height: double.infinity,
                                                // height: MediaQuery.of(context).size.height * 0.4,
                                                // aspectRatio: 16 / 9,
                                                // viewportFraction: 0.7,
                                                initialPage: 0,
                                                enableInfiniteScroll: false,
                                                height: double.infinity,
                                                // reverse: false,
                                                // autoPlay: true,
                                                // autoPlayInterval: Duration(seconds: 3),
                                                // autoPlayAnimationDuration: Duration(milliseconds: 800),
                                                // autoPlayCurve: Curves.fastOutSlowIn,
                                                enlargeCenterPage: true,
                                                enlargeFactor: 0.7,
                                                // // onPageChanged: callbackFunction,
                                                scrollDirection:
                                                    Axis.horizontal,
                                              ),
                                              itemBuilder: (BuildContext
                                                          context,
                                                      int itemIndex,
                                                      int pageViewIndex) =>
                                                  FutureBuilder<Uint8List>(
                                                      future: NavbarState
                                                              .locationoffersImages![
                                                          itemIndex],
                                                      builder: (context,
                                                          snapshotImage) {
                                                        print(
                                                            "snapshot has data ${snapshotImage.hasData}");
                                                        if (snapshotImage
                                                            .hasData) {
                                                          return FutureBuilder<
                                                                  LocationOffers>(
                                                              future: NavbarState
                                                                  .locationoffers,
                                                              builder: (context,
                                                                  snapshotOfferDetails) {
                                                                if (snapshotOfferDetails
                                                                    .hasData) {
                                                                  return GestureDetector(
                                                                    onTap: () =>
                                                                        {
                                                                      Navigator
                                                                          .push(
                                                                        context,
                                                                        PageRouteBuilder(
                                                                          pageBuilder: (_, __, ___) =>
                                                                              OfferPage(
                                                                            locOffer:
                                                                                snapshotOfferDetails.data!.locationOffer![itemIndex],
                                                                            heroTag:
                                                                                itemIndex,
                                                                          ),
                                                                        ),
                                                                      )
                                                                    },
                                                                    child:
                                                                        Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Flexible(
                                                                          flex:
                                                                              8,
                                                                          child:
                                                                              ClipRRect(
                                                                            borderRadius:
                                                                                BorderRadius.circular(5.0),
                                                                            child:
                                                                                Image.memory(
                                                                              // state.bytes![i],
                                                                              snapshotImage.data!,
                                                                              fit: BoxFit.fill,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Expanded(
                                                                          flex:
                                                                              1,
                                                                          child: Align(
                                                                              alignment: Alignment.centerLeft,
                                                                              child: Text(
                                                                                snapshotOfferDetails.data!.locationOffer![itemIndex].shm2Offer![0].title!,
                                                                                // "dsf",
                                                                                maxLines: 1,
                                                                                style: TextStyle(fontSize: size.width * 0.05, color: Colors.white, fontWeight: FontWeight.w900),
                                                                                textAlign: TextAlign.left,
                                                                              )),
                                                                        ),
                                                                        Expanded(
                                                                          flex:
                                                                              1,
                                                                          child: Align(
                                                                              alignment: Alignment.centerLeft,
                                                                              child: Text(
                                                                                snapshotOfferDetails.data!.locationOffer![itemIndex].shm2Offer![0].shortDesc!,
                                                                                // "dsf",
                                                                                style: TextStyle(fontSize: size.width * 0.045, color: Colors.white),
                                                                                textAlign: TextAlign.left,
                                                                              )),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  );
                                                                }
                                                                return SpinKitFadingCircle(
                                                                  color: Colors
                                                                      .white,
                                                                  size: 50.0,
                                                                );
                                                              });
                                                        }
                                                        return SpinKitFadingCircle(
                                                          color: Colors.white,
                                                          size: 50.0,
                                                        );
                                                      })),
                                        )
                                      : SpinKitFadingCircle(
                                          color: Colors.white,
                                          size: 50.0,
                                        )
                                ],
                              ),
                            )
                          : Container(),
                    ],
                  ),
                  backLayer: Stack(
                    children: [
                      ClipPath(
                        clipper: BodyClipper(
                            index: currentIndex,
                            context: context,
                            key: _keyheight),
                        clipBehavior: Clip.hardEdge,
                        child: PageView.builder(
                          controller: _pageController,
                          physics: NeverScrollableScrollPhysics(),
                          // physics: AlwaysScrollableScrollPhysics(),
                          itemBuilder: (context, index) => _pages[index],
                        ),
                      ),
                      // currentIndex != 4
                      Container(
                          alignment: Alignment.bottomCenter,
                          // key: _keyheight,
                          child: ClipPath(
                              key: _keyheight,
                              clipper: NavbarClipper(currentIndex),
                              child: CustomPaint(
                                painter: NavbarPainter(currentIndex),
                                child: CustomNavbar(
                                  onClicked: onClicked,
                                  selectedIndex: currentIndex,
                                ),
                              )))
                    ],
                  ),
                ))
              : Container(),
        ],
      );
    });
  }
}
