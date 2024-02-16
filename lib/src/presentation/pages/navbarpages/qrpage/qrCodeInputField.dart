import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sharemagazines/src/blocs/navbar/navbar_bloc.dart';
import 'package:sharemagazines/src/presentation/pages/navbarpages/qrpage/qr_scanner.dart';

import '../../../../blocs/auth/auth_bloc.dart';

class QRCodeInputField extends StatefulWidget {
  // final TextEditingController textEditingController;
  // final String? fingerprint;
  bool cameraActive;
  // bool hideCamera;
  ValueNotifier<bool> error;
  final QRViewExample camera;


  QRCodeInputField({Key? key, required this.cameraActive, required this.error, required this.camera}) : super(key: key);

  @override
  _QRCodeInputFieldState createState() => _QRCodeInputFieldState();
}

class _QRCodeInputFieldState extends State<QRCodeInputField> {
  // final TextEditingController _textEditingController = TextEditingController();
  final int codeLength = 10;

  @override
  void dispose() {
    // _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      alignment: Alignment.center,
      children: [
        // Invisible TextField to keep default behavior and manage input
        Opacity(
          opacity: 0.0, // make it invisible
          child: Container(
            // color: Colors.red,
            height: double.infinity,
            width: double.infinity,
            // margin: EdgeInsets.all(4.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue, width: 1.10),
              borderRadius: new BorderRadius.circular(20.0),
            ),
            // height: 100,
            // width: 200,
            child: TextField(
              controller: widget.camera.textEditingController,
              maxLength: codeLength,

              textAlignVertical: TextAlignVertical.center,
              onTap: (){
                if(mounted){
                  // if(!FocusScope.of(context).hasFocus) FocusScope.of(context).unfocus();
                  setState(() {
                    widget.camera.hideCamera.value = !widget.camera.hideCamera.value;
                    if(widget.camera.hideCamera.value==false){
                      FocusScope.of(context).unfocus();
                    }
                  });
                }
                // else{ FocusScope.of(context).unfocus();
                //   setState(() {
                //     widget.camera.hideCamera.value = false;
                //   });
                // }
              },

              // onTapOutside: (PointerDownEvent event){
              //   print("outside");
              //   FocusScope.of(context).unfocus();
              //   if(mounted){
              //     setState(() {
              //       widget.camera.hideCamera.value = false;
              //     });
              //   }
              // },
              onChanged: (String value) {
                print("dvdfvf");

                setState(() {
                  if (value.length >= codeLength) {
                    // widget.camera.
                    // setState(() {
                    //   widget.camera.hideCamera.value = true;
                    // });

                    // widget.cameraActive = false;
                    // if(mounted){
                    //   // if(!FocusScope.of(context).hasFocus) FocusScope.of(context).unfocus();
                    //   setState(() {
                    //     // widget.camera.hideCamera.value = !widget.camera.hideCamera.value;
                    //     if(widget.camera.hideCamera.value==false){
                    //
                    //       FocusScope.of(context).unfocus();
                    //     }
                    //     widget.camera.hideCamera.value = true;
                    //   });
                    // }
                    // All characters have been entered
                    // Perform your logic here
                    // if(AuthState.userDetails.response != null){
                    try {
                      BlocProvider.of<AuthBloc>(context).add(
                        SignInRequested(AuthState.savedEmail, AuthState.savedPWD, value, widget.camera.fingerprint,  true),
                      );BlocProvider.of<NavbarBloc>(context).qr(value, widget.camera.fingerprint!).then((value) => {
                        if (value == true) {Navigator.pop(context)}else{
                          widget.error.value = true
                        }
                      });
                    } catch (e, s) {

                      print(s);
                    }

                    // }


                  }
                });
              },
              keyboardType: TextInputType.text,
              // keyboardType: TextInputType.numberWithOptions(signed: true),
              textCapitalization: TextCapitalization.characters,
              inputFormatters: [NoSpaceTextInputFormatter()], // Apply the formatter.

              // Enables caps lock
              textInputAction: TextInputAction.done,
              // Changes the keyboard return key to "Done"

              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.white,
              ),
              decoration: InputDecoration(
                counterText: '',
                isCollapsed: true,

                // border: InputBorder.none,

                // contentPadding: EdgeInsets.symmetric(vertical: 1.0),
              ),

              // ... other properties of your text field
            ),
          ),
        ),
        // VisibleCe custom boxes to show characters
        IgnorePointer(
          child: Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,

              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 20),
                  child: Text("Please enter the code", style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w300)),
                ),
                Container(
                  constraints: BoxConstraints(
                    maxWidth: size.width,
                  ),
                  // margin: EdgeInsets.all(4.0),
                  // decoration: BoxDecoration(
                  //   border: Border.all(color: Colors.blue, width: 1.10),
                  //   borderRadius: new BorderRadius.circular(20.0),
                  // ),
                  height: size.height * 0.06,
                  alignment: Alignment.center,
                  child: Row(
                    // using Row instead of ListView.builder
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      codeLength,
                      (index) {
                        // scrollDirection: Axis.horizontal,
                        // itemCount: codeLength,
                        // itemBuilder: (BuildContext context, int index) {
                        // Determine the character to display and whether to highlight the box
                        String character = index < widget.camera.textEditingController.text.length ? widget.camera.textEditingController.text[index] : '';
                        bool hasInput = index < widget.camera.textEditingController.text.length;

                        return Padding(
                          padding: EdgeInsets.all(size.aspectRatio * 8),
                          child: Container(
                            height: 40, // or the size that fits your design
                            width: 24, // or the size that fits your design
                            // padding: EdgeInsets.all(8),
                            // color: Colors.blue,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: hasInput ? Colors.blue : Colors.grey, // change color based on whether there is input
                                width: 2, // the width of the border
                              ),
                              borderRadius: BorderRadius.circular(4), // if you need rounded corners
                            ),
                            child: Center(
                              child: Text(
                                character,
                                style: TextStyle(
                                    fontSize: 20, // or another size that fits your design
                                    color: Colors.white, // or another appropriate color for your design
                                    fontWeight: FontWeight.w800),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
      ],
    );
  }

}
class NoSpaceTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, // The current value of the text field.
      TextEditingValue newValue, // The value that the text field will have after the change.
      ) {
    // Remove all spaces from the new value.
    String newText = newValue.text.replaceAll(RegExp(r"\s+\b|\b\s"), "");

    // If the new value is different from the old value, update it. Otherwise, keep the old value.
    return oldValue.text == newText
        ? oldValue
        : TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}