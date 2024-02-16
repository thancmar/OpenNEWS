import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_store/open_store.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sharemagazines/src/blocs/auth/auth_bloc.dart';
import 'package:sharemagazines/src/models/login_model.dart';
import 'package:sharemagazines/src/presentation/pages/mainpage.dart';
import 'package:sharemagazines/src/presentation/pages/navbarpages/accountpage/emalpwdreset.dart';
import 'package:sharemagazines/src/presentation/pages/navbarpages/accountpage/myprofilepage.dart';
import 'package:sharemagazines/src/resources/auth_repository.dart';

import '../../../../blocs/navbar/navbar_bloc.dart';
import '../../../../blocs/splash/splash_bloc.dart';
import '../../../../models/location_model.dart';
import '../../startpage.dart';

enum ResetType {
  email,
  password,
}

class AccountPageWidgets extends StatefulWidget {
  final PageController pageController;
  final Function onClick;

  const AccountPageWidgets({Key? key, required this.pageController, required this.onClick}) : super(key: key);

  @override
  State<AccountPageWidgets> createState() => _AccountPageWidgetsState();
}

class _AccountPageWidgetsState extends State<AccountPageWidgets> {
  late List<Locale> suporttedLanguages;
  String? appName;
  String? packageName;
  String? version ;
  String? buildNumber;

  @override
  void initState() {
    getAppVersion();
    super.initState();

    // suporttedLanguages = EasyLocalization.of(context)!.supportedLocales;
    // BlocProvider.of<searchBloc.SearchBloc>(context).add(searchBloc.Initialize(context));
  }

  Future<void> getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
     appName = packageInfo.appName;
     packageName = packageInfo.packageName;
     version = packageInfo.version;
     buildNumber = packageInfo.buildNumber;

    // Use the version and build number as needed
    print("App Name: $appName");
    print("Package Name: $packageName");
    print("Version: $version");
    print("Build Number: $buildNumber");
  }

  @override
  Widget build(BuildContext context) {
    suporttedLanguages = EasyLocalization.of(context)!.supportedLocales;
    Size size = MediaQuery.of(context).size;
    return ListView(
      // shrinkWrap: true,
      padding: EdgeInsets.fromLTRB(20, 0, 20, 30),
      children: <Widget>[
        BlocProvider.of<AuthBloc>(context).state is Authenticated
            // AuthState.userDetails?.response?.email?.isEmpty == false
            ? Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 25),
                child: InkWell(
                  borderRadius: BorderRadius.circular(15),
                  // overlayColor: MaterialStateProperty.resolveWith((states) {
                  //   // If the button is pressed, return green, otherwise blue
                  //   if (states.contains(MaterialState.pressed)) {
                  //     return Colors.green;
                  //   } else {
                  //     return Colors.blue;
                  //   }
                  // }),
                  // splashColor: Colors.red,
                  // focusColor: Colors.green,
                  onTap: () => {
                    Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (context) => MyProfile(),
                      ),
                    ),
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 0,
                            // offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                        color: Colors.lightBlue,
                        // color: Colors.transparent,
                        border: Border.all(
                            // color: Colors.red,
                            ),
                        borderRadius: BorderRadius.circular(15)),
                    // color: Colors.blue,
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
                          child: Text(
                            ("welcome").tr(),
                            style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.w300),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(10, 0, 10, 20),
                          child: Text(
                            "${AuthState.userDetails?.response?.firstname} ${AuthState.userDetails?.response?.lastname}",
                            // "Name",
                            // '${AuthState.userDetails?.response?.firstname} ${AuthState.userDetails?.response?.lastname}',
                            style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.w500),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min, // Use min to fit content size or max to fit full width as needed
                            children: [
                              Icon(
                                Icons.account_circle_outlined,
                                color: Colors.white,
                              ),
                              SizedBox(width: 8), // Adjust the width to control the space between the icon and the text
                              Text(
                                ("myProfile").tr(), // Replace with your .tr() method for localization
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : Container(),
        BlocProvider.of<AuthBloc>(context).state is! Authenticated
            // AuthState.userDetails?.response?.email?.isEmpty == true
            ? Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                child: AnimatedOpacity(
                  opacity: 1,
                  duration: const Duration(milliseconds: 850),
                  child: Container(
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 0,

                            // offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                        color: Colors.transparent,
                        border: Border.all(
                          color: Colors.white,
                          width: 0.25,
                        ),
                        borderRadius: BorderRadius.circular(10)),
                    // color: Colors.blue,
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: ListTileTheme(
                      minLeadingWidth: 0,
                      child: ExpansionTile(
                        maintainState: true,
                        onExpansionChanged: (isExpanded) async {
                          BlocProvider.of<AuthBloc>(context).add(Initialize());
                          // BlocProvider.of<NavbarBloc>(context).close();
                          // BlocProvider.of<NavbarBloc>(context).add(checkLocation());

                          // BlocProvider.of<NavbarBloc>(context).checkLocation().then((value) =>  BlocProvider.of<NavbarBloc>(context).add(Initialize123(currentPosition:NavbarState.appbarlocation)));

                          // BlocProvider.of<AuthBloc>(context).add(Initialize());
                          // Navigator.pushReplacement(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => new StartPage(
                          //       title: "notitle",
                          //     ),
                          //     // transitionDuration: Duration.zero,
                          //   ),
                          // );
                          // Navigator.of(context).push(
                          //   CupertinoPageRoute(
                          //     builder: (context) => const  StartPage(
                          //             title: "notitle",
                          //           ),
                          //   ),
                          //         // (Route<dynamic> route) => false
                          // );
                          var result = await Navigator.of(context).push(
                            CupertinoPageRoute(
                              builder: (context) => const StartPage(
                                title: "notitle",
                              ),
                            ),
                            // (Route<dynamic> route) => false
                          );

                          if (result == 'popped') {
                            print('The NextScreen was popped');
                            widget.onClick(0);
                            // widget.pageController.animateTo(1.0, duration: Duration(milliseconds: 100), curve: Curves.easeInOut);
                          }
                        },

                        controlAffinity: ListTileControlAffinity.platform,
                        // textColor: Colors.red,
                        backgroundColor: Colors.transparent,
                        leading: Icon(
                          Icons.login,
                          color: Colors.white,
                        ),
                        trailing: Icon(
                          Icons.star,
                          color: Colors.transparent,
                        ),
                        title: Text(
                          ("toLogin").tr(),
                          style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            : Container(),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
          child: AnimatedOpacity(
            opacity: 1,
            duration: const Duration(milliseconds: 850),
            child: Container(
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 0,
                      // offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                  color: Colors.transparent,
                  border: Border.all(
                    color: Colors.white,
                    width: 0.25,
                  ),
                  borderRadius: BorderRadius.circular(10)),
              // color: Colors.blue,
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: ListTileTheme(
                minLeadingWidth: 0,
                child: ExpansionTile(
                  maintainState: true,
                  controlAffinity: ListTileControlAffinity.platform,
                  // textColor: Colors.red,

                  backgroundColor: Colors.transparent,
                  //
                  onExpansionChanged: (isExpanded) {
                    OpenStore.instance.open(
                      // androidAppBundleId: "com.example.new_project",
                      appStoreId: "sharemagazinesSKU",
                    );
                  },
                  leading: Icon(
                    Icons.star,
                    color: Colors.white,
                  ),
                  trailing: Icon(
                    Icons.star,
                    color: Colors.transparent,
                  ),
                  title: Text(
                    ("rateUs").tr(),
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w400),
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
          child: Container(
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 0,
                    // offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
                color: Colors.transparent,
                border: Border.all(
                  color: Colors.white,
                  width: 0.25,
                ),
                borderRadius: BorderRadius.circular(10)),
            // color: Colors.blue,
            padding: EdgeInsets.fromLTRB(25, 0, 10, 0),
            child: ListTileTheme(
              contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              // horizontalTitleGap: 0.0,
              minLeadingWidth: 0,
              child: ExpansionTile(
                // textColor: Colors.red,
                initiallyExpanded: true,
                leading: const Icon(
                  Icons.settings,
                  color: Colors.white,
                ),
                tilePadding: EdgeInsets.only(left: 0),

                backgroundColor: Colors.transparent,
                title: Text(
                  ("settings").tr(),
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w400),
                ),
                children: <Widget>[
                  BlocProvider.of<AuthBloc>(context).state is Authenticated
                      // AuthState.userDetails?.response?.firstname != ''
                      ? Padding(
                          padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                          child: ListTile(
                              leading: const Icon(
                                Icons.lock,
                                color: Colors.white,
                              ),
                              minLeadingWidth: 10,
                              title: Text(
                                ("changePasword").tr(),
                                style: Theme.of(context).textTheme.titleMedium!,
                              )),
                        )
                      : Container(),
                  // BlocProvider.of<AuthBloc>(context).state is Authenticated
                  // AuthState.userDetails?.response?.firstname != ''
                  // ?
                  BlocProvider.of<AuthBloc>(context).state is Authenticated
                      ? Padding(
                          padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                          child: InkWell(
                            onTap: () => {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                    pageBuilder: (_, __, ___) => EmailPwdReset(resetType: ResetType.email),
                                    // transitionDuration: Duration(milliseconds: 500),
                                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                      const begin = Offset(0.0, 1.0);
                                      const end = Offset.zero;
                                      const curve = Curves.decelerate;
                                      final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                                      final offsetAnimation = animation.drive(tween);
                                      return SlideTransition(position: animation.drive(tween), child: child);
                                    }),
                              ),
                            },
                            child: ListTile(
                                leading: const Icon(
                                  Icons.email,
                                  color: Colors.white,
                                ),
                                minLeadingWidth: 10,
                                title: Text(
                                  'E-Mail ändern',
                                  style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w400),
                                )),
                          ),
                        )
                      : Container(),
                  // :Container(),
                  Padding(
                    padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                    child: ListTile(
                        onTap: () => {},
                        leading: const Icon(
                          Icons.add_alert,
                          color: Colors.white,
                        ),
                        minLeadingWidth: 10,
                        title: Text(
                          ("notifications").tr(),
                          style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w400),
                        )),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                    child: InkWell(
                      onTap: () => {
                        BlocProvider.of<NavbarBloc>(context).add(OpenLanguageSelection(
                            currentLocation: BlocProvider.of<NavbarBloc>(context).state.appbarlocation, languageOptions: suporttedLanguages))
                        // Navigator.pop(context, Department.treasury);
                        // SimpleDialog(
                        //   // <-- SEE HERE
                        //   title: const Text('Select Booking Type'),
                        //   children: <Widget>[
                        //     SimpleDialogOption(
                        //       onPressed: () {
                        //         Navigator.of(context).pop();
                        //       },
                        //       child: const Text('General'),
                        //     ),
                        //     SimpleDialogOption(
                        //       onPressed: () {
                        //         Navigator.of(context).pop();
                        //       },
                        //       child: const Text('Silver'),
                        //     ),
                        //     SimpleDialogOption(
                        //       onPressed: () {
                        //         Navigator.of(context).pop();
                        //       },
                        //       child: const Text('Gold'),
                        //     ),
                        //   ],
                        // )
                      },
                      child: ListTile(
                          leading: Icon(
                            Icons.language,
                            color: Colors.white,
                          ),
                          minLeadingWidth: 10,
                          title: Text(
                            ("language").tr(),
                            style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w400),
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
          child: Container(
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 0,
                    // offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
                color: Colors.transparent,
                border: Border.all(
                  color: Colors.white,
                  width: 0.25,
                ),
                borderRadius: BorderRadius.circular(10)),
            // color: Colors.blue,
            padding: EdgeInsets.fromLTRB(25, 0, 10, 0),
            child: ListTileTheme(
              contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              // horizontalTitleGap: 0.0,
              minLeadingWidth: 0,
              child: ExpansionTile(
                initiallyExpanded: true,
                // textColor: Colors.red,

                leading: const Icon(
                  Icons.info_outline,
                  color: Colors.white,
                ),
                tilePadding: EdgeInsets.only(left: 0),

                backgroundColor: Colors.transparent,
                title: Text(
                  ("information").tr(),
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w400),
                ),
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                    child: ListTile(
                        leading: Icon(
                          Icons.account_box,
                          color: Colors.white,
                        ),
                        minLeadingWidth: 10,
                        title: Text(
                          ("impressum").tr(),
                          style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w400),
                        )),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                    child: ListTile(
                        leading: Icon(
                          Icons.lock,
                          color: Colors.white,
                        ),
                        minLeadingWidth: 10,
                        title: Text(
                          ("datenschutz").tr(),
                          style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w400),
                        )),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                    child: ListTile(
                        leading: Icon(
                          Icons.link,
                          color: Colors.white,
                        ),
                        minLeadingWidth: 10,
                        title: Text(
                          ("agb").tr(),
                          style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w400),
                        )),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                    child: ListTile(
                        leading: const Icon(
                          Icons.help_outline_outlined,
                          color: Colors.white,
                        ),
                        minLeadingWidth: 10,
                        title: Text(
                          ("help").tr(),
                          style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w400),
                        )),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                    child: ListTile(
                        leading: const Icon(
                          Icons.call,
                          color: Colors.white,
                        ),
                        minLeadingWidth: 10,
                        title: Text(
                          ("contact").tr(),
                          style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w400),
                        )),
                  ),
                ],
              ),
            ),
          ),
        ),
        // Padding(
        //   padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
        //   child: Container(
        //     decoration: BoxDecoration(
        //         boxShadow: [
        //           BoxShadow(
        //             color: Colors.grey.withOpacity(0.1),
        //             spreadRadius: 1,
        //             blurRadius: 0,
        //             // offset: Offset(0, 3), // changes position of shadow
        //           ),
        //         ],
        //         color: Colors.transparent,
        //         border: Border.all(
        //           color: Colors.white,
        //           width: 0.25,
        //         ),
        //         borderRadius: BorderRadius.circular(10)),
        //     // color: Colors.blue,
        //
        //     padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        //     child: ListTile(
        //
        //         onTap: () => BlocProvider.of<AuthBloc>(context).add(
        //               SignOutRequested(),
        //             ),
        //         leading: const Icon(
        //           Icons.logout,
        //           color: Colors.white,
        //         ),
        //         minLeadingWidth: 10,
        //         title: Text(
        //           'Abmelden',
        //           style: TextStyle(
        //             fontSize: 16,
        //             color: Colors.white,
        //           ),
        //         )),
        //     // child: ListTileTheme(
        //     //   minLeadingWidth: 0,
        //     //   child: const ExpansionTile(
        //     //     maintainState: true,
        //     //     controlAffinity: ListTileControlAffinity.platform,
        //     //     // textColor: Colors.red,
        //     //     backgroundColor: Colors.transparent,
        //     //     leading: Icon(
        //     //       Icons.logout,
        //     //       color: Colors.white,
        //     //     ),
        //     //     trailing: Icon(
        //     //       Icons.star,
        //     //       color: Colors.transparent,
        //     //     ),
        //     //     title: Text(
        //     //       'Abmelden',
        //     //       style: TextStyle(
        //     //         fontSize: 16,
        //     //         // fontWeight: FontWeight.bold,
        //     //         color: Colors.white,
        //     //       ),
        //     //     ),
        //     //   ),
        //     // ),
        //   ),
        // ),
        BlocProvider.of<AuthBloc>(context).state is Authenticated
            // AuthState.userDetails?.response?.firstname != ''
            ? Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                child: AnimatedOpacity(
                  opacity: 1,
                  duration: const Duration(milliseconds: 850),
                  child: Container(
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 0,

                            // offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                        color: Colors.transparent,
                        border: Border.all(
                          color: Colors.white,
                          width: 0.25,
                        ),
                        borderRadius: BorderRadius.circular(10)),
                    // color: Colors.blue,
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: ListTileTheme(
                      minLeadingWidth: 0,
                      child: ExpansionTile(
                        maintainState: true,
                        onExpansionChanged: (isExpanded) {
                          BlocProvider.of<AuthBloc>(context).add(SignOutRequested());
                          // BlocProvider.of<NavbarBloc>(context).add(Initialize123(currentPosition: Data()));

                          // BlocProvider.of<NavbarBloc>(context).;
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StartPage(
                                title: "notitle",
                              ),
                              // transitionDuration: Duration.zero,
                            ),
                          );
                        },

                        controlAffinity: ListTileControlAffinity.platform,
                        // textColor: Colors.red,
                        backgroundColor: Colors.transparent,
                        leading: Icon(
                          Icons.logout,
                          color: Colors.white,
                        ),
                        trailing: Icon(
                          Icons.star,
                          color: Colors.transparent,
                        ),
                        title: Text(
                          ("logout").tr(),
                          style: Theme.of(context).textTheme.titleMedium!,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            : Container(),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
          child: Center(
            child: Column(
              children: [
                Text(
                  ("version").tr() + ( " $version ($buildNumber)" ),
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w400),
                ),
                Text(
                  ("designedBy").tr(),
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(color: Colors.grey, fontWeight: FontWeight.w100),
                ),
              ],
            ),
          ),

        ), Container(
          height: size.height * 0.05,
          color: Colors.transparent,
        )
      ],
    );
  }
}