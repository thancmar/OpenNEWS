import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sharemagazines_flutter/src/presentation/pages/reader/readerpage.dart';

class ReaderPage extends StatefulWidget {
  final Reader reader;

  final int pageNumber;

  const ReaderPage({Key? key, required this.reader, required this.pageNumber}) : super(key: key);

  @override
  State<ReaderPage> createState() => _ReaderPageState();
}

class _ReaderPageState extends State<ReaderPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
          // width: MediaQuery.of(context).size.width,
          width: MediaQuery.of(context).size.width,
          // height: MediaQuery.of(context).size.height - 100,
          // color: Colors.cyan,
          // height: MediaQuery.of(context).size.height,
          //Need to calculate page width minus minus padding
          // padding: orientation == Orientation.portrait
          //     ? EdgeInsets.only(top: 150, bottom: 150)
          //     : EdgeInsets.only(
          //         right:
          //             MediaQuery.of(context).size.width * 0.3,
          //         left:
          //             MediaQuery.of(context).size.width * 0.3),
          //have to
          // adjust
          // later
          //Remove future pages all from bloc state
          child: Hero(
              tag: '${widget.reader.heroTag}',
              child: Card(
                color: Colors.transparent,
                clipBehavior: Clip.hardEdge,
                margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                elevation: 0,
                // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                child: AnimatedSwitcher(
                        // key: UniqueKey(),
                        duration: Duration(milliseconds: 100),
                        switchOutCurve: Threshold(5),
                        child: ValueListenableBuilder<int>(
                            valueListenable: widget.reader.currentPage,
                            builder: (BuildContext context,
                                int pageNo, Widget? child) {
                              return CachedNetworkImage(
                                  // key: ValueKey(
                                  //     _networklHasErrorNotifier
                                  //         .value),
                                  filterQuality:
                                      FilterQuality.none,
                                  imageUrl: widget.reader.magazine
                                          .idMagazinePublication! +
                                      "_" +
                                      widget.reader.magazine
                                          .dateOfPublication! +
                                      "_" +
                                      pageNo.toString(),
                                  // imageUrl: NavbarState.magazinePublishedGetLastWithLimit!.response!.where((i) => i.magazineLanguage == "de").toList()[index].idMagazinePublication! +
                                  //     "_" +
                                  //     NavbarState.magazinePublishedGetLastWithLimit!.response!.where((i) => i.magazineLanguage == "de").toList()[index].dateOfPublication!,
                                  // progressIndicatorBuilder: (context, url, downloadProgress) => Container(
                                  //   // color: Colors.grey.withOpacity(0.1),
                                  //   decoration: BoxDecoration(
                                  //     // image: DecorationImage(image: imageProvider, fit: BoxFit.fill),
                                  //     borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                  //     color: Colors.grey.withOpacity(0.1),
                                  //   ),
                                  //   child: SpinKitFadingCircle(
                                  //     color: Colors.white,
                                  //     size: 50.0,
                                  //   ),
                                  // ),

                                  imageBuilder: (context,
                                          imageProvider) =>
                                      Container(
                                        height: MediaQuery.of(
                                                context)
                                            .size
                                            .height,
                                        width: MediaQuery.of(
                                                context)
                                            .size
                                            .width,
                                        // color: Colors.red,
                                        decoration:
                                            BoxDecoration(
                                          image: DecorationImage(
                                              image:
                                                  imageProvider,
                                              fit: BoxFit
                                                  .contain),
                                          borderRadius:
                                              BorderRadius.all(
                                                  Radius
                                                      .circular(
                                                          5.0)),
                                        ),
                                      ),
                                  // useOldImageOnUrlChange: true,
                                  // very important: keep both placeholder and errorWidget
                                  placeholder: (context, url) =>
                                      Container(
                                        // color: Colors.grey.withOpacity(0.1),
                                        decoration:
                                            BoxDecoration(
                                          // image: DecorationImage(image: imageProvider, fit: BoxFit.fill),
                                          borderRadius:
                                              BorderRadius.all(
                                                  Radius
                                                      .circular(
                                                          5.0)),
                                          color: Colors.grey
                                              .withOpacity(0.1),
                                        ),
                                        child:
                                            SpinKitFadingCircle(
                                          color: Colors.white,
                                          size: 50.0,
                                          // controller:
                                          //     _spinKitController,
                                        ),
                                      ),
                                  errorWidget:
                                      (context, url, error) {
                                    Future.delayed(
                                        const Duration(
                                            milliseconds: 100),
                                        () {
                                      // setState(() {
                                      //   _networklHasErrorNotifier
                                      //       .value++;
                                      // });
                                    });
                                    return Container(
                                      // color: Colors.grey.withOpacity(0.1),

                                      decoration: BoxDecoration(
                                        // image: DecorationImage(image: imageProvider, fit: BoxFit.fill),
                                        borderRadius:
                                            BorderRadius.all(
                                                Radius.circular(
                                                    5.0)),
                                        color: Colors.grey
                                            .withOpacity(0.1),
                                      ),
                                      child:
                                          SpinKitFadingCircle(
                                        color: Colors.white,
                                        size: 50.0,
                                        // controller:
                                        //     _spinKitController,
                                      ),
                                    );
                                  }
                                  // errorWidget: (context, url, error) => Container(
                                  //     alignment: Alignment.center,
                                  //     child: Icon(
                                  //       Icons.error,
                                  //       color: Colors.grey.withOpacity(0.8),
                                  //     )),
                                  );
                            }),
                        // child: Image.memory((snapshot.hasData) && widget.currentPage != 0 ? snapshot.data! : widget.cover),
                      )
                    // : SpinKitFadingCircle(
                    //     color: Colors.white,
                    //     size: 50.0,
                    //   ),
              )
              // : Image.memory(widget.cover)),
              ),
        );
  }
}