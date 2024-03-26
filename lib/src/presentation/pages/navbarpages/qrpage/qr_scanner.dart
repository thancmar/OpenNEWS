import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:sharemagazines/src/presentation/pages/navbarpages/qrpage/qrCodeInputField.dart';

import '../../../../blocs/auth/auth_bloc.dart';
import '../../../../blocs/navbar/navbar_bloc.dart';

class QRCodeScanner extends StatefulWidget {
  late String? fingerprint;

  // bool hideCamera = false;
  ValueNotifier<bool> hideCameraToShowOnlyTextField = ValueNotifier<bool>(false);
  TextEditingController textEditingController = TextEditingController();

  QRCodeScanner({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRCodeScannerState();
}

class _QRCodeScannerState extends State<QRCodeScanner> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // final TextEditingController textEditingController = TextEditingController();
  Barcode? result;
  bool cameraActive = true;

  // bool hideCamera = false;
  QRViewController? controller;

  // String? fingerprint;
  ValueNotifier<bool> errorQR = ValueNotifier<bool>(false);

  // // In order to get hot reload to work we need to pause the camera if the platform
  // // is android, or resume the camera if the platform is iOS.
  // @override
  // void reassemble() {
  //   super.reassemble();
  //   if (Platform.isAndroid) {
  //     controller!.pauseCamera();
  //   } else if (Platform.isIOS) {
  //     controller!.resumeCamera();
  //   }
  // }

  @override
  void initState() {
    super.initState();
    checkCameraPermission();
    generateFingerprint().then((value) => setState(() {
          widget.fingerprint = value;
          print('hash: ${widget.fingerprint}');
        }));
  }

  Future<String> generateFingerprint() async {
    var deviceInfo = DeviceInfoPlugin();
    String fingerprintSource;

    if (Platform.isAndroid) {
      var androidInfo = await deviceInfo.androidInfo;
      fingerprintSource = '''
      ${androidInfo.id}
      ${androidInfo.brand}
      ${androidInfo.device}
      ${androidInfo.id}
      ${androidInfo.product}
      ${androidInfo.version.sdkInt}
    ''';
    } else if (Platform.isIOS) {
      var iosInfo = await deviceInfo.iosInfo;
      fingerprintSource = '''
      ${iosInfo.identifierForVendor}
      ${iosInfo.systemName}
      ${iosInfo.systemVersion}
      ${iosInfo.model}
    ''';
    } else {
      // Other platforms
      print("vd");
      fingerprintSource = 'Unsupported Platform';
    }
    print(fingerprintSource);
    var bytes = utf8.encode(fingerprintSource);

    var digest = md5.convert(bytes);
    print(digest);

    return digest.toString();
  }

  void _onQRViewCreated(QRViewController controller1) async {
    this.controller = controller1;

    controller?.scannedDataStream.listen((scanData) {
      // Find the index of the last occurrence of '=' in the string
      controller!.pauseCamera();
      int startIndex = scanData.code!.lastIndexOf('=');

      // Extract the value after '='
      String extractedValue = scanData.code!.substring(startIndex + 1);
      setState(() {
        widget.textEditingController.text = extractedValue;
      });
      BlocProvider.of<AuthBloc>(context).add(
        SignInRequested(AuthState.savedEmail, AuthState.savedPWD, extractedValue, widget.fingerprint, true),
      );

      // }

      BlocProvider.of<NavbarBloc>(context).qr(extractedValue, widget.fingerprint!).then((value) => {
            if (value == true) {Navigator.pop(context)} else {errorQR.value = true}
          });
      // BlocProvider.of<NavbarBloc>(context).qr(extractedValue);
      setState(() {
        result = scanData;
      });
    }, onError: (error) {
      print("QREEOR");

      errorQR.value = true;
    });
  }

  void checkCameraPermission() async {
    // PermissionStatus cameraPermissionStatus = await Permission.cameraStatus();
    PermissionStatus status = await Permission.camera.status;
    print(status);
    if (status.isGranted) {
      // Camera permission is granted

      setState(() {
        cameraActive = true;
      });
    } else {
      // Camera permission is not granted
      PermissionStatus status = await Permission.camera.request();
      if (status != PermissionStatus.granted) {
        setState(() {
          cameraActive = false;
        });
      } else {
        setState(() {
          cameraActive = true;
        });
      }
      // cameraActive = true;
    }
  }

  @override
  void dispose() {
    cameraActive = false;
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
            leading: InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () => {
                      // setState(() {
                      //   BlocProvider.of<NavbarBloc>(context).add(Map());
                  controller?.dispose(),
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
            child: ValueListenableBuilder<bool>(
                valueListenable: errorQR,
                builder: (BuildContext context, bool counterValue, Widget? child) {
                  return counterValue
                      ? AlertDialog(
                    backgroundColor: Colors.white,
                          title: Text(
                            ('error').tr(),
                            style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.black), ),
                          content: Text('QR code is not valid',style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.grey),),
                          actions: <Widget>[
                            // TextButton(
                            //   onPressed: () => Navigator.pop(context, 'Cancel'),
                            //   child: const Text('Cancel'),
                            // ),
                            TextButton(
                              onPressed: () => {errorQR.value = false, widget.hideCameraToShowOnlyTextField.value = false},
                              child: Text('OK',style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.blue),),
                            ),
                          ],
                        )
                      : Container(
                          // margin: EdgeInsets.all(4.0),
                          // decoration: BoxDecoration(
                          //   border: Border.all(color: Colors.blue, width: 1.10),
                          //   borderRadius: new BorderRadius.circular(20.0),
                          // ),
                          child: Column(
                            children: <Widget>[
                              ValueListenableBuilder<bool>(
                                valueListenable: widget.hideCameraToShowOnlyTextField,
                                builder: (BuildContext context, bool hideCamera, Widget? child) {
                                  return !hideCamera
                                      ? Expanded(
                                          flex: 3,
                                          child: Container(
                                            margin: EdgeInsets.all(8.0),
                                            decoration: BoxDecoration(
                                              border: Border.all(color: Colors.blue, width: 1.10),
                                              borderRadius: new BorderRadius.circular(20.0),

                                              // color: Colors.red,
                                            ),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(20.0),
                                              child: cameraActive == true
                                                  ? QRView(
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
                                                                size: 60,
                                                              ),
                                                              Text("No camera access",
                                                                  style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w300)),
                                                              GestureDetector(
                                                                onTap: () {
                                                                  openAppSettings();
                                                                },
                                                                child: Text(
                                                                  "Open Settings",
                                                                  style: TextStyle(
                                                                    color: Colors.blue,
                                                                    fontWeight: FontWeight.w300,
                                                                    fontSize: 18,
                                                                    //fontStyle: FontStyle.,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ))),
                                                    ),
                                            ),
                                          ))
                                      : Container();
                                },
                              ),
                              Expanded(
                                flex: 1,
                                child: Center(
                                    child: QRCodeInputField(
                                  // textEditingController: widget.textEditingController,
                                  // fingerprint:  widget.fingerprint,
                                  cameraActive: cameraActive,
                                  error: errorQR,
                                  camera: this.widget,
                                )
                                    // (result != null) ? Text('Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}') : Text('Scan a code'),
                                    ),
                              )
                            ],
                          ),
                        );
                }),
          ),
        ),
      ],
    );
  }
}