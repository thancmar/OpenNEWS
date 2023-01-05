// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// class Showlocationselectionsheet extends StatefulWidget {
//   const Showlocationselectionsheet({Key? key}) : super(key: key);
//
//   @override
//   State<Showlocationselectionsheet> createState() => _ShowlocationselectionsheetState();
// }
//
// class _ShowlocationselectionsheetState extends State<Showlocationselectionsheet> {
//   @override
//   Widget build(BuildContext context) {
//     return showCupertinoModalPopup(
//       context: context,
//       builder: (BuildContext context) => CupertinoActionSheet(
//         title: const Text('Title'),
//         message: const Text('Message'),
//         actions: <CupertinoActionSheetAction>[
//           CupertinoActionSheetAction(
//             /// This parameter indicates the action would be a default
//             /// defualt behavior, turns the action's text to bold text.
//             isDefaultAction: true,
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             child: const Text('Default Action'),
//           ),
//           CupertinoActionSheetAction(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             child: const Text('Action'),
//           ),
//           CupertinoActionSheetAction(
//             /// This parameter indicates the action would perform
//             /// a destructive action such as delete or exit and turns
//             /// the action's text color to red.
//             isDestructiveAction: true,
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             child: const Text('Destructive Action'),
//           ),
//         ],
//       ),
//     );
//   }
// }