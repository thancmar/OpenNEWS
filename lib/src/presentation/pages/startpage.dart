import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_svg/parser.dart';

import 'package:sharemagazines/src/blocs/auth/auth_bloc.dart';
import 'package:sharemagazines/src/presentation/clip.dart';
import 'package:sharemagazines/src/presentation/pages/coveranimmation.dart';
import 'package:sharemagazines/src/presentation/pages/mainpage.dart';
import 'package:sharemagazines/src/presentation/pages/registrationpage.dart';

import '../../blocs/navbar/navbar_bloc.dart';
import '../../models/location_model.dart';
import '../validators/emailvalidator.dart';
import '../widgets/marquee.dart';

class StartPage extends StatefulWidget {
  final String title;

  const StartPage({Key? key, required this.title}) : super(key: key);

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  GlobalKey _widgetKey = GlobalKey();
  bool hideBackground = false;
  late final AnimationController covercontroller = AnimationController(
    vsync: this,
  );
  TextEditingController _emailController = TextEditingController(text: AuthState.savedEmail);
  TextEditingController _passwordController = TextEditingController(text: AuthState.savedPWD);
  var focusUserID = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: AuthState.savedEmail);
  }

  @override
  void didUpdateWidget(StartPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update the controller if the savedEmail has changed
    if (AuthState.savedEmail != _emailController.text) {
      _emailController.text = AuthState.savedEmail ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
                      ),
                    ),
              // AnimatedBackground(),
              BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
                if (state is Authenticated || state is IncompleteAuthenticated || state is AuthenticatedWithGoogle) {
                  // print("AuthState $state");
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  Future.delayed(Duration(milliseconds: 5), () async {
                    BlocProvider.of<NavbarBloc>(context).add(InitializeNavbar(currentPosition: LocationData()));
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MainPage()), (Route<dynamic> route) => false);
                  });
                  return Container();
                } else if (state is AuthError) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) {
                      setState(() {
                        hideBackground = true;
                      });
                    }
                  });
                  return AlertDialog(
                    backgroundColor: Colors.white,
                    title: Text(
                      'Something went wrong',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.grey),
                    ),
                    content: Text(state.error.toString(), style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.grey)),
                    actions: <Widget>[
                      // TextButton(
                      //   onPressed: () => Navigator.pop(context, 'Cancel'),
                      //   child: const Text('Cancel'),
                      // ),
                      TextButton(
                        onPressed: () => {
                          BlocProvider.of<AuthBloc>(context).add(
                              // OpenLoginPage(),
                              Initialize()),
                          setState(() {
                            hideBackground = false;
                          })
                        },
                        child: Text('OK', style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.blue)),
                      ),
                    ],
                  );
                }
                _emailController = TextEditingController(text: AuthState.savedEmail
                    // text:  BlocProvider.of<AuthBloc>(context).state.userDetails.response?.firstname
                    // text: AuthState.userDetails?.response?.firstname
                    );
                _passwordController = TextEditingController(text: AuthState.savedPWD
                    // text:  BlocProvider.of<AuthBloc>(context).state.userDetails.response?.firstname
                    // text: AuthState.userDetails?.response?.firstname
                    );
                var globalpadding = EdgeInsets.fromLTRB(size.width * 0.05, size.height * 0.005, size.width * 0.05, size.height * 0.005);
                var textpadding = EdgeInsets.fromLTRB(0, size.height * 0.020, 0, size.height * 0.005);
                var textpaddingsmall = EdgeInsets.fromLTRB(0, size.height * 0.0000, 0, size.height * 0.00);
                var buttonpadding = EdgeInsets.fromLTRB(0, size.height * 0.015, 0, size.height * 0.003);
                var inputfieldpadding = EdgeInsets.fromLTRB(0, size.height * 0.005, 0, size.height * 0.005);
                return Material(
                  elevation: 0,
                  color: Colors.transparent,
                  child: Stack(
                    clipBehavior: Clip.hardEdge,
                    children: [
                      Positioned(
                        top: (MediaQuery.of(context).viewInsets.bottom > 0.0 && state is GoToLoginPage) ? 50 : constraints.constrainHeight() / 2,
                        height: constraints.constrainHeight() / 2,
                        width: constraints.constrainWidth(),
                        child: Container(
                          margin: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 45.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: Colors.transparent,
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
                                        padding: globalpadding,

                                        child: Form(
                                          key: _formKey,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.stretch,
                                            mainAxisSize: MainAxisSize.max,
                                            children: <Widget>[
                                              Padding(
                                                padding: textpadding,
                                                // padding: EdgeInsets.fromLTRB(size.width * 0.045, size.height * 0.01, size.width * 0.045, size.height * 0.001),

                                                child: Row(
                                                  children: [
                                                    BackButton(
                                                      color: Colors.white,
                                                      onPressed: () {
                                                        BlocProvider.of<AuthBloc>(context).add(Initialize());
                                                      },
                                                    ),
                                                    Text(
                                                      "Anmelden",
                                                      textAlign: TextAlign.left,
                                                      style: Theme.of(context).textTheme.headlineMedium,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: inputfieldpadding,
                                                child: TextFormField(
                                                  controller: _emailController,
                                                  validator: (value) => validateEmail(value),
                                                  style: Theme.of(context).textTheme.titleLarge,
                                                  cursorColor: Colors.blue,
                                                  // initialValue: state.savedEmail ,
                                                  onEditingComplete: () => FocusScope.of(context).nextFocus(),
                                                  onFieldSubmitted: (_) => {
                                                    {FocusScope.of(context).requestFocus()}
                                                  },
                                                  decoration: InputDecoration(
                                                    floatingLabelStyle: TextStyle(color: Colors.blue),
                                                    labelText: "E-Mail oder Benutzernam",
                                                    labelStyle: Theme.of(context).textTheme.labelLarge,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: inputfieldpadding,
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
                                                  cursorColor: Colors.blue,
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
                                                    {FocusScope.of(context).requestFocus()}
                                                  },
                                                  decoration: InputDecoration(
                                                    //Maybe we need it
                                                    // contentPadding: const EdgeInsets.symmetric(
                                                    //     vertical: 20.0, horizontal: 10.0),
                                                    floatingLabelStyle: TextStyle(color: Colors.blue),
                                                    labelText: "Passwort",

                                                    labelStyle: Theme.of(context).textTheme.labelLarge,
                                                    //, height: 3.8),
                                                    // border: OutlineInputBorder(
                                                    //     borderSide: BorderSide(color: Colors.white, width: 5),
                                                    //     borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                                    focusedBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.all(Radius.circular(18.0)),
                                                        borderSide: BorderSide(color: Colors.blue, width: 1)),
                                                    enabledBorder: const OutlineInputBorder(
                                                      borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                                                      borderRadius: BorderRadius.all(Radius.circular(18.0)),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: textpaddingsmall,
                                                child: InkWell(
                                                  // onTap: () {
                                                  //   print("I was tapped!");
                                                  // },
                                                  child: Text(
                                                    "Passwort vergessen?",
                                                    textAlign: TextAlign.left,
                                                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.blue),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                // padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 25.0),
                                                padding: buttonpadding,
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    if (_formKey.currentState!.validate()) {
                                                      FocusManager.instance.primaryFocus?.unfocus();
                                                      BlocProvider.of<AuthBloc>(context).add(
                                                        SignInRequested(_emailController.text, _passwordController.text, '', '', false),
                                                      );
                                                    }
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.blue,
                                                    shadowColor: Colors.blue,
                                                    elevation: 5,
                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
                                                    minimumSize: Size(size.width - 40, size.height * 0.075), //////// HERE
                                                  ),
                                                  child: Text(
                                                    "Anmelden",
                                                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.w300),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : Column(crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisSize: MainAxisSize.min, children: <Widget>[
                                    Padding(
                                        // flex: 3,
                                        padding: globalpadding,
                                        child: Form(
                                          key: _formKey,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.stretch,
                                            mainAxisSize: MainAxisSize.max,
                                            // mainAxisAlignment: MainAxisAlignment.start,
                                            children: <Widget>[
                                              Padding(
                                                padding: textpadding,
                                                child: Text(
                                                  ('welcome').tr(),
                                                  textAlign: TextAlign.left,
                                                  style: Theme.of(context).textTheme.headlineMedium,
                                                ),
                                              ),
                                              Padding(
                                                padding: textpadding,
                                                child: Text(
                                                  ('welcomeText').tr(),
                                                  textAlign: TextAlign.left,
                                                  style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w300),
                                                ),
                                              ),
                                              Padding(
                                                padding: buttonpadding,
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    // var sd = AuthState.inCompleteUserDetails;
                                                    if (AuthState.inCompleteUserDetails.response != null && Navigator.of(context).canPop() == true) {
                                                      // Navigator.of(context).popUntil((route) => route.isFirst,);
                                                      Navigator.pop(context, 'popped');
                                                    } else {
                                                      BlocProvider.of<AuthBloc>(context).add(
                                                        IncompleteSignInRequested(),
                                                      );
                                                    }
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.blue,
                                                    shadowColor: Colors.blue,
                                                    elevation: 5,
                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
                                                    minimumSize: Size(size.width - 40, size.height * 0.075), //////// HERE
                                                  ),
                                                  child: MarqueeWidget(
                                                    child: Text(
                                                      ("inCompleteSignIn").tr(),
                                                      style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.w300),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: buttonpadding,
                                                child: OutlinedButton(
                                                  onPressed: () {
                                                    BlocProvider.of<AuthBloc>(context).add(OpenLoginPage());
                                                  },
                                                  style: OutlinedButton.styleFrom(
                                                    side: BorderSide(width: 0.10, color: Colors.white),
                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
                                                    minimumSize: Size(size.width - 40, size.height * 0.075), //////// HERE
                                                  ),
                                                  child: Text(
                                                    ("logIn").tr(),
                                                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.w300),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: textpaddingsmall,
                                                child: Text(
                                                  ("toRegistration").tr(),
                                                  textAlign: TextAlign.center,
                                                  style: Theme.of(context).textTheme.bodyMedium,
                                                ),
                                              ),
                                              Padding(
                                                  padding: textpaddingsmall,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      print("I was tapped!");
                                                      Future.delayed(Duration(milliseconds: 50), () {
                                                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Registration()),
                                                            (Route<dynamic> route) => true);
                                                      });
                                                    },
                                                    child: Text(
                                                      "Jetzt registrieren!",
                                                      textAlign: TextAlign.center,
                                                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.blue),
                                                      // style: TextStyle(
                                                      //   color: Colors.blue,
                                                      //   fontWeight: FontWeight.w300,
                                                      //   fontSize: size.width * 0.045,
                                                      //   fontStyle: FontStyle.,
                                                      // ),
                                                    ),
                                                  )),
                                            ],
                                          ),
                                        ))
                                  ]),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              })
            ],
          );
        },
      ),
    );
  }
}