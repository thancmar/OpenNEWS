import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

// import 'package:direct_select_flutter/direct_select_container.dart';
// import 'package:direct_select_flutter/direct_select_item.dart';
// import 'package:direct_select_flutter/direct_select_list.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sharemagazines/src/blocs/navbar/navbar_bloc.dart';
import 'package:sharemagazines/src/models/locationOffers_model.dart';
import 'package:sharemagazines/src/presentation/pages/navbarpages/homepage/homepage.dart';
import 'package:sharemagazines/src/presentation/pages/navbarpages/menupage.dart';
import 'package:sharemagazines/src/presentation/pages/navbarpages/homepage/searchpage/searchpage.dart';

import 'package:sharemagazines/src/presentation/pages/navbarpages/accountpage/accountpage.dart';
import 'package:sharemagazines/src/presentation/pages/startpage.dart';
import 'package:sharemagazines/src/presentation/widgets/navbar/body_clipper.dart';
import 'package:sharemagazines/src/presentation/widgets/navbar/custom_navbar.dart';
import 'package:sharemagazines/src/presentation/widgets/sliding_AppBar.dart';
import 'package:sharemagazines/src/presentation/widgets/marquee.dart';
import 'package:sharemagazines/src/presentation/widgets/navbar/navbar_painter_clipper.dart';
import 'package:video_player/video_player.dart';

import '../../blocs/auth/auth_bloc.dart';
import '../../models/locationGetHeader_model.dart';
import '../../models/location_model.dart';
import '../widgets/backdrop/backdrop.dart';

import 'navbarpages/homepage/tokenTimer.dart';
import 'navbarpages/map/mappage.dart';
import 'navbarpages/map/offerpage.dart';
import 'navbarpages/qrpage/qr_scanner.dart';

class MainPage extends StatefulWidget {
  MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late final AnimationController _controller;
  late PageController _pageController;
  var showSearchPage = false;
  GlobalKey<BackdropScaffoldState>? backdropState = GlobalKey();
  ValueNotifier<bool> showLocationPage = ValueNotifier<bool>(true);
  GlobalKey _keyheight = GlobalKey();
  List<String> _masForUsing = [];
  int currentIndex = 0;
  int currentLocationOfferIndex = 0;
  bool isLoadingOnTop = false;
  final fabKey = GlobalKey();
  ValueNotifier<bool> isDialOpen = ValueNotifier(true);

  // late List<AnimationController> _controllers;
  // late List<Animation<double>> _animations;

  var items = [
    FloatingActionButtonLocation.startFloat,
    FloatingActionButtonLocation.startDocked,
    FloatingActionButtonLocation.centerFloat,
    FloatingActionButtonLocation.endFloat,
    FloatingActionButtonLocation.endDocked,
    FloatingActionButtonLocation.startTop,
    FloatingActionButtonLocation.centerTop,
    FloatingActionButtonLocation.endTop,
  ];

  // final dsl = DirectSelectList<String>(
  //     values: _cities,
  //     defaultItemIndex: 3,
  //     itemBuilder: (String value) => getDropDownMenuItem(value),
  //     focusedItemDecoration: _getDslDecoration(),
  //     onItemSelectedListener: (item, index, context) {
  //       Scaffold.of(context).showSnackBar(SnackBar(content: Text(item)));
  //     });
  // DirectSelectItem<String> getDropDownMenuItem(String value) {
  //   return DirectSelectItem<String>(
  //       itemHeight: 56,
  //       value: value,
  //       itemBuilder: (context, value) {
  //         return Text(value);
  //       });
  // }
  //
  // _getDslDecoration() {
  //   // if (mounted) {
  //   //   setState(() {
  //   //     isLoadingOnTop = true;
  //   //   });
  //   // }
  //
  //   return BoxDecoration(
  //     border: BorderDirectional(
  //       bottom: BorderSide(width: 10, color: Colors.red), // Change color to red
  //       top: BorderSide(width: 1, color: Colors.black12),
  //     ),
  //   );
  // }

  @override
  bool get wantKeepAlive => true;

  bool isTablet(BuildContext context) {
    // Get the device's physical screen size
    var screenSize = MediaQuery.of(context).size;

    // Arbitrary cutoff for device width that differentiates between phones and tablets
    // This can be adjusted based on your needs or specific device metrics
    const double deviceWidthCutoff = 600;

    return screenSize.width > deviceWidthCutoff;
  }

  late List<Widget> _pages = [
    HomePage(),
    MenuPage(),
    // if (showQR) Container(),
    Maps(),
    AccountPage(pageController: _pageController, onClick: onClicked),
  ];

  @override
  void initState() {
    super.initState();
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
    _masForUsing.clear(); // = [];;
    // locationOffersController.dispose();
    super.dispose();
  }

  void onClicked(int index) {
    setState(() {
      currentIndex = index;
      _pageController.animateToPage(currentIndex, duration: Duration(milliseconds: 400), curve: Curves.ease);
    });
  }

  // Future<VideoPlayerController> OfferVideo(var video) async {
  //   VideoPlayerController offerVideoController = VideoPlayerController.file(
  //     video,
  //     videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true, allowBackgroundPlayback: false),
  //   );
  //   offerVideoController!.setLooping(true);
  //   await offerVideoController!.initialize().then((_) {
  //     setState(() {});
  //   });
  //   // offerVideoController!.play();
  //   return offerVideoController;
  // }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    bool tablet = isTablet(context);
    // if(tablet) _keyheight
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlocBuilder<NavbarBloc, NavbarState>(builder: (context, state) {
        if (state is NavbarLoaded) {
          isLoadingOnTop = false;

        } else {
          isLoadingOnTop = true;
        }
        ;
        if (state is NavbarError) {
          BlocProvider.of<AuthBloc>(context).emit(AuthError(state.error));
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => StartPage(
                title: "notitle",
              ),
              // transitionDuration: Duration.zero,
            ),
          );
          // return AlertDialog(
          //   title: Text(
          //     ('error').tr(),
          //     style: TextStyle(fontSize: 16.0, color: Colors.grey, fontWeight: FontWeight.w500),
          //   ),
          //   content: Text(state.error.toString(), style: TextStyle(fontSize: 16.0, color: Colors.grey, fontWeight: FontWeight.w300)),
          //   actions: <Widget>[
          //     // TextButton(
          //     //   onPressed: () => Navigator.pop(context, 'Cancel'),
          //     //   child: const Text('Cancel'),
          //     // ),
          //     TextButton(
          //       onPressed: () => BlocProvider.of<AuthBloc>(context).add(
          //         OpenLoginPage(),
          //         // Initialize()
          //       ),
          //       child: Text('OK'),
          //     ),
          //   ],
          // );
        }


        return Stack(
          children: <Widget>[
            Positioned.fill(
              child: Hero(tag: 'bg', child: Image.asset("assets/images/background/Background.png", fit: BoxFit.cover)),
            ),
            Center(
                child: AnimatedOpacity(
              opacity: !isLoadingOnTop ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: IgnorePointer(
                ignoring: isLoadingOnTop,
                child: BackdropScaffold(
                  extendBodyBehindAppBar: tablet ? false : true,
                  resizeToAvoidBottomInset: false,
                  // extendBody: true,
                  appBar: SlidingAppBar(
                    controller: _controller,
                    visible: tablet ? true : (currentIndex == 0 || currentIndex == 1 ? true : false),
                    // visible: true,
                    child: PreferredSize(
                      preferredSize: (((currentIndex == 0 || currentIndex == 1) || tablet) && !showSearchPage)
                          ? Size.fromHeight(size.height * 0.16)
                          : Size.fromHeight(size.height * 0.0),
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
                        // toolbarHeight: ((currentIndex == 0 || currentIndex == 1) && !showSearchPage) ? size.height * 0.13 : 0,
                        // toolbarHeight: 190,
                        flexibleSpace: Builder(builder: (context) {
                          return SafeArea(
                            child: GestureDetector(
                              onTap: () => {Backdrop.of(context).fling()},
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Container(
                                      margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                      child: ExpandableNotifier(
                                        child: ScrollOnExpand(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Expanded(
                                                  child: GestureDetector(
                                                onTap: () => {Backdrop.of(context).fling()},
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    NavbarState.locationImage != null
                                                        ? FutureBuilder<Uint8List>(
                                                            future: NavbarState.locationImage,
                                                            builder: (context, snapshot) {
                                                              return (snapshot.hasData)
                                                                  ? Padding(
                                                                      padding: EdgeInsets.all(tablet ? 24 : 8.0),
                                                                      child: Container(
                                                                        height: 100,
                                                                        // width: size.height * 0.095,
                                                                        width: 100,
                                                                        decoration: BoxDecoration(
                                                                            boxShadow: <BoxShadow>[
                                                                              BoxShadow(
                                                                                // offset: Offset(0, 3),
                                                                                blurRadius: 5,
                                                                                color: Color(0xFF000000),
                                                                              ),
                                                                            ],
                                                                            border: Border.all(color: Colors.grey),
                                                                            borderRadius: BorderRadius.circular(100),
                                                                            color: Colors.grey.withOpacity(0.2)),
                                                                        child: ClipRRect(
                                                                          borderRadius: BorderRadius.circular(100.0),
                                                                          child: Image.memory(
                                                                            // state.bytes![i],
                                                                            snapshot.data!,
                                                                            fit: BoxFit.fill,
                                                                            // height: size.height * 0.01,
                                                                            // scale: size.height * 0.9,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  : Container();
                                                            })
                                                        : Container(),
                                                    Flexible(
                                                      child: Padding(
                                                        padding: NavbarState.locationImage == null ? EdgeInsets.only(left: 20) : EdgeInsets.all(0),
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          mainAxisSize: MainAxisSize.max,
                                                          children: <Widget>[
                                                            MarqueeWidget(
                                                              child: Text(
                                                                state.appbarlocation!.nameApp ?? ("notAtLocation").tr(),
                                                                // ("notAtLocation").tr(),
                                                                style: Theme.of(context).textTheme.headlineLarge,
                                                                textAlign: TextAlign.center,
                                                              ),
                                                            ),
                                                            state.appbarlocation!.expiration != '' && state.appbarlocation!.expiration != null
                                                                ? MarqueeWidget(
                                                                    child: CountdownTimer(
                                                                    futureTime: state.appbarlocation!.expiration!,
                                                                  ))
                                                                : Container(),
                                                            Row(
                                                              // mainAxisSize: MainAxisSize.min,
                                                              children: [
                                                                Flexible(
                                                                  child: MarqueeWidget(
                                                                    child: Text(
                                                                      ("locationInformation").tr(),
                                                                      // overflow: TextOverflow.fade,
                                                                      // softWrap: true,
                                                                      style: Theme.of(context)
                                                                          .textTheme
                                                                          .bodyMedium!
                                                                          .copyWith(fontWeight: FontWeight.w200),
                                                                    ),
                                                                  ),
                                                                ),
                                                                ValueListenableBuilder(
                                                                    valueListenable: showLocationPage,
                                                                    builder: (BuildContext context, bool counterValue, Widget? child) {
                                                                      return InkWell(
                                                                        onTap: () => {Backdrop.of(context).fling()},
                                                                        child: Icon(
                                                                          counterValue ? Icons.arrow_upward : Icons.arrow_downward,
                                                                          color: Colors.white,
                                                                          size: size.aspectRatio * 30,
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
                                              )),
                                              Container(
                                                color: Colors.transparent,
                                                child: ValueListenableBuilder(
                                                    valueListenable: showLocationPage,
                                                    builder: (BuildContext context, bool counterValue, Widget? child) {
                                                      return
                                                          // !counterValue &&
                                                          state.appbarlocation?.nameApp == null
                                                              ? GestureDetector(
                                                                  onTap: () {
                                                                    // FAB onPressed logic
                                                                    Navigator.of(context)
                                                                        .push(MaterialPageRoute(
                                                                          builder: (context) => QRViewExample(),
                                                                        ))
                                                                        .whenComplete(() => {
                                                                              // if (showLocationPage.value == false)
                                                                              //   backdropState!.currentState!.fling()
                                                                            });
                                                                  },
                                                                  child: Padding(
                                                                    padding: EdgeInsets.only(left: 10),
                                                                    child: Icon(
                                                                      Icons.qr_code,
                                                                      color: Colors.white,
                                                                      size: 40,
                                                                    ),
                                                                  ),
                                                                )
                                                              : Container();
                                                    }),
                                              ),
                                              tablet
                                                  ? Container(
                                                      color: Colors.transparent,
                                                      child: ValueListenableBuilder(
                                                          valueListenable: showLocationPage,
                                                          builder: (BuildContext context, bool counterValue, Widget? child) {
                                                            return !counterValue
                                                                ? Row(
                                                                    children: [
                                                                      GestureDetector(
                                                                        onTap: () => {
                                                                          if (!counterValue) {onClicked(0)} else Backdrop.of(context).fling()
                                                                        },
                                                                        child: Padding(
                                                                          padding: EdgeInsets.only(left: 10),
                                                                          child: Hero(
                                                                            tag: "search button",
                                                                            child: Icon(
                                                                              Icons.home,
                                                                              color: Colors.white,
                                                                              size: 40,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      GestureDetector(
                                                                        onTap: () => {
                                                                          if (!counterValue) {onClicked(1)} else Backdrop.of(context).fling()
                                                                        },
                                                                        child: Padding(
                                                                          padding: EdgeInsets.only(left: 10),
                                                                          child: Hero(
                                                                            tag: "search button",
                                                                            child: Icon(
                                                                              Icons.menu,
                                                                              color: Colors.white,
                                                                              size: 40,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      GestureDetector(
                                                                        onTap: () => {
                                                                          if (!counterValue) {onClicked(2)} else Backdrop.of(context).fling()
                                                                        },
                                                                        child: Padding(
                                                                          padding: EdgeInsets.only(left: 10),
                                                                          child: Hero(
                                                                            tag: "search button",
                                                                            child: Icon(
                                                                              Icons.pin_drop_outlined,
                                                                              color: Colors.white,
                                                                              size: 40,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      GestureDetector(
                                                                        onTap: () => {
                                                                          if (!counterValue) {onClicked(3)} else Backdrop.of(context).fling()
                                                                        },
                                                                        child: Padding(
                                                                          padding: EdgeInsets.only(left: 10),
                                                                          child: Hero(
                                                                            tag: "search button",
                                                                            child: Icon(
                                                                              Icons.account_circle_outlined,
                                                                              color: Colors.white,
                                                                              size: 40,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  )
                                                                : Container();
                                                          }),
                                                    )
                                                  : Container(),
                                              Container(
                                                color: Colors.transparent,
                                                child: ValueListenableBuilder(
                                                    valueListenable: showLocationPage,
                                                    builder: (BuildContext context, bool counterValue, Widget? child) {
                                                      return GestureDetector(
                                                        onTap: () => {
                                                          if (!counterValue)
                                                            {
                                                              Navigator.of(context).push(
                                                                CupertinoPageRoute(
                                                                  fullscreenDialog: true,
                                                                  builder: (context) => SearchPage(),
                                                                ),
                                                              )
                                                            }
                                                          else
                                                            Backdrop.of(context).fling()
                                                        },
                                                        child: Padding(
                                                          padding: EdgeInsets.only(left: 10),
                                                          child: Hero(
                                                            tag: "search button",
                                                            child: Icon(
                                                              !counterValue ? Icons.search_sharp : Icons.close,
                                                              color: Colors.white,
                                                              size: 40,
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    }),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (NavbarState.locationheader != null)
                                    ValueListenableBuilder(
                                        valueListenable: showLocationPage,
                                        builder: (BuildContext context, bool counterValue, Widget? child) {
                                          return !counterValue ? LocationOffersWidget() : Container();
                                        }),
                                ],
                              ),
                            ),
                          );
                        }),
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
                  headerHeight: 00,
                  frontLayerElevation: 0,
                  revealBackLayerAtStart: false,
                  key: backdropState,

                  // frontLayerScrim: Colors.blue,
                  // backLayerScrim: Colors.red,
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
                        child: Hero(tag: 'bg1', child: Image.asset("assets/images/background/Background.png", fit: BoxFit.cover)),
                      ),
                      if (NavbarState.locationheader != null)
                        SafeArea(
                          child: Container(
                            clipBehavior: Clip.antiAlias,

                            decoration: BoxDecoration(

                                // color: Colors.green.withOpacity(0.901),
                                // border: Border.all(color: Colors.blue, width: 2.0), // Outer border
                                // borderRadius: BorderRadius.circular(25.0),
                                // gradient: LinearGradient(
                                //   begin: Alignment.topCenter,
                                //   end: Alignment.bottomCenter,
                                //   colors: [Colors.blue, Colors.blue.withOpacity(0.0)], // Use transparent color to create the fill effect
                                // ),
                                ),

                            // color: Colors.redAccent,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                  flex: 2,
                                  child: FutureBuilder<LocationGetHeader>(
                                      future: NavbarState.locationheader,
                                      builder: (context, snapshotInfo) {
                                        if (snapshotInfo.hasData) {
                                          LineSplitter ls = new LineSplitter();
                                          _masForUsing = ls.convert(snapshotInfo.data!.text!);
                                          return ShaderMask(
                                            shaderCallback: (Rect bounds) {
                                              return LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: <Color>[Colors.white, Colors.transparent],
                                                stops: [0.85, 1.0], // Adjust these stops for more or less fade
                                              ).createShader(bounds);
                                            },
                                            blendMode: BlendMode.dstIn,
                                            child: Container(
                                              height: double.infinity,
                                              // constraints: BoxConstraints(maxHeight:500),
                                              child: SingleChildScrollView(
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    for (int a = 0; a < _masForUsing.length; a++)
                                                      Padding(
                                                        padding: EdgeInsets.fromLTRB(size.width * 0.07, size.height * 0.001, size.width * 0.07,
                                                            a == _masForUsing.length - 1 ? size.height * 0.001 : size.height * 0.01),
                                                        child: Text(
                                                          _masForUsing[a],
                                                          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                                                              fontSize: a == 0 ? size.aspectRatio * 50 : size.aspectRatio * 40,
                                                              fontWeight: a == 0 ? FontWeight.w500 : FontWeight.w300,
                                                              color: Colors.white),
                                                          maxLines: 10, // Adjust the number of lines accordingly
                                                          overflow: TextOverflow.clip, // Use clip instead of fade
                                                        ),
                                                        // child: ConstrainedBox(
                                                        //   constraints: BoxConstraints(maxHeight: size.height * 0.20),
                                                        //   child: ExpandablePanel(
                                                        //     header: Text("Header"),
                                                        //     collapsed: Text(
                                                        //           _masForUsing[a],
                                                        //           // textScaleFactor: ScaleSize.textScaleFactor(context),
                                                        //           // maxLines: 3,
                                                        //           // softWrap: false,
                                                        //           overflow: TextOverflow.fade,
                                                        //           style: TextStyle(
                                                        //               fontSize: a == 0 ? size.aspectRatio * 50 : size.aspectRatio * 40,
                                                        //               fontWeight: a == 0 ? FontWeight.w500 : FontWeight.w300,
                                                        //               color: Colors.white),
                                                        //         ),
                                                        //     expanded: Text("Wil", softWrap: true),
                                                        //   ),
                                                        //   // child: SingleChildScrollView(
                                                        //   //   child: Text(
                                                        //   //     _masForUsing[a],
                                                        //   //     // textScaleFactor: ScaleSize.textScaleFactor(context),
                                                        //   //     // maxLines: 3,
                                                        //   //     // softWrap: false,
                                                        //   //     overflow: TextOverflow.fade,
                                                        //   //     style: TextStyle(
                                                        //   //         fontSize: a == 0 ? size.aspectRatio * 50 : size.aspectRatio * 40,
                                                        //   //         fontWeight: a == 0 ? FontWeight.w500 : FontWeight.w300,
                                                        //   //         color: Colors.white),
                                                        //   //   ),
                                                        //   // ),
                                                        // ),
                                                      ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        }
                                        return Container();
                                        // return SpinKitFadingCircle(
                                        //   color: Colors.red,
                                        //   size: 50.0,
                                        // );
                                      }),
                                ),
                                // NavbarState.locationoffersVideos != null?  Expanded(
                                //     flex: 5,
                                //     // fit: FlexFit.loose,
                                //     child: CarouselSlider.builder(
                                //         itemCount: NavbarState.locationoffersVideos!.length,
                                //         options: CarouselOptions(
                                //           // height: double.infinity,
                                //           // height: MediaQuery.of(context).size.height * 0.4,
                                //           // aspectRatio: 16 / 9,
                                //           // viewportFraction: 0.7,
                                //           initialPage: 0,
                                //           enableInfiniteScroll: false,
                                //           height: double.infinity,
                                //           // reverse: false,
                                //           // autoPlay: true,
                                //           // autoPlayInterval: Duration(seconds: 3),
                                //           // autoPlayAnimationDuration: Duration(milliseconds: 800),
                                //           // autoPlayCurve: Curves.fastOutSlowIn,
                                //           enlargeCenterPage: true,
                                //           enlargeFactor: 0.7,
                                //           // // onPageChanged: callbackFunction,
                                //           scrollDirection: Axis.horizontal,
                                //         ),
                                //         itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) => FutureBuilder<File>(
                                //             future: NavbarState.locationoffersVideos![itemIndex],
                                //             builder: (context, snapshotImage) {
                                //               print("snapshot has data $itemIndex  ${snapshotImage.hasData}");
                                //               if (snapshotImage.hasData) {
                                //                 VideoPlayerController? _videocontroller =null;
                                //                 return FutureBuilder<LocationOffers>(
                                //                     future: NavbarState.locationoffers,
                                //                     builder: (context, snapshotOfferDetails) {
                                //                       VideoPlayerController? _videocontroller =  VideoPlayerController.file(
                                //                         snapshotImage.data! ,
                                //                         videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true, allowBackgroundPlayback: false),
                                //                       );
                                //                       _videocontroller!.setLooping(true);
                                //                        _videocontroller!.initialize().then((_) {
                                //                       setState(() {});
                                //                       });
                                //                       _videocontroller!.play();
                                //                       if (snapshotOfferDetails. hasData) {
                                //
                                //                         // WidgetsBinding.instance.addPostFrameCallback((_) {
                                //                         //
                                //                         //   _videocontroller = VideoPlayerController.file(
                                //                         //     value,
                                //                         //     videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true, allowBackgroundPlayback: false),
                                //                         //   ),
                                //                         //
                                //                         //
                                //                         // });
                                //                          return GestureDetector(
                                //                           onTap: () => {
                                //                             Navigator.of(context).push(
                                //                               CupertinoPageRoute(
                                //                                 builder: (context) => OfferPage(
                                //                                   locOffer: snapshotOfferDetails.data!.locationOffer![itemIndex],
                                //                                   // heroTag: itemIndex,
                                //                                 ),
                                //                               ),
                                //                             )
                                //                             // Navigator.push(
                                //                             //   context,
                                //                             //   PageRouteBuilder(
                                //                             //     pageBuilder: (_, __, ___) => OfferPage(
                                //                             //       locOffer: snapshotOfferDetails.data!.locationOffer![itemIndex],
                                //                             //       // heroTag: itemIndex,
                                //                             //     ),
                                //                             //   ),
                                //                             // )
                                //                           },
                                //                           child: Column(
                                //                             mainAxisSize: MainAxisSize.min,
                                //                             mainAxisAlignment: MainAxisAlignment.center,
                                //                             crossAxisAlignment: CrossAxisAlignment.center,
                                //                             children: [
                                //                               // Flexible(
                                //                               //   flex: 8,
                                //                               //   child: ClipRRect(
                                //                               //     borderRadius: BorderRadius.circular(5.0),
                                //                               //     child:  AspectRatio(
                                //                               //       aspectRatio: _videocontroller != null ? _videocontroller!.value.aspectRatio : 16 / 9,
                                //                               //       child: _videocontroller != null
                                //                               //           ? VideoPlayer(_videocontroller!)
                                //                               //           : SpinKitFadingCircle(
                                //                               //         color: Colors.white,
                                //                               //         size: 50.0,
                                //                               //       ),
                                //                               //     )
                                //                               //   ),),
                                //                               // Expanded(
                                //                               //   flex: 1,
                                //                               //   child: Align(
                                //                               //       alignment: Alignment.centerLeft,
                                //                               //       child: Text(
                                //                               //         snapshotOfferDetails.data!.locationOffer![itemIndex].shm2Offer![0].title!,
                                //                               //         // "dsf",
                                //                               //         maxLines: 1,
                                //                               //         style: TextStyle(
                                //                               //             fontSize: size.width * 0.05,
                                //                               //             color: Colors.white,
                                //                               //             fontWeight: FontWeight.w900),
                                //                               //         textAlign: TextAlign.left,
                                //                               //       )),
                                //                               // ),
                                //                               // Expanded(
                                //                               //   flex: 1,
                                //                               //   child: Align(
                                //                               //       alignment: Alignment.centerLeft,
                                //                               //       child: Text(
                                //                               //         snapshotOfferDetails
                                //                               //             .data!.locationOffer![itemIndex].shm2Offer![0].shortDesc!,
                                //                               //         // "dsf",
                                //                               //         style: TextStyle(fontSize: size.width * 0.045, color: Colors.white),
                                //                               //         textAlign: TextAlign.left,
                                //                               //       )),
                                //                               // ),
                                //                             ],
                                //                           ),
                                //                         );
                                //                       }
                                //                       return SpinKitFadingCircle(
                                //                         color: Colors.white,
                                //                         size: 50.0,
                                //                       );
                                //                     });
                                //               }
                                //               return SpinKitFadingCircle(
                                //                 color: Colors.white,
                                //                 size: 50.0,
                                //               );
                                //             })
                                //     ))
                                //     : SpinKitFadingCircle(
                                //   color: Colors.white,
                                //   size: 50.0,
                                // ),
                                Expanded(
                                    flex: 5,
                                    // fit: FlexFit.loose,
                                    child:
                                        // FutureBuilder<List<dynamic>?>(
                                        //                             future: fetchCombinedData(), // Use the method here
                                        //                             builder: (context, snapshot) {
                                        //                                     if (snapshot.connectionState == ConnectionState.waiting) {
                                        //                                       // Return loading widget or placeholder
                                        //                                       return CircularProgressIndicator();
                                        //                                     }
                                        //
                                        //                                     if (snapshot.hasError) {
                                        //                                       // Handle error scenario
                                        //                                       return Text('Error: ${snapshot.error}');
                                        //                                     }
                                        //
                                        //                                     if (!snapshot.hasData || snapshot.data == 2) {
                                        //                                       // Handle no data scenario
                                        //                                       // return Text('No data available');
                                        //                                       return Container(
                                        //                                         color: Colors.grey, // Choose a suitable background color
                                        //                                         alignment: Alignment.center,
                                        //                                         child: Text(
                                        //                                           'Error loading image', // Custom error message
                                        //                                           style: TextStyle(color: Colors.white), // Optional: style your text
                                        //                                         ),
                                        //                                       );
                                        //                                     }
                                        //
                                        //                                     // Extracting data from the combined futures
                                        //                                     // Extract the data
                                        //                                     List<Uint8List> images = snapshot.data![0];
                                        //                                     LocationOffers offers = snapshot.data![1];
                                        //                                     return CardSwiper(
                                        //                                         cardsCount: images.length,
                                        //
                                        //                                         cardBuilder: (context, index, percentThresholdX, percentThresholdY) {
                                        //                                         return ClipRRect(
                                        //                                           borderRadius: BorderRadius.circular(10.0),
                                        //                                           child: BackdropFilter(
                                        //                                             filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                                        //                                             // Adjust the blur amount with sigmaX and sigmaY
                                        //
                                        //                                             child: ConstrainedBox(
                                        //                                               constraints: BoxConstraints(maxHeight: double.infinity),
                                        //                                               child: GestureDetector(
                                        //                                                 onTap: () => {
                                        //                                                   Navigator.of(context).push(
                                        //                                                     CupertinoPageRoute(
                                        //                                                       builder: (context) => OfferPage(
                                        //                                                         locOffer: offers.locationOffer![index],
                                        //                                                         // heroTag: itemIndex,
                                        //                                                       ),
                                        //                                                     ),
                                        //                                                   )
                                        //                                                   // Navigator.push(
                                        //                                                   //   context,
                                        //                                                   //   PageRouteBuilder(
                                        //                                                   //     pageBuilder: (_, __, ___) => OfferPage(
                                        //                                                   //       locOffer: snapshotOfferDetails.data!.locationOffer![itemIndex],
                                        //                                                   //       // heroTag: itemIndex,
                                        //                                                   //     ),
                                        //                                                   //   ),
                                        //                                                   // )
                                        //                                                 },
                                        //                                                 child: Column(
                                        //                                                   mainAxisSize: MainAxisSize.max,
                                        //                                                   mainAxisAlignment: MainAxisAlignment.center,
                                        //                                                   // crossAxisAlignment: CrossAxisAlignment.center,
                                        //                                                   children: <Widget>[
                                        //                                                     Flexible(
                                        //                                                       flex: 8,
                                        //                                                       child: ClipRRect(
                                        //                                                           borderRadius: BorderRadius.circular(5.0),
                                        //                                                           child: Image.memory(
                                        //                                                             // state.bytes![i],
                                        //                                                             images[index],
                                        //                                                             // snapshot.data![0].,
                                        //                                                             fit: BoxFit.fill,
                                        //                                                             alignment: Alignment.center,
                                        //                                                             // errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                                        //                                                             //   // Return a widget to display in case of an error
                                        //                                                             //   return Container(
                                        //                                                             //     color: Colors.grey, // Choose a suitable background color
                                        //                                                             //     alignment: Alignment.center,
                                        //                                                             //     child: Text(
                                        //                                                             //       'Error loading image', // Custom error message
                                        //                                                             //       style: TextStyle(color: Colors.white), // Optional: style your text
                                        //                                                             //     ),
                                        //                                                             //   );
                                        //                                                             // },
                                        //                                                             gaplessPlayback: true,
                                        //                                                           )
                                        //                                                           // : Align(
                                        //                                                           //     alignment: Alignment.center,
                                        //                                                           //     child: Container(
                                        //                                                           //       width: double.infinity,
                                        //                                                           //       height: double.infinity,
                                        //                                                           //       color: Colors.grey.withOpacity(0.5),
                                        //                                                           //       child: Icon(
                                        //                                                           //         Icons.slow_motion_video_outlined,
                                        //                                                           //         size: 100,
                                        //                                                           //         color: Colors.white,
                                        //                                                           //       ),
                                        //                                                           //     ),
                                        //                                                           //   ),
                                        //                                                           // :Container(color: Colors.red,)
                                        //                                                           ),
                                        //                                                     ),
                                        //                                                     Expanded(
                                        //                                                       flex: 1,
                                        //                                                       child: Align(
                                        //                                                           alignment: Alignment.bottomLeft,
                                        //                                                           child: Text(
                                        //                                                             offers.locationOffer![index].shm2Offer![0].title!,
                                        //                                                             // "dsf",
                                        //                                                             maxLines: 1,
                                        //                                                             style: TextStyle(
                                        //                                                                 fontSize: size.width * 0.05, color: Colors.white, fontWeight: FontWeight.w900),
                                        //                                                             textAlign: TextAlign.left,
                                        //                                                           )),
                                        //                                                     ),
                                        //                                                     // Expanded(
                                        //                                                     //   flex: 1,
                                        //                                                     //   child: Visibility(
                                        //                                                     //     visible: currentLocationOfferIndex == itemIndex,
                                        //                                                     //     child: Align(
                                        //                                                     //         alignment: Alignment.bottomLeft,
                                        //                                                     //         child: Text(
                                        //                                                     //           snapshotOfferDetails.data!.locationOffer![itemIndex].shm2Offer![0].shortDesc!,
                                        //                                                     //           // "dsf",
                                        //                                                     //           style: TextStyle(fontSize: size.width * 0.045, color: Colors.white),
                                        //                                                     //           textAlign: TextAlign.left,
                                        //                                                     //         )),
                                        //                                                     //   ),
                                        //                                                     // ),
                                        //                                                     // Container(color: Colors.red,width: 200  ,height: 200,)
                                        //                                                   ],
                                        //                                                 ),
                                        //                                               ),
                                        //                                             ),
                                        //                                           ),
                                        //                                         );
                                        //                                       }
                                        //                                     );
                                        //                                     // Now use `image` and `offers` to build your widget
                                        //                                     // ...
                                        //
                                        //                                     // Return your widget here
                                        //                                   },
                                        //                                 )

                                        // int reversedIndex = NavbarState.locationoffersImages!.length - index - 1;

                                        FutureBuilder<LocationOffers>(
                                            future: NavbarState.locationoffers,
                                            builder: (context, snapshotOfferDetails) {
                                              VideoPlayerController? _videocontroller = null;
                                              if (snapshotOfferDetails.hasData && NavbarState.locationoffersImages.isNotEmpty) {
                                                //&& !snapshotOfferDetails.data!.locationOffer![itemIndex].shm2Offer![0].type!.contains("MOV")) {

                                                return CardSwiper(
                                                    cardsCount: snapshotOfferDetails.data!.locationOffer!.length,
                                                    numberOfCardsDisplayed: snapshotOfferDetails.data!.locationOffer!.length,
                                                    // cardsCount:  NavbarState.locationoffersImages.length,
                                                    cardBuilder: (context, index, percentThresholdX, percentThresholdY) {
                                                      return ClipRRect(
                                                        borderRadius: BorderRadius.circular(10.0),
                                                        child: BackdropFilter(
                                                          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                                                          // Adjust the blur amount with sigmaX and sigmaY

                                                          child: ConstrainedBox(
                                                            constraints: BoxConstraints(maxHeight: double.infinity),
                                                            child: GestureDetector(
                                                              onTap: () => {
                                                                Navigator.of(context).push(
                                                                  CupertinoPageRoute(
                                                                    builder: (context) => OfferPage(
                                                                      locOffer: snapshotOfferDetails.data!.locationOffer![index],
                                                                      imageData: !snapshotOfferDetails.data!.locationOffer![index].shm2Offer![0].type!
                                                                              .contains("MOV")
                                                                          ? NavbarState.locationoffersImages
                                                                              .singleWhere((element) =>
                                                                                  element.offer.idOffer ==
                                                                                  snapshotOfferDetails.data!.locationOffer![index].idOffer)
                                                                              .mediaContent
                                                                          : null,
                                                                      // heroTag: itemIndex,
                                                                    ),
                                                                  ),
                                                                )
                                                                // Navigator.push(
                                                                //   context,
                                                                //   PageRouteBuilder(
                                                                //     pageBuilder: (_, __, ___) => OfferPage(
                                                                //       locOffer: snapshotOfferDetails.data!.locationOffer![itemIndex],
                                                                //         // heroTag: itemIndex,
                                                                //     ),
                                                                //   ),
                                                                // )
                                                              },
                                                              child: Column(
                                                                mainAxisSize: MainAxisSize.max,
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                // crossAxisAlignment: CrossAxisAlignment.center,
                                                                children: <Widget>[
                                                                  Flexible(
                                                                    flex: 8,
                                                                    child: ClipRRect(
                                                                      borderRadius: BorderRadius.circular(5.0),
                                                                      child: !snapshotOfferDetails.data!.locationOffer![index].shm2Offer![0].type!
                                                                              .contains("MOV")
                                                                          // || !NavbarState.locationoffersImages.any((element) => (element.offer.idOffer==snapshotOfferDetails!.data!.locationOffer![index].idOffer && element.offer !=null))
                                                                          ? Hero(
                                                                              tag: snapshotOfferDetails.data!.locationOffer![index].shm2Offer![0].id
                                                                                  .toString(),
                                                                              child: Image.memory(
                                                                                // state.bytes![i],
                                                                                NavbarState.locationoffersImages
                                                                                    .firstWhere((element) =>
                                                                                            element.offer.idOffer ==
                                                                                            snapshotOfferDetails.data!.locationOffer![index]
                                                                                                .idOffer // Provide a default OfferImage or handle it accordingly
                                                                                        )
                                                                                    .mediaContent,
                                                                                fit: BoxFit.fill,
                                                                                alignment: Alignment.center,

                                                                                gaplessPlayback: true,
                                                                              ),
                                                                            )
                                                                          // : snapshotvideo.hasData? AspectRatio(
                                                                          //   aspectRatio:
                                                                          //       // _controller != null ? _controller!.value.aspectRatio :
                                                                          //       16 / 9,
                                                                          //   child:
                                                                          //   // VideoPlayer(snapshotvideo.data)
                                                                          //   Container()
                                                                          // ):
                                                                          // :SpinKitFadingCircle(
                                                                          //       color: Colors.white,
                                                                          //       size: 50.0,
                                                                          //     )
                                                                          // : Co
                                                                          : Align(
                                                                              alignment: Alignment.center,
                                                                              child: Container(
                                                                                width: double.infinity,
                                                                                height: double.infinity,
                                                                                color: Colors.grey.withOpacity(0.5),
                                                                                child: Icon(
                                                                                  Icons.slow_motion_video_outlined,
                                                                                  size: 100,
                                                                                  color: Colors.white,
                                                                                ),
                                                                              ),
                                                                            ),

                                                                      // :Container(height: double.infinity,width: double.infinity, color: Colors.grey.withOpacity(0.3), child: Icon(Icons.slow_motion_video_outlined, size: 80,),
                                                                      // )
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    flex: 1,
                                                                    child: Align(
                                                                        alignment: Alignment.bottomLeft,
                                                                        child: Text(
                                                                          snapshotOfferDetails.data!.locationOffer![index].shm2Offer![0].title!,
                                                                          // "dsf",
                                                                          maxLines: 1,
                                                                          style: TextStyle(
                                                                              fontSize: size.width * 0.05,
                                                                              color: Colors.white,
                                                                              fontWeight: FontWeight.w900),
                                                                          textAlign: TextAlign.left,
                                                                        )),
                                                                  ),
                                                                  // Expanded(
                                                                  //   flex: 1,
                                                                  //   child: Visibility(
                                                                  //     visible: currentLocationOfferIndex == itemIndex,
                                                                  //     child: Align(
                                                                  //         alignment: Alignment.bottomLeft,
                                                                  //         child: Text(
                                                                  //           snapshotOfferDetails.data!.locationOffer![itemIndex].shm2Offer![0].shortDesc!,
                                                                  //           // "dsf",
                                                                  //           style: TextStyle(fontSize: size.width * 0.045, color: Colors.white),
                                                                  //           textAlign: TextAlign.left,
                                                                  //         )),
                                                                  //   ),
                                                                  // ),
                                                                  // Container(color: Colors.red,width: 200  ,height: 200,)
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                      // :Container(color: Colors.red,);
                                                    });
                                              }
                                              // continue;
                                              return SpinKitFadingCircle(
                                                color: Colors.white,
                                                size: 50.0,
                                              );
                                            }))
                              ],
                            ),
                          ),
                        )
                      else
                        Container(),
                    ],
                  ),
                  // floatingActionButton: SpeedDial(
                  //   // animatedIcon: AnimatedIcons.menu_close,
                  //   // animatedIconTheme: IconThemeData(size: 22.0),
                  //   // / This is ignored if animatedIcon is non null
                  //   // child: Text("open"),
                  //   // activeChild: Text("close"),
                  //   icon: Icons.add,
                  //   activeIcon: Icons.close,
                  //   spacing: 3,
                  //   backgroundColor: Colors.redAccent,
                  //   // overlayOpacity: 0.9,
                  //
                  //   // mini: mini,
                  // openCloseDial: isDialOpen,
                  //   childPadding: const EdgeInsets.all(5),
                  //   spaceBetweenChildren: 4,
                  //    // childMargin: EdgeInsets.all(25) ,
                  //
                  //   dialRoot: (ctx, open, toggleChildren) {
                  //     return ElevatedButton(
                  //       onPressed: toggleChildren,
                  //
                  //       style: ElevatedButton.styleFrom(
                  //         backgroundColor: Colors.grey.withOpacity(0.2),
                  //         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
                  //         // alignment: Alignment(100, 500)
                  //
                  //       ),
                  //       child: Text(
                  //         "Category",
                  //         style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.white),
                  //       ),
                  //     );
                  //   },
                  //
                  //   // buttonSize: Size(40, 20),
                  //   // it's the SpeedDial size which defaults to 56 itself
                  //   // iconTheme: IconThemeData(size: 22),
                  //   label: Text("Open"),
                  //   // The label of the main button.
                  //   /// The active label of the main button, Defaults to label if not specified.
                  //   activeLabel: Text("Close"),
                  //
                  //   /// Transition Builder between label and activeLabel, defaults to FadeTransition.
                  //   // labelTransitionBuilder: (widget, animation) => ScaleTransition(scale: animation,child: widget),
                  //   /// The below button size defaults to 56 itself, its the SpeedDial childrens size
                  //   // childrenButtonSize: childrenButtonSize,
                  //   // visible: visible,
                  //   direction: SpeedDialDirection.up,
                  //   // switchLabelPosition: switchLabelPosition,
                  //
                  //   /// If true user is forced to close dial manually
                  //   // closeManually: closeManually,
                  //
                  //   /// If false, backgroundOverlay will not be rendered.
                  //   // renderOverlay: renderOverlay,
                  //   overlayColor: Colors.grey.withOpacity(0.01),
                  //   // overlayOpacity: 0.5,
                  //   onOpen: () => debugPrint('OPENING DIAL'),
                  //   onClose: () => debugPrint('DIAL CLOSED'),
                  //   // useRotationAnimation: useRAnimation,
                  //   tooltip: 'Open Speed Dial',
                  //   heroTag: 'speed-dial-hero-tag',
                  //   // foregroundColor: Colors.transparent,
                  //   // // backgroundColor: Colors.white,
                  //   // activeForegroundColor: Colors.transparent,
                  //   // activeBackgroundColor: Colors.transparent,
                  //   elevation: 8.0,
                  //   animationCurve: Curves.elasticInOut,
                  //   isOpenOnStart: false,
                  //   shape: StadiumBorder(),
                  //   // childMargin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  //   children: [
                  //     SpeedDialChild(
                  //       child: const Icon(Icons.accessibility),
                  //       backgroundColor: Colors.blue,
                  //       foregroundColor: Colors.white,
                  //       label: 'First',
                  //       labelBackgroundColor: Colors.grey.withOpacity(0.5),
                  //       // onTap: () => setState(() => rmicons = !rmicons),
                  //       onLongPress: () => debugPrint('FIRST CHILD LONG PRESS'),
                  //     ),
                  //     SpeedDialChild(
                  //       child: Icon(Icons.brush),
                  //       backgroundColor: Colors.blue,
                  //       foregroundColor: Colors.white,
                  //       label: 'Second',
                  //       labelBackgroundColor: Colors.grey.withOpacity(0.5),
                  //       onTap: () => debugPrint('SECOND CHILD'),
                  //     ),
                  //     SpeedDialChild(
                  //       child: Icon(Icons.margin),
                  //       backgroundColor: Colors.blue,
                  //       foregroundColor: Colors.white,
                  //       label: 'Show Snackbar',
                  //       labelBackgroundColor: Colors.grey.withOpacity(0.5),
                  //       visible: true,
                  //       onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(("Third Child Pressed")))),
                  //       onLongPress: () => debugPrint('THIRD CHILD LONG PRESS'),
                  //     ),
                  //   ],
                  // ),
                  // floatingActionButton: ValueListenableBuilder(
                  //     valueListenable: showLocationPage,
                  //     builder: (BuildContext context, bool counterValue, Widget? child) {
                  //       return Column(
                  //         mainAxisAlignment: MainAxisAlignment.end,
                  //         children: <Widget>[
                  //           !counterValue && state.appbarlocation?.nameApp == null
                  //               ? Padding(
                  //                   padding: EdgeInsets.only(bottom: fabQRHeight ?? 50.0), // adjust the value as needed
                  //                   child: SizedBox(
                  //                     // height: 90, // adjust as needed
                  //                     // width: 60, // adjust as needed
                  //                     child: FloatingActionButton(
                  //                       key: fabKey,
                  //
                  //                       onPressed: () {
                  //                         // FAB onPressed logic
                  //                         Navigator.of(context).push(MaterialPageRoute(
                  //                           builder: (context) => QRViewExample(),
                  //                         ));
                  //                       },
                  //                       child: Icon(
                  //                         Icons.qr_code,
                  //                         color: Colors.white, // setting icon color to white
                  //                         size: 30,
                  //                       ),
                  //                       backgroundColor: Colors.white.withOpacity(0.3),
                  //                       // setting button background to transparent with opacity 0.3
                  //                       elevation: 1.0, // elevation
                  //
                  //                     ),
                  //                   ),
                  //                 )
                  //               : Container(),
                  //         ],
                  //       );
                  //     }),
                  //
                  // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
                  backLayer: Stack(
                    children: [
                      ClipPath(
                        clipper: BodyClipper(index: currentIndex, context: context, navbarkey: _keyheight, fabkey: fabKey),
                        clipBehavior: Clip.hardEdge,
                        child: Stack(
                          children: [
                            PageView.builder(
                              controller: _pageController,
                              // itemCount: _pages.length,
                              physics: NeverScrollableScrollPhysics(),
                              // physics: AlwaysScrollableScrollPhysics(),
                              itemBuilder: (context, index) => _pages[index],
                            ),
                            if (currentIndex == 0 || currentIndex == 1)
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 0, size.height * 0.1),
                                child: Align(
                                  // alignment: Alignment.bottomRight,
                                  alignment: Alignment.bottomCenter,
                                  child: Padding(
                                    padding: const EdgeInsets.all(28.0),
                                    // child: SpeedDial(
                                    //   // animatedIcon: AnimatedIcons.menu_close,
                                    //   // animatedIconTheme: IconThemeData(size: 22.0),
                                    //   // / This is ignored if animatedIcon is non null
                                    //   // child: Text("open"),
                                    //   // activeChild: Text("close"),
                                    //   icon: Icons.add,
                                    //   activeIcon: Icons.close,
                                    //   spacing: 3,
                                    //
                                    //   // backgroundColor: Colors.redAccent,
                                    //   // overlayOpacity: 0.9,
                                    //
                                    //   // mini: mini,
                                    //   // openCloseDial: false,
                                    //   childPadding: const EdgeInsets.all(5),
                                    //   spaceBetweenChildren: 4,
                                    //   // childMargin: EdgeInsets.all(25) ,
                                    //
                                    //   dialRoot: (ctx, open, toggleChildren) {
                                    //     return ElevatedButton(
                                    //       onPressed: toggleChildren,
                                    //
                                    //       style: ElevatedButton.styleFrom(
                                    //         backgroundColor: Colors.blue, //.withOpacity(0.693),
                                    //         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
                                    //         // alignment: Alignment(100, 500)
                                    //       ),
                                    //       child: Icon(
                                    //         open ? Icons.close_fullscreen : Icons.open_with,
                                    //         color: Colors.white,
                                    //       ),
                                    //       // child: Text(
                                    //       //   "Category",
                                    //       //   style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.white),
                                    //       // ),
                                    //     );
                                    //   },
                                    //   iconTheme: IconThemeData(
                                    //     size: 50,
                                    //   ),
                                    //   buttonSize: Size(40, 40),
                                    //   // it's the SpeedDial size which defaults to 56 itself
                                    //   // iconTheme: IconThemeData(size: 22),
                                    //   label: Text("Open"),
                                    //   // The label of the main button.
                                    //   /// The active label of the main button, Defaults to label if not specified.
                                    //   activeLabel: Text("Close"),
                                    //
                                    //   /// Transition Builder between label and activeLabel, defaults to FadeTransition.
                                    //   // labelTransitionBuilder: (widget, animation) => ScaleTransition(scale: animation,child: widget),
                                    //   /// The below button size defaults to 56 itself, its the SpeedDial childrens size
                                    //   // childrenButtonSize: childrenButtonSize,
                                    //   // visible: visible,
                                    //   direction: SpeedDialDirection.up,
                                    //   // switchLabelPosition: switchLabelPosition,
                                    //
                                    //   /// If true user is forced to close dial manually
                                    //   // closeManually: closeManually,
                                    //
                                    //   /// If false, backgroundOverlay will not be rendered.
                                    //   // renderOverlay: renderOverlay,
                                    //   overlayOpacity: 0.35,
                                    //   overlayColor: Colors.black,
                                    //   // overlayOpacity: 0.5,
                                    //   // onOpen: () => debugPrint('OPENING DIAL'),
                                    //   // onClose: () => debugPrint('DIAL CLOSED'),
                                    //   // useRotationAnimation: useRAnimation,
                                    //   tooltip: 'Open Speed Dial',
                                    //   heroTag: 'speed-dial-hero-tag',
                                    //   foregroundColor: Colors.blue,
                                    //   backgroundColor: Colors.green,
                                    //   activeForegroundColor: Colors.redAccent,
                                    //   activeBackgroundColor: Colors.pink,
                                    //   elevation: 8.0,
                                    //   animationCurve: Curves.elasticInOut,
                                    //   isOpenOnStart: false,
                                    //   shape: StadiumBorder(),
                                    //   // childMargin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                    //   children: [
                                    //     SpeedDialChild(
                                    //       child: Icon(Icons.newspaper),
                                    //       backgroundColor: Colors.blue,
                                    //       foregroundColor: Colors.white,
                                    //       label: 'Presse',
                                    //       labelStyle: Theme.of(context).textTheme.titleMedium,
                                    //       labelBackgroundColor: Colors.black.withOpacity(0.5),
                                    //       shape: StadiumBorder(),
                                    //       onTap: () => BlocProvider.of<NavbarBloc>(context)
                                    //           .add(SelectCategory(currentLocation: state.appbarlocation, catStatus: CategoryStatus.presse)),
                                    //       onLongPress: () => debugPrint('FIRST CHILD LONG PRESS'),
                                    //     ),
                                    //     SpeedDialChild(
                                    //       child: Icon(Icons.book_online_outlined),
                                    //       backgroundColor: Colors.blue,
                                    //       foregroundColor: Colors.white,
                                    //       label: 'E-Books',
                                    //       labelStyle: Theme.of(context).textTheme.titleMedium,
                                    //       labelBackgroundColor: Colors.black.withOpacity(0.5),
                                    //       shape: StadiumBorder(),
                                    //       onTap: () => {
                                    //         BlocProvider.of<NavbarBloc>(context)
                                    //             .add(SelectCategory(currentLocation: state.appbarlocation, catStatus: CategoryStatus.ebooks))
                                    //       },
                                    //     ),
                                    //     SpeedDialChild(
                                    //       child: Icon(Icons.podcasts),
                                    //       backgroundColor: Colors.blue,
                                    //       foregroundColor: Colors.white,
                                    //       label: 'Hörbücher',
                                    //       labelStyle: Theme.of(context).textTheme.titleMedium,
                                    //       labelBackgroundColor: Colors.black.withOpacity(0.5),
                                    //       shape: StadiumBorder(),
                                    //       visible: true,
                                    //       onTap: () => {
                                    //         BlocProvider.of<NavbarBloc>(context)
                                    //             .add(SelectCategory(currentLocation: state.appbarlocation, catStatus: CategoryStatus.hoerbuecher))
                                    //       },
                                    //       onLongPress: () => debugPrint('THIRD CHILD LONG PRESS'),
                                    //     ),
                                    //   ],
                                    // ),
                                    child: ValueListenableBuilder<CategoryStatus>(
                                      valueListenable: NavbarState.categoryStatus,
                                      builder: (context, value, child) {
                                        return ClipRRect(
                                          borderRadius: BorderRadius.all(Radius.circular(25.0)), // Match the container's border radius

                                          child: BackdropFilter(
                                            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0), // Adjust the blur amount

                                            child: Container(
                                              // color: Colors.redAccent,
                                              height: 45,
                                              // width: 280,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                                                  color: Colors.grey.withOpacity(0.1),
                                                  // boxShadow: [
                                                  //   BoxShadow(
                                                  //     color: Colors.grey.withOpacity(0.1),
                                                  //     spreadRadius: 1,
                                                  //     blurRadius: 0,
                                                  //     // offset: Offset(0, 3), // changes position of shadow
                                                  //   ),
                                                  // ],
                                                  backgroundBlendMode: BlendMode.luminosity,
                                                  border: Border.all(color: Colors.grey, width: 0.5)),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: InkWell(
                                                      splashColor: Colors.transparent,
                                                      highlightColor: Colors.transparent,
                                                      onTap: () => {
                                                        BlocProvider.of<NavbarBloc>(context).add(
                                                            SelectCategory(currentLocation: state.appbarlocation, catStatus: CategoryStatus.presse))
                                                      },
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(100),
                                                          color: value == CategoryStatus.presse ? Colors.blue : Colors.transparent,),
                                                        // color: value == CategoryStatus.presse ? Colors.blue : Colors.transparent,
                                                        child: Padding(
                                                          padding: EdgeInsets.all(8.0),
                                                          child: Align(
                                                            alignment: Alignment.center,
                                                            child: Text(
                                                              "Presse",
                                                              style: Theme.of(context)
                                                                  .textTheme
                                                                  .titleSmall!
                                                                  .copyWith(color: Colors.white, fontWeight: FontWeight.w700),
                                                              textAlign: TextAlign.center,
                                                              maxLines: 1,
                                                              overflow: TextOverflow.fade,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),

                                                  Expanded(
                                                    child: InkWell(
                                                      splashColor: Colors.transparent,
                                                      highlightColor: Colors.transparent,
                                                      onTap: () => {
                                                        BlocProvider.of<NavbarBloc>(context).add(
                                                            SelectCategory(currentLocation: state.appbarlocation, catStatus: CategoryStatus.ebooks))
                                                      },
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(100),
                                                            color: value == CategoryStatus.ebooks ? Colors.blue : Colors.transparent,),
                                                        // color: value == CategoryStatus.ebooks ? Colors.blue : Colors.transparent,
                                                        child: Padding(
                                                          padding: EdgeInsets.all(8.0),
                                                          child: Align(
                                                            alignment: Alignment.center,
                                                            child: Text(
                                                              "Ebooks",
                                                              style: Theme.of(context)
                                                                  .textTheme
                                                                  .titleSmall!
                                                                  .copyWith(color: Colors.white, fontWeight: FontWeight.w700),
                                                              textAlign: TextAlign.center,
                                                              maxLines: 1,
                                                              overflow: TextOverflow.fade,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),

                                                  Expanded(
                                                    child: InkWell(
                                                      splashColor: Colors.transparent,
                                                      highlightColor: Colors.transparent,
                                                      onTap: () => {
                                                        BlocProvider.of<NavbarBloc>(context).add(SelectCategory(
                                                            currentLocation: state.appbarlocation, catStatus: CategoryStatus.hoerbuecher))
                                                      },
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(100),
                                                          color: value == CategoryStatus.hoerbuecher ? Colors.blue : Colors.transparent,),
                                                        child: Padding(
                                                          padding: EdgeInsets.all(8.0),
                                                          child: Align(
                                                            alignment: Alignment.center,
                                                            child: Text(
                                                              "Hörbücher",
                                                              style: Theme.of(context)
                                                                  .textTheme
                                                                  .titleSmall!
                                                                  .copyWith(color: Colors.white, fontWeight: FontWeight.w700),
                                                              textAlign: TextAlign.center,
                                                              maxLines: 1,
                                                              overflow: TextOverflow.fade,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
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
                                ),
                              )
                            else
                              Container()
                          ],
                        ),
                      ),
                      // currentIndex != 4
                      tablet
                          ? Container()
                          : Container(
                              alignment: Alignment.bottomCenter,
                              // key: _keyheight,
                              child: ClipPath(
                                  key: _keyheight,
                                  // clipper: NavbarQRClipper(currentIndex,_keyheight,fabKey),
                                  clipper: NavbarClipper(currentIndex),
                                  child: CustomPaint(
                                    // painter: NavbarQRPainter(
                                    //   currentIndex,
                                    //   fabKey,
                                    //   context,
                                    //   _keyheight,
                                    // ),
                                    painter: NavbarPainter(currentIndex),
                                    child: CustomNavbar(
                                      onClicked: onClicked,
                                      selectedIndex: currentIndex,
                                    ),
                                  ))),
                      // DirectSelectContainer(child: Container(color: Colors.grey,),),
                      // Container(color: Colors.grey,height: 100,width: 100,)
                    ],
                  ),
                ),
              ),
            )),
            state is NavbarError
                ? AlertDialog(
                    title: Text(
                      ('error').tr(),
                      // 'Navbarerror',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.grey),
                    ),
                    content: Text(state.error.toString(), style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.grey)),
                    actions: <Widget>[
                      // TextButton(
                      //   onPressed: () => Navigator.pop(context, 'Cancel'),
                      //   child: const Text('Cancel'),
                      // ),
                      TextButton(
                        onPressed: () async {
                          BlocProvider.of<AuthBloc>(context).add(Initialize());
                          var result = await Navigator.of(context).push(
                            CupertinoPageRoute(
                              builder: (context) => const StartPage(
                                title: "notitle",
                              ),
                            ),
                          );
                        },
                        child: Text('OK', style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.blue)),
                      ),
                    ],
                  )
                : state is AskForLocationPermission
                    ? Center(
                        child: CupertinoActionSheet(
                            title: Text(
                              ('permissionLocationServices').tr(),
                              style: TextStyle(fontSize: 20, color: Colors.black),
                            ),
                            message: Text(
                              ('selectOne').tr(),
                              style: TextStyle(fontSize: 16, color: Colors.black),
                            ),
                            actions: <Widget>[
                              CupertinoActionSheetAction(
                                child: Text(
                                  // state.locations_GoToLocationSelection![index].nameApp!,
                                  ('goToLocationSettings').tr(),
                                  // "$index",
                                  style: TextStyle(fontSize: 20, color: Colors.black),
                                ),
                                onPressed: () {
                                  BlocProvider.of<NavbarBloc>(context).add(OpenSystemSettings());

                                  // print(state.locations_GoToLocationSelection![index].nameApp!);
                                  // Navigator.of(context, rootNavigator: true).pop();
                                  // currentIndex = 0;
                                  // setState(() {
                                  //   BlocProvider.of<NavbarBloc>(context).add(BackFromLocationPermission());
                                  // });
                                },
                              ),
                              CupertinoActionSheetAction(
                                child: Text(
                                  // state.locations_GoToLocationSelection![index].nameApp!,
                                  ('notNow').tr(),
                                  // "$index",
                                  style: TextStyle(fontSize: 20, color: Colors.black),
                                ),
                                onPressed: () {
                                  // print(state.locations_GoToLocationSelection![index].nameApp!);
                                  // Navigator.of(context, rootNavigator: true).pop();
                                  // currentIndex = 0;
                                  // setState(() {
                                  BlocProvider.of<NavbarBloc>(context).add(BackFromLocationPermission());
                                  // });
                                },
                              ),
                              // ...List.generate(
                              //   2,
                              //   // state.locations_GoToLocationSelection!.length,
                              //   (index) => GestureDetector(
                              //     // onTap: () => setState(() => _selectedIndex = index),
                              //     child: CupertinoActionSheetAction(
                              //       child: Text(
                              //         // state.locations_GoToLocationSelection![index].nameApp!,
                              //         "asd",
                              //         // "$index",
                              //         style: TextStyle(fontSize: 20, color: Colors.black),
                              //       ),
                              //       onPressed: () {
                              //         // print(state.locations_GoToLocationSelection![index].nameApp!);
                              //         // Navigator.of(context, rootNavigator: true).pop();
                              //         // currentIndex = 0;
                              //         setState(() {
                              //           // BlocProvider.of<NavbarBloc>(context)
                              //           //     .add(LocationSelected(location: state.locations_GoToLocationSelection![index]));
                              //         });
                              //       },
                              //     ),
                              //   ),
                              // ),
                            ]),
                      )
                    : state is GoToLocationSelection
                        ? Center(
                            child: CupertinoActionSheet(
                              title: Text(
                                ('nearLocations').tr(),
                                style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.black),
                              ),
                              message: Text(
                                ('selectOne').tr(),
                                style: Theme.of(context).textTheme.titleSmall!.copyWith(color: Colors.black),
                              ),
                              actions: <Widget>[
                                ...List.generate(
                                  state.locations_GoToLocationSelection!.length,
                                  (index) => GestureDetector(
                                    // onTap: () => setState(() => _selectedIndex = index),
                                    child: CupertinoActionSheetAction(
                                      child: Text(
                                        state.locations_GoToLocationSelection![index].nameApp!,
                                        // "$index",
                                        style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.black),
                                      ),
                                      onPressed: () {
                                        // To show the "Location page(front layer of backdropscaffold)"
                                        if (showLocationPage.value == false) backdropState!.currentState!.fling();
                                        setState(() {
                                          BlocProvider.of<NavbarBloc>(context).add(LocationSelected(
                                              selectedLocation: state.locations_GoToLocationSelection![index],
                                              currentLocation: state.appbarlocation));
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ],
                              cancelButton: CupertinoActionSheetAction(
                                child: Text('Cancel', style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.redAccent)),
                                // isDefaultAction: true,
                                onPressed: () {
                                  if (showLocationPage.value == false) backdropState!.currentState!.fling();
                                  setState(() {
                                    BlocProvider.of<NavbarBloc>(context).add(
                                        LocationSelected(selectedLocation: LocationData(idLocation: "0"), currentLocation: state.appbarlocation));
                                  });
                                  // Navigator.pop(context); // You can also perform any other action here before dismissing
                                },
                              ),
                            ),
                          )
                        // : state is LoadingNavbar?LoadingAnimation()
                        : state is GoToLanguageSelection
                            ? Center(
                                child: CupertinoActionSheet(
                                    title: Text(
                                      ('selectLanguage').tr(),
                                      style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: Colors.black),
                                    ),
                                    message: Text(
                                      ('selectOne').tr(),
                                      style: Theme.of(context).textTheme.titleSmall!.copyWith(color: Colors.black),
                                    ),
                                    actions: <Widget>[
                                      ...List.generate(
                                        state.languageOptions!.length,
                                        (index) => GestureDetector(
                                          // onTap: () => setState(() => _selectedIndex = index),
                                          child: CupertinoActionSheetAction(
                                            child: Text(
                                              state.languageOptions![index].languageCode!,
                                              // "$index",
                                              style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: Colors.black),
                                            ),
                                            onPressed: () async {
                                              // To show the "Location page(front layer of backdropscaffold)"
                                              // if (showLocationPage.value == false) backdropState!.currentState!.fling();
                                              // Future.delayed(Duration(milliseconds: 500), () {});

                                              // setState(() {
                                              BlocProvider.of<NavbarBloc>(context).add(
                                                  LanguageSelected(language: state.languageOptions![index], currentLocation: state.appbarlocation));
                                              await Future.delayed(Duration(milliseconds: 700), () {});
                                              await EasyLocalization.of(context)!.setLocale(Locale(state.languageOptions![index].languageCode!));
                                              // });
                                            },
                                          ),
                                        ),
                                      ),
                                    ]),
                              )
                            : Container(),
          ],
        );
      }),
    );
  }
}