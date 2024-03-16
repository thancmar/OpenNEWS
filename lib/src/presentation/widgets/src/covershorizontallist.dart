import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sharemagazines/src/models/audioBooksForLocationGetAllActive.dart';

import '../../../models/ebooksForLocationGetAllActive.dart';
import '../../../models/magazinePublishedGetAllLastByHotspotId_model.dart';
import '../../pages/navbarpages/homepage/homepage.dart';
import '../../pages/navbarpages/homepage/puzzle.dart';
import '../../pages/reader/readerpage.dart';
import '../marquee.dart';
import 'customCover.dart';

class ListMagazineCover extends StatefulWidget {
  final BaseResponse cover;
  final String heroTag;
  final Axis scrollDirection;
  final bool isSearchResults;

  const ListMagazineCover({Key? key, required this.cover, required String this.heroTag, required this.scrollDirection, required this.isSearchResults})
      : super(key: key);

  @override
  State<ListMagazineCover> createState() => _ListMagazineCoverState();
}

class _ListMagazineCoverState extends State<ListMagazineCover> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin<ListMagazineCover> {
  late AnimationController? _spinKitController;
  final ScrollController _controller = ScrollController();

  // int currentIndex = 0;
  // PageController pageController = PageController(
  //   // viewportFraction: 0.65,
  //   // initialPage: widget.cover.response.length >0 ?Random().nextInt( widget.cover.response!.length):1,
  //     initialPage: 1,
  //     keepPage: true,
  //     viewportFraction: 0.6
  //   // viewportFraction: MediaQuery.of(context).size.aspectRatio * 1.3, //Works?
  // );

  // double scrollPosition = 0.0; // Track the scroll position

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _spinKitController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Calculate the offset for item 3.5, assuming all items have the same height
      // This is a simplified example; you might need a more dynamic calculation
      final itemHeight = 100.0; // Adjust based on your item heights
      var screenSize = MediaQuery.of(context).size;
      final initialOffset = itemHeight + 40; // For item 3.5
      // _controller.jumpTo(initialOffset);
      if (!widget.isSearchResults) {
        _controller.jumpTo(initialOffset);
      }
    });
  }

  @override
  void dispose() {
    _spinKitController?.dispose();
    // pageController.dispose();
    super.dispose();
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
  Widget build(BuildContext context) {
    super.build(context);
    bool tablet = isTablet(context);
    Size size = MediaQuery.of(context).size;
    return SizedBox(
        height: tablet ? 350 : size.aspectRatio * (widget.cover.runtimeType == AudioBooksForLocationGetAllActive ?520:700), // card height
        child: ListView.builder(
          itemCount: widget.cover.response()?.length ?? 0,
          // itemCount: state.magazinePublishedGetLastWithLimit.response!.length! + 10,
          // itemCount: 10,
          // padEnds: false,
          //IMPORTANT(.down is also good)
          // onPageChanged: (int index) => setState(() => currentIndex = index),
          dragStartBehavior: DragStartBehavior.start,
          scrollDirection: widget.scrollDirection,
          shrinkWrap: true,
          // allowImplicitScrolling: false,
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          // controller: pageController,
          controller: _controller,
          // onPageChanged: (int index) => setState(() => _index2 = index),
          // onPageChanged: (int index) => _index2 = index,
          // pageSnapping: false,
          itemBuilder: (context, i) {
            return Padding(
              padding: EdgeInsets.all(tablet ? 8.0 : 4.0),
              child: AspectRatio(
                aspectRatio: widget.cover.runtimeType == AudioBooksForLocationGetAllActive ? 9 / 10: 9 / 13,
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  // mainAxisSize:  MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Card(
                          color: Colors.transparent,
                          // clipBehavior: Clip.hardEdge,
                          // borderOnForeground: true,
                          margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
                          elevation: 0,

                          ///maybe 0?
                          // shape: RoundqedRectangleBorder(borderRadius: BorderRadius.circular(500)),
                          child: Stack(
                            children: [
                              CustomCachedNetworkImage(
                                mag: widget.cover.response()![i],
                                thumbnail: true,
                                // covers: widget.cover,
                                heroTag: "${widget.heroTag}$i",
                                pageNo: 0,
                                spinKitController: _spinKitController,
                                height_News_aus_deiner_Region: 0,
                              ),
                            ],
                          )),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0, 4, 20, 0),
                        //Dumb hack
                        child: AbsorbPointer(
                          absorbing: true,
                          child: MarqueeWidget(
                            child: MarqueeWidget(
                              direction: Axis.vertical,

                              // crossAxisAlignment: CrossAxisAlignment.start,
                              child: Text(
                                // state.magazinePublishedGetLastWithLimit.response![i + 1].name!,
                                widget.cover.response()?[i].title,

                                // " asd",
                                // "Card ${i + 1}",
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyMedium,
                                // style: TextStyle(
                                //   fontSize: 16,
                                //   color: Colors.white,
                                //   backgroundColor: Colors.transparent,
                                // ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    widget.cover.response()![i].dateOfPublication != null
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  child: AbsorbPointer(
                                    absorbing: true,
                                    child: MarqueeWidget(
                                      child: MarqueeWidget(
                                        direction: Axis.vertical,
                                        child: Text(
                                          // state.magazinePublishedGetLastWithLimit.response![i + 1].name!,
                                          ((widget.cover.runtimeType == EbooksForLocationGetAllActive ||
                                                      widget.cover.runtimeType == AudioBooksForLocationGetAllActive)
                                                  ? DateFormat("yyyy")
                                                  : DateFormat("d. MMMM yyyy"))
                                              .format(DateTime.parse(widget.cover.response()![i].dateOfPublication!)),
                                          // " asd",
                                          // "Card ${i + 1}",
                                          textAlign: TextAlign.left,
                                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.grey),
                                          // style: TextStyle(
                                          //   fontSize: 12,
                                          //   color: Colors.grey,
                                          //   backgroundColor: Colors.transparent,
                                          // ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              widget.cover.runtimeType != MagazinePublishedGetAllLastByHotspotId
                                  ? Padding(
                                padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                                child: Container(
                                  width: 1, // Adjust the width as needed
                                  height: 12, // Adjust the height as needed
                                  color: Colors.white,
                                ),
                              )
                                  : Container(),
                              widget.cover.runtimeType != MagazinePublishedGetAllLastByHotspotId
                                  ? Padding(
                                    padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                                    child: AbsorbPointer(
                                      absorbing: true,
                                      child: MarqueeWidget(
                                        child: MarqueeWidget(
                                          direction: Axis.vertical,
                                          child: Text(
                                            // state.magazinePublishedGetLastWithLimit.response![i + 1].name!,
                                            // ((widget.cover.runtimeType == EbooksForLocationGetAllActive ||widget.cover.runtimeType == AudioBooksForLocationGetAllActive)? DateFormat("yyyy"): DateFormat("d. MMMM yyyy")).format(DateTime.parse(widget.cover.response()![i].dateOfPublication!)),
                                            (widget.cover.runtimeType == EbooksForLocationGetAllActive
                                                    ? widget.cover.response()![i].ebookLanguage!
                                                    : widget.cover.response()![i].audiobookLanguage)
                                                .toString()
                                                .toUpperCase(),
                                            // " asd",
                                            // "Card ${i + 1}",
                                            textAlign: TextAlign.left,
                                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white),
                                            // style: TextStyle(
                                            //   fontSize: 12,
                                            //   color: Colors.grey,
                                            //   backgroundColor: Colors.transparent,
                                            // ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                  : Container()
                            ],
                          )
                        : Container(),
                  ],
                ),
              ),
            );
            // });
          },
        )
        // )
        );
  }
}