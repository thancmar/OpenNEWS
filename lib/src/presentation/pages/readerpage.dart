import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sharemagazines_flutter/src/presentation/pages/readeroptionspage.dart';
import 'package:sharemagazines_flutter/src/presentation/widgets/routes/toreaderoption.dart';

class Reader extends StatefulWidget {
  const Reader({Key? key}) : super(key: key);

  @override
  State<Reader> createState() => _ReaderState();
}

class _ReaderState extends State<Reader> {
  final TransformationController transformationController =
      TransformationController();

  @override
  void initState() {
    // SchedulerBinding.instance.addPostFrameCallback((_) async {
    //   Timer(Duration(seconds: 5), () {
    //     setState(() {
    //       transformationController.value = Matrix4.identity()
    //         ..translate(800, 0.0);
    //       transformationController.toScene(Offset(800, 0.0));
    //     });
    //   });
    // });
    super.initState();
  }

  static Matrix4 matrix4 =
      Matrix4(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1);
  TransformationController controller = TransformationController(matrix4);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          child: new SvgPicture.asset(
            "assets/images/background_webreader.svg",
            fit: BoxFit.fill,
            allowDrawingOutsideViewBox: true,
          ),
        ),
        GestureDetector(
          // onTap: () {
          //   showModalBottomSheet<void>(
          //     context: context,
          //     isScrollControlled: true,
          //     // barrierColor: Colors.yellow.withOpacity(0.5),
          //     builder: (BuildContext context) {
          //       return FractionallySizedBox(
          //         heightFactor: 0.9,
          //         child: Container(
          //           // height: 200,
          //           color: Colors.transparent,
          //           child: Center(
          //             child: Column(
          //               mainAxisAlignment: MainAxisAlignment.center,
          //               mainAxisSize: MainAxisSize.min,
          //               children: <Widget>[
          //                 const Text('Modal BottomSheet'),
          //                 ElevatedButton(
          //                   child: const Text('Close BottomSheet'),
          //                   onPressed: () => Navigator.pop(context),
          //                 )
          //               ],
          //             ),
          //           ),
          //         ),
          //       );
          //     },
          //   );
          // },
          // onTap: () => Navigator.of(context).push(PageRouteBuilder(
          //     opaque: false,
          //     pageBuilder: (BuildContext context, _, __) =>
          //         ReaderOptionsPage())),
          onTap: () => Navigator.push(
              context, new ReaderOptionRoute(widget: ReaderOptionsPage())),
          child: InteractiveViewer(
            clipBehavior: Clip.hardEdge,
            // alignPanAxis: true,
            boundaryMargin: EdgeInsets.all(-20),
            // scaleEnabled: true,
            transformationController: controller,
            minScale: 0.01,
            maxScale: 1.5,
            constrained: false,
            scaleEnabled: true,
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              // height: 1600, //double.infinity,
              // width: 1200,
              child: Image.network(
                'https://cdn.maikoapp.com/3d4b/4qs2p/200@2x.png',
                fit: BoxFit.cover,
                // fit: BoxFit.fitHeight,
              ),
            ),
          ),
        ),
        Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              heroTag: "FAB",
              onPressed: () => {},
              backgroundColor: Colors.white.withOpacity(0.2),
              child: Icon(
                Icons.chrome_reader_mode_outlined,
              ),
            )),
        // GestureDetector(
        //   behavior: HitTestBehavior.opaque,
        //   onTap: () => print('Tapped'),
        //   child: Text("cdxs"),
        // )
      ],
    );
  }
}
