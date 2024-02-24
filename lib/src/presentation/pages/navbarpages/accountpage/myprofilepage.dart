import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sharemagazines/src/blocs/auth/auth_bloc.dart';
import 'package:toggle_switch/toggle_switch.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({Key? key}) : super(key: key);

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  DateTime selectedDate = DateTime.now();
  TextEditingController _calenderController = TextEditingController(
      // text: AuthState.userDetails?.response?.dateOfBirth
      );
  TextEditingController _firstnameController = TextEditingController(
      // text: AuthState.userDetails?.response?.firstname
      );
  TextEditingController _lastnameController = TextEditingController(
      // text: AuthState.userDetails?.response?.lastname
      );

  @override
  Widget build(BuildContext context) {
    _firstnameController = TextEditingController(
        // text: BlocProvider.of<AuthBloc>(context).state.userDetails.response?.firstname
        text: AuthState.userDetails?.response?.firstname
        );
    _lastnameController = TextEditingController(
        // text: BlocProvider.of<AuthBloc>(context).state.userDetails.response?.lastname
        text: AuthState.userDetails?.response?.lastname
        );
    _calenderController = TextEditingController(
        // text: BlocProvider.of<AuthBloc>(context).state.userDetails.response?.dateOfBirth
        text: AuthState.userDetails?.response?.dateOfBirth
        );
    return Stack(
      children: [
        Positioned.fill(
          //Remove hero
          child: Hero(tag: 'bg12', child: Image.asset("assets/images/background/Background.png", fit: BoxFit.cover)),
        ),
        Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            automaticallyImplyLeading: false,
            // toolbarHeight: 100,
            title: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 35,
                  color: Colors.transparent,
                  child: InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () {
                      // BlocProvider.of<SearchBloc>(context).add(OpenSearch());
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Text(
                        ("myProfile").tr(),
                        style: Theme.of(context).textTheme.headlineSmall,
                        textAlign: TextAlign.center,
                        // textAlign: TextAlign.center,
                      )),
                )
              ],
            ),
          ),
          body: SafeArea(
              child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 5.0),
                  child: TextFormField(
                    controller: _firstnameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This is the required field';
                      }
                      return null;
                    },
                    style:  Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white),
                    decoration: InputDecoration(
                      //Maybe we need it
                      // contentPadding: const EdgeInsets.symmetric(
                      //     vertical: 20.0, horizontal: 10.0),

                      floatingLabelStyle: Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.blue),
                      labelText: "Vorname",
                      labelStyle:
                          Theme.of(context).textTheme.titleLarge!.copyWith( color: Colors.grey, fontWeight: FontWeight.w300),
                      //, height
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 5), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)), borderSide: BorderSide(color: Colors.red, width: 1)),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)), borderSide: BorderSide(color: Colors.blue, width: 1)),

                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
                  child: TextFormField(
                    controller: _lastnameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This is the required field';
                      }
                      return null;
                    },
                    style:  Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white),
                    decoration: InputDecoration(
                      //Maybe we need it
                      // contentPadding: const EdgeInsets.symmetric(
                      //     vertical: 20.0, horizontal: 10.0),
                      floatingLabelStyle: Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.blue),
                      labelText: "Nachname",
                      labelStyle:
                          Theme.of(context).textTheme.titleLarge!.copyWith( color: Colors.grey, fontWeight: FontWeight.w300),
                      //, height
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 5), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)), borderSide: BorderSide(color: Colors.red, width: 1)),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)), borderSide: BorderSide(color: Colors.blue, width: 1)),

                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 10.0),
                  child: TextFormField(
                    controller: _calenderController,
                    readOnly: true,
                    //To not pop up the keyboard on tap
                    onTap: () => _selectDate(context),
                    // validator: (value) => validateEmail(value),
                    style:  Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white),

                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: Icon(Icons.calendar_today_outlined, color: Colors.grey),
                        onPressed: () => _selectDate(context),
                      ),
                      floatingLabelStyle: Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.blue),
                      labelText: "Geburtsdatum",
                      labelStyle:
                          Theme.of(context).textTheme.titleLarge!.copyWith( color: Colors.grey, fontWeight: FontWeight.w300),
                      //, height
                      // border: OutlineInputBorder(
                      //     borderSide: BorderSide(color: Colors.white, width: 5), borderRadius: BorderRadius.all(Radius.circular(10.0))),
                      // errorBorder: OutlineInputBorder(
                      //     borderRadius: BorderRadius.all(Radius.circular(10.0)), borderSide: BorderSide(color: Colors.red, width: 1)),
                      // enabledBorder: const OutlineInputBorder(
                      //   borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                      //   borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      // ),
                      // focusedBorder: OutlineInputBorder(
                      //     borderRadius: BorderRadius.all(Radius.circular(10.0)), borderSide: BorderSide(color: Colors.blue, width: 1)),

                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Gender",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300, fontSize: 16),
                    ),
                  ),
                ),
                Padding(
                  // padding: EdgeInsets.fromLTRB(30, 10, 40, 10),
                  padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 10.0),
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                    decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(10)),
                    child: ToggleSwitch(
                      minWidth: MediaQuery.of(context).size.width / 2 - 30,
                      //40 because of padding
                      // dividerColor: Colors.red,
                      inactiveBgColor: Colors.grey.withOpacity(0.1),
                      initialLabelIndex: AuthState.userDetails?.response?.sex == "w"
                          ? 1
                          :
                          // AuthState.userDetails?.response?.sex == "w" ? 1 :
                          0,
                      totalSwitches: 2,
                      radiusStyle: true,

                      inactiveFgColor: Colors.white,
                      labels: ['Männlich', 'Female'],
                      onToggle: (index) {
                        print('switched to: $index');
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 20, 20.0, 20.0),
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
                      // _authenticateWithEmailAndPassword(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      // onPrimary: Colors.white,
                      shadowColor: Colors.blueAccent,
                      elevation: 3,
                      // side: BorderSide(width: 0.10, color: Colors.white),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)),
                      minimumSize: Size(300, 60), //////// HERE
                    ),
                    child: Text(
                      "Speichern",
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
                      BlocProvider.of<AuthBloc>(context).add(DeleteAccount(AuthState.userDetails));
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
                      backgroundColor: Colors.redAccent,
                      // onPrimary: Colors.redAccent,
                      // shadowColor: Colors.redAccent,
                      elevation: 3,
                      // side: BorderSide(width: 0.10, color: Colors.white),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)),
                      minimumSize: Size(300, 60), //////// HERE
                    ),
                    child: Text(
                      "Meinen Account löschen",
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
          )),
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked =
        await showDatePicker(context: context, initialDate: selectedDate, firstDate: DateTime(1955, 1, 1), lastDate: DateTime.now());
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _calenderController = new TextEditingController(text: picked.toString().split(' ')[0]);
      });
    }
  }
}