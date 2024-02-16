import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pdf_render/pdf_render.dart';
import 'package:sharemagazines/src/blocs/navbar/navbar_bloc.dart';
import 'package:sharemagazines/src/resources/location_repository.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

import '../../../../models/locationOffers_model.dart';

class OfferPage extends StatefulWidget {
  final LocationOffer locOffer;
  final Uint8List? imageData;
  OfferPage({Key? key, required this.locOffer, this.imageData}) : super(key: key);

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
    // image = null;
    // _controller!.initialize();
    // _controller = VideoPlayerController.asset('assets/test.mp4');
    if (widget.locOffer.shm2Offer![0].type!.contains("PIC") ) {
      image = RepositoryProvider.of<LocationRepository>(context)
          .GetLocationOfferImage(offerID: widget.locOffer.shm2Offer![0].id.toString(), filePath: widget.locOffer.shm2Offer![0].data.toString());
    }
    if ( widget.locOffer.shm2Offer![0].type!.contains("PDF")) {
      image = RepositoryProvider.of<LocationRepository>(context)
          .GetLocationOfferImage(offerID: widget.locOffer.shm2Offer![0].id.toString(), filePath: widget.locOffer.shm2Offer![0].data.toString());
      // PdfDocument docFromData = await PdfDocument.openData(data);
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

  @override
  void dispose() {
    _controller?.pause();
    _controller = null;
    image = null;
    super.dispose();
  }

  // _asyncMethod2() async {
  //   image = await RepositoryProvider.of<LocationRepository>(context)
  //       .GetLocationOfferPDF(offerID: widget.locOffer.shm2Offer![0].id.toString(), filePath: widget.locOffer.shm2Offer![0].data.toString());
  //
  //   PdfDocument docFromData = await PdfDocument.openData(image);
  // }

  _asyncMethod() async {
    RepositoryProvider.of<LocationRepository>(context)
        .GetLocationOfferVideo(offerID: widget.locOffer.shm2Offer![0].id.toString(), filePath: widget.locOffer.shm2Offer![0].data.toString())
        .then((value) async => {
              // print(await videoFile!.length()),
              // print(value),
              _controller = VideoPlayerController.file(
                value,
                videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true, allowBackgroundPlayback: false),
              ),
              _controller!.setLooping(true),
              await _controller!.initialize().then((_) {
                setState(() {});
              }),
              _controller!.play(),
              // _controller!.addListener(() {
              //   setState(() {});
              // }),
              // await _controller!.initialize(),
              // .initialize().then((_) {
              //     setState(() {
              //       // _controller!.play();
              //     });
              //   }),
              // // _controller!.setLooping(true),
            });
    // await _controller!.initialize().then((_) {
    //   setState(() {});
    // });
    // _controller!.setLooping(true);
    // // await _controller!.initialize().then((_) {
    // //   setState(() {});
    // // });
    // _controller!.play();
    // _controller!.initialize();
  }

  Future<void> _launchUrl(Uri _url) async {
    if (_url.scheme.isEmpty) {
      // Add the default scheme (e.g., "http://") if it's missing
      _url = Uri.parse("http://${_url.toString()}");
    }
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Hero(tag: 'bg',child: Image.asset("assets/images/background/Background.png", fit: BoxFit.cover)),
        ),
        Scaffold(
          // extendBody: true,
          // extendBodyBehindAppBar: true,
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
            title: Hero(
                tag: widget.locOffer.shm2Offer![0].title!,
                child: Text(widget.locOffer.shm2Offer![0].title!, style: Theme.of(context).textTheme.headlineSmall,)),

            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: SingleChildScrollView(
            child: Column(children: [
              // _controller.notnull == true &&
              // _controller.value.isInitialized
              //     ?

              widget.imageData!=null? Hero(tag:widget.locOffer.shm2Offer![0].id.toString(),
                child: Image.memory(
                  // state.bytes![i],
                  widget.imageData!,
                ),
              ): widget.locOffer.shm2Offer![0].type!.contains("MOV")
                  ? AspectRatio(
                      aspectRatio: _controller != null ? _controller!.value.aspectRatio : 16 / 9,
                      child: _controller != null
                          ? VideoPlayer(_controller!)
                          : SpinKitFadingCircle(
                              color: Colors.white,
                              size: 50.0,
                            ),
                    )
                  // : Container()
                  : FutureBuilder<Uint8List>(
                      future: image,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          if(widget.locOffer.shm2Offer![0].type!.contains("PIC")){
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
                          }
                          if(widget.locOffer.shm2Offer![0].type!.contains("PDF")){

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
                          }

                          // }
                        }
                        return SpinKitFadingCircle(
                          color: Colors.white,
                          size: 50.0,
                        );
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
      ],
    );
  }
}