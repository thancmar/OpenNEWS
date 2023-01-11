import 'dart:async';

import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:sharemagazines_flutter/src/blocs/navbar/navbar_bloc.dart';
import 'package:sharemagazines_flutter/src/presentation/pages/navbarpages/homepage/homepage.dart';
import 'package:sharemagazines_flutter/src/presentation/pages/navbarpages/menupage.dart';
import 'package:sharemagazines_flutter/src/presentation/pages/navbarpages/homepage/searchpage.dart';
import 'package:sharemagazines_flutter/src/presentation/pages/navbarpages/mappage.dart';
import 'package:sharemagazines_flutter/src/presentation/pages/navbarpages/accountpage/accountpage.dart';
import 'package:sharemagazines_flutter/src/presentation/widgets/body_painter.dart';
import 'package:sharemagazines_flutter/src/presentation/widgets/bottomAppBar.dart';
import 'package:sharemagazines_flutter/src/presentation/widgets/SlidingAppBar.dart';
import 'package:sharemagazines_flutter/src/presentation/widgets/marquee.dart';
import 'package:sharemagazines_flutter/src/presentation/widgets/navbar_painter.dart';

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

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    //Dont know if this helps

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
                    : Scaffold(
                        // extendBodyBehindAppBar: currentIndex == 0 || currentIndex == 1 || currentIndex == 2 ? true : false,
                        extendBodyBehindAppBar: true,
                        // extendBody: true,
                        // appBar: currentIndex == 0 || currentIndex == 1
                        //     ? PreferredSize(
                        //         preferredSize: const Size(0, 56),
                        appBar: SlidingAppBar(
                          controller: _controller,
                          visible: currentIndex == 0 || currentIndex == 1 ? true : false,
                          child: AppBar(
                            backgroundColor: Colors.transparent,
                            elevation: 0,
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
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Container(
                                                height: 70,
                                                width: 70,
                                                // color: Colors.red,
                                                decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(0100), color: Colors.grey.withOpacity(0.2)),
                                              ),
                                              // child: Icon(
                                              //   Icons.circle,
                                              //   color: Colors.white,
                                              //   size: 80,
                                              // ),
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
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
                                                  Text(
                                                    "Infos zu deiner Location",
                                                    // overflow: TextOverflow.fade,
                                                    // softWrap: true,
                                                    style: TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w200),
// textAlign: TextAlign.right,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            // Spacer(),
                                            Padding(
                                              padding: EdgeInsets.only(left: 10),
                                              child: InkWell(
                                                onTap: () => {
                                                  if (mounted) {setState(() => showSearchPage = true)},
                                                  // setState(() {
                                                  //   showSearchPage = true;
                                                  // }),
                                                  print("before searchpage state $state"),
                                                  Navigator.push(
                                                    context,
                                                    PageRouteBuilder(
                                                      // transitionDuration:
                                                      // Duration(seconds: 2),

                                                      pageBuilder: (_, __, ___) {
                                                        // return StartSearch();

                                                        return SearchPage();
                                                      },
                                                      // maintainState: true,

                                                      // transitionDuration: Duration(milliseconds: 1000),
                                                      // transitionsBuilder: (context, animation, anotherAnimation, child) {
                                                      //   // animation = CurvedAnimation(curve: curveList[index], parent: animation);
                                                      //   return ScaleTransition(
                                                      //     scale: animation,
                                                      //     alignment: Alignment.topRight,
                                                      //     child: child,
                                                      //   );
                                                      // }
                                                    ),
                                                  ).then((_) {
                                                    // if (mounted) {
                                                    print("after searchpage state $state");

                                                    setState(() {
                                                      showSearchPage = false;
                                                    });
                                                    // }
                                                  })
                                                  // ).then((_) => setState(() {
                                                  //       showSearchPage = false;
                                                  //     }))
                                                },
                                                child: Hero(
                                                  tag: "search button",
                                                  child: Icon(
                                                    Icons.search_sharp,
                                                    // Icomoon.fc_logo,
                                                    color: Colors.white,
                                                    size: 40,
                                                  ),
                                                ),
                                              ),
                                            ),
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

                        backgroundColor: Colors.transparent,
                        body: Stack(
                          children: [
                            ClipPath(
                              clipper: BodyPainter(index: currentIndex, context: context, key: _keyheight),
                              // clipBehavior: Clip.hardEdge,
                              child: PageView(
                                controller: _pageController,
                                physics: NeverScrollableScrollPhysics(),
                                // physics: AlwaysScrollableScrollPhysics(),
                                children: _pages,
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