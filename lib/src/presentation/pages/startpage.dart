import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/parser.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sharemagazines_flutter/src/blocs/auth_bloc.dart';
import 'package:sharemagazines_flutter/src/blocs/splash_bloc.dart';
import 'package:sharemagazines_flutter/src/models/login_model.dart';
import 'package:sharemagazines_flutter/src/presentation/pages/loginpage.dart';
import 'package:sharemagazines_flutter/src/presentation/pages/mainpage.dart';
import 'package:sharemagazines_flutter/src/presentation/pages/registrationpage.dart';

import '../widgets/body_painter.dart';
import '../widgets/navbar_painter.dart';
import '../widgets/startpage_painter.dart';
// import 'package:sharemagazines_flutter/src/presentation/pages/login.dart';
// import 'package:sharemagazines_flutter/src/presentation/pages/map_page.dart';

class StartPage extends StatefulWidget {
  const StartPage({Key? key, required this.title, required this.splashbloc}) : super(key: key);
  final String title;
  final SplashBloc splashbloc;

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> with SingleTickerProviderStateMixin {
  final GlobalKey _widgetKey = GlobalKey();
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 9),
    vsync: this,
  )..repeat(reverse: true);
  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    // begin: Offset.zero,
    begin: Offset(-0.1, -0.10),
    end: const Offset(-02.5, -0.50),
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: Curves.linear,
  ));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Stack(
            children: <Widget>[
              Positioned.fill(
                child: Image.asset(
                  "assets/images/Background.png",
                  fit: BoxFit.cover,
                  //allowDrawingOutsideViewBox: true,
                ),
              ),
              // position: _offsetAnimation,
              /* ClipPath(
                clipper: TsClip1(_widgetKey),
                // child: SlideTransition(
                //   position: _offsetAnimation,
                child: Wrap(
                  // alignment: WrapAlignment.start,
                  spacing: 10.0,
                  // runSpacing: 5,
                  // alignment: WrapAlignment.center,
                  // direction: Axis.vertical,
                  direction: Axis.vertical,
                  // crossAxisAlignment: WrapCrossAlignment.end,
                  // runAlignment: WrapAlignment.values,
                  // verticalDirection: VerticalDirection.down,
                  children: [
                    Wrap(
                      spacing: 15.0,
                      // alignment: WrapAlignment.center,
                      // verticalDirection: VerticalDirection.down,
                      // direction: Axis.vertical,
                      // direction: Axis.horizontal,
                      children: [
                        coverWidget(),
                        coverWidget2(),
                        coverWidget(),
                        coverWidget2(),
                        coverWidget(),
                        coverWidget2(),
                      ],
                    ),
                    Wrap(
                      // direction: Axis.vertical,
                      // direction: Axis.horizontal,
                      spacing: 15.0,
                      children: [
                        coverWidget2(),
                        coverWidget(),
                        coverWidget2(),
                        coverWidget(),
                        coverWidget2(),
                        coverWidget(),
                      ],
                    ),
                    Wrap(
                      // direction: Axis.vertical,
                      // direction: Axis.horizontal,
                      spacing: 15.0,
                      children: [
                        coverWidget(),
                        coverWidget2(),
                        coverWidget(),
                        coverWidget2(),
                        coverWidget(),
                        coverWidget2(),
                      ],
                    ),
                    Wrap(
                      // direction: Axis.vertical,
                      // direction: Axis.horizontal,
                      spacing: 15.0,
                      children: [
                        coverWidget2(),
                        coverWidget(),
                        coverWidget2(),
                        coverWidget(),
                        coverWidget2(),
                        coverWidget(),
                      ],
                    ),
                    // Wrap(
                    //   direction: Axis.vertical,
                    //   spacing: 15.0,
                    //   children: [
                    //     coverWidget(),
                    //     coverWidget2(),
                    //     coverWidget(),
                    //     coverWidget2(),
                    //     coverWidget(),
                    //     coverWidget2(),
                    //   ],
                    // ),
                    // Wrap(
                    //   // direction: Axis.vertical,
                    //   spacing: 15.0,
                    //   children: [
                    //     coverWidget2(),
                    //     coverWidget(),
                    //     coverWidget2(),
                    //     coverWidget(),
                    //     coverWidget2(),
                    //     coverWidget(),
                    //   ],
                    // ),
                    // Wrap(
                    //   // direction: Axis.vertical,
                    //   spacing: 15.0,
                    //   children: [
                    //     coverWidget(),
                    //     coverWidget2(),
                    //     coverWidget(),
                    //     coverWidget2(),
                    //     coverWidget(),
                    //     coverWidget2(),
                    //   ],
                    // ),
                  ],
                ),
              ),*/
              // ),
              Positioned(
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
                    key: _widgetKey,
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20.0, 25.0, 20.0, 20.0),
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
                          padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 20.0),
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
                          padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 20.0),
                          child: ElevatedButton(
                            onPressed: () {
                              _authenticateincomplete(context);
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainPage()));
                            },
                            style: ElevatedButton.styleFrom(
                              //primary: Colors.green,
                              onPrimary: Colors.white,
                              shadowColor: Colors.blueAccent,
                              elevation: 3,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)),
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
                          padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 25.0),
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation1, animation2) => LoginPage(
                                    // title: 'Login',
                                    splashbloc: widget.splashbloc,
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
                              side: BorderSide(width: 0.10, color: Colors.white),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)),
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
                          padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 5.0),
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