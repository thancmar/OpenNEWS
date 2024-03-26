import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sharemagazines/src/blocs/auth/auth_bloc.dart';
import 'package:sharemagazines/src/blocs/splash/splash_bloc.dart';
import 'package:sharemagazines/src/presentation/pages/navbarpages/mainpage.dart';

import '../../blocs/navbar/navbar_bloc.dart';
import '../../models/location_model.dart';
import 'startpage/startpage.dart';

class SplashScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Hero(
            tag: 'bg',
            child: Image.asset(
              "assets/images/background/Background.png",
              fit: BoxFit.fill,
              // allowDrawingOutsideViewBox: true,
            ),
          ),
        ),
        Align(child: BlocBuilder<SplashBloc, SplashState>(
          builder: (context, state) {
            if ((state is Initial)) {
              BlocProvider.of<SplashBloc>(context).add(
                NavigateToHomeEvent(),
              );
              return SplashScreenWidget(context);
            } else if (state is SkipLogin) {
              // await authRepository.signIn(email: existingemail, password: existingpwd).then((value) => {emit(IncompleteAuthenticated())});
              BlocProvider.of<AuthBloc>(context).add(SignInRequested(state.email, state.pwd, "", "", false));
              return BlocListener<AuthBloc, AuthState>(
                listener: (context, state) {
                  // Check if the state is the one you expect after IncompleteSignInRequested
                  if (state is Authenticated) {
                    // Now that AuthBloc has finished its work, do the next steps
                    BlocProvider.of<NavbarBloc>(context).add(InitializeNavbar(currentPosition: LocationData()));
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => MainPage()),
                      (Route<dynamic> route) => false,
                    );
                  } else {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => StartPage(title: "title")),
                      (Route<dynamic> route) => false,
                    );
                  }
                },
                child: Container(),
              );
            } else if (state is SkipLoginIncomplete) {
              return const StartPage(
                title: "notitle",
              );
            } else if (state is Loaded) {
              return const StartPage(
                title: "notitle",
              );
            } else if (state is SplashError) {
              print(state.error);
              BlocProvider.of<AuthBloc>(context).emit(AuthError(state.error));
              return const StartPage(
                title: "notitle",
              );
            }
            return Container();
          },
        ))
      ],
    );
  }

  Widget SplashScreenWidget(BuildContext context) {
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