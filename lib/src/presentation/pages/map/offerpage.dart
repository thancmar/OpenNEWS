import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sharemagazines_flutter/src/resources/location_repository.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

import '../../../constants.dart';
import '../../../models/locationOffers_model.dart';

class OfferPage extends StatefulWidget {
  final LocationOffer locOffer;
  final String heroTag;
  OfferPage({Key? key, required this.locOffer, required this.heroTag}) : super(key: key);

  @override
  State<OfferPage> createState() => _OfferPageState();
}

class _OfferPageState extends State<OfferPage> {
  static late Future<Uint8List>? image = null;
  static late VideoPlayerController? _controller = null;
  late File videoFile;

  @override
  void initState() {
    super.initState();
    image = null;
    // _controller = VideoPlayerController.asset('assets/test.mp4');
    if (widget.locOffer.shm2Offer![0].type!.contains("PIC") || widget.locOffer.shm2Offer![0].type!.contains("PDF")) {
      image = RepositoryProvider.of<LocationRepository>(context).GetLocationOfferImage(offerID: widget.locOffer.shm2Offer![0].id.toString(), filePath: widget.locOffer.shm2Offer![0].data.toString());
    }
    if (widget.locOffer.shm2Offer![0].type!.contains("MOV")) {
      // image = RepositoryProvider.of<LocationRepository>(context).GetLocationOfferImage(offerID: widget.locOffer.shm2Offer![0].id.toString(), filePath: widget.locOffer.shm2Offer![0].data.toString());
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _asyncMethod();
      });

      // final File videoFile = File.fromRawPath(image);
      // _controller = VideoPlayerController.asset('assets/test.mp4', videoPlayerOptions: VideoPlayerOptions())
      //   ..initialize().then((_) {
      //     setState(() {
      //       _controller.play();
      //     });
      //   });

      // _controller = VideoPlayerController.network(ApiConstants.baseUrlLocations +
      //         ApiConstants.locationsMobileAPI +
      //         "offer/" +
      //         widget.locOffer.shm2Offer![0].id.toString() +
      //         "/getImage?filePath=" +
      //         widget.locOffer.shm2Offer![0].data.toString()
      //     // 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'
      //     )
      //   ..initialize().then((_) {
      //     // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
      //     setState(() {});
      //   });
      // image = RepositoryProvider.of<LocationRepository>(context).GetLocationOfferImage(offerID: widget.locOffer.shm2Offer![0].id.toString(), filePath: widget.locOffer.shm2Offer![0].data.toString());
    }
  }

  _asyncMethod() async {
    RepositoryProvider.of<LocationRepository>(context)
        .GetLocationOfferVideo(offerID: widget.locOffer.shm2Offer![0].id.toString(), filePath: widget.locOffer.shm2Offer![0].data.toString())
        .then((value) async => {
              // videoFile = File.fromRawPath(value),
              // print(await videoFile!.length()),
              print(value),
              _controller = VideoPlayerController.file(
                value,
                videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
              ),
              _controller!.addListener(() {
                setState(() {});
              }),
              await _controller!.initialize(),
              // .initialize().then((_) {
              //     setState(() {
              //       // _controller!.play();
              //     });
              //   }),
              // // _controller!.setLooping(true),
            });
    await _controller!.initialize().then((_) {
      setState(() {});
    });
    // _controller!.play();
    // _controller!.initialize();
  }

  Future<void> _launchUrl(Uri _url) async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/Background.png"),
          fit: BoxFit.fill,
        ),
      ),
      child: Scaffold(
        // extendBody: true,
        // extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          // bottomOpacity: 1.0,
          leading: InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () => {
                    // setState(() {
                    //   BlocProvider.of<NavbarBloc>(context).add(Map());
                    Navigator.pop(context)
                    // })
                  },
              child: Icon(Icons.arrow_back_ios_new)),
          //HeroTag performance issue
          title: Text(widget.locOffer.shm2Offer![0].title!),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            // _controller.notnull == true &&
            // _controller.value.isInitialized
            //     ?
            widget.locOffer.shm2Offer![0].type!.contains("MOV")
                ? AspectRatio(
                    aspectRatio: 16 / 9,
                    child: VideoPlayer(_controller!),
                  )
                // : Container()
                : FutureBuilder<Uint8List>(
                    future: image,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: GestureDetector(
                            onTap: () => {
                              if (widget.locOffer.shm2Offer![0].url!.isNotEmpty) {_launchUrl(Uri.parse(widget.locOffer.shm2Offer![0].url!))}
                            },
                            child: Image.memory(
                              // state.bytes![i],
                              snapshot.data!,
                            ),
                          ),
                        );
                        // }
                      }
                      return Container();
                    }),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Text(widget.locOffer.shm2Offer![0].shortDesc!,
                  // widget.locOffer.addressStreet + " " + widget.locationDetails.addressHouseNr + ",\n" + widget.locationDetails.addressZip + " " + widget.locationDetails.addressCity,
                  style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600)),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Text(widget.locOffer.shm2Offer![0].longDesc!,
                  // widget.locOffer.addressStreet + " " + widget.locationDetails.addressHouseNr + ",\n" + widget.locationDetails.addressZip + " " + widget.locationDetails.addressCity,
                  style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w300)),
            ),
            (widget.locOffer.shm2Offer![0].urlTitle!.isNotEmpty)
                ? GestureDetector(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.fromLTRB(20, 10, 20, 40),
                      child: Text(
                        widget.locOffer.shm2Offer![0].urlTitle!,
                        style: TextStyle(fontSize: 20, color: Colors.blue, fontWeight: FontWeight.w500, decoration: TextDecoration.underline),
                      ),
                    ),
                    onTap: () => _launchUrl(Uri.parse(widget.locOffer.shm2Offer![0].url!)))
                : Container(),
          ]),
        ),
      ),
    );
  }
}