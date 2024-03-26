
import 'package:flutter/material.dart';
import 'dart:math' as math;


class PlayerBottomNavBarImp extends StatelessWidget {
  // const BottomNavBarImp({
  // int selectedIndex = 0;
  final selectedIndex;
  ValueChanged<int> onClicked;
  PlayerBottomNavBarImp({required this.selectedIndex, required this.onClicked});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      // withd: MediaQuery.of(context).padding.bottom;
      type: BottomNavigationBarType.fixed, //Helps with the Transparent Bug
      backgroundColor: Colors.transparent,
// backgroundColor: Theme.of(context).copyWith(splashColor: Colors.yellow),,
      elevation: 0,

      // backgroundColor: Color(0x00ffffff),
      showSelectedLabels: false,
      selectedItemColor: Colors.blue,
      showUnselectedLabels: false,
      currentIndex: selectedIndex,
      onTap: onClicked,

      items: [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.skip_previous,
            color: selectedIndex == 0 ? Colors.blue : Colors.grey,
            size: 30,
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          // backgroundColor: Colors.purpleAccent,
          icon: Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(math.pi),
            child: Icon(
              Icons.forward_10,
              color: selectedIndex == 1 ? Colors.blue : Colors.grey,
              size: 30,
            ),
          ),
          label: 'Camera',
        ),
        BottomNavigationBarItem(
          // backgroundColor: Colors.purpleAccent,
          icon: Icon(
            Icons.email,
            color: selectedIndex == 1 ? Colors.blue : Colors.grey,
            size: 30,
          ),
          label: 'Camera',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.forward_10,
            color: selectedIndex == 2 ? Colors.blue : Colors.grey,
            size: 30,
          ),
          label: 'Chats',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.skip_next,
            color: selectedIndex == 3 ? Colors.blue : Colors.grey,
            size: 30,
          ),
          label: 'Account',
        ),
      ],
    );
//     return BottomAppBar(
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: <Widget>[
//           IconButton(icon: Icon(Icons.home), onPressed: () {}),
//           IconButton(icon: Icon(Icons.search), onPressed: () {}),
//           SizedBox(width: 40), // The dummy child
//           IconButton(icon: Icon(Icons.notifications), onPressed: () {}),
//           IconButton(icon: Icon(Icons.message), onPressed: () {}),
//         ],
//       ),
//       notchMargin: 10,
//       // clipBehavior: ,
//       // shape: AutomaticNotchedShape(OutlineInputBorder(borderSide: BorderSide(color: Colors.red, width: 50), borderRadius: BorderRadius.only(topLeft: Radius.circular(50.0))),
//       //     OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 5), borderRadius: BorderRadius.all(Radius.circular(50.0)))),
//       //   shape: AutomaticNotchedShape(
//       //       RoundedRectangleBorder(
//       //         borderRadius: BorderRadius.only(
//       //           topLeft: Radius.circular(25),
//       //           topRight: Radius.circular(25),
//       //           bottomRight: Radius.circular(25),
//       //           bottomLeft: Radius.circular(25),
//       //         ),
//       //       ),
//       //       AutomaticNotchedShape()
//       //       // OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 5), borderRadius: BorderRadius.all(Radius.circular(50.0)))),
//       //   color: Colors.blueGrey,
//     );
  }
}