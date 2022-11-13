import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sharemagazines_flutter/src/blocs/navbar_bloc.dart';

import 'package:sharemagazines_flutter/src/blocs/splash_bloc.dart';
import 'package:sharemagazines_flutter/src/presentation/widgets/splash_widget.dart';
import 'package:sharemagazines_flutter/src/resources/auth_repository.dart';
import 'package:sharemagazines_flutter/src/resources/hotspot_repository.dart';
import 'package:sharemagazines_flutter/src/resources/location_repository.dart';

import 'startpage.dart';

// This the widget where the BLoC states and events are handled.
class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
    );
  }

  BlocBuilder<SplashBloc, SplashState> _buildBody(BuildContext context) {
    // return BlocProvider(
    //   create: (BuildContext context) => SplashBloc(
    //
    //       // RepositoryProvider.of<HotspotRepository>(context),
    //       // RepositoryProvider.of<AuthRepository>(context)
    //       ),
    //   child: BlocBuilder<SplashBloc, SplashState>(
    //     builder: (context, state) {
    //       if ((state is Initial || state is Loading)) {
    //         //add lodaing state
    //         return SplashScreenWidget();
    //       } else if (state is Loaded) {
    //         return StartPage(title: "notitle");
    //       }
    //       return StartPage(title: "notitle");
    //     },
    //   ),
    // );
    return BlocBuilder<SplashBloc, SplashState>(
      // bloc: BlocProvider.of(context),
      builder: (context, state) {
        print("bloc builder splash");
        if ((state is Initial)) {
          //add lodaing state
          return SplashScreenWidget();
          //return StartPage(
          // title: "notitle",
          //splashbloc: BlocProvider.of<SplashBloc>(context),
          //);
          // return Navigator.of(context).push(PageRouteBuilder(pageBuilder: (BuildContext context, _, __) => SplashScreenWidget()));
        } else if (state is Loaded) {
          print("SplashScreen state is loaded");
          print(state.position?.latitude);
          return StartPage(
            title: "notitle",
            splashbloc: BlocProvider.of<SplashBloc>(context),
          );
          // Navigator.of(context).push(PageRouteBuilder(
          //     pageBuilder: (BuildContext context, _, __) => StartPage(
          //           title: "notitle",
          //           splashbloc: BlocProvider.of<SplashBloc>(context),
          //         )));
        }
        return StartPage(
          title: "notitle",
          splashbloc: BlocProvider.of<SplashBloc>(context),
        );
      },
    );
    // return MultiBlocProvider(
    //   providers: [
    //     BlocProvider<SplashBloc>(
    //       create: (BuildContext context) => SplashBloc(),
    //     ),
    //     BlocProvider<NavbarBloc>(
    //       create: (BuildContext context) => NavbarBloc(magazineRepository: RepositoryProvider<MagazineRepository>(context), locationRepository: RepositoryProvider<LocationRepository>(context)),
    //     ),
    //   ],
    //   child: BlocBuilder<SplashBloc, SplashState>(
    //     builder: (context, state) {
    //       if ((state is Initial)) {
    //         //add lodaing state
    //         return SplashScreenWidget();
    //       } else if (state is Loaded) {
    //         print(state.position.latitude);
    //         return StartPage(
    //           title: "notitle",
    //           splashbloc: BlocProvider.of<SplashBloc>(context),
    //         );
    //       }
    //       return StartPage(
    //         title: "notitle",
    //         splashbloc: BlocProvider.of<SplashBloc>(context),
    //       );
    //     },
    //   ),
    // );
  }
}