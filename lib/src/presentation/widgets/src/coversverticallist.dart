import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../models/audioBooksForLocationGetAllActive.dart';
import '../../../models/ebooksForLocationGetAllActive.dart';
import '../../../models/magazinePublishedGetAllLastByHotspotId_model.dart';

// import '../../pages/navbarpages/homepage/puzzlepage.dart';
import '../../pages/navbarpages/homepage/puzzle.dart';
import '../../pages/reader/readerpage.dart';
import '../marquee.dart';
import 'customCover.dart';

class VerticalListCover extends StatefulWidget {
  // final MagazinePublishedGetAllLastByHotspotId items;
  final BaseResponse items;
  final ScrollController scrollController;
  final double height_News_aus_deiner_Region;
  final String? title;

  // late List<double> imageOffsets;

  VerticalListCover({Key? key, required this.items, required this.scrollController, required this.height_News_aus_deiner_Region, this.title}) : super(key: key);

  @override
  State<VerticalListCover> createState() => _VerticalListCoverState();
}

class _VerticalListCoverState extends State<VerticalListCover> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin<VerticalListCover> {
  late AnimationController? _spinKitController;
  double scrollPosition = 0.0;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _spinKitController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    // widget.scrollController.

    // BlocProvider.of<searchBloc.SearchBloc>(context).add(searchBloc.Initialize(context));
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
    // _networklHasErrorNotifier.forEach((element) {
    //   element.dispose();
    // });

    _spinKitController?.dispose();
    // widget.scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    bool tablet = isTablet(context);
    Size size = MediaQuery.of(context).size;
    return SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: tablet ? 5 : 2, // Number of items in a row
          mainAxisSpacing: 15.0,
          crossAxisSpacing: 15.0,
          childAspectRatio: widget.items.runtimeType == AudioBooksForLocationGetAllActive ? 0.8 : 0.65, // Ratio of item width to item height
        ),

        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
//             double itemWidth = (MediaQuery.of(context).size.width / 2);
//             itemWidth -= (15.0 / 2); // Adjust for the cross axis spacing.
//             double itemHeight = itemWidth * 0.7; // Calculate item height from aspect ratio.
//             double totalItemHeight = itemHeight * 2 + 45.0; // Account for the entire main axis spacing, not half.
//             double baseParallaxAmount = 0.05; // Adjust this for stronger/weaker parallax.
//
// // Calculate the row of the item.
// // For a 2-column grid, items with index 0 and 1 are on the first row, 2 and 3 are on the second row, and so on.
//             int row = index ~/ 2; // Integer division gives us the row.
//
// // Calculate the start position of the item based on its row.
//             double itemStartPosition = row * totalItemHeight;
//
// // Find the difference between the scroll position and item's start position.
//             double relativePosition = scrollPosition - itemStartPosition;
//
// // Determine the parallax offset for the image.
//             double imageOffset = relativePosition * baseParallaxAmount;

            return Column(
              mainAxisSize: MainAxisSize.min,
              // mainAxisAlignment: MainAxisAlignment.end,
              children: [

                Expanded(
                  child: Card(
                      color: Colors.transparent,
                      elevation: 0,
                      // clipBehavior: Clip.hardEdge,
                      // borderOnForeground: true,
                      // margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      // elevation: 0,
                      // semanticContainer: false,

                      ///maybe 0?
                      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () => {
                          // To open Reader

                          if (widget.items.response()![index].idMagazineType == "7")
                            {
                              Navigator.of(context).push(
                                CupertinoPageRoute(
                                  builder: (context) =>
                                      // Puzzle()
                                      Puzzle(
                                    title: widget.items.response()![index].title!,
                                    puzzleID: widget.items.response()![index].puzzleIdMobile!,
                                    gameType: widget.items.response()![index].gametypeMobile!,

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
                                    builder: (context) => Reader(magazine: widget.items.response()![index], heroTag: "toptitle${index}")
                                    //     StartReader(
                                    //   magazine: widget.items.response![index],
                                    //   heroTag: "toptitle${index}",
                                    //
                                    //   // noofpages: 5,
                                    // ),
                                    ),
                              )
                            }
                        },
                        child: Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.center,
                          children: [
                            CustomCachedNetworkImage(
                              mag: widget.items.response()![index],
                              pageNo: 0,
                              thumbnail: true,
                              // covers: widget.items,
                              heroTag: "toptitle${index}",
                              spinKitController: _spinKitController,
                              height_News_aus_deiner_Region: widget.height_News_aus_deiner_Region,
                            ),
                          ],
                        ),
                      )),
                ),
                widget.items.runtimeType != AudioBooksForLocationGetAllActive
                    ? AbsorbPointer(
                        absorbing: true,
                        child: MarqueeWidget(
                          child: Text(
                            widget.items.response()![index].title!,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    : Text(
                        // state.magazinePublishedGetLastWithLimit.response![i + 1].name!,
                        widget.items.response()![index].title!,
maxLines: 2,
                        textAlign: TextAlign.center,
                      ),
                widget.items.response()![index].dateOfPublication != null
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: MarqueeWidget(
                              child: Text(
                                // state.magazinePublishedGetLastWithLimit.response![i + 1].name!,
                                ((widget.items.runtimeType == EbooksForLocationGetAllActive ||
                                            widget.items.runtimeType == AudioBooksForLocationGetAllActive)
                                        ? DateFormat("yyyy")
                                        : DateFormat("d. MMMM yyyy"))
                                    .format(DateTime.parse(widget.items.response()![index].dateOfPublication!)),
                                // " asd",
                                // "Card ${i + 1}",
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyMedium!.copyWith(height: 0.8, color: Colors.grey, fontWeight: FontWeight.w300),

                                // style: TextStyle(
                                //   fontSize: 14,
                                //   color: Colors.grey,
                                //   backgroundColor: Colors.transparent,
                                // ),
                              ),
                            ),
                          ),
                          widget.items.runtimeType != MagazinePublishedGetAllLastByHotspotId
                              ? Padding(
                                  padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                                  child: Container(
                                    width: 1, // Adjust the width as needed
                                    height: 12, // Adjust the height as needed
                                    color: Colors.white,
                                  ),
                                )
                              : Container(),
                          widget.items.runtimeType != MagazinePublishedGetAllLastByHotspotId
                              ? Align(
                                  alignment: Alignment.centerRight,
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    child: AbsorbPointer(
                                      absorbing: true,
                                      child: MarqueeWidget(
                                        direction: Axis.vertical,
                                        child: Text(
                                          // state.magazinePublishedGetLastWithLimit.response![i + 1].name!,
                                          // ((widget.cover.runtimeType == EbooksForLocationGetAllActive ||widget.cover.runtimeType == AudioBooksForLocationGetAllActive)? DateFormat("yyyy"): DateFormat("d. MMMM yyyy")).format(DateTime.parse(widget.cover.response()![i].dateOfPublication!)),
                                          (widget.items.runtimeType == EbooksForLocationGetAllActive
                                                  ? widget.items.response()![index].ebookLanguage!
                                                  : widget.items.response()![index].audiobookLanguage)
                                              .toString()
                                              .toUpperCase(),
                                          // " asd",
                                          // "Card ${i + 1}",
                                          textAlign: TextAlign.left,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(height: 0.8, color: Colors.white, fontWeight: FontWeight.w300),
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
            );
          },
          childCount: widget.items.response()?.length,
          // addAutomaticKeepAlives: true // Number of grid items,
        ));
  }
}