import 'package:flutter/material.dart';
import 'package:sharemagazines_flutter/src/presentation/pages/navbarpages/accountpage/accountPage_widgets.dart';

class AccountPage extends StatefulWidget {
  final PageController pageController;
  final Function onClick;
  const AccountPage({Key? key,required this.pageController,required this.onClick}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage>
    with
        SingleTickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<AccountPage> {
  double widget1Opacity = 0.0;
  //Count the amount of time the Hero animation
  AnimationController? controller;
  // Generating some dummy data

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(milliseconds: 1), () {
      widget1Opacity = 1;
      setState(() {});
      controller = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 150),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return WillPopScope(
      onWillPop: () async {
        // This block will be called when the Navigator is popped
        print('Navigator was popped');
        return true; // returning true allows the pop to happen
      },
      child: SafeArea(
        child: Container(
          child: AccountPageWidgets(pageController : widget.pageController,onClick: widget.onClick),
        ),
      ),
    );
  }
}