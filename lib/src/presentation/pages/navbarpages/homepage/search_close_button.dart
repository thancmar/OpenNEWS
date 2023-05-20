import 'package:flutter/material.dart';
import 'package:sharemagazines_flutter/src/presentation/pages/navbarpages/homepage/searchpage.dart';

import '../../../widgets/backdrop/backdrop.dart';

class SearchCloseButton extends StatefulWidget {
  final BuildContext context;
  Function callback;

  SearchCloseButton({Key? key, required this.context, required this.callback})
      : super(key: key);

  @override
  State<SearchCloseButton> createState() => _SearchCloseButtonState();
}

class _SearchCloseButtonState extends State<SearchCloseButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 10),
      child: InkWell(
        onTap: () => {
          if (mounted)
            {
              setState(() =>
                  // widget.showSearchPage = true
                  widget.callback(true))
            },
          // setState(() {
          //   showSearchPage = true;
          // }),
          // print("before searchpage state $state"),
          Navigator.push(
            context,
            PageRouteBuilder(
              // transitionDuration:
              // Duration(seconds: 2),

              pageBuilder: (_, __, ___) {
                // return StartSearch();

                return SearchPage();
              },
              // maintainState: true,

              // transitionDuration: Duration(milliseconds: 1000),
              // transitionsBuilder: (context, animation, anotherAnimation, child) {
              //   // animation = CurvedAnimation(curve: curveList[index], parent: animation);
              //   return ScaleTransition(
              //     scale: animation,
              //     alignment: Alignment.topRight,
              //     child: child,
              //   );
              // }
            ),
          ).then((_) {
            // if (mounted) {
            // print("after searchpage state $state");

            setState(() {
              // showSearchPage = false;
              widget.callback(false);
            });
            // }
          })
          // ).then((_) => setState(() {
          //       showSearchPage = false;
          //     }))
        },
        child: Hero(
            tag: "search button",
            // child: Scaffold_Close_Open_button(
            //   context: context,
            // ),
            child: Icon(
              Backdrop.of(widget.context).isBackLayerConcealed == false
                  ? Icons.search_sharp
                  : Icons.clear,
              // _counter1 == false ? Icons.search_sharp : Icons.clear,
              // Icons.search_sharp,
              // Icomoon.fc_logo,
              color: Colors.white,
              size: 40,
            )),
      ),
    );
  }
}
