import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sharemagazines_flutter/src/presentation/pages/player/PlayerbottomnavbarImp.dart';
import 'package:sharemagazines_flutter/src/presentation/pages/player/playerbodypainter.dart';
import 'package:sharemagazines_flutter/src/presentation/pages/player/playernavbarclipper.dart';
import 'package:sharemagazines_flutter/src/resources/hotspot_repository.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../../../blocs/player/player_bloc.dart';
import '../../../blocs/reader/reader_bloc.dart';
import '../../widgets/navbar/body_clipper.dart';
import '../../widgets/navbar/custom_navbar.dart';
import '../../widgets/marquee.dart';
import '../../widgets/navbar/navbar_painter_clipper.dart';

class StartPlayer extends StatelessWidget {
  const StartPlayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) => PlayerBloc(
            hotspotRepository:
                RepositoryProvider.of<HotspotRepository>(context)),
        child: Player());
  }
}

class Player extends StatefulWidget {
  const Player({Key? key}) : super(key: key);

  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  GlobalKey _keyheight = GlobalKey();
  @override
  void initState() {
    // SchedulerBinding.instance.addPostFrameCallback((_) async {
    //   Timer(Duration(seconds: 5), () {
    //     setState(() {
    //       transformationController.value = Matrix4.identity()
    //         ..translate(800, 0.0);
    //       transformationController.toScene(Offset(800, 0.0));
    //     });
    //   });
    // });
    super.initState();
    // print(widget.id);
    BlocProvider.of<PlayerBloc>(context).add(
      OpenPlayer(),
    );

    // controller.addListener(zoomListener);
  }

  void onClicked(int index) {
    print("mainpage onclicked");
    // if (showSearchPage == false) {
    //   setState(() {
    //     _pageController.animateToPage(index, duration: Duration(milliseconds: 300), curve: Curves.ease);
    //   });
    // }
    print(index);
    // if (index == 0) {
    //   print("home page bloc add");
    //   BlocProvider.of<PlayerBloc>(context).add(
    //
    //   );
    // } else if (index == 1) {
    //   print("menu page bloc add");
    //   BlocProvider.of<PlayerBloc>(context).add(
    //     Menu(),
    //   );
    // }
    // else if (index == 2) {
    //   print("Mappage bloc add");
    //   BlocProvider.of<PlayerBloc>(context).add(
    //     Map(),
    //   );
    // } else if (index == 3) {
    //   print("Account page bloc add");
    //   BlocProvider.of<PlayerBloc>(context).add(
    //     AccountEvent(),
    //   );
    // }
    // else if (index == 4) {
    //   print("Account page bloc add");
    //   BlocProvider.of<NavbarBloc>(context).add(
    //     Search(),
    //   );
    // }
  }

  @override
  Widget build(BuildContext context) {
    // super.build(context);

    return BlocBuilder<PlayerBloc, PlayerState>(
        builder: (BuildContext context, state) {
      int currentIndex = state is PlayerOpened //|| state is HomeLoaded
          ? 0
          // : state is GoToMenu
          //     ? 1
          //     : state is GoToMap
          //         ? 2
          //         : state is GoToAccount
          //             ? 3
          //             : state is GoToSearch
          //                 ? 4
          : 0;
      print("Mainpage blocbuilder");
      // BlocProvider.of<searchBloc.SearchBloc>(context).add(searchBloc.Initialize(context));
      // int currentIndex = 0;
      // print(state.access_location.data!.isNotEmpty);
      return Stack(
        children: <Widget>[
          // new SvgPicture.asset(
          //   "assets/images/background_webreader.svg",
          //   fit: BoxFit.fill,
          //   allowDrawingOutsideViewBox: true,
          // ),
          DecoratedBox(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/background/Background.png"),
                  fit: BoxFit.cover),
            ),
            child: Center(
                child: Scaffold(
              extendBodyBehindAppBar: true,
              // extendBody: false,
              extendBody: true,
              appBar: AppBar(
                leading: IconButton(
                  icon: Icon(
                    Icons.navigate_before_outlined,
                    size: 30,
                  ),
                  // onPressed: () => {Navigator.of(context).popUntil((route) => route.isFirst), widget.bloc.add(CloseReader())},
                  onPressed: () => {Navigator.of(context).pop(true)},
                ),
                title: MarqueeWidget(
                  // child: Text("sfd"),
                  // child: Text(widget.reader.readerTitle ?? "Title"),
                  child: Text("Title"),
                  direction: Axis.horizontal,
                  // pauseDuration: Duration(milliseconds: 100),
                  // animationDuration: Duration(seconds: 2),
                  // backDuration: Duration(seconds: 1),
                ),
                actionsIconTheme: IconThemeData(
                  size: 25,
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Icon(Icons.add),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Icon(Icons.bookmark_border),
                  )
                ],
                // titleSpacing: 0,
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              // appBar: currentIndex == 0 || currentIndex == 1
              //     ? PreferredSize(
              //         preferredSize: const Size(0, 56),
              // appBar:
//                     AppBar(
//                       backgroundColor: Colors.transparent,
//                       elevation: 0,
//                       // toolbarOpacity: currentIndex == 0 || currentIndex == 1 ? 0 : 0,
//                       // toolbarHeight: (currentIndex == 0 || currentIndex == 1 && !showSearchPage) ? 100 : 0,
//       toolbarHeight: 100,
//                       flexibleSpace: SafeArea(
//                         child: Container(
//                           margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
//                           child: ExpandableNotifier(
//                             child: ScrollOnExpand(
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: <Widget>[
//                                   Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: Icon(
//                                       Icons.circle,
//                                       color: Colors.white,
//                                       size: 80,
//                                     ),
//                                   ),
//                                   Expanded(
//                                     child: Column(
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       mainAxisAlignment: MainAxisAlignment.center,
//                                       children: [
//                                         MarqueeWidget(
//                                           child: Text(
//                                             // state.access_location.data!.isNotEmpty ==
//                                             //         true
//                                             //     ? "sdf"
//                                             //     : "sdf",
//                                             // "Weser kurier",
//                                             state is GoToHome
//                                                 ? state.location?.data[0].nameApp ?? "Please pull down"
//                                                 : state is GoToMenu
//                                                 ? state.location?.data![0].nameApp ?? "Please pull down"
//                                                 : "${state}",
// // state.magazinePublishedGetLastWithLimit
// //     .response!.first.name!,
// //                                         overflow: TextOverflow.e,
// //                                         softWrap: true,
// //                                         maxLines: 1,
//                                             style: TextStyle(fontFamily: 'Raleway', fontSize: 22, color: Colors.white),
// // textAlign: TextAlign.left,
//                                           ),
//                                         ),
//                                         Text(
//                                           "Infos zu deiner Location",
//                                           // overflow: TextOverflow.fade,
//                                           // softWrap: true,
//                                           style: TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w200),
// // textAlign: TextAlign.right,
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   // Spacer(),
//                                   Padding(
//                                     padding: EdgeInsets.only(left: 10),
//                                     child: InkWell(
//                                       onTap: () => {
//                                         if (mounted) {setState(() => showSearchPage = true)},
//                                         // setState(() {
//                                         //   showSearchPage = true;
//                                         // }),
//                                         print("before searchpage state $state"),
//                                         Navigator.push(
//                                           context,
//                                           PageRouteBuilder(
//                                             // transitionDuration:
//                                             // Duration(seconds: 2),
//
//                                             pageBuilder: (_, __, ___) {
//                                               // return StartSearch();
//
//                                               return SearchPage();
//                                             },
//                                             // maintainState: true,
//
//                                             // transitionDuration: Duration(milliseconds: 1000),
//                                             // transitionsBuilder: (context, animation, anotherAnimation, child) {
//                                             //   // animation = CurvedAnimation(curve: curveList[index], parent: animation);
//                                             //   return ScaleTransition(
//                                             //     scale: animation,
//                                             //     alignment: Alignment.topRight,
//                                             //     child: child,
//                                             //   );
//                                             // }
//                                           ),
//                                         ).then((_) {
//                                           // if (mounted) {
//                                           print("after searchpage state $state");
//
//                                           setState(() {
//                                             showSearchPage = false;
//                                           });
//                                           // }
//                                         })
//                                         // ).then((_) => setState(() {
//                                         //       showSearchPage = false;
//                                         //     }))
//                                       },
//                                       child: Hero(
//                                         tag: "search button",
//                                         child: Icon(
//                                           Icons.search_sharp,
//                                           color: Colors.white,
//                                           size: 40,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
              // ),
              // ),

              backgroundColor: Colors.transparent,
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
              floatingActionButton: Padding(
                // padding: const EdgeInsets.only(bottom: _keyheight.currentContext?.size?.height ?? 0.0),
                padding: EdgeInsets.only(bottom: 15),

                child: Container(
                  height: 70.0,
                  width: 70.0,
                  child: FittedBox(
                    child: FloatingActionButton(
                      onPressed: () {},
                      tooltip: 'Play',
                      child: Icon(
                        Icons.play_arrow,
                        size: 40,
                      ),
                      elevation: 2.0,
                    ),
                  ),
                ),
              ),

              body: Stack(
                children: [
                  ClipPath(
                    clipper: PlayerBodyPainter(
                        index: currentIndex, context: context, key: _keyheight),
                    // clipBehavior: Clip.hardEdge,
                    child: PageView(
                      // controller: _pageController,
                      physics: NeverScrollableScrollPhysics(),
                      // physics: AlwaysScrollableScrollPhysics(),
                      // children: _pages,
                    ),
                  ),
                  // BottomAppBar(
                  //   child: CustomPaint(
                  //     painter: PlayerNavBarPainter(),
                  //     // painter: NavBarPainter(1),
                  //     child: BottomNavBarImp(
                  //       onClicked: onClicked,
                  //       selectedIndex: currentIndex,
                  //     ),
                  //   ),
                  //   notchMargin: 100,
                  //   // clipBehavior: ,
                  //   // shape: AutomaticNotchedShape(OutlineInputBorder(borderSide: BorderSide(color: Colors.red, width: 50), borderRadius: BorderRadius.only(topLeft: Radius.circular(50.0))),
                  //   //     OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 5), borderRadius: BorderRadius.all(Radius.circular(50.0)))),
                  //   //   shape: AutomaticNotchedShape(
                  //   //       RoundedRectangleBorder(
                  //   //         borderRadius: BorderRadius.only(
                  //   //           topLeft: Radius.circular(25),
                  //   //           topRight: Radius.circular(25),
                  //   //           bottomRight: Radius.circular(25),
                  //   //           bottomLeft: Radius.circular(25),
                  //   //         ),
                  //   //       ),
                  //   //       AutomaticNotchedShape()
                  //   //       // OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 5), borderRadius: BorderRadius.all(Radius.circular(50.0)))),
                  //   //   color: Colors.blueGrey,
                  // ),
                  Container(
                      alignment: Alignment.bottomCenter,
                      //key: _keyheight,
                      child: ClipPath(
                          key: _keyheight,
                          clipper: PlayerNavBarClipper(currentIndex),
                          child: CustomPaint(
                            painter: PlayerNavBarPainter(),
                            child: PlayerBottomNavBarImp(
                              onClicked: onClicked,
                              selectedIndex: currentIndex,
                            ),
                          )))
                  // ClipPath(
                  //   // clipper: BodyPainter(currentIndex, context, _keyheight),
                  //
                  //   clipper: BodyPainter(2, context, _keyheight),
                  //   // clipBehavior: Clip.hardEdge,
                  //   child: PageView(
                  //     // controller: _pageController,
                  //     physics: NeverScrollableScrollPhysics(),
                  //     // physics: AlwaysScrollableScrollPhysics(),
                  //     // children: _pages,
                  //   ),
                  // ),
                  // currentIndex != 4
                  // Container(
                  //     alignment: Alignment.bottomCenter,
                  //     //key: _keyheight,
                  //     child: ClipPath(
                  //         key: _keyheight,
                  //         clipper: PlayerNavBarClipper(0),
                  //         child: CustomPaint(
                  //           painter: PlayerNavBarPainter(),
                  //           // painter: NavBarPainter(1),
                  //           child: BottomNavBarImp(
                  //             onClicked: onClicked,
                  //             selectedIndex: currentIndex,
                  //           ),
                  //         )))
                  // : Container(),
                ],
              ),
            )),
          ),
        ],
      );
    });
  }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         decoration: BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage("assets/images/Background.png"),
//             fit: BoxFit.fill,
//           ),
//         ),
//         child: Scaffold(
//           extendBodyBehindAppBar: true,
//           backgroundColor: Colors.transparent,
//           appBar: AppBar(
//             backgroundColor: Colors.transparent,
//             elevation: 0,
//             automaticallyImplyLeading: false,
//             // toolbarHeight: 100,
//             title: Row(
//               // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: <Widget>[
//                 Container(
//                   width: 35,
//                   color: Colors.transparent,
//                   child: InkWell(
//                     onTap: () {
//                       // BlocProvider.of<SearchBloc>(context).add(OpenSearch());
//                       Navigator.pop(context);
//                     },
//                     child: Padding(
//                       padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
//                       child: Icon(
//                         Icons.arrow_back_ios,
//                         color: Colors.white,
//                         size: 30,
//                       ),
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: Container(
//                       padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
//                       child: Text(
//                         "My Profile",
//                         // textAlign: TextAlign.center,
//                       )),
//                 )
//               ],
//             ),
//           ),
//           body: SafeArea(
//               child: Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 5.0),
//                 child: TextFormField(
//                   // controller: _firstnameController,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'This is the required field';
//                     }
//                     return null;
//                   },
//                   style: TextStyle(color: Colors.white),
//                   decoration: InputDecoration(
//                     //Maybe we need it
//                     // contentPadding: const EdgeInsets.symmetric(
//                     //     vertical: 20.0, horizontal: 10.0),
//                     floatingLabelStyle: TextStyle(color: Colors.blue),
//                     labelText: "Vorname",
//                     labelStyle: TextStyle(fontSize: 16.0, color: Colors.grey, fontWeight: FontWeight.w300), //, height: 3.8),
//                     border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 5), borderRadius: BorderRadius.all(Radius.circular(10.0))),
//                     errorBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10.0)), borderSide: BorderSide(color: Colors.red, width: 1)),
//                     enabledBorder: const OutlineInputBorder(
//                       borderSide: const BorderSide(color: Colors.grey, width: 1.0),
//                       borderRadius: BorderRadius.all(Radius.circular(10.0)),
//                     ),
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
//                 child: TextFormField(
//                   // controller: _firstnameController,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'This is the required field';
//                     }
//                     return null;
//                   },
//                   style: TextStyle(color: Colors.white),
//                   decoration: InputDecoration(
//                     //Maybe we need it
//                     // contentPadding: const EdgeInsets.symmetric(
//                     //     vertical: 20.0, horizontal: 10.0),
//                     floatingLabelStyle: TextStyle(color: Colors.blue),
//                     labelText: "Nachname",
//                     labelStyle: TextStyle(fontSize: 16.0, color: Colors.grey, fontWeight: FontWeight.w300), //, height: 3.8),
//                     border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 5), borderRadius: BorderRadius.all(Radius.circular(10.0))),
//                     errorBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10.0)), borderSide: BorderSide(color: Colors.red, width: 1)),
//                     enabledBorder: const OutlineInputBorder(
//                       borderSide: const BorderSide(color: Colors.grey, width: 1.0),
//                       borderRadius: BorderRadius.all(Radius.circular(10.0)),
//                     ),
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 10.0),
//                 child: TextFormField(
//                   // controller: _calenderController,
//                   // onTap: () => _selectDate(context),
//                   // validator: (value) => validateEmail(value),
//                   style: TextStyle(color: Colors.white),
//
//                   decoration: InputDecoration(
//                     // suffixIcon: IconButton(
//                     //   icon: Icon(Icons.calendar_today_outlined, color: Colors.grey),
//                     //   // onPressed: () => _selectDate(context),
//                     // ),
//                     floatingLabelStyle: TextStyle(color: Colors.blue),
//                     labelText: "Geburtsdatum",
//                     labelStyle: TextStyle(fontSize: 16.0, color: Colors.grey), //, height: 3.8),
//                     border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 5), borderRadius: BorderRadius.all(Radius.circular(10.0))),
//                     errorBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(1.0)), borderSide: BorderSide(color: Colors.red, width: 1)),
//                     enabledBorder: const OutlineInputBorder(
//                       borderSide: const BorderSide(color: Colors.grey, width: 1.0),
//                       borderRadius: BorderRadius.all(Radius.circular(10.0)),
//                     ),
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
//                 child: Align(
//                   alignment: Alignment.centerLeft,
//                   child: Text(
//                     "Gender",
//                     style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300, fontSize: 16),
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
//                 child: Container(
//                   alignment: Alignment.center,
//                   padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
//                   decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(10)),
//                   child: ToggleSwitch(
//                     minWidth: 90.0,
//                     dividerColor: Colors.transparent,
//                     inactiveBgColor: Colors.transparent,
//                     initialLabelIndex: 0,
//                     totalSwitches: 3,
//                     radiusStyle: true,
//                     inactiveFgColor: Colors.white,
//                     labels: ['America', 'Canada', 'Mexico'],
//                     onToggle: (index) {
//                       print('switched to: $index');
//                     },
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(20.0, 20, 20.0, 20.0),
//                 child: ElevatedButton(
//                   onPressed: () {
//                     // Navigator.pushReplacement(
//                     //   context,
//                     //   PageRouteBuilder(
//                     //     pageBuilder:
//                     //         (context, animation1, animation2) =>
//                     //             LoginPage(
//                     //       title: 'Login',
//                     //     ),
//                     //     transitionDuration: Duration.zero,
//                     //   ),
//                     // );
//                     // FirebaseAuth.instance
//                     //     .authStateChanges()
//                     //     .listen((User? user) {
//                     //   if (user == null) {
//                     //     print('User is currently signed out!');
//                     //   } else {
//                     //     print('User is signed in!');
//                     //   }
//                     // });
//                     // _authenticateWithEmailAndPassword(context);
//                   },
//                   style: ElevatedButton.styleFrom(
//                     onPrimary: Colors.white,
//                     shadowColor: Colors.blueAccent,
//                     elevation: 3,
//                     // side: BorderSide(width: 0.10, color: Colors.white),
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)),
//                     minimumSize: Size(300, 60), //////// HERE
//                   ),
//                   child: Text(
//                     "Speichern",
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.w400,
//                       fontSize: 18,
//                       //fontStyle: FontStyle.,
//                     ),
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 25.0),
//                 child: ElevatedButton(
//                   onPressed: () {
//                     // Navigator.pushReplacement(
//                     //   context,
//                     //   PageRouteBuilder(
//                     //     pageBuilder:
//                     //         (context, animation1, animation2) =>
//                     //             LoginPage(
//                     //       title: 'Login',
//                     //     ),
//                     //     transitionDuration: Duration.zero,
//                     //   ),
//                     // );
//                     // FirebaseAuth.instance
//                     //     .authStateChanges()
//                     //     .listen((User? user) {
//                     //   if (user == null) {
//                     //     print('User is currently signed out!');
//                     //   } else {
//                     //     print('User is signed in!');
//                     //   }
//                     // });
//                     // _authenticateWithEmailAndPassword(context);
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.redAccent,
//                     // onPrimary: Colors.redAccent,
//                     // shadowColor: Colors.redAccent,
//                     elevation: 3,
//                     // side: BorderSide(width: 0.10, color: Colors.white),
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)),
//                     minimumSize: Size(300, 60), //////// HERE
//                   ),
//                   child: Text(
//                     "Meinen Account löschen",
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.w400,
//                       fontSize: 18,
//                       //fontStyle: FontStyle.,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           )),
//           floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//           floatingActionButton: FloatingActionButton(
//             onPressed: () {},
//             tooltip: 'Increment',
//             child: Icon(Icons.add),
//             elevation: 2.0,
//           ),
//           bottomNavigationBar: BottomAppBar(
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: <Widget>[
//                 IconButton(icon: Icon(Icons.home), onPressed: () {}),
//                 IconButton(icon: Icon(Icons.search), onPressed: () {}),
//                 SizedBox(width: 40), // The dummy child
//                 IconButton(icon: Icon(Icons.notifications), onPressed: () {}),
//                 IconButton(icon: Icon(Icons.message), onPressed: () {}),
//               ],
//             ),
//             notchMargin: 10,
//             // clipBehavior: ,
//             // shape: AutomaticNotchedShape(OutlineInputBorder(borderSide: BorderSide(color: Colors.red, width: 50), borderRadius: BorderRadius.only(topLeft: Radius.circular(50.0))),
//             //     OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 5), borderRadius: BorderRadius.all(Radius.circular(50.0)))),
//             //   shape: AutomaticNotchedShape(
//             //       RoundedRectangleBorder(
//             //         borderRadius: BorderRadius.only(
//             //           topLeft: Radius.circular(25),
//             //           topRight: Radius.circular(25),
//             //           bottomRight: Radius.circular(25),
//             //           bottomLeft: Radius.circular(25),
//             //         ),
//             //       ),
//             //       AutomaticNotchedShape()
//             //       // OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 5), borderRadius: BorderRadius.all(Radius.circular(50.0)))),
//             //   color: Colors.blueGrey,
//           ),
// //           bottomNavigationBar: BottomNavigationBar(
// //               // withd: MediaQuery.of(context).padding.bottom;
// //               type: BottomNavigationBarType.fixed, //Helps with the Transparent Bug
// //               backgroundColor: Colors.transparent,
// // // backgroundColor: Theme.of(context).copyWith(splashColor: Colors.yellow),,
// //               elevation: 1,
// //
// //               // backgroundColor: Color(0x00ffffff),
// //               showSelectedLabels: false,
// //               selectedItemColor: Colors.blue,
// //               showUnselectedLabels: false,
// //               // currentIndex: selectedIndex,
// //               // onTap: onClicked,
// //
// //               items: <BottomNavigationBarItem>[
// //                 BottomNavigationBarItem(
// //                   icon: Icon(Icons.home, color: Colors.white),
// //                   label: 'Home',
// //                 ),
// //                 BottomNavigationBarItem(
// //                   icon: Icon(
// //                     Icons.open_in_new_rounded,
// //                     color: Colors.white,
// //                   ),
// //                   label: 'Open Dialog',
// //                 ),
// //                 BottomNavigationBarItem(
// //                   icon: Icon(
// //                     Icons.open_in_new_rounded,
// //                     color: Colors.white,
// //                   ),
// //                   label: 'Open Dialog',
// //                 ),
// //                 BottomNavigationBarItem(
// //                   icon: Icon(
// //                     Icons.open_in_new_rounded,
// //                     color: Colors.white,
// //                   ),
// //                   label: 'Open Dialog',
// //                 ),
// //               ]),
//         ));
//   }
}
