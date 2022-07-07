// import 'dart:convert';
// import 'dart:typed_data';
//
// import 'package:expandable/expandable.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:sharemagazines_flutter/src/blocs/navbar_bloc.dart';
// import 'package:sharemagazines_flutter/src/presentation/widgets/bottomtoup_animation.dart';
//
// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   int _index1 = 0;
//   int _index2 = 0;
//   late Future futureRecords;
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<NavbarBloc, NavbarState>(
//       builder: (context, state) {
//         if (state is GoToHome) {
//           Uint8List bytes123 = state.bytes as Uint8List;
//           // print(state.bytes);
//           // print(state.magazinePublishedGetLastWithLimit.response!.iterator
//           //     .current.idMagazine!);
//           return Column(
//             children: [
//               Container(
//                 // decoration: BoxDecoration(
//                 //     border: Border.all(color: Colors.blueGrey),
//                 //     borderRadius: BorderRadius.all(Radius.circular(20))),
//                 margin:
//                     EdgeInsets.only(left: 10, right: 10, top: 40, bottom: 0),
//                 // padding: EdgeInsets.all(10),
//                 padding: EdgeInsets.only(top: 20, bottom: 20),
//                 child: ExpandableNotifier(
//                   child: ScrollOnExpand(
//                     child: ExpansionTile(
//                       leading: Icon(
//                         Icons.circle,
//                         color: Colors.white,
//                         size: 60,
//                       ),
//                       trailing: Icon(
//                         Icons.search,
//                         color: Colors.white,
//                         size: 30,
//                       ),
//                       title: Row(
//                         children: [
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Container(
//                                 child: Text(
//                                   // "asd",
//                                   state.magazinePublishedGetLastWithLimit
//                                       .response!.first.name!,
//                                   style: TextStyle(
//                                       fontSize: 18, color: Colors.white),
//                                   // textAlign: TextAlign.left,
//                                 ),
//                               ),
//                               Container(
//                                 child: Text(
//                                   "Infos zu deiner Location",
//                                   style: TextStyle(
//                                       fontSize: 13,
//                                       color: Colors.white,
//                                       fontWeight: FontWeight.w200),
//                                   // textAlign: TextAlign.right,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                       children: <Widget>[
//                         Text(
//                           "data",
//                           style: TextStyle(fontSize: 20, color: Colors.white),
//                           textAlign: TextAlign.right,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//
//               // ClipRRect(
//               //   borderRadius: BorderRadius.circular(4),
//               //   child: Stack(
//               //     children: <Widget>[
//               //       Positioned.fill(
//               //         child: Container(
//               //           decoration: BoxDecoration(
//               //             boxShadow: [
//               //               BoxShadow(
//               //                 color: Colors.grey.withOpacity(0.1),
//               //                 spreadRadius: 1,
//               //                 blurRadius: 0,
//               //                 // offset: Offset(0, 3), // changes position of shadow
//               //               ),
//               //             ],
//               //             borderRadius: BorderRadius.circular(15),
//               //           ),
//               //         ),
//               //       ),
//               //       ElevatedButton.icon(
//               //         style: TextButton.styleFrom(
//               //           padding: const EdgeInsets.all(16.0),
//               //           primary: Colors.white,
//               //           textStyle: const TextStyle(fontSize: 12),
//               //         ),
//               //         onPressed: () {},
//               //         icon: Icon(Icons.menu_book),
//               //         label: Text("Speisekarte"),
//               //         // child: const Text('Speisekarte'),
//               //       ),
//               //     ],
//               //   ),
//               // ),
//
//               Expanded(
//                 child: SingleChildScrollView(
//                   scrollDirection: Axis.vertical,
//                   physics: AlwaysScrollableScrollPhysics(),
//                   child: Column(
//                     children: [
//                       SingleChildScrollView(
//                         scrollDirection: Axis.horizontal,
//                         child: BottomtoUp(
//                           delay: 300,
//                           child: Row(
//                             children: [
//                               Padding(
//                                 padding:
//                                     const EdgeInsets.fromLTRB(20, 0, 10, 0),
//                                 child: Container(
//                                   width:
//                                       MediaQuery.of(context).size.width * 0.32,
//                                   height:
//                                       MediaQuery.of(context).size.width * 0.085,
//                                   child: FloatingActionButton.extended(
//                                     shape: RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.all(
//                                             Radius.circular(8)),
//                                         side: BorderSide(
//                                             color: Colors.white, width: 0.2)),
//                                     label: Text(
//                                       'Speisekarte',
//                                       style: TextStyle(fontSize: 10),
//                                     ), // <-- Text
//                                     backgroundColor:
//                                         Colors.grey.withOpacity(0.1),
//                                     icon: Icon(
//                                       // <-- Icon
//                                       Icons.menu_book,
//                                       size: 16.0,
//                                     ),
//                                     onPressed: () {},
//                                     // extendedPadding: EdgeInsets.all(50),
//                                   ),
//                                 ),
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.fromLTRB(0, 5, 10, 5),
//                                 child: Container(
//                                   width:
//                                       MediaQuery.of(context).size.width * 0.32,
//                                   height:
//                                       MediaQuery.of(context).size.width * 0.085,
//                                   child: FloatingActionButton.extended(
//                                     shape: RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.all(
//                                             Radius.circular(8)),
//                                         side: BorderSide(
//                                             color: Colors.white, width: 0.2)),
//
//                                     label: Text(
//                                       'Unser Barista',
//                                       style: TextStyle(fontSize: 10),
//                                     ), // <-- Text
//                                     backgroundColor:
//                                         Colors.grey.withOpacity(0.1),
//                                     icon: Icon(
//                                       // <-- Icon
//                                       Icons.account_box,
//                                       size: 16.0,
//                                     ),
//                                     onPressed: () {},
//                                   ),
//                                 ),
//                               ),
//                               Container(
//                                 width: MediaQuery.of(context).size.width * 0.32,
//                                 height:
//                                     MediaQuery.of(context).size.width * 0.085,
//                                 child: FloatingActionButton.extended(
//                                   shape: RoundedRectangleBorder(
//                                       borderRadius:
//                                           BorderRadius.all(Radius.circular(8)),
//                                       side: BorderSide(
//                                           color: Colors.white, width: 0.2)),
//                                   label: Text(
//                                     'Kaffeesorten',
//                                     style: TextStyle(fontSize: 10),
//                                   ), // <-- Text
//                                   backgroundColor: Colors.grey.withOpacity(0.1),
//                                   icon: Icon(
//                                     // <-- Icon
//                                     Icons.coffee,
//                                     size: 16.0,
//                                   ),
//                                   onPressed: () {},
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       BottomtoUp(
//                         delay: 350,
//                         child: Align(
//                           alignment: Alignment.centerLeft,
//                           child: Padding(
//                             padding: const EdgeInsets.fromLTRB(25, 40, 25, 20),
//                             child: Text(
//                               "News aus deiner Region",
//                               style:
//                                   TextStyle(color: Colors.white, fontSize: 16),
//                               textAlign: TextAlign.right,
//                             ),
//                           ),
//                         ),
//                       ),
//                       BottomtoUp(delay: 400, child: _buildas(context)),
//                       BottomtoUp(
//                         delay: 450,
//                         child: Align(
//                           alignment: Alignment.centerLeft,
//                           child: Padding(
//                             padding: const EdgeInsets.fromLTRB(25, 40, 25, 20),
//                             child: Text(
//                               'Meistgelesene Artikel',
//                               style:
//                                   TextStyle(color: Colors.white, fontSize: 16),
//                               textAlign: TextAlign.right,
//                             ),
//                           ),
//                         ),
//                       ),
//                       BottomtoUp(
//                         delay: 500,
//                         child: SizedBox(
//                           height: 300, // card height
//
//                           child: PageView.builder(
//                             itemCount: 5,
//                             // padEnds: true,
//
//                             controller: PageController(viewportFraction: 0.75),
//                             onPageChanged: (int index) =>
//                                 setState(() => _index1 = index),
//                             itemBuilder: (_, i) {
//                               return Transform.scale(
//                                 // origin: Offset(100, 50),
//
//                                 scale: i == _index1 ? 1 : 1,
//                                 alignment: Alignment.bottomCenter,
//                                 // alignment: AlignmentGeometry(),
//                                 child: Card(
//                                   color: Colors.transparent,
//                                   clipBehavior: Clip.antiAliasWithSaveLayer,
//                                   margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
//                                   elevation: 0,
//                                   shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(5)),
//                                   child: Stack(
//                                     children: [
//                                       SizedBox(
//                                         width: 450,
//                                         height: 300,
//                                         child: Image.memory(
//                                           state.bytes,
//                                           fit: BoxFit.fill,
//                                         ),
//                                       ),
//                                       Align(
//                                         alignment: Alignment.bottomCenter,
//                                         child: Text(
//                                           state
//                                               .magazinePublishedGetLastWithLimit
//                                               .response![i]
//                                               .name!,
//                                           // " asd",
//                                           // "Card ${i + 1}",
//                                           textAlign: TextAlign.center,
//
//                                           style: TextStyle(
//                                               fontSize: 32,
//                                               color: Colors.white,
//                                               backgroundColor:
//                                                   Colors.transparent),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                       ),
//                       Align(
//                         alignment: Alignment.centerLeft,
//                         child: Padding(
//                           padding: const EdgeInsets.fromLTRB(25, 40, 25, 20),
//                           child: Text(
//                             'Mit deinem Profil weiterstöbern',
//                             style: TextStyle(color: Colors.white, fontSize: 16),
//                             textAlign: TextAlign.right,
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         height: 200, // card height
//                         child: PageView.builder(
//                           itemCount: 5,
//                           // padEnds: true,
//
//                           controller: PageController(viewportFraction: 0.45),
//                           onPageChanged: (int index) =>
//                               setState(() => _index1 = index),
//                           itemBuilder: (_, i) {
//                             return Transform.scale(
//                               // origin: Offset(100, 50),
//
//                               scale: i == _index1 ? 1 : 1,
//                               alignment: Alignment.bottomCenter,
//                               // alignment: AlignmentGeometry(),
//                               child: Card(
//                                 clipBehavior: Clip.antiAliasWithSaveLayer,
//                                 margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
//                                 elevation: 6,
//                                 shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(5)),
//                                 child: Column(
//                                   children: [
//                                     SizedBox(
//                                       width: 200,
//                                       height: 150,
//                                       child: Image.network(
//                                         'https://via.placeholder.com/300?text=DITTO',
//                                         fit: BoxFit.fill,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           );
//         }
//         return Container();
//       },
//       // child: Column(
//       //   children: [
//       //     Container(
//       //       // decoration: BoxDecoration(
//       //       //     border: Border.all(color: Colors.blueGrey),
//       //       //     borderRadius: BorderRadius.all(Radius.circular(20))),
//       //       margin: EdgeInsets.only(left: 10, right: 10, top: 40, bottom: 10),
//       //       // padding: EdgeInsets.all(10),
//       //       padding: EdgeInsets.only(top: 20, bottom: 20),
//       //       child: ExpandableNotifier(
//       //         child: ScrollOnExpand(
//       //           child: ExpansionTile(
//       //             leading: Icon(
//       //               Icons.circle,
//       //               color: Colors.white,
//       //               size: 60,
//       //             ),
//       //             trailing: Icon(
//       //               Icons.search,
//       //               color: Colors.white,
//       //               size: 30,
//       //             ),
//       //             title: Row(
//       //               children: [
//       //                 Column(
//       //                   crossAxisAlignment: CrossAxisAlignment.start,
//       //                   mainAxisAlignment: MainAxisAlignment.center,
//       //                   children: [
//       //                     Container(
//       //                       child: Text(
//       //                         "Weser kurier",
//       //                         style:
//       //                             TextStyle(fontSize: 18, color: Colors.white),
//       //                         // textAlign: TextAlign.left,
//       //                       ),
//       //                     ),
//       //                     Container(
//       //                       child: Text(
//       //                         "Infos zu deiner Location",
//       //                         style: TextStyle(
//       //                             fontSize: 13,
//       //                             color: Colors.white,
//       //                             fontWeight: FontWeight.w200),
//       //                         // textAlign: TextAlign.right,
//       //                       ),
//       //                     ),
//       //                   ],
//       //                 ),
//       //               ],
//       //             ),
//       //             children: <Widget>[
//       //               Text(
//       //                 "data",
//       //                 style: TextStyle(fontSize: 20, color: Colors.white),
//       //                 textAlign: TextAlign.right,
//       //               ),
//       //             ],
//       //           ),
//       //         ),
//       //       ),
//       //     ),
//       //
//       //     // ClipRRect(
//       //     //   borderRadius: BorderRadius.circular(4),
//       //     //   child: Stack(
//       //     //     children: <Widget>[
//       //     //       Positioned.fill(
//       //     //         child: Container(
//       //     //           decoration: BoxDecoration(
//       //     //             boxShadow: [
//       //     //               BoxShadow(
//       //     //                 color: Colors.grey.withOpacity(0.1),
//       //     //                 spreadRadius: 1,
//       //     //                 blurRadius: 0,
//       //     //                 // offset: Offset(0, 3), // changes position of shadow
//       //     //               ),
//       //     //             ],
//       //     //             borderRadius: BorderRadius.circular(15),
//       //     //           ),
//       //     //         ),
//       //     //       ),
//       //     //       ElevatedButton.icon(
//       //     //         style: TextButton.styleFrom(
//       //     //           padding: const EdgeInsets.all(16.0),
//       //     //           primary: Colors.white,
//       //     //           textStyle: const TextStyle(fontSize: 12),
//       //     //         ),
//       //     //         onPressed: () {},
//       //     //         icon: Icon(Icons.menu_book),
//       //     //         label: Text("Speisekarte"),
//       //     //         // child: const Text('Speisekarte'),
//       //     //       ),
//       //     //     ],
//       //     //   ),
//       //     // ),
//       //
//       //     Expanded(
//       //       child: SingleChildScrollView(
//       //         scrollDirection: Axis.vertical,
//       //         physics: AlwaysScrollableScrollPhysics(),
//       //         child: Column(
//       //           children: [
//       //             SingleChildScrollView(
//       //               scrollDirection: Axis.horizontal,
//       //               child: LeftToRight(
//       //                 delay: 300,
//       //                 child: Row(
//       //                   children: [
//       //                     Padding(
//       //                       padding: const EdgeInsets.fromLTRB(20, 0, 10, 0),
//       //                       child: Container(
//       //                         width: MediaQuery.of(context).size.width * 0.32,
//       //                         height: MediaQuery.of(context).size.width * 0.085,
//       //                         child: FloatingActionButton.extended(
//       //                           shape: RoundedRectangleBorder(
//       //                               borderRadius:
//       //                                   BorderRadius.all(Radius.circular(8)),
//       //                               side: BorderSide(
//       //                                   color: Colors.white, width: 0.2)),
//       //                           label: Text(
//       //                             'Speisekarte',
//       //                             style: TextStyle(fontSize: 10),
//       //                           ), // <-- Text
//       //                           backgroundColor: Colors.grey.withOpacity(0.1),
//       //                           icon: Icon(
//       //                             // <-- Icon
//       //                             Icons.menu_book,
//       //                             size: 16.0,
//       //                           ),
//       //                           onPressed: () {},
//       //                           // extendedPadding: EdgeInsets.all(50),
//       //                         ),
//       //                       ),
//       //                     ),
//       //                     Padding(
//       //                       padding: const EdgeInsets.fromLTRB(0, 5, 10, 5),
//       //                       child: Container(
//       //                         width: MediaQuery.of(context).size.width * 0.32,
//       //                         height: MediaQuery.of(context).size.width * 0.085,
//       //                         child: FloatingActionButton.extended(
//       //                           shape: RoundedRectangleBorder(
//       //                               borderRadius:
//       //                                   BorderRadius.all(Radius.circular(8)),
//       //                               side: BorderSide(
//       //                                   color: Colors.white, width: 0.2)),
//       //
//       //                           label: Text(
//       //                             'Unser Barista',
//       //                             style: TextStyle(fontSize: 10),
//       //                           ), // <-- Text
//       //                           backgroundColor: Colors.grey.withOpacity(0.1),
//       //                           icon: Icon(
//       //                             // <-- Icon
//       //                             Icons.account_box,
//       //                             size: 16.0,
//       //                           ),
//       //                           onPressed: () {},
//       //                         ),
//       //                       ),
//       //                     ),
//       //                     Container(
//       //                       width: MediaQuery.of(context).size.width * 0.32,
//       //                       height: MediaQuery.of(context).size.width * 0.085,
//       //                       child: FloatingActionButton.extended(
//       //                         shape: RoundedRectangleBorder(
//       //                             borderRadius:
//       //                                 BorderRadius.all(Radius.circular(8)),
//       //                             side: BorderSide(
//       //                                 color: Colors.white, width: 0.2)),
//       //                         label: Text(
//       //                           'Kaffeesorten',
//       //                           style: TextStyle(fontSize: 10),
//       //                         ), // <-- Text
//       //                         backgroundColor: Colors.grey.withOpacity(0.1),
//       //                         icon: Icon(
//       //                           // <-- Icon
//       //                           Icons.coffee,
//       //                           size: 16.0,
//       //                         ),
//       //                         onPressed: () {},
//       //                       ),
//       //                     ),
//       //                   ],
//       //                 ),
//       //               ),
//       //             ),
//       //             LeftToRight(
//       //               delay: 350,
//       //               child: Align(
//       //                 alignment: Alignment.centerLeft,
//       //                 child: Padding(
//       //                   padding: const EdgeInsets.fromLTRB(25, 40, 25, 20),
//       //                   child: Text(
//       //                     "News aus deiner Region",
//       //                     style: TextStyle(color: Colors.white, fontSize: 16),
//       //                     textAlign: TextAlign.right,
//       //                   ),
//       //                 ),
//       //               ),
//       //             ),
//       //             LeftToRight(delay: 400, child: _buildas(context)),
//       //             LeftToRight(
//       //               delay: 450,
//       //               child: Align(
//       //                 alignment: Alignment.centerLeft,
//       //                 child: Padding(
//       //                   padding: const EdgeInsets.fromLTRB(25, 40, 25, 20),
//       //                   child: Text(
//       //                     'Meistgelesene Artikel',
//       //                     style: TextStyle(color: Colors.white, fontSize: 16),
//       //                     textAlign: TextAlign.right,
//       //                   ),
//       //                 ),
//       //               ),
//       //             ),
//       //             LeftToRight(
//       //               delay: 500,
//       //               child: SizedBox(
//       //                 height: 300, // card height
//       //                 child: PageView.builder(
//       //                   itemCount: 5,
//       //                   // padEnds: true,
//       //
//       //                   controller: PageController(viewportFraction: 0.75),
//       //                   onPageChanged: (int index) =>
//       //                       setState(() => _index1 = index),
//       //                   itemBuilder: (_, i) {
//       //                     return Transform.scale(
//       //                       // origin: Offset(100, 50),
//       //
//       //                       scale: i == _index1 ? 1 : 1,
//       //                       alignment: Alignment.bottomCenter,
//       //                       // alignment: AlignmentGeometry(),
//       //                       child: Card(
//       //                         clipBehavior: Clip.antiAliasWithSaveLayer,
//       //                         margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
//       //                         elevation: 6,
//       //                         shape: RoundedRectangleBorder(
//       //                             borderRadius: BorderRadius.circular(5)),
//       //                         child: Column(
//       //                           children: [
//       //                             SizedBox(
//       //                               width: 450,
//       //                               height: 210,
//       //                               child: Image.network(
//       //                                 'https://via.placeholder.com/300?text=DITTO',
//       //                                 fit: BoxFit.fill,
//       //                               ),
//       //                             ),
//       //                             Text(
//       //                               "Card ${i + 1}",
//       //                               style: TextStyle(
//       //                                   fontSize: 32,
//       //                                   backgroundColor: Colors.transparent),
//       //                             ),
//       //                           ],
//       //                         ),
//       //                       ),
//       //                     );
//       //                   },
//       //                 ),
//       //               ),
//       //             ),
//       //             Align(
//       //               alignment: Alignment.centerLeft,
//       //               child: Padding(
//       //                 padding: const EdgeInsets.fromLTRB(25, 40, 25, 20),
//       //                 child: Text(
//       //                   'Mit deinem Profil weiterstöbern',
//       //                   style: TextStyle(color: Colors.white, fontSize: 16),
//       //                   textAlign: TextAlign.right,
//       //                 ),
//       //               ),
//       //             ),
//       //             SizedBox(
//       //               height: 200, // card height
//       //               child: PageView.builder(
//       //                 itemCount: 5,
//       //                 // padEnds: true,
//       //
//       //                 controller: PageController(viewportFraction: 0.45),
//       //                 onPageChanged: (int index) =>
//       //                     setState(() => _index1 = index),
//       //                 itemBuilder: (_, i) {
//       //                   return Transform.scale(
//       //                     // origin: Offset(100, 50),
//       //
//       //                     scale: i == _index1 ? 1 : 1,
//       //                     alignment: Alignment.bottomCenter,
//       //                     // alignment: AlignmentGeometry(),
//       //                     child: Card(
//       //                       clipBehavior: Clip.antiAliasWithSaveLayer,
//       //                       margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
//       //                       elevation: 6,
//       //                       shape: RoundedRectangleBorder(
//       //                           borderRadius: BorderRadius.circular(5)),
//       //                       child: Column(
//       //                         children: [
//       //                           SizedBox(
//       //                             width: 200,
//       //                             height: 150,
//       //                             child: Image.network(
//       //                               'https://via.placeholder.com/300?text=DITTO',
//       //                               fit: BoxFit.fill,
//       //                             ),
//       //                           ),
//       //                         ],
//       //                       ),
//       //                     ),
//       //                   );
//       //                 },
//       //               ),
//       //             ),
//       //           ],
//       //         ),
//       //       ),
//       //     ),
//       //   ],
//       // ),
//     );
//   }
//
//   Widget _buildas(BuildContext context) {
//     return SizedBox(
//       height: 350, // card height
//       child: PageView.builder(
//         itemCount: 5,
//         // padEnds: true,
//
//         controller: PageController(viewportFraction: 0.707),
//         onPageChanged: (int index) => setState(() => _index2 = index),
//         itemBuilder: (_, i) {
//           return Transform.scale(
//             scale: i == _index2 ? 1 : 0.85,
//
//             alignment: Alignment.bottomCenter,
//             // alignment: AlignmentGeometry(),
//             child: Card(
//               shadowColor: Colors.black,
//               elevation: 6,
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(5)),
//               child: Center(
//                 child: Text(
//                   // state.magazinePublishedGetLastWithLimit.response!
//                   "Card ${i + 1}",
//                   style: TextStyle(fontSize: 32),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
//
// // class _MenuPageState extends State<MenuPage> {
// //   @override
// //   Widget build(BuildContext context) {
// //     return ExpandableNotifier(
// //         child: Padding(
// //       padding: const EdgeInsets.all(40),
// //       child: Card(
// //         color: Colors.blue, //transparent
// //         clipBehavior: Clip.antiAlias,
// //         child: Column(
// //           children: <Widget>[
// //             // SizedBox(
// //             //   height: 150,
// //             //   child: Container(
// //             //     decoration: BoxDecoration(
// //             //       color: Colors.orange,
// //             //       shape: BoxShape.rectangle,
// //             //     ),
// //             //   ),
// //             // ),
// //             ScrollOnExpand(
// //               scrollOnExpand: true,
// //               scrollOnCollapse: false,
// //               child: ExpandablePanel(
// //                 theme: const ExpandableThemeData(
// //                   headerAlignment: ExpandablePanelHeaderAlignment.center,
// //                   hasIcon: true,
// //                   iconPlacement: ExpandablePanelIconPlacement.left,
// //                   // tapBodyToCollapse: true,
// //                   // hasIcon: true,
// //                 ),
// //                 header: Padding(
// //                     padding: EdgeInsets.all(10),
// //                     child: Row(
// //                       children: [
// //                         Icon(
// //                           Icons.circle,
// //                           color: Colors.white,
// //                           size: 70,
// //                         ),
// //                         Column(
// //                           crossAxisAlignment: CrossAxisAlignment.start,
// //                           children: [
// //                             Padding(
// //                               padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
// //                               child: Container(
// //                                 child: Text(
// //                                   "data",
// //                                   style: TextStyle(
// //                                       fontSize: 20, color: Colors.red),
// //                                   // textAlign: TextAlign.left,
// //                                 ),
// //                               ),
// //                             ),
// //                             Padding(
// //                               padding: const EdgeInsets.fromLTRB(20, 5, 0, 0),
// //                               child: Container(
// //                                 child: Text(
// //                                   "data afd",
// //                                   style: TextStyle(
// //                                       fontSize: 16, color: Colors.red),
// //                                   // textAlign: TextAlign.right,
// //                                 ),
// //                               ),
// //                             ),
// //                           ],
// //                         ),
// //                         Icon(
// //                           Icons.search,
// //                           color: Colors.white,
// //                           size: 40,
// //                         ),
// //                       ],
// //                     )),
// //                 collapsed: Text(
// //                   "loremIpsum",
// //                   softWrap: true,
// //                   maxLines: 2,
// //                   overflow: TextOverflow.ellipsis,
// //                 ),
// //                 expanded: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: <Widget>[
// //                     for (var _ in Iterable.generate(5))
// //                       Padding(
// //                           padding: EdgeInsets.only(bottom: 10),
// //                           child: Text(
// //                             "loremIpsum",
// //                             softWrap: true,
// //                             overflow: TextOverflow.fade,
// //                           )),
// //                   ],
// //                 ),
// //                 builder: (_, collapsed, expanded) {
// //                   return Padding(
// //                     padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
// //                     child: Expandable(
// //                       collapsed: collapsed,
// //                       expanded: expanded,
// //                       theme: const ExpandableThemeData(crossFadePoint: 0),
// //                     ),
// //                   );
// //                 },
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     ));
// //   }
// // }
//
// // class _MenuPageState extends State<MenuPage> {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //         child: Column(
// //       children: [
// //         Padding(
// //           padding: const EdgeInsets.fromLTRB(35, 50, 35, 35),
// //           child: Row(
// //             children: [
// //               Icon(
// //                 Icons.circle,
// //                 color: Colors.white,
// //                 size: 70,
// //               ),
// //               Padding(
// //                 padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
// //                 child: Container(
// //                   child: Text(
// //                     "data",
// //                     style: TextStyle(fontSize: 20, color: Colors.red),
// //                     textAlign: TextAlign.right,
// //                   ),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         )
// //       ],
// //     ));
// //   }
// // }
