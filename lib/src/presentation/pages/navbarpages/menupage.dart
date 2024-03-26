import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sharemagazines/src/models/audioBooksForLocationGetAllActive.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

import '../../../blocs/navbar/navbar_bloc.dart';
import '../../../models/ebooksForLocationGetAllActive.dart';
import '../../../models/location_model.dart';
import '../../../models/magazinePublishedGetAllLastByHotspotId_model.dart';
import '../../widgets/src/covershorizontallist.dart';


class MenuPage extends StatefulWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> with AutomaticKeepAliveClientMixin<MenuPage> {
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  ScrollController _scrollController = ScrollController();

  @override
  bool get wantKeepAlive => true;

  void _onRefresh(LocationData currentLocation) async {
    // monitor network fetch
    await BlocProvider.of<NavbarBloc>(context).checkLocation(currentLocation);
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Size size = MediaQuery.of(context).size;
    return BlocBuilder<NavbarBloc, NavbarState>(builder: (BuildContext context, state) {
      return SafeArea(
        child: ValueListenableBuilder<CategoryStatus>(
            valueListenable: NavbarState.categoryStatus,
            builder: (context, categoryStatus, child) {
              _scrollController.animateTo(1.0, duration: Duration(milliseconds: 250), curve: Curves.easeInOut);
              int lastItem = (categoryStatus == CategoryStatus.presse
                  ? NavbarState.magazineCategoryGetAllActive?.response!.length
                  : categoryStatus == CategoryStatus.ebooks
                  ? NavbarState.ebookCategoryGetAllActiveByLocale.response!.length
                  : categoryStatus == CategoryStatus.hoerbuecher
                  ? NavbarState.audioBooksCategoryGetAllActiveByLocale.response!.length
                  : 0)!;
              return SmartRefresher(
                  enablePullDown: true,
                  header: ClassicHeader(
                    // Customize your header's appearance here
                    refreshingIcon: CircularProgressIndicator(
                      strokeWidth: 2.0,
                      color: Colors.grey,
                    ),
                    completeIcon: Icon(Icons.done, color: Colors.grey),
                    idleIcon: Icon(Icons.arrow_downward, color: Colors.grey),
                    releaseIcon: Icon(Icons.refresh, color: Colors.grey),

                    idleText: 'Pull down to refresh',
                    refreshingText: 'Loading...',
                    completeText: 'Refresh Completed',
                    failedText: 'Refresh Failed',
                    textStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.grey),
                    refreshStyle: RefreshStyle.Follow,

                    // Add a BoxDecoration to give a grey background
                    // decoration: BoxDecoration(
                    //   color: Colors.grey[300], // Choose the shade of grey you want
                    // ),
                  ),
                  controller: _refreshController,
                  onRefresh: () => _onRefresh(state.appbarlocation),
                  child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      controller: _scrollController,
                      itemCount: lastItem,
                      // itemCount: categoryStatus == CategoryStatus.presse
                      //     ? (NavbarState.magazineCategoryGetAllActive?.response!.length)
                      //     : categoryStatus == CategoryStatus.ebooks
                      //         ? NavbarState.ebookCategoryGetAllActiveByLocale?.response!.length
                      //         : categoryStatus == CategoryStatus.hoerbuecher
                      //             ? NavbarState.audioBooksCategoryGetAllActiveByLocale?.response!.length
                      //             : 0,
                      itemBuilder: (context, i) {
                        MagazinePublishedGetAllLastByHotspotId magazines = MagazinePublishedGetAllLastByHotspotId(response: []);
                        MagazinePublishedGetAllLastByHotspotId bookmarks;

                        EbooksForLocationGetAllActive ebooks = EbooksForLocationGetAllActive(response: []);
                        AudioBooksForLocationGetAllActive audioBooks = AudioBooksForLocationGetAllActive(response: []);

                        var cover;

                        if (categoryStatus == CategoryStatus.presse)
                          cover = MagazinePublishedGetAllLastByHotspotId(
                              response: NavbarState.magazinePublishedGetLastWithLimit
                                  .response()!
                                  .where((element) =>
                              element.idsMagazineCategory?.contains(NavbarState.magazineCategoryGetAllActive!.response![i].id!) == true)
                                  .toList()
                                ..shuffle()); // Shuffle the list

                        if (categoryStatus == CategoryStatus.ebooks)
                          cover = EbooksForLocationGetAllActive(
                              response: NavbarState.ebooks
                                  .response()!
                                  .where((element) =>
                              element.idsEbookCategory?.contains(NavbarState.ebookCategoryGetAllActiveByLocale.response![i].id!) == true)
                              // .toSet()
                                  .toList()..shuffle());
                        if (categoryStatus == CategoryStatus.hoerbuecher)
                          cover = AudioBooksForLocationGetAllActive(
                              response: NavbarState.audiobooks.response()!
                                  .where((element) =>
                              element.idsAudiobookCategory?.contains(NavbarState.audioBooksCategoryGetAllActiveByLocale.response![i].id!) ==
                                  true)
                              // .toSet()
                                  .toList()..shuffle());
                        // int lastItem = (categoryStatus == CategoryStatus.presse
                        //     ? NavbarState.magazineCategoryGetAllActive?.response!.length
                        //     : categoryStatus == CategoryStatus.ebooks
                        //         ? NavbarState.ebookCategoryGetAllActiveByLocale?.response!.length
                        //         : categoryStatus == CategoryStatus.hoerbuecher
                        //             ? NavbarState.audioBooksCategoryGetAllActiveByLocale?.response!.length
                        //             : 0)!;
                        return ValueListenableBuilder<MagazinePublishedGetAllLastByHotspotId>(
                            valueListenable: NavbarState.bookmarks,
                            builder: (context, valueBookmark, child) {
                              if (valueBookmark.response()!.isNotEmpty && i == 0) {
                                bookmarks = valueBookmark;
                              } else {
                                bookmarks = MagazinePublishedGetAllLastByHotspotId(response: []);
                              }
                            return StickyHeader(
                              overlapHeaders: false,

                              header:cover.response()!.length !=0? Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.grey.withOpacity(0.01), // Less opacity at the top
                                      Colors.grey.withOpacity(0.1), // More opacity in the center
                                      Colors.grey.withOpacity(0.01), // Less opacity at the bottom
                                    ],
                                  ),
                                ),
                                child:  Column(
                                  children: [
                                    if(valueBookmark.response()!.isNotEmpty && i == 0)
                                    Align(
                                      alignment: Alignment.center,
                                      child: Padding(
                                        // padding: EdgeInsets.fromLTRB(25, NavbarState.getTopMagazines!.length != 0 ? 60 : 20, 25, 20),
                                        padding: EdgeInsets.fromLTRB(0, size.aspectRatio * 40, 0, size.aspectRatio * 20),

                                        child: Text(
                                          // 'Meistgelesene Artikel',
                                          //   element.idsMagazineCategory!,
                                          "Bookmarks",
                                          style: Theme.of(context).textTheme.bodyLarge,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.center,
                                      child: Padding(
                                        padding: EdgeInsets.fromLTRB(0, size.aspectRatio * 40, 0, size.aspectRatio * 20),
                                        child: Text(
                                          // 'Meistgelesene Artikel',
                                          //   element.idsMagazineCategory!,
                                          categoryStatus == CategoryStatus.ebooks
                                              ? NavbarState.ebookCategoryGetAllActiveByLocale.response![i].name!
                                              : categoryStatus == CategoryStatus.hoerbuecher
                                              ? NavbarState.audioBooksCategoryGetAllActiveByLocale.response![i].name!
                                              : NavbarState.magazineCategoryGetAllActive!.response![i].name!,
                                          style: Theme.of(context).textTheme.bodyLarge,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ):Container(
                                // height: 100,
                                // color: Colors.red,
                                // width: 100,
                              ),
                              // header: Container(
                              //   height: 50.0,
                              //   color: Colors.blueGrey[700],
                              //   padding: EdgeInsets.symmetric(horizontal: 16.0),
                              //   alignment: Alignment.centerLeft,
                              //   child:  Text(
                              //     // 'Meistgelesene Artikel',
                              //     //   element.idsMagazineCategory!,
                              //     categoryStatus == CategoryStatus.ebooks
                              //         ? NavbarState.ebookCategoryGetAllActiveByLocale.response![i].name!
                              //         : categoryStatus == CategoryStatus.hoerbuecher
                              //         ? NavbarState.audioBooksCategoryGetAllActiveByLocale.response![i].name!
                              //         : NavbarState.magazineCategoryGetAllActive!.response![i].name!,
                              //     style: Theme.of(context).textTheme.bodyLarge,
                              //     textAlign: TextAlign.center,
                              //   ),
                              // ),
                              content: Column(
                                    // crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: <Widget>[

                                      if (valueBookmark.response()!.isNotEmpty && i == 0)
                                        ListMagazineCover(
                                          cover: bookmarks,
                                          heroTag: 'menu_bookmarks',
                                          scrollDirection: Axis.horizontal,
                                          isSearchResults: false,
                                        ),
                                      // cover.response()!.length !=0? Align(
                                      //   alignment: Alignment.center,
                                      //   child: Padding(
                                      //     // padding: EdgeInsets.fromLTRB(25, NavbarState.getTopMagazines!.length != 0 ? 60 : 20, 25, 20),
                                      //     padding: EdgeInsets.fromLTRB(0, size.aspectRatio * 40, 0, size.aspectRatio * 20),
                                      //
                                      //     child: Text(
                                      //       // 'Meistgelesene Artikel',
                                      //       //   element.idsMagazineCategory!,
                                      //       categoryStatus == CategoryStatus.ebooks
                                      //           ? NavbarState.ebookCategoryGetAllActiveByLocale.response![i].name!
                                      //           : categoryStatus == CategoryStatus.hoerbuecher
                                      //           ? NavbarState.audioBooksCategoryGetAllActiveByLocale.response![i].name!
                                      //           : NavbarState.magazineCategoryGetAllActive!.response![i].name!,
                                      //       style: Theme.of(context).textTheme.bodyLarge,
                                      //       textAlign: TextAlign.center,
                                      //     ),
                                      //   ),
                                      // ):Container(
                                      //   // height: 100,
                                      //   // color: Colors.red,
                                      //   // width: 100,
                                      // ),
                                      cover.response()!.length !=0?ListMagazineCover(
                                        // cover: categoryStatus == CategoryStatus.ebooks
                                        //     ? ebooks
                                        //     : categoryStatus == CategoryStatus.hoerbuecher
                                        //         ? audioBooks
                                        //         : magazines,
                                        cover: cover,
                                        heroTag: 'menu_$i',
                                        scrollDirection: Axis.horizontal,
                                        isSearchResults: false,
                                      ):Container(
                                        // height: 100,
                                        // color: Colors.red,
                                        // width: 100,
                                      ),
                                      if (i == lastItem - 1)
                                        Container(
                                          height: size.height * 0.2,
                                          color: Colors.transparent,
                                        )

                                      //Add as padding
                                    ],
                                  )

                            );
                          }
                        );
                        // return ValueListenableBuilder<MagazinePublishedGetAllLastByHotspotId>(
                        //   valueListenable: NavbarState.bookmarks,
                        //   builder: (context, valueBookmark, child) {
                        //     if (valueBookmark.response()!.isNotEmpty && i == 0) {
                        //       bookmarks = valueBookmark;
                        //     } else {
                        //       bookmarks = MagazinePublishedGetAllLastByHotspotId(response: []);
                        //     }
                        //     return Column(
                        //       // crossAxisAlignment: CrossAxisAlignment.stretch,
                        //       children: <Widget>[
                        //         if (valueBookmark.response()!.isNotEmpty && i == 0)
                        //           Align(
                        //             alignment: Alignment.center,
                        //             child: Padding(
                        //               // padding: EdgeInsets.fromLTRB(25, NavbarState.getTopMagazines!.length != 0 ? 60 : 20, 25, 20),
                        //               padding: EdgeInsets.fromLTRB(0, size.aspectRatio * 40, 0, size.aspectRatio * 20),
                        //
                        //               child: Text(
                        //                 // 'Meistgelesene Artikel',
                        //                 //   element.idsMagazineCategory!,
                        //                 "Bookmarks",
                        //                 style: Theme.of(context).textTheme.bodyLarge,
                        //                 textAlign: TextAlign.center,
                        //               ),
                        //             ),
                        //           ),
                        //         if (valueBookmark.response()!.isNotEmpty && i == 0)
                        //           ListMagazineCover(
                        //             cover: bookmarks,
                        //             heroTag: 'menu_bookmarks',
                        //             scrollDirection: Axis.horizontal,
                        //             isSearchResults: false,
                        //           ),
                        //        cover.response()!.length !=0? Align(
                        //           alignment: Alignment.center,
                        //           child: Padding(
                        //             // padding: EdgeInsets.fromLTRB(25, NavbarState.getTopMagazines!.length != 0 ? 60 : 20, 25, 20),
                        //             padding: EdgeInsets.fromLTRB(0, size.aspectRatio * 40, 0, size.aspectRatio * 20),
                        //
                        //             child: Text(
                        //               // 'Meistgelesene Artikel',
                        //               //   element.idsMagazineCategory!,
                        //               categoryStatus == CategoryStatus.ebooks
                        //                   ? NavbarState.ebookCategoryGetAllActiveByLocale.response![i].name!
                        //                   : categoryStatus == CategoryStatus.hoerbuecher
                        //                       ? NavbarState.audioBooksCategoryGetAllActiveByLocale.response![i].name!
                        //                       : NavbarState.magazineCategoryGetAllActive!.response![i].name!,
                        //               style: Theme.of(context).textTheme.bodyLarge,
                        //               textAlign: TextAlign.center,
                        //             ),
                        //           ),
                        //         ):Container(
                        //          // height: 100,
                        //          // color: Colors.red,
                        //          // width: 100,
                        //        ),
                        //         cover.response()!.length !=0?ListMagazineCover(
                        //           // cover: categoryStatus == CategoryStatus.ebooks
                        //           //     ? ebooks
                        //           //     : categoryStatus == CategoryStatus.hoerbuecher
                        //           //         ? audioBooks
                        //           //         : magazines,
                        //           cover: cover,
                        //           heroTag: 'menu_$i',
                        //           scrollDirection: Axis.horizontal,
                        //           isSearchResults: false,
                        //         ):Container(
                        //           // height: 100,
                        //           // color: Colors.red,
                        //           // width: 100,
                        //         ),
                        //         if (i == lastItem - 1)
                        //           Container(
                        //             height: size.height * 0.2,
                        //             color: Colors.transparent,
                        //           )
                        //
                        //         //Add as padding
                        //       ],
                        //     );
                        //   },
                        // );
                      }));
            }),
      );
    });
  }
}