import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// import 'package:backdrop/backdrop.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sharemagazines_flutter/src/blocs/navbar/navbar_bloc.dart';
import 'package:sharemagazines_flutter/src/models/locationOffers_model.dart';
import 'package:sharemagazines_flutter/src/presentation/pages/navbarpages/homepage/homepage.dart';
import 'package:sharemagazines_flutter/src/presentation/pages/navbarpages/menupage.dart';
import 'package:sharemagazines_flutter/src/presentation/pages/navbarpages/homepage/searchpage.dart';

import 'package:sharemagazines_flutter/src/presentation/pages/navbarpages/accountpage/accountpage.dart';
import 'package:sharemagazines_flutter/src/presentation/pages/startpage.dart';
import 'package:sharemagazines_flutter/src/presentation/widgets/loading.dart';
import 'package:sharemagazines_flutter/src/presentation/widgets/navbar/body_clipper.dart';
import 'package:sharemagazines_flutter/src/presentation/widgets/navbar/custom_navbar.dart';
import 'package:sharemagazines_flutter/src/presentation/widgets/sliding_AppBar.dart';
import 'package:sharemagazines_flutter/src/presentation/widgets/marquee.dart';
import 'package:sharemagazines_flutter/src/presentation/widgets/navbar/navbar_painter_clipper.dart';
import 'package:video_player/video_player.dart';

import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/splash/splash_bloc.dart';
import '../../models/locationGetHeader_model.dart';
import '../../resources/location_repository.dart';
import '../widgets/backdrop/backdrop.dart';

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
  bool isLoadingOnTop = false;
  final fabKey = GlobalKey();
  bool showQR = false;

  late List<Widget> _pages = [
    HomePage(),
    MenuPage(),
    if(showQR)Container(),
    Maps(),
    AccountPage(pageController: _pageController, onClick: onClicked),
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
    print("mainpage onclicked $index");
    // if (showSearchPage == false) {
    // if (index != 2) // Makes the QR code area non-interactive
    // {
    setState(() {
      if (index != 2 && showQR) {
        // if (index > 2) {
        //   currentIndex = index - 1;
        // } else {
        currentIndex = index;
        // }
        // currentIndex = index;
        _pageController.animateToPage(currentIndex, duration: Duration(milliseconds: 400), curve: Curves.ease);
      }else{
        currentIndex = index;
        // }
        // currentIndex = index;
        _pageController.animateToPage(currentIndex, duration: Duration(milliseconds: 400), curve: Curves.ease);

      }
    });
    // }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    Size size = MediaQuery.of(context).size;
    print("localeee");
    print(EasyLocalization.of(context)!.supportedLocales);
    // double appBarHeight = ((currentIndex == 0 || currentIndex == 1) && !showSearchPage) ? size.height * 0.10 : 0;
    double? fabQRHeight = ((_keyheight.currentContext?.findRenderObject() as RenderBox?)?.size.height ?? 0) * 0.4;

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
          // BlocProvider.of<AuthBloc>(context).emit(AuthError(state.error));
          // return StartPage(
          //   title: "notitle",
          // );
          return AlertDialog(
            title: Text(
              ('error').tr(),
              style: TextStyle(fontSize: 16.0, color: Colors.grey, fontWeight: FontWeight.w500),
            ),
            content: Text(state.error.toString(), style: TextStyle(fontSize: 16.0, color: Colors.grey, fontWeight: FontWeight.w300)),
            actions: <Widget>[
              // TextButton(
              //   onPressed: () => Navigator.pop(context, 'Cancel'),
              //   child: const Text('Cancel'),
              // ),
              TextButton(
                onPressed: () => BlocProvider.of<AuthBloc>(context).add(
                  OpenLoginPage(),
                  // Initialize()
                ),
                child: Text('OK'),
              ),
            ],
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
              child: Hero(tag: 'bg', child: Image.asset("assets/images/background/Background.png", fit: BoxFit.cover)),
            ),
            // Visibility( visible: currentIndex == 0 || currentIndex == 1 ? true : false, child: SharedWidget()),
            //

            // Column(
            //   children: [
            //     Container(width: MediaQuery.of(context).size.width * 0.40, height: MediaQuery.of(context).size.width * 0.3, color: Colors.grey),
            //     Container(width: MediaQuery.of(context).size.width * 0.40, height: MediaQuery.of(context).size.width * 0.3, color: Colors.black),
            //   ],
            // ),
            Center(
                child: AnimatedOpacity(
              opacity: !isLoadingOnTop ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: IgnorePointer(
                ignoring: isLoadingOnTop,
                child: BackdropScaffold(
                  // extendBodyBehindAppBar: currentIndex == 0 || currentIndex == 1 || currentIndex == 2 ? true : false,
                  extendBodyBehindAppBar: true,
                  resizeToAvoidBottomInset: false,
                  // extendBody: true,
                  // appBar: currentIndex == 0 || currentIndex == 1
                  //     ? PreferredSize(
                  //         preferredSize: const Size(0, 56),
                  appBar: SlidingAppBar(
                    controller: _controller,
                    visible: currentIndex == 0 || currentIndex == 1 ? true : false,
                    child: PreferredSize(
                      preferredSize: ((currentIndex == 0 || currentIndex == 1) && !showSearchPage)
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
                                // mainAxisAlignment: MainAxisAlignment.center, // Try .end or .center
                                // crossAxisAlignment: CrossAxisAlignment.center, // Try .end or .center

                                children: [
                                  Expanded(
                                    child: Container(
                                      margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                      child: ExpandableNotifier(
                                        child: ScrollOnExpand(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              // GestureDetector(onTap: ,),
                                              // GestureDetector(
                                              //     child: Column(children: <Widget>[

                                              // child: Icon(
                                              //   Icons.circle,
                                              //   color: Colors.white,
                                              //   size: 80,
                                              // ),

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
                                                                      padding: EdgeInsets.all(8.0),
                                                                      child: Container(
                                                                        height: size.width *0.25,
                                                                        // width: size.height * 0.095,
                                                                        width: size.width *0.25,
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
                                                                NavbarState.appbarlocation!.nameApp ?? ("notAtLocation").tr(),
                                                                style: TextStyle(
                                                                  // fontSize: size.aspectRatio * 65,
                                                                  fontSize: 30,
                                                                  color: Colors.white,
                                                                  // fontWeight: FontWeight.bold
                                                                ),
                                                                textAlign: TextAlign.center,
                                                              ),
                                                            ),
                                                            Row(
                                                              // mainAxisSize: MainAxisSize.min,
                                                              children: [
                                                                Flexible(
                                                                  child: MarqueeWidget(
                                                                    child: Text(
                                                                      ("locationInformation").tr(),
                                                                      // overflow: TextOverflow.fade,
                                                                      // softWrap: true,
                                                                      style: TextStyle(
                                                                          // fontSize: size.aspectRatio * 25,
                                                                          fontSize: 14,
                                                                          color: Colors.white,
                                                                          fontWeight: FontWeight.w200),
                                                                      // textAlign: TextAlign.center,
// textAlign: TextAlign.right,
                                                                    ),
                                                                  ),
                                                                ),
                                                                ValueListenableBuilder(
                                                                    valueListenable: showLocationPage,
                                                                    builder: (BuildContext context, bool counterValue, Widget? child) {
                                                                      return InkWell(
                                                                        onTap: () => {
                                                                          // if (!counterValue)
                                                                          Backdrop.of(context).fling()
                                                                        },
                                                                        // child: BackdropToggleButton(
                                                                        //   // icon: AnimatedIcons.menu_arrow,
                                                                        //   // icon:AnimateIcons(),
                                                                        //   color: Colors.white,
                                                                        // ),
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
                                              // Container(
                                              //   color: Colors.transparent,
                                              //   child: ValueListenableBuilder(
                                              //       valueListenable: showLocationPage,
                                              //       builder: (BuildContext context, bool counterValue, Widget? child) {
                                              //         return !counterValue
                                              //             ? GestureDetector(
                                              //                 onTap: () {
                                              //                   // FAB onPressed logic
                                              //                   Navigator.of(context).push(MaterialPageRoute(
                                              //                     builder: (context) => QRViewExample(),
                                              //                   ));
                                              //                 },
                                              //                 // backgroundColor: Colors.grey.withOpacity(0.2),
                                              //                 // child: Icon(Icons.qr_code),
                                              //
                                              //                 child: Padding(
                                              //                   padding: EdgeInsets.only(left: 10),
                                              //                   child: Icon(
                                              //                     // Backdrop.of(context).isBackLayerConcealed == false ? Icons.search_sharp : Icons.clear,
                                              //                     // _counter1 == false ? Icons.search_sharp : Icons.clear,
                                              //                     Icons.qr_code,
                                              //                     // Icomoon.fc_logo,
                                              //                     color: Colors.white,
                                              //                     size: 40,
                                              //                   ),
                                              //                 ),
                                              //               )
                                              //             : Container();
                                              //       }),
                                              // ),

                                              Container(
                                                color: Colors.transparent,
                                                child: ValueListenableBuilder(
                                                    valueListenable: showLocationPage,
                                                    builder: (BuildContext context, bool counterValue, Widget? child) {
                                                      return GestureDetector(
                                                        onTap: () => {
                                                          if (!counterValue)
                                                            {
                                                              // if (mounted) {setState(() => showSearchPage = true)},
                                                              // setState(() {
                                                              //   showSearchPage = true;
                                                              // }),
                                                              print("before searchpage state $state"),
                                                              Navigator.of(context).push(
                                                                CupertinoPageRoute(
                                                                  fullscreenDialog: true,
                                                                  builder: (context) => SearchPage(),
                                                                ),
                                                              )
                                                              // Navigator.push(
                                                              //   context,
                                                              //   PageRouteBuilder(
                                                              //       pageBuilder: (_, __, ___) => SearchPage(),
                                                              //       // transitionDuration: Duration(milliseconds: 500),
                                                              //       transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                                              //         const begin = Offset(0, 1.0);
                                                              //         const end = Offset.zero;
                                                              //         const curve = Curves.ease;
                                                              //         final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                                                              //         final offsetAnimation = animation.drive(tween);
                                                              //         return SlideTransition(position: animation.drive(tween), child: child);
                                                              //       }),
                                                              // ).then((_) {
                                                              //   // print("after searchpage state $state");
                                                              //   // setState(() {
                                                              //   //   showSearchPage = false;
                                                              //   // });
                                                              // })
                                                            }
                                                          else
                                                            Backdrop.of(context).fling()
                                                        },
                                                        child: Padding(
                                                          padding: EdgeInsets.only(left: 10),
                                                          child: Hero(
                                                            tag: "search button",
                                                            // child: Scaffold_Close_Open_button(
                                                            //   context: context,
                                                            // ),
                                                            child: Icon(
                                                              // Backdrop.of(context).isBackLayerConcealed == false ? Icons.search_sharp : Icons.clear,
                                                              // _counter1 == false ? Icons.search_sharp : Icons.clear,
                                                              !counterValue ? Icons.search_sharp : Icons.close,
                                                              // Icomoon.fc_logo,
                                                              color: Colors.white,
                                                              size: 40,
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    }),
                                              ),

                                              // if (NavbarState.locationheader != null) LocationOffersWidget(),
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
                  // subHeader:
                  //     Container(width: MediaQuery.of(context).size.width * 0.40, height: MediaQuery.of(context).size.width * 0.3, color: Colors.grey),

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
                        child: Hero(tag: 'bg1', child: Image.asset("assets/images/background/Background.png", fit: BoxFit.cover)),
                      ),
                      if (NavbarState.locationheader != null)
                        SafeArea(
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
                                      _masForUsing = ls.convert(snapshotInfo.data!.text!);
                                      return Column(
                                        children: [
                                          for (int a = 0; a < _masForUsing.length; a++)
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(size.width * 0.07, size.height * 0.001, size.width * 0.07,
                                                  a == _masForUsing.length - 1 ? size.height * 0.001 : size.height * 0.01),
                                              child: Expanded(
                                                flex: 2,
                                                child: ConstrainedBox(
                                                  constraints: BoxConstraints(maxHeight: size.height * 0.20),
                                                  child: SingleChildScrollView(
                                                    child: Text(
                                                      _masForUsing[a],
                                                      // textScaleFactor: ScaleSize.textScaleFactor(context),
                                                      // maxLines: 3,
                                                      // softWrap: false,
                                                      overflow: TextOverflow.fade,
                                                      style: TextStyle(
                                                          fontSize: a == 0 ? size.aspectRatio * 50 : size.aspectRatio * 40,
                                                          fontWeight: a == 0 ? FontWeight.w500 : FontWeight.w300,
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ),
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
                                  child: CarouselSlider.builder(
                                      itemCount: NavbarState.locationoffersImages!.length,
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
                                        scrollDirection: Axis.horizontal,
                                      ),
                                      itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) => FutureBuilder<Uint8List>(
                                          future: NavbarState.locationoffersImages![itemIndex],
                                          builder: (context, snapshotImage) {
                                            print("snapshot has data $itemIndex  ${snapshotImage.hasData}");
                                            // if (snapshotImage.hasData) {
                                            return FutureBuilder<LocationOffers>(
                                                future: NavbarState.locationoffers,
                                                builder: (context, snapshotOfferDetails) {
                                                  VideoPlayerController? _videocontroller = null;
                                                  if (snapshotOfferDetails.hasData) {
                                                    //&& !snapshotOfferDetails.data!.locationOffer![itemIndex].shm2Offer![0].type!.contains("MOV")) {

                                                    return ConstrainedBox(
                                                      constraints: BoxConstraints(maxHeight: double.infinity),
                                                      child: GestureDetector(
                                                        onTap: () => {
                                                          Navigator.of(context).push(
                                                            CupertinoPageRoute(
                                                              builder: (context) => OfferPage(
                                                                locOffer: snapshotOfferDetails.data!.locationOffer![itemIndex],
                                                                // heroTag: itemIndex,
                                                              ),
                                                            ),
                                                          )
                                                          // Navigator.push(
                                                          //   context,
                                                          //   PageRouteBuilder(
                                                          //     pageBuilder: (_, __, ___) => OfferPage(
                                                          //       locOffer: snapshotOfferDetails.data!.locationOffer![itemIndex],
                                                          //       // heroTag: itemIndex,
                                                          //     ),
                                                          //   ),
                                                          // )
                                                        },
                                                        child: Column(
                                                          // mainAxisSize: MainAxisSize.min,
                                                          // mainAxisAlignment: MainAxisAlignment.center,
                                                          // crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: <Widget>[
                                                            Flexible(
                                                              flex: 8,
                                                              child: ClipRRect(
                                                                borderRadius: BorderRadius.circular(5.0),
                                                                child: snapshotImage.hasData
                                                                    ? Image.memory(
                                                                        // state.bytes![i],
                                                                        snapshotImage.data!,
                                                                        fit: BoxFit.fill,
                                                                      )
                                                                    : Align(
                                                                        alignment: Alignment.center,
                                                                        child: Icon(
                                                                          Icons.slow_motion_video_outlined,
                                                                          size: 100,
                                                                          color: Colors.white,
                                                                        ),
                                                                      ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              flex: 1,
                                                              child: Align(
                                                                  alignment: Alignment.centerLeft,
                                                                  child: Text(
                                                                    snapshotOfferDetails.data!.locationOffer![itemIndex].shm2Offer![0].title!,
                                                                    // "dsf",
                                                                    maxLines: 1,
                                                                    style: TextStyle(
                                                                        fontSize: size.width * 0.05,
                                                                        color: Colors.white,
                                                                        fontWeight: FontWeight.w900),
                                                                    textAlign: TextAlign.left,
                                                                  )),
                                                            ),
                                                            Expanded(
                                                              flex: 1,
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
                                                      ),
                                                    );
                                                  }
                                                  // continue;
                                                  return Container();
                                                });
                                          })))
                            ],
                          ),
                        )
                      else
                        Container(),
                    ],
                  ),
                  // floatingActionButton: Column(
                  //   mainAxisAlignment: MainAxisAlignment.end,
                  //   children: <Widget>[
                  //     Padding(
                  //       padding: EdgeInsets.only(bottom: fabQRHeight ?? 50.0), // adjust the value as needed
                  //       child: SizedBox(
                  //         height: 80, // adjust as needed
                  //         width: 60, // adjust as needed
                  //         child: FloatingActionButton(
                  //           key: fabKey,
                  //           onPressed: () => {},
                  //           child: Icon(
                  //             Icons.qr_code,
                  //             color: Colors.white, // setting icon color to white
                  //           ),
                  //           backgroundColor: Colors.black.withOpacity(0.3),
                  //           // setting button background to transparent with opacity 0.3
                  //           elevation: 6.0, // elevation
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // floatingActionButton: ValueListenableBuilder(
                  //     valueListenable: showLocationPage,
                  //     builder: (BuildContext context, bool counterValue, Widget? child) {
                  //       return Column(
                  //         mainAxisAlignment: MainAxisAlignment.end,
                  //         children: <Widget>[
                  //           !counterValue
                  //               ? Padding(
                  //                   padding: EdgeInsets.only(bottom: fabQRHeight ?? 50.0), // adjust the value as needed
                  //                   child: SizedBox(
                  //                     // height: 90, // adjust as needed
                  //                     // width: 60, // adjust as needed
                  //                     child: FloatingActionButton(
                  //                       key: fabKey,
                  //                       onPressed: () => {},
                  //                       child: Icon(
                  //                         Icons.qr_code,
                  //                         color: Colors.white, // setting icon color to white
                  //                       ),
                  //                       backgroundColor: Colors.grey.withOpacity(0.3),
                  //                       // setting button background to transparent with opacity 0.3
                  //                       elevation: 6.0, // elevation
                  //                     ),
                  //                   ),
                  //                 )
                  //               : Container(),
                  //         ],
                  //       );
                  //     }),
                  //
                  // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
                  backLayer: Stack(
                    children: [
                      ClipPath(
                        clipper: BodyClipper(index: currentIndex, context: context, navbarkey: _keyheight, fabkey: fabKey),
                        clipBehavior: Clip.hardEdge,
                        child: PageView.builder(
                          controller: _pageController,
                          // itemCount: _pages.length,
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
                              // clipper: NavbarQRClipper(currentIndex,_keyheight,fabKey),
                              clipper: NavbarClipper(currentIndex),
                              child: CustomPaint(
                                // painter: NavbarQRPainter(
                                //   currentIndex,
                                //   fabKey,
                                //   context,
                                //   _keyheight,
                                // ),
                                painter: NavbarPainter(currentIndex,showQR),
                                child: CustomNavbar(
                                  onClicked: onClicked,
                                  showQR: showQR,
                                  selectedIndex: currentIndex,
                                ),
                              ))),
                    ],
                  ),
                ),
              ),
            )),
            state is AskForLocationPermission
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
                              style: TextStyle(fontSize: 20, color: Colors.black),
                            ),
                            message: Text(
                              ('selectOne').tr(),
                              style: TextStyle(fontSize: 16, color: Colors.black),
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
                                      style: TextStyle(fontSize: 20, color: Colors.black),
                                    ),
                                    onPressed: () {
                                      // To show the "Location page(front layer of backdropscaffold)"
                                      if (showLocationPage.value == false) backdropState!.currentState!.fling();
                                      setState(() {
                                        BlocProvider.of<NavbarBloc>(context)
                                            .add(LocationSelected(location: state.locations_GoToLocationSelection![index]));
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ]),
                      )
                    // : state is LoadingNavbar?LoadingAnimation()
                    : state is GoToLanguageSelection
                        ? Center(
                            child: CupertinoActionSheet(
                                title: Text(
                                  ('selectLanguage').tr(),
                                  style: TextStyle(fontSize: 20, color: Colors.black),
                                ),
                                message: Text(
                                  ('selectOne').tr(),
                                  style: TextStyle(fontSize: 16, color: Colors.black),
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
                                          style: TextStyle(fontSize: 20, color: Colors.black),
                                        ),
                                        onPressed: () async {
                                          // To show the "Location page(front layer of backdropscaffold)"
                                          // if (showLocationPage.value == false) backdropState!.currentState!.fling();
                                          await EasyLocalization.of(context)!.setLocale(Locale(state.languageOptions![index].languageCode!));
                                          // setState(() {
                                          BlocProvider.of<NavbarBloc>(context).add(LanguageSelected(language: state.languageOptions![index]));
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