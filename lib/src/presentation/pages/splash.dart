import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sharemagazines_flutter/src/blocs/auth/auth_bloc.dart';

import 'package:sharemagazines_flutter/src/blocs/splash/splash_bloc.dart';
import 'package:sharemagazines_flutter/src/presentation/pages/mainpage.dart';
import 'package:sharemagazines_flutter/src/presentation/widgets/splash_widget.dart';

import '../../blocs/navbar/navbar_bloc.dart';
import '../../models/location_model.dart';
import 'startpage.dart';

// This the widget where the BLoC states and events are handled.
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
        Align(child: _buildBody(context))
      ],
      // body: _buildBody(context),
    );
  }

  BlocBuilder<SplashBloc, SplashState> _buildBody(BuildContext context) {
    return BlocBuilder<SplashBloc, SplashState>(
      builder: (context, state) {
        print("bloc builder splash");
        if ((state is Initial)) {
          //add lodaing state
          BlocProvider.of<SplashBloc>(context).add(
            NavigateToHomeEvent(),
          );
          return SplashScreenWidget();
          //return StartPage(
          // title: "notitle",
          //splashbloc: BlocProvider.of<SplashBloc>(context),
          //);
          // return Navigator.of(context).push(PageRouteBuilder(pageBuilder: (BuildContext context, _, __) => SplashScreenWidget()));
        }
        // else if (state is SkipLogin) {
        //   // await authRepository.signIn(email: existingemail, password: existingpwd).then((value) => {emit(IncompleteAuthenticated())});
        //   BlocProvider.of<AuthBloc>(context).add(SignInRequested(state.email, state.pwd));
        //
        //   return StartPage(
        //     title: "notitle",
        //   );
        // }
        else if (state is SkipLogin) {
          // await authRepository.signIn(email: existingemail, password: existingpwd).then((value) => {emit(IncompleteAuthenticated())});
          BlocProvider.of<AuthBloc>(context).add(SignInRequested(state.email, state.pwd, "","",false));
          return BlocListener<AuthBloc, AuthState>(
              listener: (context, state) {
                // Check if the state is the one you expect after IncompleteSignInRequested
                if (state is Authenticated) {
                  // Now that AuthBloc has finished its work, do the next steps
                  BlocProvider.of<NavbarBloc>(context).add(InitializeNavbar(currentPosition: Data()));

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => MainPage()),
                        (Route<dynamic> route) => false,
                  );
                }else{
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => StartPage(title: "title")),
                        (Route<dynamic> route) => false,
                  );
                }
              },
            child: Container(),
              // child: ... // Rest of your widget tree
          );

          // Navigator.pushAndRemoveUntil(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => const StartPage(
          //       title: "notitle",
          //     ),
          //     // transitionDuration: Duration.zero,
          //   ),
          //   (_) => false,
          // );
          // Future.delayed(Duration(milliseconds: 5), () async { BlocProvider.of<NavbarBloc>(context).add(InitializeNavbar(currentPosition: Data()));
          // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MainPage()), (Route<dynamic> route) => false);
          // });

          // return MainPage();
          // return Container();
        } else if (state is SkipLoginIncomplete) {

          // await authRepository.signIn(email: existingemail, password: existingpwd).then((value) => {emit(IncompleteAuthenticated())});
          // BlocProvider.of<AuthBloc>(context).add(IncompleteSignInRequested());
          return const StartPage(
            title: "notitle",
          );
          // return BlocListener<AuthBloc, AuthState>(
          //   listener: (context, state) {
          //     // Check if the state is the one you expect after IncompleteSignInRequested
          //     if (state is IncompleteAuthenticated) {
          //       // Now that AuthBloc has finished its work, do the next steps
          //       BlocProvider.of<NavbarBloc>(context).add(InitializeNavbar(currentPosition: Data()));
          //
          //       Navigator.pushAndRemoveUntil(
          //         context,
          //         MaterialPageRoute(builder: (context) => MainPage()),
          //             (Route<dynamic> route) => false,
          //       );
          //     }
          //   },
          //   child: Container(),
          //   // child: ... // Rest of your widget tree
          // );
          // Future.delayed(Duration(milliseconds: 500), () async { BlocProvider.of<NavbarBloc>(context).add(InitializeNavbar(currentPosition: Data()));
          // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MainPage()), (Route<dynamic> route) => false);
          // });
          // return  Container(color: Colors.green,child: Text(BlocProvider.of<AuthState>(context).s),);
        }

        else if (state is Loaded) {
          return const StartPage(
            title: "notitle",
          );
        } else if (state is SplashError) {
          print(state.error);
          // print(state.position?.latitude);
          BlocProvider.of<AuthBloc>(context).emit(AuthError(state.error));
          return const StartPage(
            title: "notitle",
          );

        }
        return Container();

      },
    );
  }
}