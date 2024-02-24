// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'package:sharemagazines_flutter/pdfreadermain.dart';
import 'package:sharemagazines/src/blocs/auth/auth_bloc.dart';
import 'package:sharemagazines/src/blocs/ebook/ebook_bloc.dart';
import 'package:sharemagazines/src/blocs/navbar/navbar_bloc.dart';
import 'package:sharemagazines/src/blocs/reader/reader_bloc.dart';
import 'package:sharemagazines/src/blocs/searchpage/search_bloc.dart';
import 'package:sharemagazines/src/blocs/splash/splash_bloc.dart';
import 'package:sharemagazines/src/presentation/pages/reader/readerpage.dart';
import 'package:sharemagazines/src/presentation/pages/splash.dart';
import 'package:sharemagazines/src/presentation/widgets/customloading.dart';
import 'package:sharemagazines/src/presentation/widgets/src/easy_loading.dart';
import 'package:sharemagazines/src/resources/auth_repository.dart';
import 'package:sharemagazines/src/resources/hotspot_repository.dart';
import 'package:sharemagazines/src/resources/location_repository.dart';
import 'package:sharemagazines/src/resources/magazine_repository.dart';
import 'package:get_it/get_it.dart';

// import ‘package:flutter/services.dart’;
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

  //Langange package init
  WidgetsFlutterBinding.ensureInitialized();

  await EasyLocalization.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) => runApp(EasyLocalization(
      supportedLocales: [Locale('en'), Locale('de')],
      path: 'assets/translations', // <-- change the path of the translation files
      fallbackLocale: Locale('en'),
      child: MyApp())));

  runApp(EasyLocalization(
      supportedLocales: [Locale('en'), Locale('de')],
      path: 'assets/translations', // <-- change the path of the translation files
      fallbackLocale: Locale('en'),
      child: MyApp()));
  configLoading();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    // ..indicatorType = EasyLoadingIndicatorType.wanderingCubes
    ..indicatorType = EasyLoadingIndicatorType.shmg
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 115.0
    ..radius = 30.0
    ..progressColor = Colors.blue
    ..backgroundColor = Colors.transparent
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.white
    ..textStyle
    // ..maskColor = Colors.blue.withOpacity(0.5)
    ..maskColor = Colors.transparent
    ..userInteractions = false
    ..dismissOnTap = false;
  // ..customAnimation = CustomAnimation();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final ThemeData baseTheme = ThemeData.light();
    TextTheme customTextTheme = GoogleFonts.ralewayTextTheme(baseTheme.textTheme).copyWith(
        bodyMedium: TextStyle(color: Colors.white),
        bodySmall: TextStyle(color: Colors.white),
        bodyLarge: TextStyle(color: Colors.white),
        titleSmall: TextStyle(color: Colors.white),
        titleMedium: TextStyle(color: Colors.white),
        titleLarge: TextStyle(color: Colors.white),
        displaySmall: TextStyle(color: Colors.white),
        displayMedium: TextStyle(color: Colors.white),
        displayLarge: TextStyle(color: Colors.white),
        headlineSmall: TextStyle(color: Colors.white),
        headlineMedium: TextStyle(color: Colors.white),
        headlineLarge: TextStyle(color: Colors.white),
        labelSmall: TextStyle(color: Colors.grey, fontWeight: FontWeight.w100, fontSize: 14),
        labelMedium: TextStyle(color: Colors.grey, fontWeight: FontWeight.w100, fontSize: 16),
        labelLarge: TextStyle(color: Colors.grey, fontWeight: FontWeight.w100, fontSize: 18));
    EasyLoading.instance.textStyle = Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white);
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
            ),
          ),
          BlocProvider<SplashBloc>(
              create: (context) => SplashBloc(
                  authRepository: RepositoryProvider.of<AuthRepository>(context),
                  locationRepository: RepositoryProvider.of<LocationRepository>(context))),
          BlocProvider<NavbarBloc>(
              create: (context) => NavbarBloc(
                  magazineRepository: RepositoryProvider.of<MagazineRepository>(context),
                  locationRepository: RepositoryProvider.of<LocationRepository>(context),
                  hotspotRepository: RepositoryProvider.of<HotspotRepository>(context))),
          BlocProvider<SearchBloc>(create: (context) => SearchBloc(magazineRepository: RepositoryProvider.of<MagazineRepository>(context))),
          BlocProvider<ReaderBloc>(create: (context) => ReaderBloc(magazineRepository: RepositoryProvider.of<MagazineRepository>(context))),
          BlocProvider<EbookBloc>(create: (context) => EbookBloc(magazineRepository: RepositoryProvider.of<MagazineRepository>(context))),
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

          //langange package parameteres
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,

          theme: ThemeData(
              primarySwatch: Colors.blue, // Your primary color for the app
              colorScheme: ColorScheme.fromSwatch(
                primarySwatch: Colors.blue, // This sets the main color for the scheme
                accentColor: Colors.blueAccent, // This sets the accent color in the scheme

              ).copyWith(
                secondary: Colors.blueAccent, // Used for elements like floating action buttons
                // Define other colors like surface, background, error, etc., as needed
              ),
              textTheme: customTextTheme,
              iconTheme: IconThemeData(
                color: Colors.white, // Set the color for icons
              ),
              // primarySwatch: Colors.green,
              primaryIconTheme: IconThemeData(
                color: Colors.white, // Set the color for primary icons
              ),

              inputDecorationTheme: InputDecorationTheme(
                floatingLabelStyle: TextStyle(color: Colors.blue),
                // Focused border color
                border:
                    OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 5), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                errorBorder:
                    OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10.0)), borderSide: BorderSide(color: Colors.red, width: 1)),
                enabledBorder: const OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                focusedBorder:
                    OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10.0)), borderSide: BorderSide(color: Colors.blue, width: 1)),
              ),
              textSelectionTheme: TextSelectionThemeData(
                cursorColor: Colors.blue, // Change this to your desired cursor color
              ),

              pageTransitionsTheme: PageTransitionsTheme(builders: {
                TargetPlatform.android: CupertinoPageTransitionsBuilder(),
                TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
              }),
              // fontFamily: 'Raleway',

              // pageTransitionsTheme: PageTransitionsTheme(builders: {TargetPlatform.android: CupertinoPageTransitionsBuilder(), TargetPlatform.iOS: CupertinoPageTransitionsBuilder()}),
              dividerColor: Colors.transparent),
          home: SplashScreen(),
          builder: EasyLoading.init(),
        ),
      ),
    );
  }

// @override
// Widget build(BuildContext context) {
//   return MaterialApp(
//     title: 'sharemagazines',
//     theme: ThemeData(
//         // bottomSheetTheme: BottomSheetThemeData(
//         //     backgroundColor: Colors.black.withOpacity(0)),
//         //primarySwatch: Colors.blue,
//         pageTransitionsTheme: PageTransitionsTheme(builders: {
//           TargetPlatform.android: CupertinoPageTransitionsBuilder(),
//           TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
//         }),
//         fontFamily: 'Raleway',
//
//         // pageTransitionsTheme: PageTransitionsTheme(builders: {TargetPlatform.android: CupertinoPageTransitionsBuilder(), TargetPlatform.iOS: CupertinoPageTransitionsBuilder()}),
//         dividerColor: Colors.transparent),
//     home: StartReaderTesting(),
//   );
// }
}