import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:sharemagazines_flutter/src/presentation/pages/navbarpages/qrpage/qrCodeInputField.dart';

import '../../../../blocs/navbar/navbar_bloc.dart';

class QRViewExample extends StatefulWidget {
  const QRViewExample({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final TextEditingController textEditingController = TextEditingController();
  Barcode? result;
  bool cameraActive = false;
  QRViewController? controller;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  void initState() {
    super.initState();
    checkCameraPermission();
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      // Find the index of the last occurrence of '=' in the string
      controller!.pauseCamera();
      int startIndex = scanData.code!.lastIndexOf('=');

    // Extract the value after '='
      String extractedValue = scanData.code!.substring(startIndex + 1);
      setState(() {
        textEditingController.text=extractedValue;
      });


      BlocProvider.of<NavbarBloc>(context).qr(extractedValue);
      setState(() {
        result = scanData;
      });
    });
  }

  void checkCameraPermission() async {
    // PermissionStatus cameraPermissionStatus = await Permission.cameraStatus();
    PermissionStatus status = await Permission.camera.status;
    if (status.isGranted) {
      // Camera permission is granted

      setState(() {
        cameraActive = true;
      });
    } else {
      // Camera permission is not granted
      PermissionStatus status = await Permission.camera.request();
      // openAppSettings();
      setState(() {
        cameraActive = false;
      });
      // cameraActive = false;
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset("assets/images/background/Background.png", fit: BoxFit.cover),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            // bottomOpacity: 1.0,

            leading: GestureDetector(
                // splashColor: Colors.transparent,
                // highlightColor: Colors.transparent,
                onTap: () => {
                      // setState(() {
                      //   BlocProvider.of<NavbarBloc>(context).add(Map());
                      Navigator.pop(context)
                      // })
                    },
                child: Hero(
                    tag: "backbutton",
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                    ))),
            //HeroTag performance issue
            title: Text("QR Scanner", style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w300)),

            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: SafeArea(
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: cameraActive == true
                      ? Container(
                          margin:  EdgeInsets.all(4.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.blue, width: 1.10),
                            borderRadius: new BorderRadius.circular(20.0),
                            // color: Colors.red,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child: QRView(
                              key: qrKey,
                              overlay: QrScannerOverlayShape(
                                borderColor: Colors.blue,
                                borderRadius: 10.0,
                                borderLength: 30.0,
                                borderWidth: 4.0,
                                cutOutSize: MediaQuery.of(context).size.width * 0.8,
                              ),
                              // overlayMargin: EdgeInsets.all(80),
                              onQRViewCreated: _onQRViewCreated,
                            ),
                          ),
                        )
                      : Container(
                          width: double.infinity,
                          height: double.infinity,
                          color: Colors.grey.withOpacity(0.4),
                          child: Align(
                              alignment: Alignment.center,
                              child: Center(
                                  child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.no_photography_outlined,
                                    color: Colors.white,
                                  ),
                                  Text("No camera access"),
                                ],
                              ))),
                        ),
                ),
                Expanded(
                  flex: 1,
                  child: Center(child: QRCodeInputField(textEditingController: textEditingController,)
                      // (result != null) ? Text('Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}') : Text('Scan a code'),
                      ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}