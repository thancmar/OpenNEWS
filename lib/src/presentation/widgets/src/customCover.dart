import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sharemagazines/src/models/audioBooksForLocationGetAllActive.dart';
import 'package:sharemagazines/src/models/ebooksForLocationGetAllActive.dart';

import '../../../blocs/navbar/navbar_bloc.dart';
import '../../../models/magazinePublishedGetAllLastByHotspotId_model.dart';
import '../../pages/navbarpages/homepage/homepage.dart';
import '../../pages/navbarpages/homepage/puzzle.dart';
import '../../pages/reader/readerpage.dart';

class CustomCachedNetworkImage extends StatefulWidget {
  const CustomCachedNetworkImage({
    Key? key,
    required this.pageNo,
    required this.heroTag,
     this.spinKitController,
    required this.mag,
    required this.thumbnail,
    required this.height_News_aus_deiner_Region,
  }) : super(key: key);

  final int pageNo;
  final String? heroTag;
  final AnimationController? spinKitController;
  final dynamic mag;
  final bool thumbnail;

  final double height_News_aus_deiner_Region;

  @override
  State<CustomCachedNetworkImage> createState() => _CustomCachedNetworkImageState();
}

class _CustomCachedNetworkImageState extends State<CustomCachedNetworkImage> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin<CustomCachedNetworkImage> {

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // return ValueListenableBuilder<CategoryStatus>(
    //     valueListenable: NavbarState.categoryStatus,
    //     builder: (context, categoryStatus, child) {
    // print(widget.mag.runtimeType);
    return widget.mag.runtimeType == ResponseMagazine
        ? FutureBuilder<Uint8List?>(
            future: BlocProvider.of<NavbarBloc>(context)
                .getCover(widget.mag.idMagazinePublication!, widget.mag.dateOfPublication, widget.pageNo.toString(), widget.thumbnail, false),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      color: Colors.grey.withOpacity(0.1),
                    ),
                    child: SpinKitFadingCircle(
                      color: Colors.white,
                      size: 50.0,
                      controller: widget.spinKitController,
                    ),
                  );
                case ConnectionState.active:
                case ConnectionState.done:
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return GestureDetector(
                      onTap: () => {
                        if (widget.mag.idMagazineType == "7")
                          {
                            Navigator.of(context).push(
                              CupertinoPageRoute(
                                builder: (context) =>
                                    // Puzzle()
                                    Puzzle(
                                  title: widget.mag.title!,
                                  puzzleID: widget.mag.puzzleIdMobile!,
                                  gameType: widget.mag.gametypeMobile!,

                                  // noofpages: 5,
                                ),
                                // WebViewXPage()
                              ),
                            )
                          }
                        else
                          {
                            Navigator.of(context).push(
                              CupertinoPageRoute(
                                builder: (context) =>
                                    //     StartReader(
                                    //   magazine: widget.cover.response![i],
                                    //   heroTag: "${widget.heroTag}$i",
                                    //
                                    //   // noofpages: 5,
                                    // ),
                                    Reader(
                                  magazine: widget.mag,
                                  heroTag: "${widget.heroTag}",
                                ),
                              ),
                            )
                          }
                      },
                      child: CachedNetworkImage(
                        // key: ValueKey(
                        //     // widget._networklHasErrorNotifier != null && widget.index < widget._networklHasErrorNotifier.length
                        //     // ?
                        //     widget._networklHasErrorNotifier[widget.index].value
                        //     // :
                        //     // 'defaultKey'
                        //     ),
                        imageUrl: widget.mag.idMagazinePublication! +
                            "_" +
                            (widget.mag.dateOfPublication ?? "puzzle.dart") +
                            "_" +
                            widget.pageNo.toString() //+ '_thumbnail',
                            +
                            (widget.thumbnail == true ? '_thumbnail' : ''),
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
                        // imageRenderMethodForWeb: ,
                        imageBuilder: (context, imageProvider) => Container(
                          // decoration: BoxDecoration(
                          //   // border: Border.all(color: Colors.black, width: 2.0), // Outer border
                          //   borderRadius: BorderRadius.circular(5.0),
                          // ),
                          child: ClipRRect(
                            // This will clip any child widget going outside its bounds
                            borderRadius: BorderRadius.circular(8.0), // Same rounded corners as the outer border
                            child: Transform.translate(
                              offset: Offset(0, 0),
                              child: Hero(
                                tag: "${widget.heroTag}",
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    // border: Border.all(color: Colors.black, width: 2.0), // Outer border
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.fill,
                                    ),
                                    // borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        // filterQuality: widget.reader ? FilterQuality.high : FilterQuality.low,
                        filterQuality: FilterQuality.low,
                        // useOldImageOnUrlChange: true,
                        // very important: keep both placeholder and errorWidget
                        // placeholder: (context, url) => Container(
                        //   // color: Colors.grey.withOpacity(0.1),
                        //   decoration: BoxDecoration(
                        //     // image: DecorationImage(image: imageProvider, fit: BoxFit.fill),
                        //     borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        //     // color: Colors.grey.withOpacity(0.05),
                        //     color: Colors.grey.withOpacity(0.1),
                        //   ),
                        //   child: SpinKitFadingCircle(
                        //     color: Colors.white,
                        //     size: 50.0,
                        //     controller: widget.spinKitController,
                        //   ),
                        // ),
                        placeholder: (context, url) => ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          child: Container(
                            // color: Colors.grey.withOpacity(0.1),

                            decoration: BoxDecoration(
                              // image: DecorationImage(image: imageProvider, fit: BoxFit.fill),
                              borderRadius: BorderRadius.all(Radius.circular(8.0)),
                              // color: Colors.grey.withOpacity(0.1),
                            ),
                            child: SpinKitFadingCircle(
                              color: Colors.white,
                              size: 50.0,
                              controller: widget.spinKitController,
                            ),
                          ),
                        ),

                        errorWidget: (context, url, error) => Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                              color: Colors.grey.withOpacity(0.1),
                            ),
                            child: Icon(
                              Icons.error,
                              color: Colors.grey.withOpacity(0.8),
                            )),
                      ),
                    );
                  }
              }
            })
        : widget.mag.runtimeType == ResponseEbook
            ? FutureBuilder<Uint8List?>(
                future: BlocProvider.of<NavbarBloc>(context).getEbookCover(widget.mag.id!, widget.mag.dateOfPublication, "0"),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          color: Colors.grey.withOpacity(0.1),
                        ),
                        child: SpinKitFadingCircle(
                          color: Colors.white,
                          size: 50.0,
                          controller: widget.spinKitController,
                        ),
                      );
                    case ConnectionState.active:
                    case ConnectionState.done:
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return GestureDetector(
                          onTap: () => {
                            showModalBottomSheet(
                              context: context,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
                              ),
                              isScrollControlled: true,
                              constraints: BoxConstraints.tight(Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height * .8)),
                              builder: (ctx) {
                                return ebookDescription(
                                  context: ctx,
                                  ebook: widget.mag,
                                  spinKitController: widget.spinKitController,
                                );
                              },
                            )
                          },
                          child: CachedNetworkImage(
                            // key: ValueKey(
                            //     // widget._networklHasErrorNotifier != null && widget.index < widget._networklHasErrorNotifier.length
                            //     // ?
                            //     widget._networklHasErrorNotifier[widget.index].value
                            //     // :
                            //     // 'defaultKey'
                            //     ),
                            imageUrl: widget.mag.id + // idMagazinePublication! +
                                "_" +
                                (widget.mag.dateOfPublication) +
                                "ebook"
                            //+ '_thumbnail',
                            ,
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
                            // imageRenderMethodForWeb: ,
                            imageBuilder: (context, imageProvider) => Container(
                              // decoration: BoxDecoration(
                              //   // border: Border.all(color: Colors.black, width: 2.0), // Outer border
                              //   borderRadius: BorderRadius.circular(5.0),
                              // ),
                              child: ClipRRect(
                                // This will clip any child widget going outside its bounds
                                borderRadius: BorderRadius.circular(8.0), // Same rounded corners as the outer border
                                child: Transform.translate(
                                  offset: Offset(0, 0),
                                  child: Hero(
                                    tag: "${widget.heroTag}",
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8.0),
                                        // border: Border.all(color: Colors.black, width: 2.0), // Outer border
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.fill,
                                        ),
                                        // borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            // filterQuality: widget.reader ? FilterQuality.high : FilterQuality.low,
                            filterQuality: FilterQuality.low,
                            // useOldImageOnUrlChange: true,
                            // very important: keep both placeholder and errorWidget
                            // placeholder: (context, url) => Container(
                            //   // color: Colors.grey.withOpacity(0.1),
                            //   decoration: BoxDecoration(
                            //     // image: DecorationImage(image: imageProvider, fit: BoxFit.fill),
                            //     borderRadius: BorderRadius.all(Radius.circular(5.0)),
                            //     // color: Colors.grey.withOpacity(0.05),
                            //     color: Colors.grey.withOpacity(0.1),
                            //   ),
                            //   child: SpinKitFadingCircle(
                            //     color: Colors.white,
                            //     size: 50.0,
                            //     controller: widget.spinKitController,
                            //   ),
                            // ),
                            placeholder: (context, url) => ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(8.0)),
                              child: Container(
                                // color: Colors.grey.withOpacity(0.1),

                                decoration: BoxDecoration(
                                  // image: DecorationImage(image: imageProvider, fit: BoxFit.fill),
                                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                  // color: Colors.grey.withOpacity(0.1),
                                ),
                                child: SpinKitFadingCircle(
                                  color: Colors.white,
                                  size: 50.0,
                                  controller: widget.spinKitController,
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                  color: Colors.grey.withOpacity(0.1),
                                ),
                                child: Icon(
                                  Icons.error,
                                  color: Colors.red.withOpacity(0.8),
                                )),
                          ),
                        );
                      }
                  }
                })
            : widget.mag.runtimeType == ResponseAudioBook
                ? FutureBuilder<Uint8List?>(
                    future: BlocProvider.of<NavbarBloc>(context).getAudioBookCover(widget.mag.id!, widget.mag.dateOfPublication, "0"),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                        case ConnectionState.waiting:
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                              color: Colors.grey.withOpacity(0.1),
                            ),
                            child: SpinKitFadingCircle(
                              color: Colors.white,
                              size: 50.0,
                              controller: widget.spinKitController,
                            ),
                          );
                        case ConnectionState.active:
                        case ConnectionState.done:
                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            return GestureDetector(
                              onTap: () => {
                                showModalBottomSheet(
                                  context: context,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0)),
                                  ),
                                  isScrollControlled: true,
                                  constraints: BoxConstraints.tight(Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height * .8)),
                                  builder: (ctx) {
                                    return ebookDescription(
                                      context: ctx,
                                      audiobook: widget.mag,
                                      spinKitController: widget.spinKitController,
                                    );
                                  },
                                )
                              },
                              child: CachedNetworkImage(
                                // key: ValueKey(
                                //     // widget._networklHasErrorNotifier != null && widget.index < widget._networklHasErrorNotifier.length
                                //     // ?
                                //     widget._networklHasErrorNotifier[widget.index].value
                                //     // :
                                //     // 'defaultKey'
                                //     ),
                                imageUrl: widget.mag.id + // idMagazinePublication! +
                                    "_" +
                                    (widget.mag.dateOfPublication) +
                                    "audiobook"
                                //+ '_thumbnail',
                                ,
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
                                // imageRenderMethodForWeb: ,
                                imageBuilder: (context, imageProvider) => Container(
                                  // decoration: BoxDecoration(
                                  //   // border: Border.all(color: Colors.black, width: 2.0), // Outer border
                                  //   borderRadius: BorderRadius.circular(5.0),
                                  // ),
                                  child: ClipRRect(
                                    // This will clip any child widget going outside its bounds
                                    borderRadius: BorderRadius.circular(8.0), // Same rounded corners as the outer border
                                    child: Transform.translate(
                                      offset: Offset(0, 0),
                                      child: Hero(
                                        tag: "${widget.heroTag}",
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8.0),
                                            // border: Border.all(color: Colors.black, width: 2.0), // Outer border
                                            image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.fill,
                                            ),
                                            // borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                // filterQuality: widget.reader ? FilterQuality.high : FilterQuality.low,
                                filterQuality: FilterQuality.low,
                                // useOldImageOnUrlChange: true,
                                // very important: keep both placeholder and errorWidget
                                // placeholder: (context, url) => Container(
                                //   // color: Colors.grey.withOpacity(0.1),
                                //   decoration: BoxDecoration(
                                //     // image: DecorationImage(image: imageProvider, fit: BoxFit.fill),
                                //     borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                //     // color: Colors.grey.withOpacity(0.05),
                                //     color: Colors.grey.withOpacity(0.1),
                                //   ),
                                //   child: SpinKitFadingCircle(
                                //     color: Colors.white,
                                //     size: 50.0,
                                //     controller: widget.spinKitController,
                                //   ),
                                // ),
                                placeholder: (context, url) => ClipRRect(
                                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                  child: Container(
                                    // color: Colors.grey.withOpacity(0.1),

                                    decoration: BoxDecoration(
                                      // image: DecorationImage(image: imageProvider, fit: BoxFit.fill),
                                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                      // color: Colors.grey.withOpacity(0.1),
                                    ),
                                    child: SpinKitFadingCircle(
                                      color: Colors.white,
                                      size: 50.0,
                                      controller: widget.spinKitController,
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                      color: Colors.grey.withOpacity(0.1),
                                    ),
                                    child: Icon(
                                      Icons.error,
                                      color: Colors.red.withOpacity(0.8),
                                    )),
                              ),
                            );
                          }
                      }
                    })
                : Container();
    // });
  }
}