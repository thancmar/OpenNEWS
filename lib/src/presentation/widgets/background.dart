// import 'package:flutter/material.dart';
//
// class ScaffoldWithBackground extends StatelessWidget {
//   final Widget child;
//
//   ScaffoldWithBackground({required this.child});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Container(
//             width: MediaQuery.of(context).size.width,
//             height: MediaQuery.of(context).size.height,
//             decoration: BoxDecoration(
//                 color: Colors.black,
//                 image: DecorationImage(
//                   image: AssetImage('assets/images/background.png'),
//                   fit: BoxFit.cover,
//                   colorFilter: new ColorFilter.mode(
//                       Colors.black.withOpacity(0.9), BlendMode.dstATop),
//                 )),
//             child: child));
//   }
// }
