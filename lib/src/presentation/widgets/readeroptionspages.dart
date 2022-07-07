import 'package:flutter/material.dart';

class ReaderOptionsPages extends StatefulWidget {
  const ReaderOptionsPages({Key? key}) : super(key: key);

  @override
  State<ReaderOptionsPages> createState() => _ReaderOptionsPagesState();
}

class _ReaderOptionsPagesState extends State<ReaderOptionsPages> {
  int _index1 = 0;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
      child: _buildas(context),
    );
  }

  Widget _buildas(BuildContext context) {
    return SizedBox(
      height: 200, // card height

      child: PageView.builder(
        itemCount: 5,
        // padEnds: true,

        controller: PageController(viewportFraction: 0.45),
        onPageChanged: (int index) => setState(() => _index1 = index),
        itemBuilder: (_, i) {
          return Transform(
            // origin: Offset(20, 1000),
            // scaleX: 1,
            // scaleY: 1,

            // scale: i == _index1 ? 1 : 1,
            // alignment: FractionalOffset.bottomLeft,
            // alignment: AlignmentGeometry(),
            transform: Matrix4.skewY(0),
            child: Card(
              color: Colors.white,
              // clipBehavior: Clip.antiAliasWithSaveLayer,
              margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0)),
              child: Stack(
                children: [
                  SizedBox(
                    width: 450,
                    height: 300,
                  ),
                  Text(
                    "asdad",
                    // " asd",
                    // "Card ${i + 1}",
                    textAlign: TextAlign.center,

                    style: TextStyle(
                        fontSize: 32,
                        color: Colors.blue,
                        backgroundColor: Colors.transparent),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
