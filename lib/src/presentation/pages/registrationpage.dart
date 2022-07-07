import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sharemagazines_flutter/src/blocs/auth_bloc.dart';
import 'package:sharemagazines_flutter/src/presentation/pages/startpage.dart';
import 'package:sharemagazines_flutter/src/presentation/validators/emailvalidator.dart';
import 'package:sharemagazines_flutter/src/presentation/validators/passwordvalidator.dart';

class Registration extends StatefulWidget {
  const Registration({Key? key}) : super(key: key);

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final _formKey = GlobalKey<FormState>();
  DateTime selectedDate = DateTime.now();
  TextEditingController _calenderController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _firstnameController = TextEditingController();
  TextEditingController _lastnameController = TextEditingController();
  TextEditingController _date_of_birth_Controller = TextEditingController();
  TextEditingController _genderController = TextEditingController();
  bool _passwordVisible = false;

  int _selectedIndex = 1;
  List<String> _options = ['Männlich', 'Weiblich', 'Divers'];
  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Container(
        child: new SvgPicture.asset(
          "assets/images/background_webreader.svg",
          fit: BoxFit.fill,
          allowDrawingOutsideViewBox: true,
        ),
      ),
      Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_sharp,
            ),
            onPressed: () => Navigator.of(context).pop(false),
            // onPressed: () => Future.delayed(Duration(milliseconds: 50), () {
            //   Navigator.pushAndRemoveUntil(
            //       context,
            //       MaterialPageRoute(
            //           builder: (context) => StartPage(title: "sd")),
            //       (Route<dynamic> route) => true);
            // }),
          ),
          backgroundColor: Colors.transparent,
          bottom: PreferredSize(
              child: Container(
                color: Colors.white,
                height: 0.10,
              ),
              preferredSize: Size.fromHeight(4.0)),
          title: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Registration",
              style: TextStyle(fontWeight: FontWeight.w300),
            ),
          ),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: AlwaysScrollableScrollPhysics(),
          child: Form(
            key: _formKey,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              // mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
                  child: TextFormField(
                    controller: _firstnameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This is the required field';
                      }
                      return null;
                    },
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      floatingLabelStyle: TextStyle(color: Colors.blue),
                      labelText: "Vorname",
                      labelStyle: TextStyle(
                          fontSize: 16.0,
                          color: Colors.grey,
                          fontWeight: FontWeight.w300), //, height: 3.8),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 5),
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(color: Colors.red, width: 1)),
                      enabledBorder: const OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 10.0),
                  child: TextFormField(
                    controller: _lastnameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This is the required field';
                      }
                      return null;
                    },
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      floatingLabelStyle: TextStyle(color: Colors.blue),
                      labelText: "Nachname",
                      labelStyle: TextStyle(
                          fontSize: 16.0, color: Colors.grey), //, height: 3.8),

                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 5),
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(color: Colors.red, width: 1)),
                      enabledBorder: const OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 10.0),
                  child: TextFormField(
                    controller: _emailController,
                    validator: (value) => validateEmail(value),
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      floatingLabelStyle: TextStyle(color: Colors.blue),
                      labelText: "Email",
                      labelStyle: TextStyle(
                          fontSize: 16.0, color: Colors.grey), //, height: 3.8),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 5),
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(color: Colors.red, width: 1)),
                      enabledBorder: const OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 10.0),
                  child: TextFormField(
                    controller: _passwordController,
                    // validator: (value) => validatePassword(value),
                    style: TextStyle(color: Colors.white),
                    obscureText: !_passwordVisible,
                    validator: (value) => validatePassword(value),
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                          icon: Icon(
                              _passwordVisible
                                  ? Icons.remove_red_eye_outlined
                                  : Icons.remove_red_eye,
                              color: Colors.grey),
                          onPressed: () {
                            // Update the state i.e. toogle the state of passwordVisible variable
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          }),
                      floatingLabelStyle: TextStyle(color: Colors.blue),
                      labelText: "Passwort",
                      labelStyle: TextStyle(
                          fontSize: 16.0,
                          color: Colors.grey,
                          fontWeight: FontWeight.w300), //, height: 3.8),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 5),
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(color: Colors.red, width: 1)),
                      enabledBorder: const OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 10.0),
                  child: TextFormField(
                    controller: _calenderController,
                    // validator: (value) => validateEmail(value),
                    style: TextStyle(color: Colors.white),

                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: Icon(Icons.calendar_today_outlined,
                            color: Colors.grey),
                        onPressed: () => _selectDate(context),
                      ),
                      floatingLabelStyle: TextStyle(color: Colors.blue),
                      labelText: "Geburtsdatum",
                      labelStyle: TextStyle(
                          fontSize: 16.0, color: Colors.grey), //, height: 3.8),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 5),
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(1.0)),
                          borderSide: BorderSide(color: Colors.red, width: 1)),
                      enabledBorder: const OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Gender",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w300,
                          fontSize: 16),
                    ),
                  ),
                ),
                //
                //
                //Controller not yet defined for gender
                Container(
                  height: 60,
                  // alignment: Alignment.centerRight,
                  margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10)),
                  padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                  child: _buildChips(),
                  // color: Colors.blue,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "By pressing the button I agree with Share Magazines Terms and Conditions and the Privacy policy",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w300,
                          fontSize: 14),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 10, 20.0, 20.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        BlocProvider.of<AuthBloc>(context).add(
                          SignUpRequested(
                            _emailController.text,
                            _passwordController.text,
                            _emailController.text,
                            _passwordController.text,
                            " ",
                            " ",
                            " ",
                            " ",
                            " ",
                            " ",
                            " ",
                            " ",
                            " ",
                            " ",
                            " ",
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      //primary: Colors.green,
                      onPrimary: Colors.white,
                      shadowColor: Colors.blueAccent,
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.0)),
                      minimumSize: Size(400, 60), //////// HERE
                    ),
                    child: Text(
                      "Registrieren",
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
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "or signup with",
                      style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w300,
                          fontSize: 14),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 20),
                      child: Container(
                          // color: Colors.white,
                          height: 50,
                          width: 80,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          child: Icon(
                            IconData(0xe255, fontFamily: 'MaterialIcons'),
                            size: 30,
                            color: Colors.blue,
                          )),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 20),
                      child: Container(
                          // color: Colors.white,
                          height: 50,
                          width: 80,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          child: Icon(
                            IconData(0xe255, fontFamily: 'MaterialIcons'),
                            size: 30,
                            color: Colors.blue,
                          )),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      )
    ]);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _calenderController =
            new TextEditingController(text: picked.toString().split(' ')[0]);
      });
    }
  }

  // bool validatePassword(String value){
  //   String  pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
  //   RegExp regExp = new RegExp(pattern);
  //   return regExp.hasMatch(value);
  // }

  Widget _buildChips() {
    List<Widget> chips = [];

    for (int i = 0; i < _options.length; i++) {
      ChoiceChip choiceChip = ChoiceChip(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        selected: _selectedIndex == i,
        label: Container(
            width: 80,
            height: 40,
            alignment: Alignment.center,
            child: Text(_options[i], style: TextStyle(color: Colors.white))),
        // avatar: FlutterLogo(),

        // elevation: 10,
        pressElevation: 5,
        // disabledColor: Colors.black,
        // shadowColor: Colors.teal,
        backgroundColor: Colors.transparent,
        selectedColor: Colors.blue,
        onSelected: (bool selected) {
          setState(() {
            if (selected) {
              _selectedIndex = i;
            }
          });
        },
      );

      chips.add(Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Container(
              color: Colors.transparent,
              child: Theme(
                data: ThemeData(
                  canvasColor: Colors.transparent,
                ),
                child: choiceChip,
              ))));
    }
    // return Row(
    //   children: <Widget>[
    //     Theme(
    //       data: ThemeData(canvasColor: Colors.red),
    //       child: Chip(
    //         label: Text("Männlic"),
    //         backgroundColor: Colors.transparent, // or any other color
    //       ),
    //     ),
    //     Theme(
    //       data: ThemeData(canvasColor: Colors.transparent),
    //       child: Chip(
    //         label: Text(
    //           "as",
    //           style: TextStyle(color: Colors.white),
    //         ),
    //         backgroundColor: Colors.transparent, // or any other color
    //       ),
    //     )
    //   ],
    // );
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        // This next line does the trick.
        // scrollDirection: Axis.horizontal,
        // physics: NeverScrollableScrollPhysics(),

        children: chips,
      ),
    );
  }
}
