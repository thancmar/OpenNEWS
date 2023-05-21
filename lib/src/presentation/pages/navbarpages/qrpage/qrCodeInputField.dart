

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sharemagazines_flutter/src/blocs/navbar/navbar_bloc.dart';

class QRCodeInputField extends StatefulWidget {
  final TextEditingController textEditingController;
  QRCodeInputField({Key? key,required this.textEditingController}) : super(key: key);
  @override
  _QRCodeInputFieldState createState() => _QRCodeInputFieldState();
}

class _QRCodeInputFieldState extends State<QRCodeInputField> {
  // final TextEditingController _textEditingController = TextEditingController();
  final int codeLength = 10;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Please enter the code"),
        // Spacer(),
        Container(
          height: 50.0,
          width: size.width/2,
          margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
          // padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blue,width: 5),
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.grey.withOpacity(0.2),
          ),
          alignment: Alignment.center,
          child: TextField(
            controller: widget.textEditingController,
            maxLength: codeLength,
            textAlignVertical: TextAlignVertical.center,
            onChanged: (String value) {
              if (value.length >= codeLength) {
                // All characters have been entered
                // Perform your logic here
                BlocProvider.of<NavbarBloc>(context).qr(value);

              }
            },
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.characters, // Enables caps lock
            textInputAction: TextInputAction.done, // Changes the keyboard return key to "Done"

            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,

            ),
            decoration: InputDecoration(
              counterText: '',
              isCollapsed: true,
              border: InputBorder.none,
              // contentPadding: EdgeInsets.symmetric(vertical: 1.0),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    // _textEditingController.dispose();
    super.dispose();
  }
}