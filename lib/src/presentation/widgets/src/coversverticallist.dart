

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../models/magazinePublishedGetAllLastByHotspotId_model.dart';
import '../../pages/navbarpages/homepage/homepage.dart';
// import '../../pages/navbarpages/homepage/puzzlepage.dart';
import '../../pages/reader/readerpage.dart';
import '../marquee.dart';
import 'customCover.dart';

class VerticalListCover extends StatefulWidget {
  final MagazinePublishedGetAllLastByHotspotId items;
  final ScrollController scrollController;
  final double height_News_aus_deiner_Region;

  // late List<double> imageOffsets;

  VerticalListCover({Key? key, required this.items, required this.scrollController, required this.height_News_aus_deiner_Region}) : super(key: key);

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

    return SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Number of items in a row
          mainAxisSpacing: 45.0,
          crossAxisSpacing: 15.0,
          childAspectRatio: 0.7, // Ratio of item width to item height
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
                          if(widget.items.response![index].idMagazineType == "7"){
                            // Navigator.of(context).push(
                            //   CupertinoPageRoute(
                            //     builder: (context) => Puzzle(
                            //       puzzleID: widget.items.response![index].puzzleIdMobile!,
                            //       gameType: widget.items.response![index].gametypeMobile!,
                            //
                            //       // noofpages: 5,
                            //     ),
                            //   ),
                            // )
                          }else{
                          Navigator.of(context).push(
                            CupertinoPageRoute(
                              builder: (context) => StartReader(
                                magazine: widget.items.response![index],
                                heroTag: "toptitle${index}",

                                // noofpages: 5,
                              ),
                            ),
                          )}
                        },
                        child: Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.center,
                          children: [
                            CustomCachedNetworkImage(
                              reader: false,
                              mag: widget.items.response![index],
                              pageNo: 0,
                              thumbnail: true,
                              // covers: widget.items,
                              heroTag: "toptitle${index}",
                              spinKitController: _spinKitController,
                              // imageOffset: imageOffset,
                              verticalScroll: true,
                              // upperWidget: this.widget,
                              // scrollController: widget.scrollController,
                              height_News_aus_deiner_Region: widget.height_News_aus_deiner_Region,
                              // size: MediaQuery.of(context).size,
                              // widget: widget, widget: widget, widget: widget, widget: widget, widget: widget, widget: widget
                            ),
                            // Spacer(),
                            widget.items.response![index].dateOfPublication !=null? Positioned(
                              // top: -50,
                              bottom: -35,
                              // height: -50,
                              width: MediaQuery.of(context).size.width / 2 - 20,
                              child: Align(
                                alignment: Alignment.center,
                                child: MarqueeWidget(
                                  child: Text(
                                    // state.magazinePublishedGetLastWithLimit.response![i + 1].name!,
                                    DateFormat("d. MMMM yyyy").format(DateTime.parse(widget.items.response![index].dateOfPublication!)),
                                    // " asd",
                                    // "Card ${i + 1}",
                                    textAlign: TextAlign.center,
                                    style:  Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.grey),
                                    // style: TextStyle(
                                    //   fontSize: 14,
                                    //   color: Colors.grey,
                                    //   backgroundColor: Colors.transparent,
                                    // ),
                                  ),
                                ),
                              ),
                            ):Container(),
                            Positioned(
                              // top: -50,
                              bottom: -20,
                              // height: -50,
                              width: MediaQuery.of(context).size.width / 2 - 20,
                              child: Align(
                                alignment: Alignment.center,
                                child: MarqueeWidget(
                                  // crossAxisAlignment: CrossAxisAlignment.start,
                                  child: Text(
                                    // state.magazinePublishedGetLastWithLimit.response![i + 1].name!,
                                    widget.items.response![index].name!,
                                    // " asd",
                                    // "Card ${i + 1}",
                                    textAlign: TextAlign.center,
                                    style:  Theme.of(context).textTheme.bodyMedium,
                                    // style: TextStyle(
                                    //   fontSize: 14,
                                    //   color: Colors.white,
                                    //   backgroundColor: Colors.transparent,
                                    // ),
                                  ),
                                ),
                              ),
                            ),

                            // return GestureDetector(
                            //   behavior: HitTestBehavior.translucent,
                            //   onTap: () => {
                            //     // Navigator.push(
                            //     //     context,
                            //     //     new ReaderRoute(
                            //     //         widget: StartReader(
                            //     //       id: state
                            //     //           .magazinePublishedGetLastWithLimit
                            //     //           .response![i + 1]
                            //     //           .idMagazinePublication!,
                            //     //       tagindex: i,
                            //     //       cover: state.bytes[i],
                            //     //     ))),
                            //     // print('Asf'),
                            //     Navigator.push(
                            //       context,
                            //       PageRouteBuilder(
                            //         // transitionDuration:
                            //         // Duration(seconds: 2),
                            //         pageBuilder: (_, __, ___) => StartReader(
                            //           id: state.magazinePublishedGetLastWithLimit.response![i + 1].idMagazinePublication!,
                            //
                            //           index: i.toString(),
                            //           cover: state.bytes![i],
                            //           noofpages: state.magazinePublishedGetLastWithLimit.response![i + 1].pageMax!,
                            //           readerTitle: state.magazinePublishedGetLastWithLimit.response![i + 1].name!,
                            //
                            //           // noofpages: 5,
                            //         ),
                            //       ),
                            //     )
                            //     // Navigator.push(context,
                            //     //     MaterialPageRoute(
                            //     //         builder: (context) {
                            //     //   return StartReader(
                            //     //     id: state
                            //     //         .magazinePublishedGetLastWithLimit
                            //     //         .response![i + 1]
                            //     //         .idMagazinePublication!,
                            //     //     index: i,
                            //     //   );
                            //     // }))
                            //   },
                            //   child: Image.memory(
                            //       // state.bytes![i],
                            //       snapshot.data!
                            //       // fit: BoxFit.fill,
                            //       // frameBuilder: ((context, child, frame, wasSynchronouslyLoaded) {
                            //       //   if (wasSynchronouslyLoaded) return child;
                            //       //   return AnimatedSwitcher(
                            //       //     duration: const Duration(milliseconds: 200),
                            //       //     child: frame != null
                            //       //         ? child
                            //       //         : SizedBox(
                            //       //             height: 60,
                            //       //             width: 60,
                            //       //             child: CircularProgressIndicator(strokeWidth: 6),
                            //       //           ),
                            //       //   );
                            //       // }),
                            //       ),
                            // );

                            // Align(
                            //   alignment: Alignment.bottomCenter,
                            //   child: Text(
                            //     state.magazinePublishedGetLastWithLimit.response![i + 1].name!,
                            //     // " asd",
                            //     // "Card ${i + 1}",
                            //     textAlign: TextAlign.center,
                            //
                            //     style: TextStyle(fontSize: 32, color: Colors.white, backgroundColor: Colors.transparent),
                            //   ),
                            // ),
                          ],
                        ),
                      )),
                ),
              ],
            );
          },
          childCount: widget.items.response?.length,
          // addAutomaticKeepAlives: true // Number of grid items,
        ));
  }
}