import 'package:flutter/material.dart';
import 'package:sharemagazines_flutter/src/presentation/pages/readerpage.dart';
import 'package:sharemagazines_flutter/src/presentation/widgets/readeroptionspages.dart';

class ReaderOptionsPage extends StatefulWidget {
  @override
  State<ReaderOptionsPage> createState() => _ReaderOptionsPageState();
}

class _ReaderOptionsPageState extends State<ReaderOptionsPage> {
  @override
  void initState() {
    super.initState();
    // Future(() {
    //   Navigator.of(context).push(PageRouteBuilder(
    //       pageBuilder: (BuildContext context, _, __) => Reader()));
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(
          0.40), // this is the main reason of transparency at next screen. I am ignoring rest implementation but what i have achieved is you can see.
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.navigate_before_outlined,
            size: 30,
          ),
          onPressed: () =>
              Navigator.of(context).popUntil((route) => route.isFirst),
        ),
        title: Text("df"),
        actionsIconTheme: IconThemeData(
          size: 25,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Icon(Icons.menu_outlined),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Icon(Icons.bookmark_border),
          )
        ],
        // titleSpacing: 0,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => {
          Navigator.of(context).pop()
          // print("dsfs");
        },
        // child: Column(
        //   children: [
        //     Expanded(
        //       child: Container(
        //         color: Colors.red,
        //       ),
        //     ),
        //   ],
        // ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
                child: Container(
                    // color: Colors.red,
                    )),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 20, 10),
              child: Align(
                alignment: Alignment.bottomRight,
                child: FloatingActionButton(
                  heroTag: "FAB",
                  onPressed: () => {},
                  backgroundColor: Colors.white.withOpacity(0.2),
                  child: Icon(
                    Icons.chrome_reader_mode_outlined,
                  ),
                ),
              ),
            ),
            // Text(
            //   "adscxdsa",
            //   style: TextStyle(color: Colors.red),
            // )
            ReaderOptionsPages(),
          ],
        ),
        // Navigator.of(context).pop,
      ),
    );
  }
}
