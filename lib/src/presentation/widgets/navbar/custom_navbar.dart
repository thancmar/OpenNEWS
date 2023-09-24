import 'package:flutter/material.dart';

class CustomNavbar extends StatelessWidget {
  // const BottomNavBarImp({
  // int selectedIndex = 0;
  final selectedIndex;
  final ValueChanged<int> onClicked;
  final showQR;

  CustomNavbar({required this.selectedIndex, required this.onClicked,required this.showQR});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Theme(
          data: Theme.of(context).copyWith(
            splashColor: Colors.transparent,  // Disabling splash effect
            highlightColor: Colors.transparent,  // Disabling highlight effect
          ),
          child: BottomNavigationBar(
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
              if(showQR == true)BottomNavigationBarItem(
                icon: SizedBox.shrink(), // This creates an empty space for the icon

                label: 'QR_FAB',

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
          ),
        ),
      ],
    );
  }
}