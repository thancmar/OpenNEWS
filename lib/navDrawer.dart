// import 'package:flutter/material.dart';
//
// class NavDrawer extends StatefulWidget {
//   @override
//   State<NavDrawer> createState() => _NavDrawerState();
// }
//
// class _NavDrawerState extends State<NavDrawer> {
//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       elevation: 5,
//       child: Container(
//         width: 200,
//         height: 100,
//         decoration: BoxDecoration(
//           image: new DecorationImage(
//             image:
//                 AssetImage("assets/images/hintergrund-dunkel_iPhone6plus.png"),
//             fit: BoxFit.cover,
//           ),
//         ),
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: <Widget>[
//             const DrawerHeader(
//               child: Scaffold(backgroundColor: Colors.transparent),
//               decoration: BoxDecoration(
//                   //color: Colors.white,
//                   image: DecorationImage(
//                       //fit: BoxFit.fill,
//                       image: AssetImage('assets/images/logo@2x.png'))),
//             ),
//             ListTile(
//               leading: Icon(Icons.input),
//               title: Text('Bibliothek'),
//               onTap: () => {},
//             ),
//             ListTile(
//               leading: Icon(Icons.verified_user),
//               title: Text('Kategorien'),
//               onTap: () => {Navigator.of(context).pop()},
//             ),
//             ListTile(
//               leading: Icon(Icons.settings),
//               title: Text('Favoriten'),
//               onTap: () => {Navigator.of(context).pop()},
//             ),
//             ListTile(
//               leading: Icon(Icons.border_color),
//               title: Text('Lesezeichen'),
//               onTap: () => {Navigator.of(context).pop()},
//             ),
//             ListTile(
//               leading: Icon(Icons.exit_to_app),
//               title: Text('Locations'),
//               onTap: () => {Navigator.of(context).pop()},
//             ),
//             ListTile(
//               leading: Icon(Icons.exit_to_app),
//               title: Text('Mein Account'),
//               onTap: () => {Navigator.of(context).pop()},
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
