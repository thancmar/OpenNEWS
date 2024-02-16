import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sharemagazines/src/blocs/navbar/navbar_bloc.dart';
import 'package:sharemagazines/src/blocs/reader/reader_bloc.dart';
import 'package:sharemagazines/src/presentation/pages/navbarpages/homepage/homepage.dart';

class SlidingAppBar extends StatelessWidget implements PreferredSizeWidget {
  SlidingAppBar({
    required this.child,
    required this.controller,
    required this.visible,
  });

  final PreferredSizeWidget child;
  final AnimationController controller;
  final bool visible;

  @override
  Size get preferredSize => child.preferredSize;

  @override
  Widget build(BuildContext context) {
    visible ? controller.reverse() : controller.forward();
    return SlideTransition(
      position: Tween<Offset>(begin: Offset.zero, end: Offset(0, -5)).animate(
        CurvedAnimation(parent: controller, curve: Curves.bounceInOut),
      ),
      child: child,
    );
  }
}

// class LocationAppbar extends StatefulWidget {
//   const LocationAppbar({Key? key}) : super(key: key);
//
//   @override
//   State<LocationAppbar> createState() => _LocationAppbarState();
// }
//
// class _LocationAppbarState extends State<LocationAppbar> {
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<NavbarBloc, NavbarState>(builder: (context, state) {
//       print("LA");
//       return Scaffold(
//           backgroundColor: Colors.transparent,
//           // appBar: PreferredSize(
//           //   preferredSize: const Size(0, 81),
//           //   child: Container(
//           //     // decoration: BoxDecoration(
//           //     //     border: Border.all(color: Colors.blueGrey),
//           //     //     borderRadius: BorderRadius.all(Radius.circular(20))),
//           //     margin: EdgeInsets.only(left: 10, right: 10, top: 40, bottom: 10),
//           //     // padding: EdgeInsets.all(10),
//           //     padding: EdgeInsets.only(top: 20, bottom: 0),
//           //     child: ExpandableNotifier(
//           //       child: ScrollOnExpand(
//           //         child: ExpansionTile(
//           //           // onExpansionChanged: (bool expanding) =>
//           //           //     _onExpansion(expanding),
//           //           leading: Icon(
//           //             Icons.circle,
//           //             color: Colors.white,
//           //             size: 60,
//           //           ),
//           //           trailing: GestureDetector(
//           //             // onTap: ,
//           //             child: Icon(
//           //               Icons.search,
//           //               color: Colors.white,
//           //               size: 30,
//           //             ),
//           //           ),
//           //           title: Row(
//           //             children: [
//           //               Column(
//           //                 crossAxisAlignment: CrossAxisAlignment.start,
//           //                 mainAxisAlignment: MainAxisAlignment.center,
//           //                 children: [
//           //                   Container(
//           //                     child: Text(
//           //                       "asd",
//           //                       // state.magazinePublishedGetLastWithLimit
//           //                       //     .response!.first.name!,
//           //                       style: TextStyle(
//           //                           fontSize: 18, color: Colors.white),
//           //                       // textAlign: TextAlign.left,
//           //                     ),
//           //                   ),
//           //                   Container(
//           //                     child: Text(
//           //                       "Infos zu deiner Location",
//           //                       style: TextStyle(
//           //                           fontSize: 13,
//           //                           color: Colors.white,
//           //                           fontWeight: FontWeight.w200),
//           //                       // textAlign: TextAlign.right,
//           //                     ),
//           //                   ),
//           //                 ],
//           //               ),
//           //             ],
//           //           ),
//           //           children: <Widget>[
//           //             SingleChildScrollView(
//           //               child: Container(
//           //                 height: MediaQuery.of(context).size.height * 0.8,
//           //                 width: MediaQuery.of(context).size.width,
//           //                 child: Text(
//           //                   "data",
//           //                   style: TextStyle(fontSize: 20, color: Colors.white),
//           //                   textAlign: TextAlign.center,
//           //                 ),
//           //               ),
//           //             ),
//           //           ],
//           //         ),
//           //       ),
//           //     ),
//           //   ),
//           // child: AppBar(
//           //   titleSpacing: 0,
//           //   leadingWidth: 80,
//           //   automaticallyImplyLeading: false,
//           //   backgroundColor: Colors.transparent,
//           //   leading: Icon(
//           //     Icons.circle,
//           //     color: Colors.white,
//           //     size: 60,
//           //   ),
//           //   title: Row(
//           //     children: [
//           //       Column(
//           //         crossAxisAlignment: CrossAxisAlignment.start,
//           //         mainAxisAlignment: MainAxisAlignment.center,
//           //         children: [
//           //           Container(
//           //             child: Text(
//           //               "asd",
//           //               // state.magazinePublishedGetLastWithLimit.response!.first
//           //               //     .name!,
//           //               style: TextStyle(fontSize: 18, color: Colors.white),
//           //               // textAlign: TextAlign.left,
//           //             ),
//           //           ),
//           //           Container(
//           //             child: Text(
//           //               "Infos zu deiner Location",
//           //               style: TextStyle(
//           //                   fontSize: 13,
//           //                   color: Colors.white,
//           //                   fontWeight: FontWeight.w200),
//           //               // textAlign: TextAlign.right,
//           //             ),
//           //           ),
//           //         ],
//           //       ),
//           //     ],
//           //   ),
//           // ),
//           // ),
//           body: state is GoToHome ? HomePageState() : Container());
//     });
//   }
// }