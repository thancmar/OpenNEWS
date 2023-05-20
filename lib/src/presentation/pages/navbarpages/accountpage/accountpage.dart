import 'package:flutter/material.dart';
import 'package:sharemagazines_flutter/src/presentation/pages/navbarpages/accountpage/accountPage_widgets.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage>
    with
        SingleTickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<AccountPage> {
  double widget1Opacity = 0.0;
  //Count the amount of time the Hero animation
  AnimationController? controller;
  // Generating some dummy data

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement initState
    // super.initState();
    Future.delayed(Duration(milliseconds: 1), () {
      widget1Opacity = 1;
      setState(() {});
      controller = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 150),
      );
    });
  }

  // List<Map<String, dynamic>> _items = List.generate(
  //     20,
  //     (index) => {
  //           'id': index,
  //           'title': 'Item $index',
  //           'description':
  //               'This is the description of the item $index. There is nothing important here. In fact, it is meaningless.',
  //           'isExpanded': false
  //         });

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return SafeArea(
      child: Container(
        child: AccountPageWidgets(),
        // child: ListView(
        //   // shrinkWrap: true,
        //   padding: EdgeInsets.fromLTRB(20, 25, 20, 30),
        //   children: <Widget>[
        //     Padding(
        //       padding: EdgeInsets.fromLTRB(0, 0, 0, 25),
        //       child: AnimatedSize(
        //         vsync: this,
        //
        //         // opacity: widget1Opacity,
        //         duration: const Duration(milliseconds: 500),
        //         child: Container(
        //           decoration: BoxDecoration(
        //               boxShadow: [
        //                 BoxShadow(
        //                   color: Colors.grey.withOpacity(0.1),
        //                   spreadRadius: 1,
        //                   blurRadius: 0,
        //                   // offset: Offset(0, 3), // changes position of shadow
        //                 ),
        //               ],
        //               color: Colors.lightBlue,
        //               border: Border.all(
        //                   // color: Colors.red,
        //                   ),
        //               borderRadius: BorderRadius.circular(15)),
        //           // color: Colors.blue,
        //           padding: EdgeInsets.fromLTRB(10, 10, 10, 20),
        //           child: Column(
        //             crossAxisAlignment: CrossAxisAlignment.stretch,
        //             children: [
        //               Padding(
        //                 padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
        //                 child: Text(
        //                   'Herzlich Willkommen',
        //                   style: TextStyle(
        //                     fontSize: 16,
        //                     // fontWeight: FontWeight.bold,
        //                     color: Colors.white,
        //                   ),
        //                   textAlign: TextAlign.left,
        //                 ),
        //               ),
        //               Padding(
        //                 padding: EdgeInsets.fromLTRB(10, 0, 10, 20),
        //                 child: Text(
        //                   'Johanna Meister',
        //                   style: TextStyle(
        //                     fontSize: 24,
        //                     fontWeight: FontWeight.w500,
        //                     color: Colors.white,
        //                   ),
        //                   textAlign: TextAlign.left,
        //                 ),
        //               ),
        //               Padding(
        //                 padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
        //                 child: RichText(
        //                   text: TextSpan(children: [
        //                     WidgetSpan(
        //                         child: Icon(
        //                           Icons.account_box,
        //                           color: Colors.white,
        //                         ),
        //                         alignment: PlaceholderAlignment.middle),
        //                     TextSpan(
        //                       text: "My profile ",
        //                     ),
        //                   ]),
        //                 ),
        //               ),
        //             ],
        //           ),
        //         ),
        //       ),
        //     ),
        //     Padding(
        //       padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
        //       child: AnimatedOpacity(
        //         opacity: widget1Opacity,
        //         duration: const Duration(milliseconds: 850),
        //         child: Container(
        //           decoration: BoxDecoration(
        //               boxShadow: [
        //                 BoxShadow(
        //                   color: Colors.grey.withOpacity(0.1),
        //                   spreadRadius: 1,
        //                   blurRadius: 0,
        //                   // offset: Offset(0, 3), // changes position of shadow
        //                 ),
        //               ],
        //               color: Colors.transparent,
        //               border: Border.all(
        //                 color: Colors.white,
        //                 width: 0.25,
        //               ),
        //               borderRadius: BorderRadius.circular(10)),
        //           // color: Colors.blue,
        //           padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        //           child: ListTileTheme(
        //             minLeadingWidth: 0,
        //             child: const ExpansionTile(
        //               maintainState: true,
        //               controlAffinity: ListTileControlAffinity.platform,
        //               // textColor: Colors.red,
        //               backgroundColor: Colors.transparent,
        //               leading: Icon(
        //                 Icons.star,
        //                 color: Colors.white,
        //               ),
        //               trailing: Icon(
        //                 Icons.star,
        //                 color: Colors.transparent,
        //               ),
        //               title: Text(
        //                 'Rate Us',
        //                 style: TextStyle(
        //                   fontSize: 16,
        //                   // fontWeight: FontWeight.bold,
        //                   color: Colors.white,
        //                 ),
        //               ),
        //             ),
        //           ),
        //         ),
        //       ),
        //     ),
        //     Padding(
        //       padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
        //       child: Container(
        //         decoration: BoxDecoration(
        //             boxShadow: [
        //               BoxShadow(
        //                 color: Colors.grey.withOpacity(0.1),
        //                 spreadRadius: 1,
        //                 blurRadius: 0,
        //                 // offset: Offset(0, 3), // changes position of shadow
        //               ),
        //             ],
        //             color: Colors.transparent,
        //             border: Border.all(
        //               color: Colors.white,
        //               width: 0.25,
        //             ),
        //             borderRadius: BorderRadius.circular(10)),
        //         // color: Colors.blue,
        //         padding: EdgeInsets.fromLTRB(25, 0, 10, 0),
        //         child: ListTileTheme(
        //           contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        //           // horizontalTitleGap: 0.0,
        //           minLeadingWidth: 0,
        //           child: const ExpansionTile(
        //             // textColor: Colors.red,
        //             initiallyExpanded: true,
        //             leading: const Icon(
        //               Icons.settings,
        //               color: Colors.white,
        //             ),
        //             tilePadding: EdgeInsets.only(left: 0),
        //
        //             backgroundColor: Colors.transparent,
        //             title: Text(
        //               'Einstellungen',
        //               style: TextStyle(
        //                 fontSize: 16,
        //                 color: Colors.white,
        //               ),
        //             ),
        //             children: <Widget>[
        //               Padding(
        //                 padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
        //                 child: ListTile(
        //                     leading: const Icon(
        //                       Icons.lock,
        //                       color: Colors.white,
        //                     ),
        //                     minLeadingWidth: 10,
        //                     title: Text(
        //                       'Passwort ändern',
        //                       style: TextStyle(
        //                         fontSize: 16,
        //                         // fontWeight: FontWeight.bold,
        //                         color: Colors.white,
        //                       ),
        //                     )),
        //               ),
        //               Padding(
        //                 padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
        //                 child: ListTile(
        //                     leading: const Icon(
        //                       Icons.email,
        //                       color: Colors.white,
        //                     ),
        //                     minLeadingWidth: 10,
        //                     title: Text(
        //                       'E-Mail ändern',
        //                       style: TextStyle(
        //                         fontSize: 16,
        //                         color: Colors.white,
        //                       ),
        //                     )),
        //               ),
        //               Padding(
        //                 padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
        //                 child: ListTile(
        //                     leading: const Icon(
        //                       Icons.add_alert,
        //                       color: Colors.white,
        //                     ),
        //                     minLeadingWidth: 10,
        //                     title: Text(
        //                       'Benachrichtigungen',
        //                       style: TextStyle(
        //                         fontSize: 16,
        //                         color: Colors.white,
        //                       ),
        //                     )),
        //               ),
        //             ],
        //           ),
        //         ),
        //       ),
        //     ),
        //     Padding(
        //       padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
        //       child: Container(
        //         decoration: BoxDecoration(
        //             boxShadow: [
        //               BoxShadow(
        //                 color: Colors.grey.withOpacity(0.1),
        //                 spreadRadius: 1,
        //                 blurRadius: 0,
        //                 // offset: Offset(0, 3), // changes position of shadow
        //               ),
        //             ],
        //             color: Colors.transparent,
        //             border: Border.all(
        //               color: Colors.white,
        //               width: 0.25,
        //             ),
        //             borderRadius: BorderRadius.circular(10)),
        //         // color: Colors.blue,
        //         padding: EdgeInsets.fromLTRB(25, 0, 10, 0),
        //         child: ListTileTheme(
        //           contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        //           // horizontalTitleGap: 0.0,
        //           minLeadingWidth: 0,
        //           child: const ExpansionTile(
        //             initiallyExpanded: true,
        //             // textColor: Colors.red,
        //
        //             leading: const Icon(
        //               Icons.info_outline,
        //               color: Colors.white,
        //             ),
        //             tilePadding: EdgeInsets.only(left: 0),
        //
        //             backgroundColor: Colors.transparent,
        //             title: Text(
        //               'Informationen',
        //               style: TextStyle(
        //                 fontSize: 16,
        //                 color: Colors.white,
        //               ),
        //             ),
        //             children: <Widget>[
        //               Padding(
        //                 padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
        //                 child: ListTile(
        //                     leading: const Icon(
        //                       Icons.account_box,
        //                       color: Colors.white,
        //                     ),
        //                     minLeadingWidth: 10,
        //                     title: Text(
        //                       'Impressum',
        //                       style: TextStyle(
        //                         fontSize: 16,
        //                         // fontWeight: FontWeight.bold,
        //                         color: Colors.white,
        //                       ),
        //                     )),
        //               ),
        //               Padding(
        //                 padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
        //                 child: ListTile(
        //                     leading: const Icon(
        //                       Icons.lock,
        //                       color: Colors.white,
        //                     ),
        //                     minLeadingWidth: 10,
        //                     title: Text(
        //                       'Datenschutz',
        //                       style: TextStyle(
        //                         fontSize: 14,
        //                         color: Colors.white,
        //                       ),
        //                     )),
        //               ),
        //               Padding(
        //                 padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
        //                 child: ListTile(
        //                     leading: const Icon(
        //                       Icons.link,
        //                       color: Colors.white,
        //                     ),
        //                     minLeadingWidth: 10,
        //                     title: Text(
        //                       'AGB',
        //                       style: TextStyle(
        //                         fontSize: 16,
        //                         color: Colors.white,
        //                       ),
        //                     )),
        //               ),
        //               Padding(
        //                 padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
        //                 child: ListTile(
        //                     leading: const Icon(
        //                       Icons.help_outline_outlined,
        //                       color: Colors.white,
        //                     ),
        //                     minLeadingWidth: 10,
        //                     title: Text(
        //                       'Hilfe',
        //                       style: TextStyle(
        //                         fontSize: 16,
        //                         color: Colors.white,
        //                       ),
        //                     )),
        //               ),
        //               Padding(
        //                 padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
        //                 child: ListTile(
        //                     leading: const Icon(
        //                       Icons.call,
        //                       color: Colors.white,
        //                     ),
        //                     minLeadingWidth: 10,
        //                     title: Text(
        //                       'Kontakte',
        //                       style: TextStyle(
        //                         fontSize: 16,
        //                         color: Colors.white,
        //                       ),
        //                     )),
        //               ),
        //             ],
        //           ),
        //         ),
        //       ),
        //     ),
        //     Padding(
        //       padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
        //       child: Container(
        //         decoration: BoxDecoration(
        //             boxShadow: [
        //               BoxShadow(
        //                 color: Colors.grey.withOpacity(0.1),
        //                 spreadRadius: 1,
        //                 blurRadius: 0,
        //                 // offset: Offset(0, 3), // changes position of shadow
        //               ),
        //             ],
        //             color: Colors.transparent,
        //             border: Border.all(
        //               color: Colors.white,
        //               width: 0.25,
        //             ),
        //             borderRadius: BorderRadius.circular(10)),
        //         // color: Colors.blue,
        //         padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        //         child: ListTileTheme(
        //           minLeadingWidth: 0,
        //           child: const ExpansionTile(
        //             maintainState: true,
        //             controlAffinity: ListTileControlAffinity.platform,
        //             // textColor: Colors.red,
        //             backgroundColor: Colors.transparent,
        //             leading: Icon(
        //               Icons.logout,
        //               color: Colors.white,
        //             ),
        //             trailing: Icon(
        //               Icons.star,
        //               color: Colors.transparent,
        //             ),
        //             title: Text(
        //               'Abmelden',
        //               style: TextStyle(
        //                 fontSize: 16,
        //                 // fontWeight: FontWeight.bold,
        //                 color: Colors.white,
        //               ),
        //             ),
        //           ),
        //         ),
        //       ),
        //     ),
        //     Padding(
        //       padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
        //       child: Center(
        //         child: Column(
        //           children: [
        //             Text(
        //               "Version 2.01",
        //               style: TextStyle(
        //                 fontSize: 16,
        //                 color: Colors.white,
        //               ),
        //             ),
        //             Text(
        //               "Designed by 28apps Software GmbH",
        //               style: TextStyle(
        //                 fontSize: 12,
        //                 color: Colors.grey,
        //                 fontWeight: FontWeight.w300,
        //               ),
        //             ),
        //           ],
        //         ),
        //       ),
        //     )
        //   ],
        // ),
      ),
    );
  }
}
