import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import 'package:sharemagazines_flutter/src/presentation/pages/startpage.dart';
//import 'package:sharemagazines_flutter/src/presentation/pages/map_page.dart';
import 'package:sharemagazines_flutter/src/presentation/widgets/loginwidget.dart';
import 'package:sharemagazines_flutter/src/blocs/auth/auth_bloc.dart';
import 'package:sharemagazines_flutter/src/models/login_model.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Stack(
            children: <Widget>[
              Container(
                // child: new SvgPicture.asset(
                //   "assets/images/background_webreader.svg",
                //   fit: BoxFit.fill,
                //   allowDrawingOutsideViewBox: true,
                // ),
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
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  20.0, 5.0, 0.0, 0.0),
                              child: BackButton(
                                color: Colors.white,
                                // onPressed: () {
                                //   Navigator.pop(context, true);
                                // }),
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  5.0, 25.0, 20.0, 20.0),
                              child: Text(
                                "Anmelden",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 24,
                                  //fontStyle: FontStyle.,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
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
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                  labelText: "E-Mail oder Benutzername",
                                  labelStyle: TextStyle(
                                      fontSize: 16.0), //, height: 3.8),
                                  border: InputBorder.none),
                            ),
                          ),
                        ),
                        Padding(
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
                              decoration: InputDecoration(
                                labelText: "Passwort",
                                labelStyle: TextStyle(
                                    fontSize: 16.0), //20.0, height: 3.8),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 25.0),
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
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(20.0, 0, 20.0, 25.0),
                          child: ElevatedButton(
                            onPressed: () {
                              //bloc.fetchLogin();
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
                            },
                            style: ElevatedButton.styleFrom(
                              // onPrimary: Colors.white,
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
}