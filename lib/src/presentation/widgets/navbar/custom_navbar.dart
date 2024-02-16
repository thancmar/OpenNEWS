import 'package:flutter/material.dart';

class CustomNavbar extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int> onClicked;

  CustomNavbar({required this.selectedIndex, required this.onClicked});

  @override
  _CustomNavbarState createState() => _CustomNavbarState();
}

class _CustomNavbarState extends State<CustomNavbar> with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
        4,
        (index) => AnimationController(
              vsync: this,
              // value: 1,
              duration: Duration(milliseconds: 200),
            ));
    _animations = _controllers.map((controller) => Tween<double>(begin: 1, end: 1.5).animate(controller)).toList();

  }

  @override
  void dispose() {
    for (var controller in _controllers) controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Theme(
          data: Theme.of(context).copyWith(splashColor: Colors.transparent, highlightColor: Colors.transparent),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            elevation: 0,
            showSelectedLabels: false,
            selectedItemColor: Colors.blue,
            showUnselectedLabels: false,
            currentIndex: widget.selectedIndex,
            onTap: (index) {
              widget.onClicked(index);
              _controllers[index]
                  .forward()
                  .then((_) => _controllers[index].reverse()); // Trigger the animation when tapped

            },
            items: [

              _buildItem(0, Icons.home),
              _buildItem(1, Icons.menu),
              _buildItem(2, Icons.pin_drop_outlined),
              _buildItem(3, Icons.account_circle_outlined),
            ],
          ),
        ),
      ],
    );
  }

  BottomNavigationBarItem _buildItem(int index, IconData iconData) {
    return BottomNavigationBarItem(
      icon: ScaleTransition(
        scale: _animations[index], // Use the animation for scaling
        child: Icon(iconData, color: widget.selectedIndex == index ? Colors.blue : Colors.grey),
      ),
      label: '',
    );
  }
}