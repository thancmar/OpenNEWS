import 'dart:developer';
import 'dart:io';

import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sharemagazines_flutter/src/blocs/auth_bloc.dart';
import 'package:sharemagazines_flutter/src/blocs/map_bloc.dart';
import 'package:sharemagazines_flutter/src/blocs/navbar_bloc.dart';
import 'package:sharemagazines_flutter/src/presentation/pages/homepage.dart';
import 'package:sharemagazines_flutter/src/presentation/pages/startpage.dart';
import 'package:sharemagazines_flutter/src/presentation/pages/mappage.dart';
import 'package:sharemagazines_flutter/src/presentation/widgets/account.dart';
import 'package:sharemagazines_flutter/src/presentation/widgets/body_painter.dart';
import 'package:sharemagazines_flutter/src/presentation/widgets/bottomAppBar.dart';
import 'package:sharemagazines_flutter/src/presentation/widgets/locationAppbar.dart';
import 'package:sharemagazines_flutter/src/presentation/widgets/navbar_painter.dart';
import 'package:sharemagazines_flutter/src/resources/hotspot_repository.dart';
import 'package:sharemagazines_flutter/src/resources/magazine_repository.dart';

class MainPageState extends StatelessWidget {
  const MainPageState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => NavbarBloc(
            magazineRepository:
                RepositoryProvider.of<MagazineRepository>(context)),
        child: MainPage());
  }
}

class MainPage extends StatefulWidget {
  MainPage({Key? key}) : super(key: key);
  int num = 0;

  // final NavbarBloc _navbarBloc;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // NavbarBloc _navbarBloc = BlocProvider.of<NavbarBloc>(context);
  int selectedIndex = 0;
  GlobalKey _keyheight = GlobalKey();
  final controller = ScrollController();
  late OverlayEntry sticky;
  GlobalKey stickyKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    print("init");
    BlocProvider.of<NavbarBloc>(context).add(Home());
    // _navbarBloc = NavbarBloc();
  }

  @override
  void dispose() {
    // _navbarBloc.dispose();
    super.dispose();
  }

  void onClicked(int index) {
    if (index == 0) {
      print("emit");
      BlocProvider.of<NavbarBloc>(context).add(
        Home(),
      );
    } else if (index == 1) {
      BlocProvider.of<NavbarBloc>(context).add(
        Menu(),
      );
    } else if (index == 2) {
      print("aads");
      BlocProvider.of<NavbarBloc>(context).add(
        Map(),
      );
    } else if (index == 3) {
      print("emit");
      BlocProvider.of<NavbarBloc>(context).add(
        AccountEvent(),
      );
    }
  }

  // @override
  // Widget build(BuildContext context) {
  //   return BlocBuilder<NavbarBloc, NavbarState>(
  //     builder: (context, state) {
  //       if (state is GoToHome) {
  //         print("stateishome");
  //         // print(state.magazinePublishedGetLastWithLimit.response);
  //         return buildFlexibleSpace(0);
  //       } else if (state == GoToMenu()) {
  //         print("stateisMenu");
  //         return buildFlexibleSpace(1);
  //         print("stateisMenu");
  //       } else if (state == GoToMap()) {
  //         return buildFlexibleSpace(2);
  //       } else if (state == GoToAccount()) {
  //         return buildFlexibleSpace(3);
  //       }
  //       return buildFlexibleSpace(0);
  //     },
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavbarBloc, NavbarState>(builder: (context, state) {
      int currentIndex = state is GoToHome
          ? 0
          : state is GoToMenu
              ? 1
              : state is GoToMap
                  ? 2
                  : state is GoToAccount
                      ? 3
                      : 0;
      return Stack(
        children: <Widget>[
          new SvgPicture.asset(
            "assets/images/background_webreader.svg",
            fit: BoxFit.fill,
            allowDrawingOutsideViewBox: true,
          ),
          Scaffold(
            extendBodyBehindAppBar: true,
            // extendBody: true,
            appBar: currentIndex == 0 || currentIndex == 1
                ? PreferredSize(
                    preferredSize: const Size(0, 81),
                    child: Container(
                      // decoration: BoxDecoration(
                      //     border: Border.all(color: Colors.blueGrey),
                      //     borderRadius: BorderRadius.all(Radius.circular(20))),
                      margin: EdgeInsets.only(
                          left: 10, right: 10, top: 40, bottom: 10),
                      // padding: EdgeInsets.all(10),
                      padding: EdgeInsets.only(top: 20, bottom: 0),
                      child: ExpandableNotifier(
                        child: ScrollOnExpand(
                          child: ExpansionTile(
                            // onExpansionChanged: (bool expanding) =>
                            //     _onExpansion(expanding),
                            leading: Icon(
                              Icons.circle,
                              color: Colors.white,
                              size: 60,
                            ),
                            trailing: GestureDetector(
                              // onTap: ,
                              child: Icon(
                                Icons.search,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                            title: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      child: Text(
                                        "asd",
                                        // state.magazinePublishedGetLastWithLimit
                                        //     .response!.first.name!,
                                        style: TextStyle(
                                            fontSize: 18, color: Colors.white),
                                        // textAlign: TextAlign.left,
                                      ),
                                    ),
                                    Container(
                                      child: Text(
                                        "Infos zu deiner Location",
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w200),
                                        // textAlign: TextAlign.right,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            children: <Widget>[
                              SingleChildScrollView(
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.8,
                                  width: MediaQuery.of(context).size.width,
                                  child: Text(
                                    "data",
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // child: AppBar(
                    //   titleSpacing: 0,
                    //   leadingWidth: 80,
                    //   automaticallyImplyLeading: false,
                    //   backgroundColor: Colors.transparent,
                    //   leading: Icon(
                    //     Icons.circle,
                    //     color: Colors.white,
                    //     size: 60,
                    //   ),
                    //   title: Row(
                    //     children: [
                    //       Column(
                    //         crossAxisAlignment: CrossAxisAlignment.start,
                    //         mainAxisAlignment: MainAxisAlignment.center,
                    //         children: [
                    //           Container(
                    //             child: Text(
                    //               "asd",
                    //               // state.magazinePublishedGetLastWithLimit.response!.first
                    //               //     .name!,
                    //               style: TextStyle(fontSize: 18, color: Colors.white),
                    //               // textAlign: TextAlign.left,
                    //             ),
                    //           ),
                    //           Container(
                    //             child: Text(
                    //               "Infos zu deiner Location",
                    //               style: TextStyle(
                    //                   fontSize: 13,
                    //                   color: Colors.white,
                    //                   fontWeight: FontWeight.w200),
                    //               // textAlign: TextAlign.right,
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  )
                : null,
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                ClipPath(
                  clipper: BodyPainter(currentIndex, context, _keyheight),
                  // clipBehavior: Clip.hardEdge,
                  child: Container(
                    child: BlocBuilder<NavbarBloc, NavbarState>(
                        builder: (context, state) {
                      if (state is GoToHome || state is GoToMenu) {
                        // return LocationAppbar();
                        return SafeArea(child: HomePageState());
                        // } else if (state is GoToMenu) {
                        // return MenuPage();
                        return Container();
                      } else if (state is GoToMap) {
                        return MapsBlocWidget();
                      } else if (state is GoToAccount) {
                        return Account();
                      }
                      ;
                      return Container();
                    }),
                  ),
                ),
                ClipPath(
                  key: _keyheight,
                  clipper: NavBarClipper(currentIndex),
                  child: Container(
                      alignment: Alignment.bottomCenter,
                      key: _keyheight,
                      child: ClipPath(
                          key: _keyheight,
                          clipper: NavBarClipper(currentIndex),
                          child: CustomPaint(
                            painter: NavBarPainter(currentIndex),
                            child: BottomNavBarImp(
                              onClicked: onClicked,
                              selectedIndex: currentIndex,
                            ),
                          ))),
                ),
              ],
            ),
          )
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
