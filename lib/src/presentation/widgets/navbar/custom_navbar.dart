import 'package:flutter/material.dart';

class CustomNavbar extends StatelessWidget {
  // const BottomNavBarImp({
  // int selectedIndex = 0;
  final selectedIndex;
  final ValueChanged<int> onClicked;
  CustomNavbar({required this.selectedIndex, required this.onClicked});

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
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
            color: selectedIndex == 0 ? Colors.blue : Colors.grey,
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.menu,
            color: selectedIndex == 1 ? Colors.blue : Colors.grey,
          ),
          label: 'Camera',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.pin_drop_outlined,
            color: selectedIndex == 2 ? Colors.blue : Colors.grey,
          ),
          label: 'Chats',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.account_circle_outlined,
            color: selectedIndex == 3 ? Colors.blue : Colors.grey,
          ),
          label: 'Account',
        ),
      ],
    );
  }
}
