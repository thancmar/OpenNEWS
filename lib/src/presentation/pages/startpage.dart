import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/parser.dart';
import 'package:sharemagazines_flutter/src/blocs/auth_bloc.dart';
import 'package:sharemagazines_flutter/src/models/login_model.dart';
import 'package:sharemagazines_flutter/src/presentation/pages/loginpage.dart';
import 'package:sharemagazines_flutter/src/presentation/pages/mainpage.dart';
import 'package:sharemagazines_flutter/src/presentation/pages/registrationpage.dart';
// import 'package:sharemagazines_flutter/src/presentation/pages/login.dart';
// import 'package:sharemagazines_flutter/src/presentation/pages/map_page.dart';

class StartPage extends StatefulWidget {
  const StartPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          print("Authlistner");
          if (state is Authenticated || state is IncompleteAuthenticated) {
            parseSVG("assets/images/background_webreader.svg");
            // Navigating to the dashboard screen if the user is authenticated
            // Navigator.pushReplacement(
            //     context, MaterialPageRoute(builder: (context) => MainPage()));
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => MainPageState()),
                (Route<dynamic> route) =>
                    false); //removes everything below MainPage()
          }

          if (state is AuthError) {
            // Showing the error message if the user has entered invalid credentials
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error)));
          }
        },
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Stack(
              children: <Widget>[
                Container(
                  child: SvgPicture.asset(
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
                    child: SingleChildScrollView(
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                                20.0, 25.0, 20.0, 20.0),
                            child: Text(
                              "Herzlich willkommen",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 24,
                                //fontStyle: FontStyle.,
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(20.0, 0, 20.0, 20.0),
                            child: Text(
                              "Lorem ipsum dolor sit amit, consectetur adipiscing elit.",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w300,
                                fontSize: 16,
                                //fontStyle: FontStyle.,
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(20.0, 0, 20.0, 20.0),
                            child: ElevatedButton(
                              onPressed: () {
                                _authenticateincomplete(context);
                                // Navigator.pushReplacement(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => MainPage()));
                              },
                              style: ElevatedButton.styleFrom(
                                //primary: Colors.green,
                                onPrimary: Colors.white,
                                shadowColor: Colors.blueAccent,
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14.0)),
                                minimumSize: Size(100, 60), //////// HERE
                              ),
                              child: Text(
                                "Ohne Account lesen",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 18,
                                  //fontStyle: FontStyle.,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(20.0, 0, 20.0, 25.0),
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder:
                                        (context, animation1, animation2) =>
                                            LoginPage(
                                                // title: 'Login',
                                                ),
                                    transitionDuration: Duration.zero,
                                  ),
                                );

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
                                side: BorderSide(
                                    width: 0.10, color: Colors.white),
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
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(20.0, 0, 20.0, 5.0),
                            child: Text(
                              "Du hast noch keinen Account?",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w300,
                                fontSize: 16,
                                //fontStyle: FontStyle.,
                              ),
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 25.0),
                              child: InkWell(
                                onTap: () {
                                  print("I was tapped!");
                                  Future.delayed(Duration(milliseconds: 50),
                                      () {
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                Registration()),
                                        (Route<dynamic> route) => true);
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
                                    fontSize: 16,
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
            );
          },
        ),
      ),
    );
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

  void _authenticateincomplete(context) {
    print("incomplete");
    // if (_formKey.currentState!.validate()) {
    // If email is valid adding new Event [SignInRequested].
    BlocProvider.of<AuthBloc>(context).add(
      IncompleteSignInRequested(),
    );
    // }
  }
}
