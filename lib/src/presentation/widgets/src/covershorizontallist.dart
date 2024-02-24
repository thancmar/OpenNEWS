import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../models/magazinePublishedGetAllLastByHotspotId_model.dart';
import '../../pages/navbarpages/homepage/puzzle.dart';
import '../../pages/reader/readerpage.dart';
import '../marquee.dart';
import 'customCover.dart';

class ListMagazineCover extends StatefulWidget {
  final BaseResponse cover;
  final String heroTag;
  final Axis scrollDirection;

  const ListMagazineCover({Key? key, required this.cover, required String this.heroTag, required this.scrollDirection}) : super(key: key);

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
      final initialOffset = itemHeight * 3.5; // For item 3.5
      _controller.jumpTo(initialOffset);
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
        height: tablet?350:size.aspectRatio * 700, // card height
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
              // controller: PageController(
              //   // viewportFraction: 0.65,
              //   // initialPage: widget.cover.response.length >0 ?Random().nextInt( widget.cover.response!.length):1,
              //   initialPage: 1,
              //   keepPage: true,
              //   viewportFraction: MediaQuery.of(context).size.aspectRatio * 1.3, //Works?
              // ),

              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              // controller: pageController,
              controller: _controller,

              // onPageChanged: (int index) => setState(() => _index2 = index),
              // onPageChanged: (int index) => _index2 = index,
              // pageSnapping: false,
              itemBuilder: (context, i) {
                // Calculate the parallax effect based on the scroll position
                // Calculate the parallax effect based on the current page and the item's position
                // final double value = currentIndex - i.toDouble();
                // double scale = max(1.0, (1 - (currentIndex - i).abs()) + 0.1);
                // double gaussianOffset = exp(-(pow((currentIndex - i), 2) / 0.1));
                // // double imageOffset = (currentIndex - i) * 0.5 * gaussianOffset; // adjusted by Gaussian function
                // double imageOffset = (scrollPosition - i) * 20.0; // adjust the multiplier for stronger/weaker parallax

                return Padding(
                  padding:  EdgeInsets.all(tablet?8.0:4.0),
                  child: AspectRatio(
                    aspectRatio: 9 / 13,

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
                                // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(500)),
                                child: Stack(
                                  children: [
                                    GestureDetector(
                                      // behavior: HitTestBehavior.translucent,
                                      onTap: () => {
                                        if(widget.cover.response()![i].idMagazineType == "7"){

                                          Navigator.of(context).push(
                                            CupertinoPageRoute(
                                              builder: (context) =>
                                              // Puzzle()
                                              Puzzle(
                                                title:  widget.cover.response()![i].title!,
                                                puzzleID: widget.cover.response()![i].puzzleIdMobile!,
                                                gameType: widget.cover.response()![i].gametypeMobile!,

                                                // noofpages: 5,
                                              ),
                                              // WebViewXPage()
                                            ),
                                          )
                                        }else{
                                        Navigator.of(context).push(
                                          CupertinoPageRoute(
                                            builder: (context) => 
                                            //     StartReader(
                                            //   magazine: widget.cover.response![i],
                                            //   heroTag: "${widget.heroTag}$i",
                                            //
                                            //   // noofpages: 5,
                                            // ),
                                            Reader(magazine: widget.cover.response()![i],heroTag:"${widget.heroTag}$i" ,),
                                          ),
                                        )}
                                      },
                                      child: CustomCachedNetworkImage(
                                        mag: widget.cover.response()![i],

                                        thumbnail: true,
                                        // covers: widget.cover,
                                        heroTag: "${widget.heroTag}$i",
                                        pageNo: 0,
                                        spinKitController: _spinKitController,
                                        height_News_aus_deiner_Region: 0,


                                      ),
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
                                      widget.cover.response()?[i].title ,

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
                          widget.cover.response()![i].dateOfPublication!=null? Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                              child: AbsorbPointer(
                                absorbing: true,
                                child: MarqueeWidget(
                                  child: MarqueeWidget(
                                    direction: Axis.vertical,
                                    child: Text(
                                      // state.magazinePublishedGetLastWithLimit.response![i + 1].name!,
                                      DateFormat("d. MMMM yyyy").format(DateTime.parse(widget.cover.response()![i].dateOfPublication!)),
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
                          ):Container(),
                          // Positioned(
                          //   // top: -50,
                          //   bottom: -100,
                          //   // height: -50,
                          //   width: MediaQuery.of(context).size.width / 2 - 20,
                          //   child: Align(
                          //     alignment: Alignment.center,
                          //     child: MarqueeWidget(
                          //       // crossAxisAlignment: CrossAxisAlignment.start,
                          //       child: Text(
                          //         // state.magazinePublishedGetLastWithLimit.response![i + 1].name!,
                          //         NavbarState.magazinePublishedGetLastWithLimit!.response![i].name!,
                          //         // " asd",
                          //         // "Card ${i + 1}",
                          //         textAlign: TextAlign.center,
                          //
                          //         style: TextStyle(
                          //           fontSize: 14,
                          //           color: Colors.white,
                          //           backgroundColor: Colors.transparent,
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                          // ),
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