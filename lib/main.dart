// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sharemagazines_flutter/src/blocs/auth_bloc.dart';
import 'package:sharemagazines_flutter/src/blocs/navbar_bloc.dart';
import 'package:sharemagazines_flutter/src/blocs/search_bloc.dart';
import 'package:sharemagazines_flutter/src/blocs/splash_bloc.dart';
import 'package:sharemagazines_flutter/src/presentation/pages/splash.dart';
import 'package:sharemagazines_flutter/src/resources/auth_repository.dart';
import 'package:sharemagazines_flutter/src/resources/hotspot_repository.dart';
import 'package:sharemagazines_flutter/src/resources/location_repository.dart';
import 'package:sharemagazines_flutter/src/resources/magazine_repository.dart';
import 'package:get_it/get_it.dart';
// import 'package:rest_api_work/Service/note_service.dart';
// import 'firebase_options.dart';

// import 'firebase_options.dart';

Future<void> main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // prefs.setString('email', "");
  // prefs.setString('pw', "");
  // print(email);

  // await Firebase.initializeApp();
  //
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemStatusBarContrastEnforced: true,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark));

//Setting SystmeUIMode
//   SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge,
//       overlays: [SystemUiOverlay.top]);
//   setUpLocator();
//   configureInjection();
  runApp(const MyApp());
  configLoading();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.wanderingCubes
    ..loadingStyle = EasyLoadingStyle.light
    ..indicatorSize = 55.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = false
    ..dismissOnTap = false;

  // ..customAnimation = CustomAnimation();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(create: (context) => AuthRepository()),
        RepositoryProvider<HotspotRepository>(create: (context) => HotspotRepository()),
        RepositoryProvider<MagazineRepository>(
          create: (context) => MagazineRepository(),
          lazy: false,
        ),
        RepositoryProvider<LocationRepository>(create: (context) => LocationRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          ///Have to add all blocs here
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(
              //no need of Authbloc here
              authRepository: RepositoryProvider.of<AuthRepository>(context),
              hotspotRepository: RepositoryProvider.of<HotspotRepository>(context),
            ),
          ),
          BlocProvider<SplashBloc>(create: (context) => SplashBloc()),
          BlocProvider<NavbarBloc>(
              create: (context) => NavbarBloc(
                  magazineRepository: RepositoryProvider.of<MagazineRepository>(context),
                  locationRepository: RepositoryProvider.of<LocationRepository>(context),
                  hotspotRepository: RepositoryProvider.of<HotspotRepository>(context))),
          BlocProvider<SearchBloc>(create: (context) => SearchBloc(magazineRepository: RepositoryProvider.of<MagazineRepository>(context))),
          // BlocProvider<AuthBloc>(
          //   create: (context) => AuthBloc(
          //     //no need of Authbloc here
          //     authRepository: RepositoryProvider.of<AuthRepository>(context),
          //     hotspotRepository: RepositoryProvider.of<HotspotRepository>(context),
          //   ),
          // ),
        ],
        // create: (context) => AuthBloc(
        //   //no need of Authbloc here
        //   authRepository: RepositoryProvider.of<AuthRepository>(context),
        //   hotspotRepository: RepositoryProvider.of<HotspotRepository>(context),
        // ),
        child: MaterialApp(
          title: 'sharemagazines',
          theme: ThemeData(
              // bottomSheetTheme: BottomSheetThemeData(
              //     backgroundColor: Colors.black.withOpacity(0)),
              //primarySwatch: Colors.blue,
              pageTransitionsTheme: PageTransitionsTheme(builders: {TargetPlatform.android: CupertinoPageTransitionsBuilder(), TargetPlatform.iOS: CupertinoPageTransitionsBuilder()}),
              dividerColor: Colors.transparent),
          home: SplashScreen(),
          builder: EasyLoading.init(),
        ),
      ),
    );
  }
}