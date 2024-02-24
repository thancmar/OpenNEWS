import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:sharemagazines/src/blocs/navbar/navbar_bloc.dart';
import 'package:sharemagazines/src/presentation/pages/navbarpages/homepage/homepage.dart';
import 'package:sharemagazines/src/presentation/widgets/src/customCover.dart';

import '../pages/reader/readerpage.dart';
import 'marquee.dart';

class News_aus_deiner_Region extends StatefulWidget {
  final NavbarState state;
  final String categoryName;

  News_aus_deiner_Region({Key? key, required this.state, required this.categoryName}) : super(key: key);

  @override
  State<News_aus_deiner_Region> createState() => News_aus_deiner_RegionState();
}

class News_aus_deiner_RegionState extends State<News_aus_deiner_Region>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin<News_aus_deiner_Region> {
  int index1 = 0;
  // static late List<ValueNotifier<int>> _networklHasErrorNotifier;
  late AnimationController? _spinKitController;

  @override
  bool get wantKeepAlive => true;

  void initState() {
    // _networklHasErrorNotifier = List.filled(NavbarState.magazinePublishedGetTopLastByRange!.response!.length, ValueNotifier(0), growable: true);
    super.initState();
    _spinKitController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
  }

  bool isTablet(BuildContext context) {
    // Get the device's physical screen size
    var screenSize = MediaQuery.of(context).size;

    // Arbitrary cutoff for device width that differentiates between phones and tablets
    // This can be adjusted based on your needs or specific device metrics
    const double deviceWidthCutoff = 600;

    return screenSize.width > deviceWidthCutoff;
  }

  @override
  void dispose() {
    _spinKitController?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    bool tablet = isTablet(context);
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Align(
          alignment:tablet?Alignment.center: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(25, 20, 25, 20),
            child: Text(
              ("regionalTitle").tr(),
              style:  Theme.of(context).textTheme.bodyLarge,
              textAlign: tablet?TextAlign.center: TextAlign.right,
            ),
          ),
        ),
        SizedBox(
          // height: MediaQuery.of(context).size.height *0.55, // card height
          height:size.aspectRatio * 840, // card height
          // height: 450,
          // height: double.infinity,
          // width: 30,
          child: PageView.builder(
            itemCount: NavbarState.magazinePublishedGetTopLastByRange!.response()!.length,
            // padEnds: true,

            controller: PageController(viewportFraction: 0.6807),
            onPageChanged: (int index) => setState(() => index1 = index),
            itemBuilder: (_, i) {
              return Transform.scale(
                  scale: i == index1 ? 1 : 0.85,
                  alignment: Alignment.bottomCenter,

                  child: Card(
                    color: Colors.transparent,
                    // clipBehavior: Clip.hardEdge,
                    // borderOnForeground: true,
                    margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
                    elevation: 0,
                    child: Stack(
                      // clipBehavior: Clip.none,
                      // alignment: Alignment.center,
                      // clipBehavior: Clip.antiAlias,
                      children: [
                        // CustomCachedNetworkImage(
                        //   mag: NavbarState.magazinePublishedGetTopLastByRange!.response![i],
                        //   reader: false,
                        //   thumbnail: true,
                        //   // covers: widget.cover,
                        //   heroTag:'News_aus_deiner_Region_$i',
                        //   pageNo: 0,
                        //   spinKitController: _spinKitController,
                        //   height_News_aus_deiner_Region: 0,
                        //   // scrollController: ,
                        //   // imageOffset: imageOffset,
                        //   verticalScroll: false,
                        //   // widget: widget, widget: widget, widget: widget, widget: widget, widget: widget, widget: widget
                        // ),
                  ColumnSuper(
                      innerDistance: 10, //-60 for circular card
                      // outerDistance: -50,
                      children: [
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () => {
                            Navigator.of(context).push(
                              CupertinoPageRoute(
                                builder: (context) => Reader(magazine: NavbarState.magazinePublishedGetTopLastByRange!.response()![i], heroTag: 'News_aus_deiner_Region_$i')
                                //     StartReader(
                                //   magazine: NavbarState.magazinePublishedGetTopLastByRange!.response![i],
                                //
                                //   heroTag: 'News_aus_deiner_Region_$i',
                                //
                                //   // noofpages: 5,
                                // ),
                              ),
                            )
                          },
                          child: Stack(
                            // clipBehavior: Clip.antiAlias,
                            children: [
                              // CustomCachedNetworkImage(
                              //   networklHasErrorNotifier: _networklHasErrorNotifier, index: i, covers: NavbarState.magazinePublishedGetTopLastByRange!,
                              //   // widget: widget, widget: widget, widget: widget, widget: widget, widget: widget, widget: widget
                              // ),
                              CachedNetworkImage(
                                // key: ValueKey(_networklHasErrorNotifier[i].value),
                                  imageUrl: NavbarState.magazinePublishedGetTopLastByRange!.response()![i].idMagazinePublication! +
                                      "_" +
                                      NavbarState.magazinePublishedGetTopLastByRange!.response()![i].dateOfPublication! +
                                      "_0",
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
                                          tag: "News_aus_deiner_Region_$i",
                                          child: Container(
                                            height: size.aspectRatio * 700,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(5.0),
                                              // border: Border.all(color: Colors.black, width: 2.0), // Outer border
                                              image: DecorationImage(
                                                image: imageProvider,
                                                fit:
                                                // widget.verticalScroll ? BoxFit.fill :
                                                BoxFit.fill,

                                              ),
                                              // borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // imageBuilder: (context, imageProvider) => Hero(
                                  //       tag: "News_aus_deiner_Region_$i",
                                  //       child: Container(
                                  //         height: 400,
                                  //         decoration: BoxDecoration(
                                  //           image: DecorationImage(image: imageProvider, fit: BoxFit.fill),
                                  //           borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                  //         ),
                                  //       ),
                                  //     ),
                                  // useOldImageOnUrlChange: true,
                                  // very important: keep both placeholder and errorWidget
                                  placeholder: (context, url) => Container(
                                    // color: Colors.grey.withOpacity(0.1),
                                    height:400,
                                    decoration: BoxDecoration(
                                      // image: DecorationImage(image: imageProvider, fit: BoxFit.fill),
                                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                      color: Colors.grey.withOpacity(0.1),
                                    ),
                                    child: SpinKitFadingCircle(
                                      color: Colors.white,
                                      size: 50.0,
                                      controller: _spinKitController,
                                    ),
                                  ),
                                  errorWidget: (context, url, error) {
                                    // Future.delayed(const Duration(milliseconds: 500), () {
                                    //   setState(() {
                                    //     _networklHasErrorNotifier[i].value++;
                                    //   });
                                    // });
                                    return Container(
                                      height: 400,
                                      // color: Colors.grey.withOpacity(0.1),
                                      decoration: BoxDecoration(
                                        // image: DecorationImage(image: imageProvider, fit: BoxFit.fill),
                                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                        color: Colors.grey.withOpacity(0.1),
                                      ),
                                      child: SpinKitFadingCircle(
                                        color: Colors.white,
                                        size: 50.0,
                                        controller: _spinKitController,
                                      ),
                                    );
                                  }),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            i == index1
                                ? Align(
                              alignment: Alignment.center,
                              child: AbsorbPointer(
                                absorbing: true,
                                child: MarqueeWidget(
                                  animationDuration: Duration(milliseconds: 10),
                                  direction: Axis.vertical,
                                  child: MarqueeWidget(
                                    animationDuration: Duration(milliseconds: 6000),
                                    direction: Axis.horizontal,
                                    // crossAxisAlignment: CrossAxisAlignment.start,
                                    child: Text(
                                      // state.magazinePublishedGetLastWithLimit.response![i + 1].name!,
                                      NavbarState.magazinePublishedGetTopLastByRange!.response()![i].title!
                                      // + "NavbarState.magazinePublishedGetTopLastByRange!.response![i].name!"
                                      ,
                                      // " asd",
                                      // "Card ${i + 1}",
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                        backgroundColor: Colors.transparent,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                                : Container(),
                            i == index1
                                ? Align(
                              alignment: Alignment.center,
                              child: AbsorbPointer(
                                absorbing: true,
                                child: MarqueeWidget(
                                  // animationDuration: Duration(milliseconds: 0),
                                  direction: Axis.vertical,
                                  child: MarqueeWidget(
                                    direction: Axis.horizontal,
                                    child: Text(
                                      // state.magazinePublishedGetLastWithLimit.response![i + 1].name!,
                                      DateFormat("d. MMMM yyyy").format(
                                          DateTime.parse(NavbarState.magazinePublishedGetTopLastByRange!.response()![i].dateOfPublication!)),
                                      // " asd",
                                      // "Card ${i + 1}",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                        backgroundColor: Colors.transparent,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                                : Container(),
                          ],
                        ),
                      ],


                  )],
                    ),
                  ));
            },
          ),
        ),
        Align(
          alignment: tablet?Alignment.center: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(25, 8, 25, 20),
            child: Text(
              // ("Top-title").tr(),
              widget.categoryName,
              style:  Theme.of(context).textTheme.bodyLarge,
              textAlign:tablet?TextAlign.center: TextAlign.right,
            ),
          ),
        ),
      ],
    );
    // return Container();
  }
}