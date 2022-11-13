import 'package:flutter/material.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                SingleChildScrollView(
                  physics: RangeMaintainingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 10, 5),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.40,
                          height: MediaQuery.of(context).size.width * 0.1,
                          child: FloatingActionButton.extended(
                            // heroTag: 'location_offers',
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8)), side: BorderSide(color: Colors.white, width: 0.2)),
                            label: Text(
                              'Speisekarte',
                              style: TextStyle(fontSize: 12),
                            ), // <-- Text
                            backgroundColor: Colors.grey.withOpacity(0.1),
                            icon: Icon(
                              // <-- Icon
                              Icons.menu_book,
                              size: 16.0,
                            ),
                            onPressed: () {},
                            // extendedPadding: EdgeInsets.all(50),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 10, 5),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.40,
                          height: MediaQuery.of(context).size.width * 0.1,
                          child: FloatingActionButton.extended(
                            // heroTag: 'location_offers',
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8)), side: BorderSide(color: Colors.white, width: 0.2)),

                            label: Text(
                              'Unser Barista',
                              style: TextStyle(fontSize: 12),
                            ), // <-- Text
                            backgroundColor: Colors.grey.withOpacity(0.1),
                            icon: Icon(
                              // <-- Icon
                              Icons.account_box,
                              size: 16.0,
                            ),
                            onPressed: () {},
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 10, 5),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.40,
                          height: MediaQuery.of(context).size.width * 0.1,
                          child: FloatingActionButton.extended(
                            // heroTag: 'location_offers',
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8)), side: BorderSide(color: Colors.white, width: 0.2)),
                            label: Text(
                              'Kaffeesorten',
                              style: TextStyle(fontSize: 12),
                            ), // <-- Text
                            backgroundColor: Colors.grey.withOpacity(0.1),
                            icon: Icon(
                              // <-- Icon
                              Icons.coffee,
                              size: 16.0,
                            ),
                            onPressed: () {},
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}