// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sharemagazines_flutter/src/blocs/auth_bloc.dart' as auth;
import 'package:sharemagazines_flutter/src/blocs/navbar_bloc.dart';
import 'package:sharemagazines_flutter/src/presentation/pages/startpage.dart';
import 'package:sharemagazines_flutter/src/presentation/pages/mainpage.dart';
import 'package:sharemagazines_flutter/src/presentation/validators/emailvalidator.dart';
// import 'package:sharemagazines_flutter/src/presentation/pages/map_page.dart';
import 'package:sharemagazines_flutter/src/presentation/widgets/loginwidget.dart';
// import 'package:sharemagazines_flutter/src/blocs/login_bloc.dart';
import 'package:sharemagazines_flutter/src/models/login_model.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //drawer: NavDrawer(),
      // appBar: AppBar(
      //   backgroundColor: primaryColor,
      //   title: Container(
      //     height: 70,
      //     width: 70,
      //     decoration: BoxDecoration(
      //       //color: Colors.greenAccent,
      //       image: DecorationImage(
      //           image: AssetImage('assets/images/logo@2x.png'),
      //           fit: BoxFit.fitWidth),
      //     ),
      //   ),
      //   iconTheme: IconThemeData(color: Colors.black),
      // ),
      body: BlocListener<auth.AuthBloc, auth.AuthState>(
        listener: (context, state) {
          if (state is auth.Authenticated) {
            // Navigating to the dashboard screen if the user is authenticated
            // Navigator.pushReplacement(
            //     context, MaterialPageRoute(builder: (context) => MainPage()));
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => MainPageState()),
                (Route<dynamic> route) =>
                    false); //removes everything below MainPage()
          }
          if (state is auth.AuthError) {
            // Showing the error message if the user has entered invalid credentials
            // ScaffoldMessenger.of(context)
            //     .showSnackBar(SnackBar(content: Text(state.error)));
          }
        },
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Stack(
              children: <Widget>[
                Container(
                  child: new SvgPicture.asset(
                    "assets/images/background_webreader.svg",
                    fit: BoxFit.fill,
                    allowDrawingOutsideViewBox: true,
                  ),
                ),
                Positioned(
                  top: constraints.constrainHeight() / 2,
                  height: constraints.constrainHeight() / 2,
                  width: constraints.constrainWidth(),
                  // left: constraints.constrainWidth() / 2,
                  // child: FlutterLogo(),

                  child: Container(
                    margin: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 45.0),
                    decoration: new BoxDecoration(
                      border: Border.all(color: Colors.blueAccent, width: 0.10),
                      borderRadius: new BorderRadius.circular(20.0),
                      // color: Colors.red,
                    ),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding:
                                const EdgeInsets.fromLTRB(20.0, 10.0, 0.0, 0.0),
                            child: Row(
                              children: [
                                BackButton(
                                  color: Colors.white,
                                  // onPressed: () {
                                  //   Navigator.pop(context, true);
                                  // }),
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                ),
                                Text(
                                  "Anmelden",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 24,
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
                            padding: const EdgeInsets.fromLTRB(
                                20.0, 10.0, 20.0, 10.0),
                            child: Container(
                              padding:
                                  const EdgeInsets.fromLTRB(20.0, 0, 20.0, 0.0),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              child: TextFormField(
                                controller: _emailController,
                                validator: (value) => validateEmail(value),
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                    labelText: "E-Mail oder Benutzername",
                                    labelStyle: TextStyle(
                                        fontSize: 16.0), //, height: 3.8),
                                    border: InputBorder.none),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding:
                                const EdgeInsets.fromLTRB(20.0, 0, 20.0, 20.0),
                            child: Container(
                              padding:
                                  const EdgeInsets.fromLTRB(20.0, 0, 20.0, 0.0),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              child: TextFormField(
                                controller: _passwordController,
                                obscureText: true,
                                decoration: InputDecoration(
                                  labelText: "Passwort",
                                  labelStyle: TextStyle(
                                      fontSize: 16.0), //20.0, height: 3.8),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(
                                20.0, 10.0, 20.0, 25.0),
                            child: InkWell(
                              onTap: () {
                                print("I was tapped!");
                              },
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
                            padding:
                                const EdgeInsets.fromLTRB(20.0, 0, 20.0, 25.0),
                            child: ElevatedButton(
                              onPressed: () {
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
                                _authenticateWithEmailAndPassword(context);
                              },
                              style: ElevatedButton.styleFrom(
                                onPrimary: Colors.white,
                                shadowColor: Colors.blueAccent,
                                elevation: 3,
                                // side: BorderSide(width: 0.10, color: Colors.white),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14.0)),
                                minimumSize: Size(100, 60), //////// HERE
                              ),
                              child: Text(
                                "Anmelden",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 18,
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
              ],
            );
          },
        ),
      ),
    );
  }

  void _authenticateWithEmailAndPassword(context) {
    print("sadfsd");
    // if (_formKey.currentState!.validate()) {
    // If email is valid adding new Event [SignInRequested].
    BlocProvider.of<auth.AuthBloc>(context).add(
      auth.SignInRequested(_emailController.text, _passwordController.text),
    );
    // }
  }

  // void _authenticateWithEmailAndPassword(context) {
  //   if (_formKey.currentState!.validate()) {
  //     BlocProvider.of<AuthBloc>(context).add(
  //       SignInRequested(_emailController.text, _passwordController.text),
  //     );
  //   }
  // }
  // Future<FirebaseApp> _initializeFirebase() async {
  //   FirebaseApp firebaseApp = await Firebase.initializeApp();
  //   return firebaseApp;
  // }
}
