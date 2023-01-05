import 'package:flutter/material.dart';

class FAB extends StatefulWidget {
  const FAB({Key? key}) : super(key: key);

  @override
  State<FAB> createState() => _FABState();
}

class _FABState extends State<FAB> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
        bottom: 20,
        right: 20,
        child: FloatingActionButton(
          key: UniqueKey(),
          heroTag: "FAB",
          onPressed: () => {},
          backgroundColor: Colors.white.withOpacity(0.2),
          child: Icon(
            Icons.chrome_reader_mode_outlined,
          ),
        ));
  }
}