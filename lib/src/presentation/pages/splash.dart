import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sharemagazines_flutter/src/blocs/navbar_bloc.dart';

import 'package:sharemagazines_flutter/src/blocs/splash_bloc.dart';
import 'package:sharemagazines_flutter/src/presentation/widgets/splash_widget.dart';
import 'package:sharemagazines_flutter/src/resources/auth_repository.dart';
import 'package:sharemagazines_flutter/src/resources/hotspot_repository.dart';

import 'startpage.dart';

// This the widget where the BLoC states and events are handled.
class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
    );
  }

  MultiBlocProvider _buildBody(BuildContext context) {
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
    return MultiBlocProvider(
      providers: [
        BlocProvider<SplashBloc>(
          create: (BuildContext context) => SplashBloc(),
        ),
      ],
      child: BlocBuilder<SplashBloc, SplashState>(
        builder: (context, state) {
          if ((state is Initial)) {
            //add lodaing state
            return SplashScreenWidget();
          } else if (state is Loaded) {
            return StartPage(title: "notitle");
          }
          return StartPage(title: "notitle");
        },
      ),
    );
  }
}
