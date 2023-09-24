import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:sharemagazines_flutter/src/blocs/navbar/navbar_bloc.dart';

import '../pages/reader/readerpage.dart';
import 'marquee.dart';

class News_aus_deiner_Region extends StatefulWidget {
  final NavbarState state;

  News_aus_deiner_Region({Key? key, required this.state}) : super(key: key);

  @override
  State<News_aus_deiner_Region> createState() => News_aus_deiner_RegionState();
}

class News_aus_deiner_RegionState extends State<News_aus_deiner_Region> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin<News_aus_deiner_Region>{
  int index1 = 0;
  static late List<ValueNotifier<int>> _networklHasErrorNotifier;
  late AnimationController? _spinKitController;

  @override
  bool get wantKeepAlive => true;

  void initState() {
    _networklHasErrorNotifier = List.filled( NavbarState.magazinePublishedGetTopLastByRange!.response!.length, ValueNotifier(0), growable: true);
    super.initState();
    _spinKitController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      // height: MediaQuery.of(context).size.width + 60, // card height
      height: size.aspectRatio * 1000,
      // height: double.infinity,
      // width: 30,
      child: PageView.builder(
        itemCount: NavbarState.magazinePublishedGetTopLastByRange!.response!.length,
        // padEnds: true,

        controller: PageController(viewportFraction: 0.807),
        onPageChanged: (int index) => setState(() => index1 = index),
        itemBuilder: (_, i) {
          return Transform.scale(
              scale: i == index1 ? 1 : 0.85,
              alignment: Alignment.bottomCenter,

              // alignment: AlignmentGeometry(),
              // child: Card(
              //   shadowColor: Colors.black,
              //   elevation: 6,
              //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
              //   child: Center(
              //     child: Text(
              //       // state.magazinePublishedGetLastWithLimit.response!
              //       "Card ${i + 1}",
              //       style: TextStyle(fontSize: 32),
              //     ),
              //   ),
              // ),
              child: ColumnSuper(
                innerDistance: 10, //-60 for circular card
                // outerDistance: -50,
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () => {
                      Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (context) => StartReader(
                            magazine: NavbarState.magazinePublishedGetTopLastByRange!.response![i],

                            heroTag: 'News_aus_deiner_Region_$i',

                            // noofpages: 5,
                          ),
                        ),
                      )
                    },
                    child: Stack(
                      // clipBehavior: Clip.antiAlias,
                      children: [
                        CachedNetworkImage(
                            key: ValueKey(_networklHasErrorNotifier[i].value),
                            imageUrl: NavbarState.magazinePublishedGetTopLastByRange!.response![i].idMagazinePublication! +
                                "_" +
                                NavbarState.magazinePublishedGetTopLastByRange!.response![i].dateOfPublication! +
                                "_0",
                            imageBuilder: (context, imageProvider) => Hero(
                                  tag: "News_aus_deiner_Region_$i",
                                  child: Container(
                                    height: size.aspectRatio * 900,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(image: imageProvider, fit: BoxFit.fill),
                                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                    ),
                                  ),
                                ),
                            // useOldImageOnUrlChange: true,
                            // very important: keep both placeholder and errorWidget
                            placeholder: (context, url) => Container(
                                  // color: Colors.grey.withOpacity(0.1),
                                  height: size.aspectRatio * 700,
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
                              Future.delayed(const Duration(milliseconds: 500), () {
                                setState(() {
                                  _networklHasErrorNotifier[i].value++;
                                });
                              });
                              return Container(
                                height: size.aspectRatio * 700,
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
                                      NavbarState.magazinePublishedGetTopLastByRange!.response![i].name!
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
                                      DateFormat("d. MMMM yyyy")
                                          .format(DateTime.parse(NavbarState.magazinePublishedGetTopLastByRange!.response![i].dateOfPublication!)),
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
              ));
        },
      ),
    );
    // return Container();
  }
}