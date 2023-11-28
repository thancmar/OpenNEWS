

import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../blocs/navbar/navbar_bloc.dart';
import '../../../models/magazinePublishedGetAllLastByHotspotId_model.dart';
import 'coversverticallist.dart';

class CustomCachedNetworkImage extends StatefulWidget {
  const CustomCachedNetworkImage(
      {Key? key,
        // required List<ValueNotifier<bool>> networklHasErrorNotifier,
        required this.pageNo,
        // required this.covers,
        required this.heroTag,
        required this.spinKitController,
        required this.mag,
        required this.thumbnail,
        required this.reader,
        // required this.imageOffset,
        required this.verticalScroll,
        // required this.upperWidget,
        // required this.scrollController,
        required this.height_News_aus_deiner_Region,
        // required this.size
        // required this.widget,
        // required this.widget,
        // required this.widget,
        // required this.widget,
        // required this.widget,
        // required this.widget,
      })
      :
  // _networklHasErrorNotifier = networklHasErrorNotifier,
        super(key: key);

  // final List<ValueNotifier<bool>> _networklHasErrorNotifier;
  final int pageNo;

  // final MagazinePublishedGetAllLastByHotspotId covers;
  final String? heroTag;
  final AnimationController? spinKitController;
  final ResponseMagazine mag;
  final bool thumbnail;
  final bool reader;
  // final double imageOffset;
  final bool verticalScroll;
  // final VerticalListCover upperWidget;
  // final ScrollController scrollController;
  final double height_News_aus_deiner_Region;
  // final Size size;

  @override
  State<CustomCachedNetworkImage> createState() => _CustomCachedNetworkImageState();
}

class _CustomCachedNetworkImageState extends State<CustomCachedNetworkImage>
    with SingleTickerProviderStateMixin //, AutomaticKeepAliveClientMixin<CustomCachedNetworkImage>
    {
  // final VerticalListCover widget;

  // @override
  // bool get wantKeepAlive => true;
  double scrollPosition = 0.0;
  double imageOffset = 0;


  @override
  void initState() {
    super.initState();
    // widget.scrollController.addListener(_calculateOffset);
  }

  // void _calculateOffset() {
  //   if (!widget.scrollController.hasClients) return;
  //
  //   double itemWidth = widget.size.width / 2;
  //   double itemHeight = itemWidth * 0.7;
  //   double totalItemHeight = itemHeight * 2 + 45.0;
  //   double baseParallaxAmount = 0.05;
  //
  //   int row = widget.pageNo ~/ 2;
  //   double itemStartPosition = row * totalItemHeight;
  //   double itemEndPosition = itemStartPosition + totalItemHeight;
  //
  //   double currentScrollPosition = widget.scrollController.position.pixels - widget.height_News_aus_deiner_Region;
  //
  //   // Debugging: print out values to check calculations
  //   // print('Current Scroll: $currentScrollPosition, Start: $itemStartPosition, End: $itemEndPosition');
  //
  //   if (currentScrollPosition > itemEndPosition || currentScrollPosition + widget.scrollController.position.viewportDimension < itemStartPosition) {
  //     return;
  //   }
  //
  //   double relativePosition = currentScrollPosition - itemStartPosition;
  //   double newImageOffset = relativePosition * baseParallaxAmount;
  //
  //   if (newImageOffset != imageOffset) {
  //     setState(() {
  //       imageOffset = newImageOffset;
  //     });
  //   }
  // }



  @override
  void dispose() {
    // widget.scrollController.removeListener(_calculateOffset);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FutureBuilder<Uint8List?>(
        future: BlocProvider.of<NavbarBloc>(context)
            .getCover(widget.mag.idMagazinePublication!, widget.mag.dateOfPublication!, widget.pageNo.toString(), widget.thumbnail,false),
        builder: (context, snapshot) {
          if (snapshot.hasData) {


            return CachedNetworkImage(
              // key: ValueKey(
              //     // widget._networklHasErrorNotifier != null && widget.index < widget._networklHasErrorNotifier.length
              //     // ?
              //     widget._networklHasErrorNotifier[widget.index].value
              //     // :
              //     // 'defaultKey'
              //     ),
              imageUrl: widget.mag.idMagazinePublication! + "_" + widget.mag.dateOfPublication! + "_" + widget.pageNo.toString() //+ '_thumbnail',
              +(widget.thumbnail == true ? '_thumbnail' : ''),
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
                  borderRadius: BorderRadius.circular(5.0), // Same rounded corners as the outer border
                  child: Transform.translate(
                    offset: Offset(0,0),
                    // offset: Offset(widget.verticalScroll ? 0 : imageOffset, widget.verticalScroll ? imageOffset : 0),
                    child: Hero(
                      tag: "${widget.heroTag}",
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          // border: Border.all(color: Colors.black, width: 2.0), // Outer border
                          image: DecorationImage(
                            image: imageProvider,
                            fit:
                            // widget.verticalScroll ? BoxFit.fill :
                            BoxFit.cover,

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
              placeholder: (context, url) => Container(
                // color: Colors.grey.withOpacity(0.1),
                decoration: BoxDecoration(
                  // image: DecorationImage(image: imageProvider, fit: BoxFit.fill),
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  // color: Colors.grey.withOpacity(0.1),
                ),
                child: SpinKitFadingCircle(
                  color: Colors.white,
                  size: 50.0,
                  controller: widget.spinKitController,
                ),
              ),
              // errorWidget: (context, url, error) {
              //   // Future.delayed(Duration(milliseconds: 250), () {
              //   //   if (mounted) {
              //   //     setState(() {
              //   //       widget._networklHasErrorNotifier[widget.index].value=false;
              //   //     });
              //   //   }
              //   // });
              //   return Container(
              //     // color: Colors.grey.withOpacity(0.1),
              //     decoration: BoxDecoration(
              //       // image: DecorationImage(image: imageProvider, fit: BoxFit.fill),
              //       borderRadius: BorderRadius.all(Radius.circular(5.0)),
              //       // color: Colors.grey.withOpacity(0.1),
              //     ),
              //     child: SpinKitFadingCircle(
              //       color: Colors.white,
              //       size: 50.0,
              //       controller: widget.spinKitController,
              //     ),
              //   );
              // },
              errorWidget: (context, url, error) => Container(
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.error,
                    color: Colors.grey.withOpacity(0.8),
                  )),
            );
          } else {
            return Container(
              // color: Colors.grey.withOpacity(0.1),
              decoration: BoxDecoration(
                // image: DecorationImage(image: imageProvider, fit: BoxFit.fill),
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                // color: Colors.grey.withOpacity(0.1),
                // color: Colors.red,
              ),
              child: SpinKitFadingCircle(
                color: Colors.white,
                size: 50.0,
                controller: widget.spinKitController,
              ),
            );
          }
        });
  }
}