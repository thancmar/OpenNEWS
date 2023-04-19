import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/parser.dart';

import 'package:sharemagazines_flutter/src/blocs/auth/auth_bloc.dart';
import 'package:sharemagazines_flutter/src/blocs/splash/splash_bloc.dart';
import 'package:sharemagazines_flutter/src/presentation/pages/mainpage.dart';
import 'package:sharemagazines_flutter/src/presentation/pages/registrationpage.dart';

import '../../blocs/navbar/navbar_bloc.dart';

import '../validators/emailvalidator.dart';
// import 'package:sharemagazines_flutter/src/presentation/pages/login.dart';
// import 'package:sharemagazines_flutter/src/presentation/pages/map_page.dart';

class StartPage extends StatefulWidget {
  final String title;
  const StartPage({Key? key, required this.title}) : super(key: key);

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  final _formKey = GlobalKey<FormState>();
  // TextEditingController _emailController = TextEditingController();
  TextEditingController _emailController = TextEditingController(text: AuthState.savedEmail);
  TextEditingController _passwordController = TextEditingController(text: AuthState.savedPWD);
  var focusUserID = false;

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
                    "assets/images/Background.png",
                    fit: BoxFit.cover,
                    //allowDrawingOutsideViewBox: true,
                  ),
                ),
              ),
              BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
                if (state is Authenticated || state is IncompleteAuthenticated || state is AuthenticatedWithGoogle) {
                  // Navigating to the dashboard screen if the user is authenticated
                  // Navigator.pushReplacement(
                  //     context, MaterialPageRoute(builder: (context) => MainPage()));+

                  print("AuthState $state");
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  Future.delayed(Duration(milliseconds: 1), () async {
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MainPage()), (Route<dynamic> route) => false);

                    // BlocProvider.of<NavbarBloc>(context);
                    BlocProvider.of<NavbarBloc>(context).add(Initialize123());
                    // setState(() {});
                  });
                } else if (state is UnAuthenticated) {
                  // _emailController.text = AuthState?.userDetails?.response?.email ?? '';
                  // _passwordController.text = AuthState.savedPWD;
                  return Positioned(
                    top: constraints.constrainHeight() / 2,
                    height: constraints.constrainHeight() / 2,
                    width: constraints.constrainWidth(),

                    // left: constraints.constrainWidth() / 2,
                    // child: FlutterLogo(),
                    // key: _widgetKey,
                    child: Container(
                      // key: _widgetKey,
                      margin: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 45.0),
                      decoration: new BoxDecoration(border: Border.all(color: Colors.blueAccent, width: 0.10), borderRadius: new BorderRadius.circular(20.0), color: Colors.transparent
                          // color: Colors.red,
                          ),
                      child: SingleChildScrollView(
                        // key: _widgetKey,
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
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
                                ('welcome_text').tr(),
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
                                  // if (AuthState.userDetails?.response?.id != null) {
                                  //   Navigator.of(context).popUntil((route) => route.isFirst);
                                  // }
                                  BlocProvider.of<AuthBloc>(context).add(
                                    IncompleteSignInRequested(),
                                  );
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
                                  onPrimary: Colors.white,
                                  shadowColor: Colors.blueAccent,
                                  elevation: 3,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)),
                                  minimumSize: Size(size.width - 40, size.height * 0.075), //////// HERE
                                ),
                                child: Text(
                                  "Ohne Account lesen",
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
                            Padding(
                              padding: EdgeInsets.fromLTRB(size.width * 0.06, 0, size.width * 0.06, size.height * 0.005),
                              child: Text(
                                "Du hast noch keinen Account?",
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
                                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Registration()), (Route<dynamic> route) => true);
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
                  );
                } else if (state is GoToLoginPage) {
                  return Positioned.fill(
                    // top: constraints.constrainHeight() / 2,
                    // height: constraints.constrainHeight() / 2,
                    // width: constraints.constrainWidth(),
                    // left: constraints.constrainWidth() / 2,
                    child: SafeArea(
                      child: Align(
                        alignment: MediaQuery.of(context).viewInsets.bottom > 0.0 ? Alignment.topCenter : Alignment.bottomCenter,
                        child: SizedBox(
                          height: constraints.constrainHeight() / 2,
                          width: constraints.constrainWidth(),
                          child: Container(
                            // margin: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 45.0),
                            margin: EdgeInsets.fromLTRB(size.width * 0.045, size.height * 0.025, size.width * 0.045, size.height * 0.025),
                            decoration: new BoxDecoration(
                              border: Border.all(color: Colors.blueAccent, width: 0.10),
                              borderRadius: new BorderRadius.circular(20.0),
                              // color: Colors.red,
                            ),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  Expanded(
                                    flex: 2,
                                    child: Padding(
                                      // padding:  EdgeInsets.fromLTRB(20.0, 10.0, 0.0, 0.0),
                                      padding: EdgeInsets.fromLTRB(size.width * 0.045, size.height * 0.01, size.width * 0.045, size.height * 0.001),

                                      child: Row(
                                        children: [
                                          BackButton(
                                            color: Colors.white,

                                            // onPressed: () {
                                            //   Navigator.pop(context, true);
                                            // }),
                                            // onPressed: () => Navigator.of(context).pop(true),
                                            onPressed: () => {BlocProvider.of<AuthBloc>(context).add(Initialize())},
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
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(size.width * 0.045, size.height * 0.005, size.width * 0.045, size.height * 0.005),
                                      child: TextFormField(
                                        controller: _emailController,
                                        validator: (value) => validateEmail(value),
                                        style: TextStyle(color: Colors.white),
                                        // initialValue: state.savedEmail ?? "",
                                        onEditingComplete: () => FocusScope.of(context).nextFocus(),
                                        decoration: InputDecoration(
                                          //Maybe we need it
                                          // contentPadding: const EdgeInsets.symmetric(
                                          //     vertical: 20.0, horizontal: 10.0),
                                          floatingLabelStyle: TextStyle(color: Colors.blue),
                                          labelText: "E-Mail oder Benutzernam",
                                          labelStyle: TextStyle(fontSize: size.width * 0.045, color: Colors.grey, fontWeight: FontWeight.w300), //, height: 3.8),
                                          border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 5), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                          errorBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10.0)), borderSide: BorderSide(color: Colors.red, width: 1)),
                                          enabledBorder: const OutlineInputBorder(
                                            borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                          ),
                                        ),
                                      ),
                                    ),
                                    // child: Padding(
                                    //   padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                    //   child: Container(
                                    //     padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 0.0),
                                    //     decoration: BoxDecoration(
                                    //       border: Border.all(color: Colors.grey),
                                    //       borderRadius: BorderRadius.all(
                                    //         Radius.circular(10),
                                    //       ),
                                    //     ),
                                    //     child: TextFormField(
                                    //       // controller: _emailController,
                                    //       // validator: (value) => validateEmail(value),
                                    //       style: TextStyle(color: Colors.white),
                                    //       decoration: InputDecoration(
                                    //           hintStyle: TextStyle(fontSize: 16.0, color: Colors.amberAccent),
                                    //           labelText: "E-Mail oder Benutzername",
                                    //           labelStyle: TextStyle(fontSize: 16.0, color: Colors.white),
                                    //           fillColor: Colors.red,
                                    //           hoverColor: Colors.amber, //, height: 3.8),
                                    //           border: InputBorder.none),
                                    //     ),
                                    //   ),
                                    // ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(size.width * 0.045, size.height * 0.005, size.width * 0.045, size.height * 0.005),
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

                                          labelStyle: TextStyle(fontSize: 16.0, color: Colors.grey, fontWeight: FontWeight.w300), //, height: 3.8),
                                          border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 5), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                          errorBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10.0)), borderSide: BorderSide(color: Colors.red, width: 1)),
                                          enabledBorder: const OutlineInputBorder(
                                            borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                          ),
                                        ),
                                      ),
                                    ),
                                    // child: Padding(
                                    //   padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 20.0),
                                    //   child: Container(
                                    //     padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 0.0),
                                    //     decoration: BoxDecoration(
                                    //       border: Border.all(color: Colors.grey),
                                    //       borderRadius: BorderRadius.all(
                                    //         Radius.circular(10),
                                    //       ),
                                    //     ),
                                    //     child: TextFormField(
                                    //       // controller: _passwordController,
                                    //       obscureText: true,
                                    //       decoration: InputDecoration(
                                    //         labelText: "Passwort",
                                    //         labelStyle: TextStyle(fontSize: 16.0), //20.0, height: 3.8),
                                    //         border: InputBorder.none,
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(size.width * 0.045, size.height * 0.005, size.width * 0.045, size.height * 0.005),
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
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Padding(
                                      // padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 25.0),
                                      padding: EdgeInsets.fromLTRB(size.width * 0.045, size.height * 0.005, size.width * 0.045, size.height * 0.025),

                                      child: ElevatedButton(
                                        onPressed: () {
                                          if (_formKey.currentState!.validate()) {
                                            FocusManager.instance.primaryFocus?.unfocus();
                                            BlocProvider.of<AuthBloc>(context).add(
                                              SignInRequested(_emailController.text, _passwordController.text),
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
                                          onPrimary: Colors.white,
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
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                } else if (state is AuthError) {
                  return AlertDialog(
                    title: const Text('Login Error'),
                    content: Text(state.error),
                    actions: <Widget>[
                      // TextButton(
                      //   onPressed: () => Navigator.pop(context, 'Cancel'),
                      //   child: const Text('Cancel'),
                      // ),
                      TextButton(
                        onPressed: () => BlocProvider.of<AuthBloc>(context).add(
                          OpenLoginPage(),
                        ),
                        child: const Text('OK'),
                      ),
                    ],
                  );
                }
                // else if (state is LoadingAuth) {}
                return Container(
                    // color: Colors.red,
                    );
              })
            ],
          );
        },
      ),
    );

    // return Scaffold(
    //   resizeToAvoidBottomInset: false,
    //   body: LayoutBuilder(
    //     builder: (BuildContext context, BoxConstraints constraints) {
    //       return Stack(
    //         children: <Widget>[
    //           Positioned.fill(
    //             child: Image.asset(
    //               "assets/images/Background.png",
    //               fit: BoxFit.cover,
    //               //allowDrawingOutsideViewBox: true,
    //             ),
    //           ),
    //           // position: _offsetAnimation,
    //           /* ClipPath(
    //             clipper: TsClip1(_widgetKey),
    //             // child: SlideTransition(
    //             //   position: _offsetAnimation,
    //             child: Wrap(
    //               // alignment: WrapAlignment.start,
    //               spacing: 10.0,
    //               // runSpacing: 5,
    //               // alignment: WrapAlignment.center,
    //               // direction: Axis.vertical,
    //               direction: Axis.vertical,
    //               // crossAxisAlignment: WrapCrossAlignment.end,
    //               // runAlignment: WrapAlignment.values,
    //               // verticalDirection: VerticalDirection.down,
    //               children: [
    //                 Wrap(
    //                   spacing: 15.0,
    //                   // alignment: WrapAlignment.center,
    //                   // verticalDirection: VerticalDirection.down,
    //                   // direction: Axis.vertical,
    //                   // direction: Axis.horizontal,
    //                   children: [
    //                     coverWidget(),
    //                     coverWidget2(),
    //                     coverWidget(),
    //                     coverWidget2(),
    //                     coverWidget(),
    //                     coverWidget2(),
    //                   ],
    //                 ),
    //                 Wrap(
    //                   // direction: Axis.vertical,
    //                   // direction: Axis.horizontal,
    //                   spacing: 15.0,
    //                   children: [
    //                     coverWidget2(),
    //                     coverWidget(),
    //                     coverWidget2(),
    //                     coverWidget(),
    //                     coverWidget2(),
    //                     coverWidget(),
    //                   ],
    //                 ),
    //                 Wrap(
    //                   // direction: Axis.vertical,
    //                   // direction: Axis.horizontal,
    //                   spacing: 15.0,
    //                   children: [
    //                     coverWidget(),
    //                     coverWidget2(),
    //                     coverWidget(),
    //                     coverWidget2(),
    //                     coverWidget(),
    //                     coverWidget2(),
    //                   ],
    //                 ),
    //                 Wrap(
    //                   // direction: Axis.vertical,
    //                   // direction: Axis.horizontal,
    //                   spacing: 15.0,
    //                   children: [
    //                     coverWidget2(),
    //                     coverWidget(),
    //                     coverWidget2(),
    //                     coverWidget(),
    //                     coverWidget2(),
    //                     coverWidget(),
    //                   ],
    //                 ),
    //                 // Wrap(
    //                 //   direction: Axis.vertical,
    //                 //   spacing: 15.0,
    //                 //   children: [
    //                 //     coverWidget(),
    //                 //     coverWidget2(),
    //                 //     coverWidget(),
    //                 //     coverWidget2(),
    //                 //     coverWidget(),
    //                 //     coverWidget2(),
    //                 //   ],
    //                 // ),
    //                 // Wrap(
    //                 //   // direction: Axis.vertical,
    //                 //   spacing: 15.0,
    //                 //   children: [
    //                 //     coverWidget2(),
    //                 //     coverWidget(),
    //                 //     coverWidget2(),
    //                 //     coverWidget(),
    //                 //     coverWidget2(),
    //                 //     coverWidget(),
    //                 //   ],
    //                 // ),
    //                 // Wrap(
    //                 //   // direction: Axis.vertical,
    //                 //   spacing: 15.0,
    //                 //   children: [
    //                 //     coverWidget(),
    //                 //     coverWidget2(),
    //                 //     coverWidget(),
    //                 //     coverWidget2(),
    //                 //     coverWidget(),
    //                 //     coverWidget2(),
    //                 //   ],
    //                 // ),
    //               ],
    //             ),
    //           ),*/
    //           // ),
    //           Positioned(
    //             top: constraints.constrainHeight() / 2,
    //             height: constraints.constrainHeight() / 2,
    //             width: constraints.constrainWidth(),
    //             // left: constraints.constrainWidth() / 2,
    //             // child: FlutterLogo(),
    //             // key: _widgetKey,
    //             child: Container(
    //               // key: _widgetKey,
    //               margin: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 45.0),
    //               decoration: new BoxDecoration(border: Border.all(color: Colors.blueAccent, width: 0.10), borderRadius: new BorderRadius.circular(20.0), color: Colors.transparent
    //                   // color: Colors.red,
    //                   ),
    //               child: SingleChildScrollView(
    //                 key: _widgetKey,
    //                 child: new Column(
    //                   crossAxisAlignment: CrossAxisAlignment.stretch,
    //                   children: <Widget>[
    //                     Padding(
    //                       padding: const EdgeInsets.fromLTRB(20.0, 25.0, 20.0, 20.0),
    //                       child: Text(
    //                         "Herzlich willkommen",
    //                         textAlign: TextAlign.left,
    //                         style: TextStyle(
    //                           color: Colors.white,
    //                           fontWeight: FontWeight.w700,
    //                           fontSize: 24,
    //                           //fontStyle: FontStyle.,
    //                         ),
    //                       ),
    //                     ),
    //                     Padding(
    //                       padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 20.0),
    //                       child: Text(
    //                         "Lorem ipsum dolor sit amit, consectetur adipiscing elit.",
    //                         textAlign: TextAlign.left,
    //                         style: TextStyle(
    //                           color: Colors.white,
    //                           fontWeight: FontWeight.w300,
    //                           fontSize: 16,
    //                           //fontStyle: FontStyle.,
    //                         ),
    //                       ),
    //                     ),
    //                     Padding(
    //                       padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 20.0),
    //                       child: ElevatedButton(
    //                         onPressed: () {
    //                           // _authenticateincomplete(context);
    //                           BlocProvider.of<AuthBloc>(context).add(
    //                             IncompleteSignInRequested(),
    //                           );
    //                           Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainPage()));
    //                         },
    //                         style: ElevatedButton.styleFrom(
    //                           //primary: Colors.green,
    //                           onPrimary: Colors.white,
    //                           shadowColor: Colors.blueAccent,
    //                           elevation: 3,
    //                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)),
    //                           minimumSize: Size(100, 60), //////// HERE
    //                         ),
    //                         child: Text(
    //                           "Ohne Account lesen",
    //                           style: TextStyle(
    //                             color: Colors.white,
    //                             fontWeight: FontWeight.w400,
    //                             fontSize: 18,
    //                             //fontStyle: FontStyle.,
    //                           ),
    //                         ),
    //                       ),
    //                     ),
    //                     Padding(
    //                       padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 25.0),
    //                       child: OutlinedButton(
    //                         onPressed: () {
    //                           Navigator.push(
    //                             context,
    //                             PageRouteBuilder(
    //                               pageBuilder: (context, animation1, animation2) => LoginPage(
    //                                 // title: 'Login',
    //                                 splashbloc: widget.splashbloc,
    //                               ),
    //                               transitionDuration: Duration.zero,
    //                             ),
    //                           );
    //
    //                           // Navigator.pushReplacement(
    //                           //     context,
    //                           //     MaterialPageRoute(
    //                           //         builder: (context) => MainPage()));
    //                         },
    //                         style: OutlinedButton.styleFrom(
    //                           //primary: Colors.,
    //                           //onPrimary: Colors.white,
    //                           //shadowColor: Colors.blueAccent,
    //                           // elevation: 3,
    //                           side: BorderSide(width: 0.10, color: Colors.white),
    //                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)),
    //                           minimumSize: Size(100, 60), //////// HERE
    //                         ),
    //                         child: Text(
    //                           "Anmelden",
    //                           style: TextStyle(
    //                             color: Colors.white,
    //                             fontWeight: FontWeight.w400,
    //                             fontSize: 18,
    //                             //fontStyle: FontStyle.,
    //                           ),
    //                         ),
    //                       ),
    //                     ),
    //                     Padding(
    //                       padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 5.0),
    //                       child: Text(
    //                         "Du hast noch keinen Account?",
    //                         textAlign: TextAlign.center,
    //                         style: TextStyle(
    //                           color: Colors.white,
    //                           fontWeight: FontWeight.w300,
    //                           fontSize: 16,
    //                           //fontStyle: FontStyle.,
    //                         ),
    //                       ),
    //                     ),
    //                     Padding(
    //                         padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 25.0),
    //                         child: InkWell(
    //                           onTap: () {
    //                             print("I was tapped!");
    //                             Future.delayed(Duration(milliseconds: 50), () {
    //                               Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Registration()), (Route<dynamic> route) => true);
    //                             });
    //                             // Navigator.push(
    //                             //   context,
    //                             //   PageRouteBuilder(
    //                             //     pageBuilder:
    //                             //         (context, animation1, animation2) =>
    //                             //             Registration(
    //                             //                 // title: 'Login',
    //                             //                 ),
    //                             //     transitionDuration: Duration.zero,
    //                             //   ),
    //                             // );
    //                           },
    //                           child: Text(
    //                             "Jetzt registrieren!",
    //                             textAlign: TextAlign.center,
    //                             style: TextStyle(
    //                               color: Colors.blue,
    //                               fontWeight: FontWeight.w300,
    //                               fontSize: 16,
    //                               //fontStyle: FontStyle.,
    //                             ),
    //                           ),
    //                         )),
    //                   ],
    //                 ),
    //               ),
    //             ),
    //           ),
    //         ],
    //       );
    //     },
    //   ),
    // );
  }

  Future<void> parseSVG(String assetName) async {
    final SvgParser parser = SvgParser();
    final svgString = await rootBundle.loadString(assetName);
    try {
      await parser.parse(svgString, warningsAsErrors: true);
      print('SVG is supported');
    } catch (e) {
      print('SVG contains unsupported features');
      print(e);
    }
  }

  Widget coverWidget() {
    return Container(
      // color: Colors.red,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
          color: Colors.deepOrange),
      height: MediaQuery.of(context).size.height / 3.5,
      width: MediaQuery.of(context).size.width / 2.4,
    );
  }

  Widget coverWidget2() {
    return Container(
      // color: Colors.red,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
          color: Colors.yellowAccent),
      height: MediaQuery.of(context).size.height / 3.5,
      width: MediaQuery.of(context).size.width / 2.4,
    );
  }
}