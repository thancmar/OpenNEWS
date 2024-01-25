import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_svg/parser.dart';

import 'package:sharemagazines_flutter/src/blocs/auth/auth_bloc.dart';
import 'package:sharemagazines_flutter/src/presentation/clip.dart';
import 'package:sharemagazines_flutter/src/presentation/pages/coveranimmation.dart';
import 'package:sharemagazines_flutter/src/presentation/pages/mainpage.dart';
import 'package:sharemagazines_flutter/src/presentation/pages/registrationpage.dart';

import '../../blocs/navbar/navbar_bloc.dart';
import '../../models/location_model.dart';
import '../validators/emailvalidator.dart';
import '../widgets/marquee.dart';

// import 'package:sharemagazines_flutter/src/presentation/pages/login.dart';
// import 'package:sharemagazines_flutter/src/presentation/pages/map_page.dart';

class StartPage extends StatefulWidget {
  final String title;

  const StartPage({Key? key, required this.title}) : super(key: key);

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  GlobalKey _widgetKey = GlobalKey();
  late final AnimationController _controller = AnimationController(
    duration: Duration(seconds: 5),
    vsync: this,
  )..repeat(reverse: true);
  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    // begin: Offset.zero,
    begin: Offset(-0.1, -0.1),
    end: Offset(-0.5, -0.50),
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: Curves.linear,
  ));
  bool hideBackground = false;
  late final AnimationController covercontroller = AnimationController(
    // duration: const Duration(seconds: 10),

    vsync: this,
  );

  // ..repeat(reverse: true);

  // List<Widget> generateAlternatingWidgets(int count) {
  //   List<Widget> widgets = [];
  //   for (int i = 0; i < count; i++) {
  //     if (i % 2 == 0) {
  //       widgets.add(coverWidget());
  //     } else {
  //       widgets.add(coverWidget2());
  //     }
  //   }
  //   return widgets;
  // }

  // TextEditingController _emailController = TextEditingController();
  TextEditingController _emailController = TextEditingController(text: AuthState.savedEmail);
  TextEditingController _passwordController = TextEditingController(text: AuthState.savedPWD);
  var focusUserID = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: AuthState.savedEmail);
    // Navigator.of(context).popUntil((route) => route.isFirst);
    // BlocProvider.of<AuthBloc>(context).add(Initialize());
  }

  @override
  void didUpdateWidget(StartPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update the controller if the savedEmail has changed
    if (AuthState.savedEmail != _emailController.text) {
      _emailController.text = AuthState.savedEmail??"";
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // else
    //   if (state is GoToLoginPage) {
    //   Navigator.push(
    //     context,
    //     PageRouteBuilder(
    //       pageBuilder: (context, animation1, animation2) => LoginPage(
    //         // title: 'Login',
    //         splashbloc: widget.splashbloc,
    //       ),
    //       transitionDuration: Duration.zero,
    //     ),
    //   );
    // } else if (state is AuthError) {
    //   Navigator.pushAndRemoveUntil(
    //       context,
    //       MaterialPageRoute(
    //           builder: (context) => StartPage(
    //             title: widget.title,
    //             splashbloc: widget.splashbloc,
    //           )),
    //           (Route<dynamic> route) => false); //removes
    //   // everything below
    //   // MainPage()
    // }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: LayoutBuilder(
        builder: (context, BoxConstraints constraints) {
          return Stack(
            children: <Widget>[
              Positioned.fill(
                child: Hero(
                  tag: 'bg',
                  child: Image.asset(
                    "assets/images/background/Background.png",
                    fit: BoxFit.cover,
                    //allowDrawingOutsideViewBox: true,
                  ),
                ),
              ),

              (MediaQuery.of(context).viewInsets.bottom > 0.0 || hideBackground == true)
                  ? Container()
                  : Positioned(
                      top: 0,
                      left: 0,
                      child: ClipPath(
                        clipper: InnerClipper(
                          height: constraints.constrainHeight() / 2,
                          width: constraints.constrainWidth(),
                          borderRadius: 20,
                          borderWidth: 0.10,
                          // Match with BoxDecoration borderWidth
                          padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 45.0),
                          // padding: EdgeInsets.fromLTRB(size.width * 0.045, size.height * 0.01, size.width * 0.045, size.height * 0.001),
                        ),
                        child: Container(
                          color: Colors.transparent,
                          height: constraints.constrainHeight(),
                          width: constraints.constrainWidth(),
                          child: AnimatedBackground(
                              // controller: covercontroller,
                              ),
                        ),
                        // child: AnimatedBackground()
                        // child: SlideTransition(
                        //   position: _offsetAnimation,
                        //   child: Wrap(
                        //
                        //     spacing: 15.0,       // horizontal spacing
                        //     runSpacing: 10.0,   // vertical spacing
                        //     children: generateAlternatingWidgets(20),
                        //   ),
                        // )
                      ),
                    ),
              // AnimatedBackground(),
              BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
                if (state is Authenticated || state is IncompleteAuthenticated || state is AuthenticatedWithGoogle) {
                  // Navigating to the dashboard screen if the user is authenticated
                  // Navigator.pushReplacement(
                  //     context, MaterialPageRoute(builder: (context) => MainPage()));+

                  print("AuthState $state");
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  Future.delayed(Duration(milliseconds: 5), () async {
                    BlocProvider.of<NavbarBloc>(context).add(InitializeNavbar(currentPosition: Data()));
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MainPage()), (Route<dynamic> route) => false);

                    // BlocProvider.of<NavbarBloc>(context);
                    // BlocProvider.of<NavbarBloc>(context).add(Initialize123(currentPosition: SplashState.appbarlocation));
                    // setState(() {});
                  });
                  return Container();
                  // } else if (state is GoToLoginPage) {
                  //   return Stack(
                  //     children: [
                  //       Positioned(
                  //         top: MediaQuery.of(context).viewInsets.bottom > 0.0 ? 50 : constraints.constrainHeight() / 2,
                  //         height: constraints.constrainHeight() / 2,
                  //         width: constraints.constrainWidth(),
                  //         child: Align(
                  //           alignment: MediaQuery.of(context).viewInsets.bottom > 0.0 ? Alignment.topCenter : Alignment.bottomCenter,
                  //           child: Container(
                  //             margin: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 45.0),
                  //             // margin: EdgeInsets.fromLTRB(size.width * 0.045, size.height * 0.025, size.width * 0.045, size.height * 0.025),
                  //             decoration: new BoxDecoration(
                  //               border: Border.all(color: Colors.blueAccent, width: 0.10),
                  //               borderRadius: new BorderRadius.circular(20.0),
                  //               // color: Colors.red,
                  //             ),
                  //             child: Form(
                  //               key: _formKey,
                  //               child: Column(
                  //                 crossAxisAlignment: CrossAxisAlignment.stretch,
                  //                 children: <Widget>[
                  //                   Expanded(
                  //                     flex: 2,
                  //                     child: Padding(
                  //                       padding: EdgeInsets.fromLTRB(20.0, 10.0, 0.0, 0.0),
                  //                       // padding: EdgeInsets.fromLTRB(size.width * 0.045, size.height * 0.01, size.width * 0.045, size.height * 0.001),
                  //
                  //                       child: Row(
                  //                         children: [
                  //                           BackButton(
                  //                             color: Colors.white,
                  //                             onPressed: () {
                  //                               // Navigator.pop(context, true);
                  //
                  //                               BlocProvider.of<AuthBloc>(context).add(Initialize());
                  //                             },
                  //                             // onPressed: () => Navigator.of(context).pop(true),
                  //                             // onPressed: () => {BlocProvider.of<AuthBloc>(context).add(Initialize())},
                  //                           ),
                  //                           Text(
                  //                             "Anmelden",
                  //                             textAlign: TextAlign.left,
                  //                             style: TextStyle(
                  //                               color: Colors.white,
                  //                               fontWeight: FontWeight.w700,
                  //                               fontSize: size.width * 0.065,
                  //                               //fontStyle: FontStyle.,
                  //                             ),
                  //                           ),
                  //                         ],
                  //                       ),
                  //                     ),
                  //                   ),
                  //                   Expanded(
                  //                     flex: 3,
                  //                     child: Padding(
                  //                       padding: EdgeInsets.fromLTRB(size.width * 0.045, size.height * 0.005, size.width * 0.045, size.height * 0.005),
                  //                       child: TextFormField(
                  //                         controller: _emailController,
                  //                         validator: (value) => validateEmail(value),
                  //                         style: TextStyle(color: Colors.white),
                  //                         // initialValue: state.savedEmail ,
                  //                         onEditingComplete: () => FocusScope.of(context).nextFocus(),
                  //                         decoration: InputDecoration(
                  //                           //Maybe we need it
                  //                           // contentPadding: const EdgeInsets.symmetric(
                  //                           //     vertical: 20.0, horizontal: 10.0),
                  //                           floatingLabelStyle: TextStyle(color: Colors.blue),
                  //                           labelText: "E-Mail oder Benutzernam",
                  //                           labelStyle: TextStyle(fontSize: size.width * 0.045, color: Colors.grey, fontWeight: FontWeight.w300),
                  //                           //, height: 3.8),
                  //                           border: OutlineInputBorder(
                  //                               borderSide: BorderSide(color: Colors.white, width: 5),
                  //                               borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  //                           errorBorder: OutlineInputBorder(
                  //                               borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  //                               borderSide: BorderSide(color: Colors.red, width: 1)),
                  //                           enabledBorder: const OutlineInputBorder(
                  //                             borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                  //                             borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  //                           ),
                  //                         ),
                  //                       ),
                  //                     ),
                  //                     // child: Padding(
                  //                     //   padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  //                     //   child: Container(
                  //                     //     padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 0.0),
                  //                     //     decoration: BoxDecoration(
                  //                     //       border: Border.all(color: Colors.grey),
                  //                     //       borderRadius: BorderRadius.all(
                  //                     //         Radius.circular(10),
                  //                     //       ),
                  //                     //     ),
                  //                     //     child: TextFormField(
                  //                     //       // controller: _emailController,
                  //                     //       // validator: (value) => validateEmail(value),
                  //                     //       style: TextStyle(color: Colors.white),
                  //                     //       decoration: InputDecoration(
                  //                     //           hintStyle: TextStyle(fontSize: 16.0, color: Colors.amberAccent),
                  //                     //           labelText: "E-Mail oder Benutzername",
                  //                     //           labelStyle: TextStyle(fontSize: 16.0, color: Colors.white),
                  //                     //           fillColor: Colors.red,
                  //                     //           hoverColor: Colors.amber, //, height: 3.8),
                  //                     //           border: InputBorder.none),
                  //                     //     ),
                  //                     //   ),
                  //                     // ),
                  //                   ),
                  //                   Expanded(
                  //                     flex: 3,
                  //                     child: Padding(
                  //                       padding: EdgeInsets.fromLTRB(size.width * 0.045, size.height * 0.005, size.width * 0.045, size.height * 0.005),
                  //                       child: TextFormField(
                  //                         controller: _passwordController,
                  //                         // validator: (value) {
                  //                         //   if (value == null || value.isEmpty) {
                  //                         //     return 'This is the required field';
                  //                         //   }
                  //                         //   return null;
                  //                         // },
                  //                         // validator: (value) => validateEmail(value),
                  //                         // initialValue: state.sa,
                  //                         obscureText: true,
                  //                         style: TextStyle(color: Colors.white),
                  //                         onFieldSubmitted: (_) => {
                  //                           // FocusScope.of(context).unfocus(),
                  //                           // if (_formKey.currentState!.validate())
                  //                           //   {
                  //                           //     FocusScope.of(context).unfocus(),
                  //                           //     // FocusManager.instance.primaryFocus?.unfocus(),
                  //                           //     BlocProvider.of<AuthBloc>(context).add(
                  //                           //       SignInRequested(_emailController.text, _passwordController.text),
                  //                           //     ),
                  //                           //   }
                  //                           // else
                  //                           //   {FocusScope.of(context).requestFocus()}
                  //                         },
                  //                         decoration: InputDecoration(
                  //                           //Maybe we need it
                  //                           // contentPadding: const EdgeInsets.symmetric(
                  //                           //     vertical: 20.0, horizontal: 10.0),
                  //                           floatingLabelStyle: TextStyle(color: Colors.blue),
                  //                           labelText: "Passwort",
                  //
                  //                           labelStyle: TextStyle(fontSize: 16.0, color: Colors.grey, fontWeight: FontWeight.w300),
                  //                           //, height: 3.8),
                  //                           border: OutlineInputBorder(
                  //                               borderSide: BorderSide(color: Colors.white, width: 5),
                  //                               borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  //                           errorBorder: OutlineInputBorder(
                  //                               borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  //                               borderSide: BorderSide(color: Colors.red, width: 1)),
                  //                           enabledBorder: const OutlineInputBorder(
                  //                             borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                  //                             borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  //                           ),
                  //                         ),
                  //                       ),
                  //                     ),
                  //                     // child: Padding(
                  //                     //   padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 20.0),
                  //                     //   child: Container(
                  //                     //     padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 0.0),
                  //                     //     decoration: BoxDecoration(
                  //                     //       border: Border.all(color: Colors.grey),
                  //                     //       borderRadius: BorderRadius.all(
                  //                     //         Radius.circular(10),
                  //                     //       ),
                  //                     //     ),
                  //                     //     child: TextFormField(
                  //                     //       // controller: _passwordController,
                  //                     //       obscureText: true,
                  //                     //       decoration: InputDecoration(
                  //                     //         labelText: "Passwort",
                  //                     //         labelStyle: TextStyle(fontSize: 16.0), //20.0, height: 3.8),
                  //                     //         border: InputBorder.none,
                  //                     //       ),
                  //                     //     ),
                  //                     //   ),
                  //                     // ),
                  //                   ),
                  //                   Expanded(
                  //                     flex: 2,
                  //                     child: Padding(
                  //                       padding: EdgeInsets.fromLTRB(size.width * 0.045, size.height * 0.005, size.width * 0.045, size.height * 0.005),
                  //                       child: InkWell(
                  //                         // onTap: () {
                  //                         //   print("I was tapped!");
                  //                         // },
                  //                         child: Text(
                  //                           "Passwort vergessen?",
                  //                           textAlign: TextAlign.left,
                  //                           style: TextStyle(
                  //                             color: Colors.blue,
                  //                             fontWeight: FontWeight.w300,
                  //                             fontSize: 16,
                  //                             //fontStyle: FontStyle.,
                  //                           ),
                  //                         ),
                  //                       ),
                  //                     ),
                  //                   ),
                  //                   Expanded(
                  //                     flex: 3,
                  //                     child: Padding(
                  //                       // padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 25.0),
                  //                       padding: EdgeInsets.fromLTRB(size.width * 0.045, size.height * 0.005, size.width * 0.045, size.height * 0.025),
                  //
                  //                       child: ElevatedButton(
                  //                         onPressed: () {
                  //                           if (_formKey.currentState!.validate()) {
                  //                             FocusManager.instance.primaryFocus?.unfocus();
                  //                             BlocProvider.of<AuthBloc>(context).add(
                  //                               SignInRequested(_emailController.text, _passwordController.text),
                  //                             );
                  //                           }
                  //                           // Navigator.pushReplacement(
                  //                           //   context,
                  //                           //   PageRouteBuilder(
                  //                           //     pageBuilder:
                  //                           //         (context, animation1, animation2) =>
                  //                           //             LoginPage(
                  //                           //       title: 'Login',
                  //                           //     ),
                  //                           //     transitionDuration: Duration.zero,
                  //                           //   ),
                  //                           // );
                  //                           // FirebaseAuth.instance
                  //                           //     .authStateChanges()
                  //                           //     .listen((User? user) {
                  //                           //   if (user == null) {
                  //                           //     print('User is currently signed out!');
                  //                           //   } else {
                  //                           //     print('User is signed in!');
                  //                           //   }
                  //                           // });
                  //                           // _authenticateWithEmailAndPassword(context);
                  //                         },
                  //                         style: ElevatedButton.styleFrom(
                  //                           onPrimary: Colors.white,
                  //                           shadowColor: Colors.blueAccent,
                  //                           elevation: 3,
                  //                           // side: BorderSide(width: 0.10, color: Colors.white),
                  //                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(size.height * 0.015)),
                  //                           // minimumSize: Size(100, 60), //////// HERE
                  //                           minimumSize: Size(size.width - 40, size.height * 0.075),
                  //                         ),
                  //                         child: Text(
                  //                           "Anmelden",
                  //                           style: TextStyle(
                  //                             color: Colors.white,
                  //                             fontWeight: FontWeight.w400,
                  //                             fontSize: size.width * 0.06,
                  //                             //fontStyle: FontStyle.,
                  //                           ),
                  //                         ),
                  //                       ),
                  //                     ),
                  //                   ),
                  //                 ],
                  //               ),
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   );
                  // }
                  // else if (state is LoadingAuth) {
                  //   return Container(color: Colors.blue,height: 200  ,width: 200,);
                  // return LoadingAnimation();
                } else if (state is AuthError) {
                  WidgetsBinding.instance!.addPostFrameCallback((_) {
                    if (mounted) {
                      setState(() {
                        hideBackground = true;
                      });
                    }
                  });
                  return AlertDialog(
                    title: Text(
                      'Error',
                      style: TextStyle(fontSize: 16.0, color: Colors.grey, fontWeight: FontWeight.w500),
                    ),
                    content: Text(state.error.toString(), style: TextStyle(fontSize: 16.0, color: Colors.grey, fontWeight: FontWeight.w300)),
                    actions: <Widget>[
                      // TextButton(
                      //   onPressed: () => Navigator.pop(context, 'Cancel'),
                      //   child: const Text('Cancel'),
                      // ),
                      TextButton(
                        onPressed: () => {
                          BlocProvider.of<AuthBloc>(context).add(
                            // OpenLoginPage(),
                            Initialize()
                          ),
                          setState(() {
                            hideBackground = false;
                          })
                        },
                        child: Text('OK'),
                      ),
                    ],
                  );
                }
                _emailController =
                    TextEditingController(
                      text: AuthState.savedEmail
                        // text:  BlocProvider.of<AuthBloc>(context).state.userDetails.response?.firstname
                      // text: AuthState.userDetails?.response?.firstname
                    );
                _passwordController =
                    TextEditingController(
                        text: AuthState.savedPWD
                      // text:  BlocProvider.of<AuthBloc>(context).state.userDetails.response?.firstname
                      // text: AuthState.userDetails?.response?.firstname
                    );
                return Material(
                  elevation: 0,
                  color: Colors.transparent,
                  child: Stack(
                    clipBehavior: Clip.hardEdge,
                    children: [
                      //     Positioned(
                      //       top: 0,
                      //       left: 0,
                      //       child: ClipPath(
                      //
                      //           clipper: TsClip1(_widgetKey),
                      //           // child: AnimatedBackground(),
                      //         child: Container(),
                      //           // child: SlideTransition(
                      //           //   position: _offsetAnimation,
                      //           //   child: Wrap(
                      //           //
                      //           //     spacing: 15.0,       // horizontal spacing
                      //           //     runSpacing: 10.0,   // vertical spacing
                      //           //     children: generateAlternatingWidgets(20),
                      //           //   ),
                      //           // )
                      // ),
                      //     ),
                      Positioned(
                        // top: constraints.constrainHeight() / 2,
                        top: (MediaQuery.of(context).viewInsets.bottom > 0.0 && state is GoToLoginPage) ? 50 : constraints.constrainHeight() / 2,

                        height: constraints.constrainHeight() / 2,
                        width: constraints.constrainWidth(),

                        // left: constraints.constrainWidth() / 2,
                        // child: FlutterLogo(),
                        // key: _widgetKey,
                        child: Container(
                          // key: _widgetKey,
                          margin: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 45.0),

                          decoration: BoxDecoration(
                            // border: Border.all(color: Colors.blueAccent, width: 0.15),
                            borderRadius: BorderRadius.circular(20.0),
                            color: Colors.transparent,

                            // boxShadow:  [
                            //   BoxShadow(
                            //       color: Colors.transparent,
                            //       blurRadius: 10,
                            //       offset: Offset(0, 0))
                            // ]
                            // color: Colors.red,
                          ),
                          child: SingleChildScrollView(
                            key: _widgetKey,
                            child: state is GoToLoginPage
                                ? Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Padding(
                                        // flex: 3,
                                        padding: EdgeInsets.fromLTRB(size.width * 0.05, size.height * 0.005, size.width * 0.05, size.height * 0.005),

                                        child: Form(
                                          key: _formKey,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.stretch,
                                            mainAxisSize: MainAxisSize.max,
                                            // mainAxisAlignment: MainAxisAlignment.start,
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.fromLTRB(20.0, 10.0, 0.0, 0.0),
                                                // padding: EdgeInsets.fromLTRB(size.width * 0.045, size.height * 0.01, size.width * 0.045, size.height * 0.001),

                                                child: Row(
                                                  children: [
                                                    BackButton(
                                                      color: Colors.white,
                                                      onPressed: () {
                                                        // Navigator.pop(context, true);

                                                        BlocProvider.of<AuthBloc>(context).add(Initialize());
                                                      },
                                                      // onPressed: () => Navigator.of(context).pop(true),
                                                      // onPressed: () => {BlocProvider.of<AuthBloc>(context).add(Initialize())},
                                                    ),
                                                    Text(
                                                      "Anmelden",
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.w700,
                                                        fontSize: size.width * 0.065,
                                                        //fontStyle: FontStyle.,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    size.width * 0.0145, size.height * 0.005, size.width * 0.0145, size.height * 0.005),
                                                child: TextFormField(
                                                  controller: _emailController,
                                                  validator: (value) => validateEmail(value),
                                                  style: TextStyle(color: Colors.white),
                                                  // initialValue: state.savedEmail ,
                                                  onEditingComplete: () => FocusScope.of(context).nextFocus(),
                                                  decoration: InputDecoration(
                                                    //Maybe we need it
                                                    // contentPadding: const EdgeInsets.symmetric(
                                                    //     vertical: 20.0, horizontal: 10.0),
                                                    floatingLabelStyle: TextStyle(color: Colors.blue),
                                                    labelText: "E-Mail oder Benutzernam",
                                                    labelStyle:
                                                        TextStyle(fontSize: size.width * 0.045, color: Colors.grey, fontWeight: FontWeight.w300),
                                                    //, height: 3.8),
                                                    border: OutlineInputBorder(
                                                        borderSide: BorderSide(color: Colors.white, width: 5),
                                                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                                    errorBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                                        borderSide: BorderSide(color: Colors.red, width: 1)),
                                                    enabledBorder: const OutlineInputBorder(
                                                      borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                                                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    size.width * 0.0145, size.height * 0.005, size.width * 0.0145, size.height * 0.005),
                                                child: TextFormField(
                                                  controller: _passwordController,
                                                  // validator: (value) {
                                                  //   if (value == null || value.isEmpty) {
                                                  //     return 'This is the required field';
                                                  //   }
                                                  //   return null;
                                                  // },
                                                  // validator: (value) => validateEmail(value),
                                                  // initialValue: state.sa,
                                                  obscureText: true,
                                                  style: TextStyle(color: Colors.white),
                                                  onFieldSubmitted: (_) => {
                                                    // FocusScope.of(context).unfocus(),
                                                    // if (_formKey.currentState!.validate())
                                                    //   {
                                                    //     FocusScope.of(context).unfocus(),
                                                    //     // FocusManager.instance.primaryFocus?.unfocus(),
                                                    //     BlocProvider.of<AuthBloc>(context).add(
                                                    //       SignInRequested(_emailController.text, _passwordController.text),
                                                    //     ),
                                                    //   }
                                                    // else
                                                    //   {FocusScope.of(context).requestFocus()}
                                                  },
                                                  decoration: InputDecoration(
                                                    //Maybe we need it
                                                    // contentPadding: const EdgeInsets.symmetric(
                                                    //     vertical: 20.0, horizontal: 10.0),
                                                    floatingLabelStyle: TextStyle(color: Colors.blue),
                                                    labelText: "Passwort",

                                                    labelStyle: TextStyle(fontSize: 16.0, color: Colors.grey, fontWeight: FontWeight.w300),
                                                    //, height: 3.8),
                                                    border: OutlineInputBorder(
                                                        borderSide: BorderSide(color: Colors.white, width: 5),
                                                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                                    errorBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                                        borderSide: BorderSide(color: Colors.red, width: 1)),
                                                    enabledBorder: const OutlineInputBorder(
                                                      borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                                                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    size.width * 0.0145, size.height * 0.005, size.width * 0.0145, size.height * 0.005),
                                                child: InkWell(
                                                  // onTap: () {
                                                  //   print("I was tapped!");
                                                  // },
                                                  child: Text(
                                                    "Passwort vergessen?",
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                      color: Colors.blue,
                                                      fontWeight: FontWeight.w300,
                                                      fontSize: 16,
                                                      //fontStyle: FontStyle.,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                // padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 25.0),
                                                padding: EdgeInsets.fromLTRB(
                                                    size.width * 0.0145, size.height * 0.005, size.width * 0.0145, size.height * 0.025),

                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    if (_formKey.currentState!.validate()) {
                                                      FocusManager.instance.primaryFocus?.unfocus();
                                                      BlocProvider.of<AuthBloc>(context).add(
                                                        SignInRequested(_emailController.text, _passwordController.text, '', '', false),
                                                      );
                                                    }
                                                    // Navigator.pushReplacement(
                                                    //   context,
                                                    //   PageRouteBuilder(
                                                    //     pageBuilder:
                                                    //         (context, animation1, animation2) =>
                                                    //             LoginPage(
                                                    //       title: 'Login',
                                                    //     ),
                                                    //     transitionDuration: Duration.zero,
                                                    //   ),
                                                    // );
                                                    // FirebaseAuth.instance
                                                    //     .authStateChanges()
                                                    //     .listen((User? user) {
                                                    //   if (user == null) {
                                                    //     print('User is currently signed out!');
                                                    //   } else {
                                                    //     print('User is signed in!');
                                                    //   }
                                                    // });
                                                    // _authenticateWithEmailAndPassword(context);
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                    // onPrimary: Colors.white,
                                                    shadowColor: Colors.blueAccent,
                                                    elevation: 3,
                                                    // side: BorderSide(width: 0.10, color: Colors.white),
                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(size.height * 0.015)),
                                                    // minimumSize: Size(100, 60), //////// HERE
                                                    minimumSize: Size(size.width - 40, size.height * 0.075),
                                                  ),
                                                  child: Text(
                                                    "Anmelden",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.w400,
                                                      fontSize: size.width * 0.06,
                                                      //fontStyle: FontStyle.,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: <Widget>[
                                      // Padding(
                                      //   padding: const EdgeInsets.all(25.0),
                                      //   child: Container( height: 300,child: LoadingAnimation()),
                                      // ),

                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(20.0, 25.0, 20.0, 20.0),
                                        child: Text(
                                          ('welcome').tr(),
                                          // "Herzlich willkommen",
                                          textAlign: TextAlign.left,
                                          // textScaleFactor: ScaleSize.textScaleFactor(context),
                                          style: TextStyle(
                                            // fontFamily: "Raleway",
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                            // fontSize: 24,
                                            fontSize: size.width * 0.065,
                                            //fontStyle: FontStyle.,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 20.0),
                                        child: Text(
                                          ('welcomeText').tr(),
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w300,
                                            // fontSize: 16,
                                            fontSize: size.width * 0.05,
                                            //fontStyle: FontStyle.,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(size.width * 0.06, 0, size.width * 0.06, size.height * 0.02),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            // Navigator.of(context).pop();
                                            // Navigator.of(context).popUntil((route) => route.isFirst);
                                            var sd = AuthState.inCompleteUserDetails;
                                            if (AuthState.inCompleteUserDetails?.response != null && Navigator.of(context).canPop() == true) {
                                              // Navigator.of(context).popUntil((route) => route.isFirst,);
                                              Navigator.pop(context, 'popped');
                                            } else {
                                              BlocProvider.of<AuthBloc>(context).add(
                                                IncompleteSignInRequested(),
                                              );
                                            }
                                            // Navigator.of(context).popUntil((route) => route.isFirst);
                                            // Future.delayed(Duration(milliseconds: 3), () async {
                                            //   BlocProvider.of<NavbarBloc>(context).add(Initialize123(currentPosition: SplashState.appbarlocation));
                                            //   Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MainPage()), (Route<dynamic> route) => false);
                                            //
                                            //   // BlocProvider.of<NavbarBloc>(context);
                                            //   // BlocProvider.of<NavbarBloc>(context).add(Initialize123(currentPosition: SplashState.appbarlocation));
                                            //   // setState(() {});
                                            // });
                                            // BlocProvider.of<AuthBloc>(context).add(
                                            //   IncompleteSignInRequested(),
                                            // );
                                            // Future.delayed(Duration(milliseconds: 1), () async {
                                            //   Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MainPage()), (Route<dynamic> route) => false);
                                            //
                                            // });
                                            // }
                                            // _authenticateincomplete(context);
                                            // BlocListener<NavbarBloc, NavbarState>(listener: (context, state) {
                                            //   if (NavbarState.ap is! Loading) {
                                            //     Navigator.of(context).popUntil((route) => route.isFirst);
                                            //     Future.delayed(Duration(milliseconds: 1), () async {
                                            //       Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MainPage()), (Route<dynamic> route) => false);
                                            //     });
                                            //     return;
                                            //   }
                                            // });

                                            // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainPage()));
                                          },
                                          style: ElevatedButton.styleFrom(
                                            //primary: Colors.green,
                                            // onPrimary: Colors.white,
                                            shadowColor: Colors.blueAccent,
                                            elevation: 3,
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)),
                                            minimumSize: Size(size.width - 40, size.height * 0.075), //////// HERE
                                          ),
                                          child: MarqueeWidget(
                                            child: Text(
                                              ("inCompleteSignIn").tr(),
                                              style: TextStyle(
                                                color: Colors.white,

                                                fontWeight: FontWeight.w400,
                                                // fontSize: 18,
                                                fontSize: size.width * 0.06,
                                                //fontStyle: FontStyle.,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(size.width * 0.06, 0, size.width * 0.06, size.height * 0.02),
                                        child: OutlinedButton(
                                          onPressed: () {
                                            // Navigator.push(
                                            //   context,
                                            //   PageRouteBuilder(
                                            //     pageBuilder: (context, animation1, animation2) => LoginPage(
                                            //       // title: 'Login',
                                            //       splashbloc: widget.splashbloc,
                                            //     ),
                                            //     transitionDuration: Duration.zero,
                                            //   ),
                                            // );
                                            BlocProvider.of<AuthBloc>(context).add(OpenLoginPage());
                                            // BlocProvider.of<AuthBloc>(context).add(Initialize());

                                            // Navigator.pushReplacement(
                                            //     context,
                                            //     MaterialPageRoute(
                                            //         builder: (context) => MainPage()));
                                          },
                                          style: OutlinedButton.styleFrom(
                                            //primary: Colors.,
                                            //onPrimary: Colors.white,
                                            //shadowColor: Colors.blueAccent,
                                            // elevation: 3,
                                            side: BorderSide(width: 0.10, color: Colors.white),
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)),
                                            minimumSize: Size(size.width - 40, size.height * 0.075), //////// HERE
                                          ),
                                          child: Text(
                                            ("logIn").tr(),
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w400,
                                              fontSize: size.width * 0.06,
                                              //fontStyle: FontStyle.,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(size.width * 0.06, 0, size.width * 0.06, size.height * 0.005),
                                        child: Text(
                                          ("toRegistration").tr(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w300,
                                            fontSize: size.width * 0.04,
                                            //fontStyle: FontStyle.,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                          padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 25.0),
                                          child: InkWell(
                                            onTap: () {
                                              print("I was tapped!");
                                              Future.delayed(Duration(milliseconds: 50), () {
                                                Navigator.pushAndRemoveUntil(
                                                    context, MaterialPageRoute(builder: (context) => Registration()), (Route<dynamic> route) => true);
                                              });
                                              // Navigator.push(
                                              //   context,
                                              //   PageRouteBuilder(
                                              //     pageBuilder:
                                              //         (context, animation1, animation2) =>
                                              //             Registration(
                                              //                 // title: 'Login',
                                              //                 ),
                                              //     transitionDuration: Duration.zero,
                                              //   ),
                                              // );
                                            },
                                            child: Text(
                                              "Jetzt registrieren!",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.blue,
                                                fontWeight: FontWeight.w300,
                                                fontSize: size.width * 0.045,
                                                //fontStyle: FontStyle.,
                                              ),
                                            ),
                                          )),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
                // else if (state is LoadingAuth) {}
                // Navigator.of(context).popUntil((route) => route.isFirst);
                // return Container(
                // color: Colors.red,
                // );
              })
            ],
          );
        },
      ),
    );
  }

}