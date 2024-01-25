//
//
//
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:rive/rive.dart';
//
// class LoadingAnimation extends StatefulWidget {
//   const LoadingAnimation({Key? key}) : super(key: key);
//
//   @override
//   _LoadingAnimationState createState() => _LoadingAnimationState();
// }
//
// class _LoadingAnimationState extends State<LoadingAnimation> {
//   /// Tracks if the animation is playing by whether controller is running.
//   bool get isPlaying => _controller?.isActive ?? false;
//
//   Artboard? _riveArtboard;
//   StateMachineController? _controller;
//   SMIBool? trigger;
//   StateMachineController? stateMachineController;
//
//   @override
//   void initState() {
//     super.initState();
//
//     // Load the animation file from the bundle, note that you could also
//     // download this. The RiveFile just expects a list of bytes.
//     rootBundle.load('assets/loading.riv').then(
//           (data) async {
//         // Load the RiveFile from the binary data.
//         final file = RiveFile.import(data);
//
//         // The artboard is the root of the animation and gets drawn in the
//         // Rive widget.
//         final artboard = file.mainArtboard;
//         // setState(() => _riveArtboard = artboard);
//         stateMachineController = StateMachineController.fromArtboard(artboard, "State Machine");
//         if (stateMachineController != null) {
//           artboard.addController(stateMachineController!);
//           trigger = stateMachineController!.findSMI('Pressed');
//
//           stateMachineController!.inputs.forEach((e) {
//             debugPrint(e.runtimeType.toString());
//             debugPrint("name${e.name}End");
//           });
//           trigger = stateMachineController!.inputs.first as SMIBool;
//           trigger?.value= true;
//           // setState(() => _riveArtboard = artboard);
//         }
//
//         setState(() => _riveArtboard = artboard);
//         print("rive");
//     });
//   }
//
//   @override
//   void dispose() {
//     // _pressInput?.value = false;
//
//     // _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return
//       // appBar: AppBar(
//       //   title: const Text('Button State Machine'),
//       // ),
//        Center(
// // child: RiveAnimation.asset("assets/loading.riv"),
//         child: _riveArtboard == null
//             ?  SizedBox(child: Container(color: Colors.transparent,height: 200,),)
//             :SizedBox(
//           height:400,
//           width: 400,
//           // color: Colors.transparent,
//               child: Rive(
//                 // 'assets/loading.riv',
//                 // antialiasing: false,
// // useArtboardSize: true,
//                 artboard: _riveArtboard!,
//                 fit: BoxFit.fill ,
//                 // alignment: Alignment.center,
//               ),
//             ),
//       );
//
//   }
// }