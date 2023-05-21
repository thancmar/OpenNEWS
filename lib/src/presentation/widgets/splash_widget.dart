import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sharemagazines_flutter/src/blocs/searchpage/search_bloc.dart';
import 'package:sharemagazines_flutter/src/blocs/splash/splash_bloc.dart';

// class SplashScreenWidget extends StatefulWidget {
//   @override
//   _SplashScreenWidgetState createState() => _SplashScreenWidgetState();
// }
//
// class _SplashScreenWidgetState extends State<SplashScreenWidget> {
//   @override
//   void initState() {
//     super.initState();
//     //This  will dispatch the navigateToHomeScreen event.
//     BlocProvider.of<SplashBloc>(context).add(
//       NavigateToHomeEvent(),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         fit: StackFit.expand,
//         children: <Widget>[
//           // Positioned.fill(
//           //   child:
//             Image.asset(
//               "assets/images/background/Background.png",
//               fit: BoxFit.fill,
//               // allowDrawingOutsideViewBox: true,
//             ),
//           // ),
//           Center(
//             child: Image.asset(
//               'assets/images/logo/logo.png',
//               width: MediaQuery.of(context).size.width * 5.9,
//               // ,fit: BoxFit.,filterQuality: FilterQuality.medium,
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }

class SplashScreenWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Stack(
        fit: StackFit.expand,
        children: <Widget>[
          // Positioned.fill(
          //   child:
          Image.asset(
            "assets/images/background/Background.png",
            fit: BoxFit.fill,
            // allowDrawingOutsideViewBox: true,
          ),
          // ),
          Center(
            child: Image.asset(
              'assets/images/logo/logo.png',
              width: MediaQuery.of(context).size.width * 0.5,
              // ,fit: BoxFit.,
              // filterQuality: FilterQuality.high,
            ),
          )
        ],
      ),
    );
  }
}