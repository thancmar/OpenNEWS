import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sharemagazines_flutter/src/blocs/searchpage/search_bloc.dart';
import 'package:sharemagazines_flutter/src/blocs/splash/splash_bloc.dart';

class SplashScreenWidget extends StatefulWidget {
  @override
  _SplashScreenWidgetState createState() => _SplashScreenWidgetState();
}

class _SplashScreenWidgetState extends State<SplashScreenWidget> {
  @override
  void initState() {
    super.initState();
    //This  will dispatch the navigateToHomeScreen event.
    BlocProvider.of<SplashBloc>(context).add(
      NavigateToHomeEvent(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: Image.asset(
                "assets/images/Background.png",
                fit: BoxFit.fill,
                // allowDrawingOutsideViewBox: true,
              ),
            ),
            Positioned.fill(
              child: const Image(image: AssetImage('assets/images/logo.png')),
              // child: new Image.asset(
              //   image: "assets/images/logo.png",
              //
              //   //fit: BoxFit.fill,
              // ),
            )
          ],
        ),
      ),
    );
  }
}