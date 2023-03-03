import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sharemagazines_flutter/src/blocs/auth/auth_bloc.dart';
import 'package:sharemagazines_flutter/src/models/login_model.dart';
import 'package:sharemagazines_flutter/src/presentation/pages/navbarpages/accountpage/myprofilepage.dart';
import 'package:sharemagazines_flutter/src/resources/auth_repository.dart';

class AccountPageWidgets extends StatefulWidget {
  const AccountPageWidgets({Key? key}) : super(key: key);

  @override
  State<AccountPageWidgets> createState() => _AccountPageWidgetsState();
}

class _AccountPageWidgetsState extends State<AccountPageWidgets> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      // shrinkWrap: true,
      padding: EdgeInsets.fromLTRB(20, 0, 20, 30),
      children: <Widget>[
        AuthState.userDetails?.response?.firstname != null
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
                    Navigator.of(context).push(PageRouteBuilder(
                      // transitionDuration:
                      // Duration(seconds: 2),

                      pageBuilder: (_, __, ___) {
                        // return StartSearch();

                        return MyProfile();
                      },
                    ))
                  },
                  child: AnimatedSize(
                    // vsync: this,

                    // opacity: widget1Opacity,
                    duration: const Duration(milliseconds: 500),

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
                              'Herzlich Willkommen',
                              style: TextStyle(
                                fontSize: 16,
                                // fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(10, 0, 10, 20),
                            child: Text(
                              '${AuthState.userDetails?.response?.firstname} ${AuthState.userDetails?.response?.lastname}',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                            child: RichText(
                              text: TextSpan(children: [
                                WidgetSpan(
                                    child: Icon(
                                      Icons.account_circle_outlined,
                                      color: Colors.white,
                                    ),
                                    alignment: PlaceholderAlignment.middle),
                                TextSpan(
                                  text: "My profile ",
                                ),
                              ]),
                            ),
                          ),
                        ],
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
                      color: Colors.grey.withOpacity(0.1),
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
                child: const ExpansionTile(
                  maintainState: true,
                  controlAffinity: ListTileControlAffinity.platform,
                  // textColor: Colors.red,
                  backgroundColor: Colors.transparent,
                  leading: Icon(
                    Icons.star,
                    color: Colors.white,
                  ),
                  trailing: Icon(
                    Icons.star,
                    color: Colors.transparent,
                  ),
                  title: Text(
                    'Rate Us',
                    style: TextStyle(
                      fontSize: 16,
                      // fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
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
                    color: Colors.grey.withOpacity(0.1),
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
                  'Einstellungen',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                    child: ListTile(
                        leading: const Icon(
                          Icons.lock,
                          color: Colors.white,
                        ),
                        minLeadingWidth: 10,
                        title: Text(
                          'Passwort ändern',
                          style: TextStyle(
                            fontSize: 16,
                            // fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        )),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                    child: ListTile(
                        leading: const Icon(
                          Icons.email,
                          color: Colors.white,
                        ),
                        minLeadingWidth: 10,
                        title: Text(
                          'E-Mail ändern',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        )),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                    child: ListTile(
                        leading: const Icon(
                          Icons.add_alert,
                          color: Colors.white,
                        ),
                        minLeadingWidth: 10,
                        title: Text(
                          'Benachrichtigungen',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        )),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                    child: GestureDetector(
                      onTap: () => {
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
                            'Sprache',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
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
                    color: Colors.grey.withOpacity(0.1),
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
              child: const ExpansionTile(
                initiallyExpanded: true,
                // textColor: Colors.red,

                leading: const Icon(
                  Icons.info_outline,
                  color: Colors.white,
                ),
                tilePadding: EdgeInsets.only(left: 0),

                backgroundColor: Colors.transparent,
                title: Text(
                  'Informationen',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                    child: ListTile(
                        leading: const Icon(
                          Icons.account_box,
                          color: Colors.white,
                        ),
                        minLeadingWidth: 10,
                        title: Text(
                          'Impressum',
                          style: TextStyle(
                            fontSize: 16,
                            // fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        )),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                    child: ListTile(
                        leading: const Icon(
                          Icons.lock,
                          color: Colors.white,
                        ),
                        minLeadingWidth: 10,
                        title: Text(
                          'Datenschutz',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        )),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                    child: ListTile(
                        leading: const Icon(
                          Icons.link,
                          color: Colors.white,
                        ),
                        minLeadingWidth: 10,
                        title: Text(
                          'AGB',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
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
                          'Hilfe',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
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
                          'Kontakte',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        )),
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
                    color: Colors.grey.withOpacity(0.1),
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
            child: ListTile(
                onTap: () => BlocProvider.of<AuthBloc>(context).add(
                      SignOutRequested(),
                    ),
                leading: const Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
                minLeadingWidth: 10,
                title: Text(
                  'Abmelden',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                )),
            // child: ListTileTheme(
            //   minLeadingWidth: 0,
            //   child: const ExpansionTile(
            //     maintainState: true,
            //     controlAffinity: ListTileControlAffinity.platform,
            //     // textColor: Colors.red,
            //     backgroundColor: Colors.transparent,
            //     leading: Icon(
            //       Icons.logout,
            //       color: Colors.white,
            //     ),
            //     trailing: Icon(
            //       Icons.star,
            //       color: Colors.transparent,
            //     ),
            //     title: Text(
            //       'Abmelden',
            //       style: TextStyle(
            //         fontSize: 16,
            //         // fontWeight: FontWeight.bold,
            //         color: Colors.white,
            //       ),
            //     ),
            //   ),
            // ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
          child: Center(
            child: Column(
              children: [
                Text(
                  "Version 2.01",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                Text(
                  "Designed by 28apps Software GmbH",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}