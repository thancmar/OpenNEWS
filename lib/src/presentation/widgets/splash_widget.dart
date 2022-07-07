import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sharemagazines_flutter/src/blocs/splash_bloc.dart';

class SplashScreenWidget extends StatefulWidget {
  @override
  _SplashScreenWidgetState createState() => _SplashScreenWidgetState();
}

class _SplashScreenWidgetState extends State<SplashScreenWidget> {
  @override
  void initState() {
    super.initState();
    this._dispatchEvent(
        context); // This will dispatch the navigateToHomeScreen event.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: new SvgPicture.asset(
                "assets/images/background_webreader.svg",
                fit: BoxFit.fill,
                allowDrawingOutsideViewBox: true,
              ),
            ),
            Positioned.fill(
              child: new Image.asset(
                "assets/images/logo@2x.png",
                //fit: BoxFit.fill,
              ),
            )
          ],
        ),
      ),
    );
  }

  //This method will dispatch the navigateToHomeScreen event.
  void _dispatchEvent(BuildContext context) {
    BlocProvider.of<SplashBloc>(context).add(
      NavigateToHomeEvent(),
    );
  }
}
