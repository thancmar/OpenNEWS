import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:animate_icons/animate_icons.dart';
import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
// import 'package:backdrop/backdrop.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';
import 'package:sharemagazines_flutter/src/blocs/navbar/navbar_bloc.dart';
import 'package:sharemagazines_flutter/src/models/locationOffers_model.dart';
import 'package:sharemagazines_flutter/src/presentation/pages/navbarpages/homepage/homepage.dart';
import 'package:sharemagazines_flutter/src/presentation/pages/navbarpages/menupage.dart';
import 'package:sharemagazines_flutter/src/presentation/pages/navbarpages/homepage/searchpage.dart';
import 'package:sharemagazines_flutter/src/presentation/pages/map/mappage.dart';
import 'package:sharemagazines_flutter/src/presentation/pages/navbarpages/accountpage/accountpage.dart';
import 'package:sharemagazines_flutter/src/presentation/widgets/body_painter.dart';
import 'package:sharemagazines_flutter/src/presentation/widgets/bottomAppBar.dart';
import 'package:sharemagazines_flutter/src/presentation/widgets/SlidingAppBar.dart';
import 'package:sharemagazines_flutter/src/presentation/widgets/marquee.dart';
import 'package:sharemagazines_flutter/src/presentation/widgets/navbar_painter.dart';

import '../../blocs/auth/auth_bloc.dart';
import '../../models/locationGetHeader_model.dart';
import '../widgets/backdrop/backdrop.dart';
import 'map/mapOfferpage.dart';
import 'navbarpages/homepage/search_close_button.dart';

class MainPage extends StatefulWidget {
  MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  // NavbarBloc _navbarBloc = BlocProvider.of<NavbarBloc>(context);

  late final AnimationController _controller;
  int selectedIndex = 0;
  late PageController _pageController;
  var showSearchPage = false;
  GlobalKey<ScaffoldState>? backdropState = GlobalKey();
  ValueNotifier<bool> showLocationPage = ValueNotifier<bool>(false);
  //easyloading

  late double _progress;
  // _MainPageState(){
  //
  // }
  late List<Widget> _pages = [
    // HomePageState(navbarBloc: BlocProvider.of<NavbarBloc>(context)),
    HomePage(),
    MenuPage(),
    // MapsBlocWidget(),
    // Maps(_progress, _timer),
    Maps(),
    AccountPage(),
    // _showlocationselectionsheet(context),
    // _showlocationselectionsheet(context),
  ];
  GlobalKey _keyheight = GlobalKey();
  final controller = ScrollController();
  late OverlayEntry sticky;
  GlobalKey stickyKey = GlobalKey();

  //to get showsearchpage callback
  // callback(newValue) {
  //   setState(() {
  //     print("reader callback function");
  //     showSearchPage = newValue;
  //     // _controller.value = matrix4;
  //   });
  // }

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    print("init_MainPageState");
    // EasyLoading.addStatusCallback((status) {
    //   print('EasyLoading Status $status');
    //   if (status == EasyLoadingStatus.dismiss) {
    //     _timer?.cancel();
    //   }
    // });
    // _progress = 0;
    // EasyLoading.showSuccess('Use in initState');
    // BlocProvider.of<NavbarBloc>(context).add(Initialize123(_timer));

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );
    _pageController = PageController(initialPage: selectedIndex);
  }

  void _onItemFocus(int index) {
    // setState(() {
    //   // _focusedIndex = index;
    // });
  }

  @override
  void dispose() {
    // _pageController.dispose();
    // _controller.dispose();
    super.dispose();
  }

  void onClicked(int index) {
    print("mainpage onclicked");
    if (showSearchPage == false) {
      setState(() {
        _pageController.animateToPage(index, duration: Duration(milliseconds: 300), curve: Curves.ease);
      });
    }
    print(index);
    if (index == 0) {
      print("home page bloc add");
      BlocProvider.of<NavbarBloc>(context).add(
        Home(),
      );
    } else if (index == 1) {
      print("menu page bloc add");
      BlocProvider.of<NavbarBloc>(context).add(
        Menu(),
      );
    } else if (index == 2) {
      print("Mappage bloc add");
      BlocProvider.of<NavbarBloc>(context).add(
        Map(),
      );
    } else if (index == 3) {
      print("Account page bloc add");
      BlocProvider.of<NavbarBloc>(context).add(
        AccountEvent(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var _selectedIndex = 0;
    ValueNotifier<bool> _counter1 = ValueNotifier<bool>(false);
    return BlocBuilder<NavbarBloc, NavbarState>(builder: (context, state) {
      int currentIndex = state is GoToHome //|| state is HomeLoaded
          ? 0
          : state is GoToMenu
              ? 1
              : state is GoToMap
                  ? 2
                  : state is GoToAccount
                      ? 3
                      // : state is GoToSearch
                      : state is GoToLocationSelection
                          ? 4
                          //     ? 4
                          : 0;
      print("Mainpage blocbuilder $state");

      return Stack(
        children: <Widget>[
          // new SvgPicture.asset(
          //   "assets/images/background_webreader.svg",
          //   fit: BoxFit.fill,
          //   allowDrawingOutsideViewBox: true,
          // ),
          DecoratedBox(
            decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage("assets/images/Background.png"), fit: BoxFit.cover),
            ),
            child: Center(
                child: state is GoToLocationSelection
                    ? CupertinoActionSheet(
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
                              state.locations_GoToLocationSelection!.data!.length,
                              (index) => GestureDetector(
                                // onTap: () => setState(() => _selectedIndex = index),
                                child: CupertinoActionSheetAction(
                                  child: Text(
                                    state.locations_GoToLocationSelection!.data![index].nameApp!,
                                    // "$index",
                                    style: TextStyle(fontSize: 20, color: Colors.black),
                                  ),
                                  onPressed: () {
                                    print(state.locations_GoToLocationSelection!.data![index].nameApp!);
                                    // Navigator.of(context, rootNavigator: true).pop();
                                    // currentIndex = 0;
                                    // setState(() {
                                    BlocProvider.of<NavbarBloc>(context).add(
                                      // Home(state.locations!.data![index], _timer),
                                      LocationSelection(state.locations_GoToLocationSelection!.data![index]),
                                    );
                                    // });
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
                          ])
                    :
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
                          visible: currentIndex == 0 || currentIndex == 1 ? true : false,
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
                            toolbarHeight: (currentIndex == 0 || currentIndex == 1 && !showSearchPage) ? 100 : 0,
                            flexibleSpace: SafeArea(
                              child: Container(
                                margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: ExpandableNotifier(
                                  child: ScrollOnExpand(
                                    child: Column(
                                      children: [
                                        Row(
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

                                            Expanded(child: Builder(
                                              builder: (BuildContext context) {
                                                return GestureDetector(
                                                  onTap: () => {Backdrop.of(context).fling()},
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Container(
                                                            height: 70,
                                                            width: 70,

                                                            // color: Colors.red,
                                                            decoration: BoxDecoration(boxShadow: <BoxShadow>[
                                                              BoxShadow(
                                                                // offset: Offset(0, 3),
                                                                blurRadius: 5,
                                                                color: Color(0xFF000000),
                                                              ),
                                                            ], border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(100), color: Colors.grey.withOpacity(0.2)),
                                                            child: FutureBuilder<Uint8List>(
                                                                future: NavbarState.locationImage,
                                                                builder: (context, snapshot) {
                                                                  return (snapshot.hasData)
                                                                      ? ClipRRect(
                                                                          borderRadius: BorderRadius.circular(100.0),
                                                                          child: Image.memory(
                                                                            // state.bytes![i],
                                                                            snapshot.data!,
                                                                            fit: BoxFit.fill,
                                                                          ),
                                                                        )
                                                                      : Container();
                                                                })),
                                                      ),
                                                      Flexible(
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          mainAxisSize: MainAxisSize.min,
                                                          children: <Widget>[
                                                            MarqueeWidget(
                                                              child: Text(
                                                                // state.access_location.data!.isNotEmpty ==
                                                                //         true
                                                                //     ? "sdf"
                                                                //     : "sdf",
                                                                // "Weser kurier",
                                                                state is GoToHome
                                                                    ? state.location_HomeState?.nameApp ?? "No location"
                                                                    : state is GoToMenu
                                                                        ? state.location?.nameApp ?? "No location"
                                                                        : "${state}",
// state.magazinePublishedGetLastWithLimit
//     .response!.first.name!,
//                                         overflow: TextOverflow.e,
//                                         softWrap: true,
//                                         maxLines: 1,
                                                                style: TextStyle(fontFamily: 'Raleway', fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
// textAlign: TextAlign.left,
                                                              ),
                                                            ),
                                                            Row(
                                                              children: [
                                                                MarqueeWidget(
                                                                  child: Text(
                                                                    "Infos zu deiner Location ",
                                                                    // overflow: TextOverflow.fade,
                                                                    // softWrap: true,
                                                                    style: TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w200),
// textAlign: TextAlign.right,
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
                                                                        child: Icon(counterValue ? Icons.arrow_upward : Icons.arrow_downward, color: Colors.white),
                                                                      );
                                                                    }),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            )),
                                            // Builder(builder: (BuildContext context) {
                                            //   return SearchCloseButton(context: context, callback: this.callback);
                                            // }),
                                            // ])
                                            // ),
                                            // Spacer(),
                                            Container(
                                              color: Colors.transparent,
                                              child: ValueListenableBuilder(
                                                  valueListenable: showLocationPage,
                                                  builder: (BuildContext context, bool counterValue, Widget? child) {
                                                    return GestureDetector(
                                                      onTap: () => {
                                                        if (!counterValue)
                                                          {
                                                            if (mounted) {setState(() => showSearchPage = true)},
                                                            // setState(() {
                                                            //   showSearchPage = true;
                                                            // }),
                                                            print("before searchpage state $state"),
                                                            Navigator.push(
                                                              context,
                                                              PageRouteBuilder(
                                                                pageBuilder: (_, __, ___) {
                                                                  return SearchPage();
                                                                },
                                                              ),
                                                            ).then((_) {
                                                              print("after searchpage state $state");
                                                              setState(() {
                                                                showSearchPage = false;
                                                              });
                                                            })
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
                                            )
                                          ],
                                        ),
                                        // SingleChildScrollView(
                                        //   physics: RangeMaintainingScrollPhysics(),
                                        //   scrollDirection: Axis.horizontal,
                                        //   child: Row(
                                        //     children: [
                                        //       Padding(
                                        //         padding: const EdgeInsets.fromLTRB(20, 0, 10, 5),
                                        //         child: Container(
                                        //           width: MediaQuery.of(context).size.width * 0.40,
                                        //           height: MediaQuery.of(context).size.width * 0.1,
                                        //           child: FloatingActionButton.extended(
                                        //             // heroTag: 'location_offers',
                                        //             heroTag: null,
                                        //             shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8)), side: BorderSide(color: Colors.white, width: 0.2)),
                                        //             label: Text(
                                        //               'Speisekarte',
                                        //               style: TextStyle(fontSize: 12),
                                        //             ), // <-- Text
                                        //             backgroundColor: Colors.grey.withOpacity(0.1),
                                        //             icon: Icon(
                                        //               // <-- Icon
                                        //               Icons.menu_book,
                                        //               // IconData(0xe9a9, fontFamily: ‘icomoon’);
                                        //               size: 16.0,
                                        //             ),
                                        //             onPressed: () {},
                                        //             // extendedPadding: EdgeInsets.all(50),
                                        //           ),
                                        //         ),
                                        //       ),
                                        //       Padding(
                                        //         padding: const EdgeInsets.fromLTRB(0, 0, 10, 5),
                                        //         child: Container(
                                        //           width: MediaQuery.of(context).size.width * 0.40,
                                        //           height: MediaQuery.of(context).size.width * 0.1,
                                        //           child: FloatingActionButton.extended(
                                        //             // heroTag: 'location_offers',
                                        //             heroTag: null,
                                        //             shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8)), side: BorderSide(color: Colors.white, width: 0.2)),
                                        //
                                        //             label: Text(
                                        //               'Unser Barista',
                                        //               style: TextStyle(fontSize: 12),
                                        //             ), // <-- Text
                                        //             backgroundColor: Colors.grey.withOpacity(0.1),
                                        //             icon: Icon(
                                        //               // <-- Icon
                                        //               Icons.account_box,
                                        //               size: 16.0,
                                        //             ),
                                        //             onPressed: () {},
                                        //           ),
                                        //         ),
                                        //       ),
                                        //       Padding(
                                        //         padding: const EdgeInsets.fromLTRB(0, 0, 10, 5),
                                        //         child: Container(
                                        //           width: MediaQuery.of(context).size.width * 0.40,
                                        //           height: MediaQuery.of(context).size.width * 0.1,
                                        //           child: FloatingActionButton.extended(
                                        //             // heroTag: 'location_offers',
                                        //             heroTag: null,
                                        //             shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8)), side: BorderSide(color: Colors.white, width: 0.2)),
                                        //             label: Text(
                                        //               'Kaffeesorten',
                                        //               style: TextStyle(fontSize: 12),
                                        //             ), // <-- Text
                                        //             backgroundColor: Colors.grey.withOpacity(0.1),
                                        //             icon: Icon(
                                        //               // <-- Icon
                                        //               Icons.coffee,
                                        //               size: 16.0,
                                        //             ),
                                        //             onPressed: () {},
                                        //           ),
                                        //         ),
                                        //       ),
                                        //     ],
                                        //   ),
                                        // ),
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
                        revealBackLayerAtStart: true,
                        // fr

                        // scaffoldKey: backdropState,
                        key: backdropState,
                        frontLayerScrim: Colors.transparent,
                        // stickyFrontLayer: true,
                        onBackLayerRevealed: () => showLocationPage.value = false,
                        onBackLayerConcealed: () => showLocationPage.value = true,

                        backLayerScrim: Colors.red,
                        // extendBody: true,
                        // subHeaderAlwaysActive: true,
                        frontLayer: Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/images/Background.png"),
                              fit: BoxFit.fill,
                            ),
                          ),
                          child: SafeArea(
                            child: SingleChildScrollView(
                                child: Column(
                              children: [
                                FutureBuilder<LocationGetHeader>(
                                    future: NavbarState.locationheader,
                                    builder: (context, snapshotInfo) {
                                      if (snapshotInfo.hasData) {
                                        LineSplitter ls = new LineSplitter();
                                        List<String> _masForUsing = ls.convert(snapshotInfo.data!.text!);
                                        return Column(
                                          children: [
                                            for (int a = 0; a < _masForUsing.length; a++)
                                              Padding(
                                                padding: EdgeInsets.fromLTRB(20, 10, 20, a == _masForUsing.length - 1 ? 20 : 10),
                                                child: Text(
                                                  _masForUsing[a],
                                                  // "datadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadatadata",
                                                  style: TextStyle(fontSize: a == 0 ? 22 : 18, fontWeight: a == 0 ? FontWeight.w900 : FontWeight.w500, color: Colors.white),
                                                ),
                                              ),
                                          ],
                                        );
                                      }
                                      return Container();
                                    }),
                                SizedBox(
                                  // height: double.infinity,
                                  height: MediaQuery.of(context).size.height / 1.5,
                                  width: MediaQuery.of(context).size.width,
                                  // child: ListView.builder(
                                  //     itemCount: NavbarState.locationoffersImages!.length,
                                  //     scrollDirection: Axis.horizontal,
                                  //     // itemCount: 1,
                                  //     // padEnds: false,
                                  //     // pageSnapping: false,
                                  //     // controller: PageController(viewportFraction: 0.5),
                                  //     // onPageChanged: (int index) => setState(() => widget.index1 = index),
                                  //     itemBuilder: (_, i) {
                                  //       return FutureBuilder<Uint8List>(
                                  //           future: NavbarState.locationoffersImages![i],
                                  //           builder: (context, snapshot) {
                                  //             print("snapshot has data ${snapshot.hasData}");
                                  //             if (snapshot.hasData) {
                                  //               return ClipRRect(
                                  //                 borderRadius: BorderRadius.circular(5.0),
                                  //                 child: Image.memory(
                                  //                   // state.bytes![i],
                                  //                   snapshot.data!,
                                  //                   fit: BoxFit.fill,
                                  //                 ),
                                  //               );
                                  //             }
                                  //             return Container(
                                  //               height: 40,
                                  //               color: Colors.blue,
                                  //             );
                                  //           });
                                  //     }),
                                  child: PageView.builder(
                                    itemCount: NavbarState.getTopMagazines!.length,
                                    // padEnds: true,

                                    controller: PageController(viewportFraction: 0.8),
                                    // onPageChanged: (int index) => setState(() => widget.index1 = index),
                                    itemBuilder: (_, i) {
                                      return FutureBuilder<Uint8List>(
                                          future: NavbarState.locationoffersImages![i],
                                          builder: (context, snapshot) {
                                            return Transform.scale(
                                                // scale: i == widget.index1 ? 1 : 0.85,
                                                // scale: 1,
                                                alignment: Alignment.center,
                                                scaleX: 1,
                                                scaleY: 1,
                                                child: ColumnSuper(
                                                  // innerDistance: -50,
                                                  alignment: Alignment.center,
                                                  children: [
                                                    Align(
                                                      alignment: Alignment.center,
                                                      child: Card(
                                                          color: Colors.transparent,

                                                          // clipBehavior: Clip.hardEdge,
                                                          borderOnForeground: true,
                                                          margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                                          elevation: 5,
                                                          // key: stickyKey,

                                                          ///maybe 0?
                                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                                          child: Stack(
                                                            // clipBehavior: Clip.antiAlias,
                                                            children: [
                                                              Hero(
                                                                //sizedbox after this w550 h300
                                                                key: UniqueKey(),
                                                                tag: 'News_aus_deiner_Region_$i',
                                                                transitionOnUserGestures: true,

                                                                child: (snapshot.hasData)
                                                                    ? GestureDetector(
                                                                        behavior: HitTestBehavior.translucent,
                                                                        onTap: () => {},
                                                                        child: ClipRRect(
                                                                          borderRadius: BorderRadius.circular(8.0),
                                                                          child: Image.memory(
                                                                            // state.bytes![i],
                                                                            snapshot.data!,
                                                                            fit: BoxFit.fill,
                                                                          ),
                                                                        ),
                                                                      )
                                                                    : Container(
                                                                        ///Actually useless
                                                                        color: Colors.grey.withOpacity(0.1),
                                                                        child: SpinKitFadingCircle(
                                                                          color: Colors.white,
                                                                          size: 50.0,
                                                                        ),
                                                                      ),
                                                              ),
                                                            ],
                                                          )),
                                                    ),
                                                    FutureBuilder<LocationOffers>(
                                                        future: NavbarState.locationoffers,
                                                        builder: (context, snapshot2) {
                                                          return Column(
                                                            children: [
                                                              Align(
                                                                  alignment: Alignment.centerLeft,
                                                                  child: Text(
                                                                    snapshot2.data!.locationOffer![i].shm2Offer![0].title!,
                                                                    // "dsf",
                                                                    style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w900),
                                                                    textAlign: TextAlign.left,
                                                                  )),
                                                              Align(
                                                                  alignment: Alignment.centerLeft,
                                                                  child: Text(
                                                                    snapshot2.data!.locationOffer![i].shm2Offer![0].shortDesc!,
                                                                    // "dsf",
                                                                    style: TextStyle(fontSize: 14, color: Colors.white),
                                                                    textAlign: TextAlign.left,
                                                                  )),
                                                              // RichText(
                                                              //   text: TextSpan(
                                                              //     children: [
                                                              //       TextSpan(
                                                              //         text: "${NavbarState.magazinePublishedGetTopLastByRange!.response![i].name!} ",
                                                              //         // text: state.magazinePublishedGetLastWithLimit!.response![_index1].name!
                                                              //       ),
                                                              //       WidgetSpan(
                                                              //         child: Icon(Icons.navigate_next_outlined, color: Colors.white, size: 14),
                                                              //       ),
                                                              //     ],
                                                              //   ),
                                                              // ),
                                                              // RichText(
                                                              //   text: TextSpan(
                                                              //     children: [
                                                              //       TextSpan(text: "11. Januar 2022", style: TextStyle(color: Colors.grey, fontSize: 12)),
                                                              //     ],
                                                              //   ),
                                                              // )
                                                            ],
                                                          );
                                                        }),
                                                  ],
                                                )

                                                // child: Column(
                                                //   children: [
                                                //     Expanded(
                                                //       flex: 10,
                                                //       child: Card(
                                                //           color: Colors.transparent,
                                                //           // clipBehavior: Clip.hardEdge,
                                                //           borderOnForeground: true,
                                                //           margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                                //           elevation: 0,
                                                //           // key: stickyKey,
                                                //
                                                //           ///maybe 0?
                                                //           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                                //           child: Stack(
                                                //             // clipBehavior: Clip.antiAlias,
                                                //             children: [
                                                //               Align(
                                                //                 alignment: Alignment.center,
                                                //                 child: Hero(
                                                //                   //sizedbox after this w550 h300
                                                //                   key: UniqueKey(),
                                                //                   tag: 'News_aus_deiner_Region_$i',
                                                //                   transitionOnUserGestures: true,
                                                //
                                                //                   child: (snapshot.hasData)
                                                //                       ? GestureDetector(
                                                //                           behavior: HitTestBehavior.translucent,
                                                //                           onTap: () => {
                                                //                             // Navigator.of(context).push(
                                                //                             //   PageRouteBuilder(
                                                //                             //     transitionDuration: Duration(milliseconds: 1000),
                                                //                             //     pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
                                                //                             //       return StartReader(
                                                //                             //         id: state.magazinePublishedGetLastWithLimit!.response![i + 1].idMagazinePublication!,
                                                //                             //         index: i.toString(),
                                                //                             //         cover: snapshot.data!,
                                                //                             //         noofpages: state.magazinePublishedGetLastWithLimit!.response![i + 1].pageMax!,
                                                //                             //         readerTitle: state.magazinePublishedGetLastWithLimit!.response![i + 1].name!,
                                                //                             //
                                                //                             //         // noofpages: 5,
                                                //                             //       );
                                                //                             //     },
                                                //                             //     transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
                                                //                             //       return Align(
                                                //                             //         child: FadeTransition(
                                                //                             //           opacity: new CurvedAnimation(parent: animation, curve: Curves.easeIn),
                                                //                             //           child: child,
                                                //                             //         ),
                                                //                             //       );
                                                //                             //     },
                                                //                             //   ),
                                                //                             // )
                                                //                             Navigator.push(
                                                //                               context,
                                                //                               PageRouteBuilder(
                                                //                                 // transitionDuration:
                                                //                                 // Duration(seconds: 2),
                                                //                                 pageBuilder: (_, __, ___) => StartReader(
                                                //                                   id: NavbarState.magazinePublishedGetTopLastByRange!.response![i].idMagazinePublication!,
                                                //                                   index: i.toString(),
                                                //                                   cover: snapshot.data!,
                                                //                                   noofpages: NavbarState.magazinePublishedGetTopLastByRange!.response![i].pageMax!,
                                                //                                   readerTitle: NavbarState.magazinePublishedGetTopLastByRange!.response![i].name!,
                                                //                                   heroTag: 'News_aus_deiner_Region_$i',
                                                //                                   // noofpages: 5,
                                                //                                 ),
                                                //                               ),
                                                //                             ),
                                                //                           },
                                                //                           child: ClipRRect(
                                                //                             borderRadius: BorderRadius.circular(8.0),
                                                //                             child: Image.memory(
                                                //                               // state.bytes![i],
                                                //                               snapshot.data!,
                                                //                             ),
                                                //                           ),
                                                //                         )
                                                //                       : Container(
                                                //                           color: Colors.grey.withOpacity(0.1),
                                                //                           child: SpinKitFadingCircle(
                                                //                             color: Colors.white,
                                                //                             size: 50.0,
                                                //                           ),
                                                //                         ),
                                                //                 ),
                                                //               ),
                                                //
                                                //               // Align(
                                                //               //   alignment: Alignment.bottomCenter,
                                                //               //   child: Text(
                                                //               //     state.magazinePublishedGetLastWithLimit.response![i + 1].name!,
                                                //               //     // " asd",
                                                //               //     // "Card ${i + 1}",
                                                //               //     textAlign: TextAlign.center,
                                                //               //
                                                //               //     style: TextStyle(fontSize: 32, color: Colors.white, backgroundColor: Colors.transparent),
                                                //               //   ),
                                                //               // ),
                                                //             ],
                                                //           )
                                                //           // : Container(
                                                //           //     color: Colors.grey.withOpacity(0.1),
                                                //           //     child: SpinKitFadingCircle(
                                                //           //       color: Colors.white,
                                                //           //       size: 50.0,
                                                //           //     ),
                                                //           //   ),
                                                //           ),
                                                //     ),
                                                //     Expanded(
                                                //       flex: 1,
                                                //       child: Column(
                                                //         children: [
                                                //           Card(
                                                //             color: Colors.grey[900],
                                                //             shape: RoundedRectangleBorder(
                                                //               side: BorderSide(color: Colors.white70, width: 0),
                                                //               borderRadius: BorderRadius.circular(100),
                                                //             ),
                                                //             margin: EdgeInsets.all(10.0),
                                                //             child: Icon(
                                                //               Icons.ac_unit,
                                                //               size: 80,
                                                //               color: Colors.amber,
                                                //             ),
                                                //           ),
                                                //           RichText(
                                                //             text: TextSpan(
                                                //               children: [
                                                //                 TextSpan(
                                                //                   text: "Hamburger Morgenpost ",
                                                //                   // text: state.magazinePublishedGetLastWithLimit!.response![_index1].name!
                                                //                 ),
                                                //                 WidgetSpan(
                                                //                   child: Icon(Icons.navigate_next_outlined, color: Colors.white, size: 14),
                                                //                 ),
                                                //               ],
                                                //             ),
                                                //           ),
                                                //           RichText(
                                                //             text: TextSpan(
                                                //               children: [
                                                //                 TextSpan(text: "11. Januar 2022", style: TextStyle(color: Colors.grey, fontSize: 12)),
                                                //               ],
                                                //             ),
                                                //           )
                                                //         ],
                                                //       ),
                                                //     ),
                                                //   ],
                                                // ),
                                                );
                                          });
                                    },
                                  ),
                                  // child: CarouselSlider.builder(
                                  //     itemCount: NavbarState.locationoffersImages!.length,
                                  //     options: CarouselOptions(
                                  //       // height: double.infinity,
                                  //       height: MediaQuery.of(context).size.height * 0.4,
                                  //       // aspectRatio: 16 / 9,
                                  //       // viewportFraction: 0.4,
                                  //       initialPage: 0,
                                  //       enableInfiniteScroll: false,
                                  //
                                  //       // reverse: false,
                                  //       // autoPlay: true,
                                  //       // autoPlayInterval: Duration(seconds: 3),
                                  //       // autoPlayAnimationDuration: Duration(milliseconds: 800),
                                  //       // autoPlayCurve: Curves.fastOutSlowIn,
                                  //       enlargeCenterPage: true,
                                  //       // enlargeFactor: 0.2,
                                  //       // // onPageChanged: callbackFunction,
                                  //       scrollDirection: Axis.horizontal,
                                  //     ),
                                  //     itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) => FutureBuilder<Uint8List>(
                                  //         future: NavbarState.locationoffersImages![itemIndex],
                                  //         builder: (context, snapshot) {
                                  //           print("snapshot has data ${snapshot.hasData}");
                                  //           if (snapshot.hasData) {
                                  //             return FutureBuilder<LocationOffers>(
                                  //                 future: NavbarState.locationoffers,
                                  //                 builder: (context, snapshot2) {
                                  //                   return Column(
                                  //                     mainAxisSize: MainAxisSize.max,
                                  //                     mainAxisAlignment: MainAxisAlignment.center,
                                  //                     crossAxisAlignment: CrossAxisAlignment.center,
                                  //                     children: [
                                  //                       ClipRRect(
                                  //                         borderRadius: BorderRadius.circular(5.0),
                                  //                         child: Image.memory(
                                  //                           // state.bytes![i],
                                  //                           snapshot.data!,
                                  //                           fit: BoxFit.fill,
                                  //                         ),
                                  //                       ),
                                  //                       Align(
                                  //                           alignment: Alignment.centerLeft,
                                  //                           child: Text(
                                  //                             snapshot2.data!.locationOffer![itemIndex].shm2Offer![0].title!,
                                  //                             // "dsf",
                                  //                             style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w900),
                                  //                             textAlign: TextAlign.left,
                                  //                           )),
                                  //                       Align(
                                  //                           alignment: Alignment.centerLeft,
                                  //                           child: Text(
                                  //                             snapshot2.data!.locationOffer![itemIndex].shm2Offer![0].shortDesc!,
                                  //                             // "dsf",
                                  //                             style: TextStyle(fontSize: 16, color: Colors.white),
                                  //                             textAlign: TextAlign.left,
                                  //                           )),
                                  //                     ],
                                  //                   );
                                  //                 });
                                  //           }
                                  //           return Container(
                                  //             height: 40,
                                  //             color: Colors.blue,
                                  //           );
                                  //         })),
                                )
                                // Column(
                                //   children: [
                                //     SizedBox(
                                //       // height: MediaQuery.of(context).size.height,
                                //       width: MediaQuery.of(context).size.width,
                                //       // child: ListView.builder(
                                //       //     itemCount: NavbarState.locationoffersImages!.length,
                                //       //     scrollDirection: Axis.horizontal,
                                //       //     // itemCount: 1,
                                //       //     // padEnds: false,
                                //       //     // pageSnapping: false,
                                //       //     // controller: PageController(viewportFraction: 0.5),
                                //       //     // onPageChanged: (int index) => setState(() => widget.index1 = index),
                                //       //     itemBuilder: (_, i) {
                                //       //       return FutureBuilder<Uint8List>(
                                //       //           future: NavbarState.locationoffersImages![i],
                                //       //           builder: (context, snapshot) {
                                //       //             print("snapshot has data ${snapshot.hasData}");
                                //       //             if (snapshot.hasData) {
                                //       //               return ClipRRect(
                                //       //                 borderRadius: BorderRadius.circular(5.0),
                                //       //                 child: Image.memory(
                                //       //                   // state.bytes![i],
                                //       //                   snapshot.data!,
                                //       //                   fit: BoxFit.fill,
                                //       //                 ),
                                //       //               );
                                //       //             }
                                //       //             return Container(
                                //       //               height: 40,
                                //       //               color: Colors.blue,
                                //       //             );
                                //       //           });
                                //       //     }),
                                //       child: CarouselSlider.builder(
                                //           itemCount: NavbarState.locationoffersImages!.length,
                                //           options: CarouselOptions(
                                //             height: MediaQuery.of(context).size.height * 0.5,
                                //             // aspectRatio: 16 / 9,
                                //             // viewportFraction: 0.4,
                                //             initialPage: 0,
                                //             enableInfiniteScroll: false,
                                //
                                //             // reverse: false,
                                //             // autoPlay: true,
                                //             // autoPlayInterval: Duration(seconds: 3),
                                //             // autoPlayAnimationDuration: Duration(milliseconds: 800),
                                //             // autoPlayCurve: Curves.fastOutSlowIn,
                                //             enlargeCenterPage: true,
                                //             // enlargeFactor: 0.2,
                                //             // // onPageChanged: callbackFunction,
                                //             scrollDirection: Axis.horizontal,
                                //           ),
                                //           itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) => FutureBuilder<Uint8List>(
                                //               future: NavbarState.locationoffersImages![itemIndex],
                                //               builder: (context, snapshot) {
                                //                 print("snapshot has data ${snapshot.hasData}");
                                //                 if (snapshot.hasData) {
                                //                   return Column(
                                //                     mainAxisAlignment: MainAxisAlignment.center,
                                //                     children: [
                                //                       ClipRRect(
                                //                         borderRadius: BorderRadius.circular(5.0),
                                //                         child: Image.memory(
                                //                           // state.bytes![i],
                                //                           snapshot.data!,
                                //                           fit: BoxFit.fill,
                                //                         ),
                                //                       ),
                                //                       Align(
                                //                         alignment: Alignment.centerLeft,
                                //                         child: Text(
                                //                           "dsf",
                                //                           style: TextStyle(fontSize: 18, color: Colors.white),
                                //                           textAlign: TextAlign.left,
                                //                         ),
                                //                       ),
                                //                     ],
                                //                   );
                                //                 }
                                //                 return Container(
                                //                   height: 40,
                                //                   color: Colors.blue,
                                //                 );
                                //               })),
                                //     ),
                                //   ],
                                // )
                              ],
                            )),
                          ),
                          // color: Colors.transparent,
                        ),
                        backLayer: Stack(
                          children: [
                            ClipPath(
                              clipper: BodyPainter(index: currentIndex, context: context, key: _keyheight),
                              // clipBehavior: Clip.hardEdge,
                              child:
                                  // PageView(
                                  //   controller: _pageController,
                                  //   physics: NeverScrollableScrollPhysics(),
                                  //   // physics: AlwaysScrollableScrollPhysics(),
                                  //   children: _pages,
                                  // ),
                                  PageView.builder(
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
                                    clipper: NavBarClipper(currentIndex),
                                    child: CustomPaint(
                                      painter: NavBarPainter(currentIndex),
                                      child: BottomNavBarImp(
                                        onClicked: onClicked,
                                        selectedIndex: currentIndex,
                                      ),
                                    )))
                            // : Container(),
                          ],
                        ),
                      )),
          ),
        ],
      );
    });
  }

// Stack buildFlexibleSpace(int currentIndex) {
//   return Stack(
//     children: <Widget>[
//       new SvgPicture.asset(
//         "assets/images/background_webreader.svg",
//         fit: BoxFit.fill,
//         allowDrawingOutsideViewBox: true,
//       ),
//       Scaffold(
//           extendBodyBehindAppBar: true,
//           // extendBody: true,
//           backgroundColor: Colors.transparent,
//           body: Stack(
//             children: [
//               ClipPath(
//                 clipper: BodyPainter(currentIndex, context, _keyheight),
//                 // clipBehavior: Clip.hardEdge,
//                 child: Container(
//                   child: BlocBuilder<NavbarBloc, NavbarState>(
//                       builder: (context, state) {
//                     if (state is GoToHome || state is GoToMenu) {
//                       return LocationAppbar();
//                       // return HomePageState();
//                       // } else if (state is GoToMenu) {
//                       // return MenuPage();
//                       return Container();
//                     } else if (state is GoToMap) {
//                       return MapsBlocWidget();
//                     } else if (state is GoToAccount) {
//                       return Account();
//                     }
//                     ;
//                     return Container();
//                   }),
//                 ),
//               ),
//               ClipPath(
//                 key: _keyheight,
//                 clipper: NavBarClipper(currentIndex),
//                 child: Container(
//                     alignment: Alignment.bottomCenter,
//                     key: _keyheight,
//                     child: ClipPath(
//                         key: _keyheight,
//                         clipper: NavBarClipper(currentIndex),
//                         child: CustomPaint(
//                           painter: NavBarPainter(currentIndex),
//                           child: BottomNavBarImp(
//                             onClicked: onClicked,
//                             selectedIndex: currentIndex,
//                           ),
//                         ))),
//               ),
//             ],
//           ))
//     ],
//   );
// }

// Stack buildLocationFlexibleSpace(int currentIndex) {
//   return Stack(
//     children: <Widget>[
//       new SvgPicture.asset(
//         "assets/images/background_webreader.svg",
//         fit: BoxFit.fill,
//         allowDrawingOutsideViewBox: true,
//       ),
//       Scaffold(
//           extendBodyBehindAppBar: true,
//           // extendBody: true,
//           backgroundColor: Colors.transparent,
//           body: Stack(
//             children: [
//               Container(
//                 alignment: Alignment.bottomCenter,
//                 // key: _keyheight,
//                 child: Text("data"),
//               )
//             ],
//           ))
//     ],
//   );
// }
}

// class Scaffold_Close_Open_button extends StatelessWidget {
//   final BuildContext context;
//   const Scaffold_Close_Open_button({
//     Key? key,
//     required BuildContext this.context,
//   }) : super(key: key);
//
//   @override
//   Widget build(context) {
//     return Icon(
//       Backdrop.of(context).isBackLayerConcealed == true ? Icons.search_sharp : Icons.clear,
//       // Icons.search_sharp,
//       // Icomoon.fc_logo,
//       color: Colors.white,
//       size: 40,
//     );
//   }
// }

// child: ExpansionTile(
// // onExpansionChanged: (bool expanding) =>
// //     _onExpansion(expanding),
// leading: Icon(
// Icons.circle,
// color: Colors.white,
// size: 80,
// ),
// trailing: GestureDetector(
// // onTap: ,
// child: Icon(
// Icons.search,
// color: Colors.white,
// size: 30,
// ),
// ),
// title: Row(
// children: [
// Column(
// crossAxisAlignment: CrossAxisAlignment.start,
// mainAxisAlignment: MainAxisAlignment.center,
// children: [
// Container(
// child: Text(
// "asd",
// // state.magazinePublishedGetLastWithLimit
// //     .response!.first.name!,
// style: TextStyle(
// fontSize: 18, color: Colors.white),
// // textAlign: TextAlign.left,
// ),
// ),
// Container(
// child: Text(
// "Infos zu deiner Location",
// style: TextStyle(
// fontSize: 13,
// color: Colors.white,
// fontWeight: FontWeight.w200),
// // textAlign: TextAlign.right,
// ),
// ),
// ],
// ),
// ],
// ),
// children: <Widget>[
// SingleChildScrollView(
// child: Container(
// height: MediaQuery.of(context).size.height * 0.8,
// width: MediaQuery.of(context).size.width,
// child: Text(
// "data",
// style: TextStyle(
// fontSize: 20, color: Colors.white),
// textAlign: TextAlign.center,
// ),
// ),
// ),
// ],
// ),