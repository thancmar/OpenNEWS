import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sharemagazines/src/presentation/pages/navbarpages/homepage/categoriepage.dart';
import 'package:sharemagazines/src/presentation/pages/navbarpages/homepage/homepage.dart';

import '../../../../blocs/navbar/navbar_bloc.dart';
import '../../../../blocs/searchpage/search_bloc.dart';
import '../../../widgets/marquee.dart';
import '../../../widgets/src/coversverticallist.dart';
import '../../reader/readerpage.dart';
import 'languagepage.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with
        SingleTickerProviderStateMixin
// ,TickerProviderStateMixin
        ,
        AutomaticKeepAliveClientMixin<SearchPage> {
  TextEditingController _searchController = TextEditingController();
  static late PageController controller = PageController(viewportFraction: 0.30, keepPage: true);

  @override
  bool get wantKeepAlive => true;

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  void initState() {
    super.initState();
    BlocProvider.of<SearchBloc>(context).add(OpenSearch());
  }

  @override
  void dispose() {
    _searchController.dispose();
    // controller.dispose();
    // WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Size size = MediaQuery.of(context).size;

    return Stack(
      children: [
        Positioned.fill(
            // child: Hero(tag: 'bg',
            child: Image.asset("assets/images/background/Background.png", fit: BoxFit.cover)
            // ),
            ),
        BlocBuilder<SearchBloc, SearchState>(builder: (context, state) {
          // print("SearchState is ${BlocProvider.of<SearchState>(context).state}");
          print(BlocProvider.of<NavbarBloc>(context).state);
          // print("rebuild $state");
          // print("search bloc state $state");
          return Scaffold(
            // extendBodyBehindAppBar: true,
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              // automaticallyImplyLeading: false,
              toolbarHeight: size.height * 0.12,
              titleSpacing: size.width * 0.02,
              leading: Container(
                // width: 35,
                color: Colors.transparent,
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(30, 0, 00, 0),
                    //Hero for langauge page
                    child: Hero(
                      tag: "backbutton",
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                        size: size.width * 0.1,
                      ),
                    ),
                  ),
                ),
              ),
              title: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      // padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      // height: MediaQuery.of(context).size.height,
                      // width: MediaQuery.of(context).size.width * 0.2,
                      color: Colors.transparent,

                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: TextFormField(
                          style: TextStyle(fontSize: 18, color: Colors.white.withOpacity(0.5)),
                          controller: _searchController,
                          cursorColor: Colors.white,
                          onChanged: (text) {
                            // Handle the search logic here
                            handleSearchClick(_searchController.text, state, false, false);
                            // FocusManager.instance.primaryFocus?.unfocus();
                          },
                          onTap: () {
                            if (_searchController.selection == TextSelection.fromPosition(TextPosition(offset: _searchController.text.length - 1))) {
                              setState(() {
                                _searchController.selection = TextSelection.fromPosition(TextPosition(offset: _searchController.text.length));
                              });
                            }
                          },

                          onFieldSubmitted: (text) {
                            print("field submitted");
                            handleSearchClick(text, state, false,true);
                          },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey.withOpacity(0.2),
                            labelStyle:  Theme.of(context).textTheme.titleLarge,
                            floatingLabelStyle:  Theme.of(context).textTheme.bodyLarge,
                            labelText: "Suchen",

                            border: OutlineInputBorder(
                                borderSide: BorderSide(width: 0.10, color: Colors.white), borderRadius: BorderRadius.all(Radius.circular(15.0))),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white, width: 0.2),
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            ),
                            // disabledBorder: const OutlineInputBorder(
                            //   borderSide: const BorderSide(color: Colors.grey, width: 0.2),
                            //   borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            // ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.blue, width: 0.4),
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              // ),
              actions: [
                InkWell(
                  onTap: () => {
                    // print(_searchController.text), showSearchResults = true
                    // if (state is GoToSearchPage)
                    //   {
                    //     BlocProvider.of<SearchBloc>(context).add(OpenSearchResults()),
                    //   }
                    // else if (state is GoToSearchResults)
                    //   {
                    //     BlocProvider.of<SearchBloc>(context).add(OpenSearch()),
                    //   }
                    handleSearchClick(_searchController.text, state, state is GoToSearchResults ? true : false, false),
                    FocusManager.instance.primaryFocus?.unfocus()
                  },
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child: Hero(
                      tag: "search button",

                      child: Icon(
                        state is GoToSearchResults ? Icons.close_rounded : Icons.search,
                        color: Colors.white,
                        size: size.width * 0.1,
                      ),
                      // child: ImageIcon(
                      //   AssetImage(
                      //     "assets/images/search_button.png",
                      //   ),
                      //   // color: Colors.blue,
                      //
                      //   size: 50,
                      // )
                    ),
                  ),
                  // child: Image.asset("assets/images/search_button.png")),
                ),
              ],
              // flexibleSpace: SafeArea(
              //     child: Container(
              //   color: Colors.red,
              // )),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: state is GoToSearchResults
                    ? <Widget>[SearchResults(context, state,  MediaQuery.of(context).size.height * 0.12)]
                    : state is SearchError
                        ? <Widget>[
                            Container(
                              child: Text(state.error,
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                  )),
                            )
                          ]
                        : <Widget>[
                            Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(30, 10, 30, 20),
                                child: Text(
                                  'Kategorien',
                                  style:Theme.of(context).textTheme.headlineSmall,
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ),
                            CategoryImages(controller: controller),
                            SearchState.oldSearchResults.isEmpty == false
                                ? Column(
                                    children: [
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Padding(
                                          padding: EdgeInsets.fromLTRB(30, 20, 30, 20),
                                          child: Text(
                                            'Letzte Suchanfragen',
                                            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.right,
                                          ),
                                        ),
                                      ),
                                      // for (var i = 0; i < SearchState.oldSearchResults.length; i++)
                                      // if (SearchState.oldSearchResults?.length != 0)
                                      for (var i = SearchState.oldSearchResults!.length - 1;
                                          i >= max(0, SearchState.oldSearchResults!.length! - 5);
                                          i--)
                                        Container(
                                          child: Padding(
                                            padding: EdgeInsets.fromLTRB(30, 0, 30, 5),
                                            child: Row(
                                              children: <Widget>[
                                                Icon(
                                                  Icons.access_time_sharp,
                                                  color: Colors.white,
                                                  size: 30,
                                                ),
                                                Expanded(
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      // Navigator.pop(context);
                                                      handleSearchClick(SearchState.oldSearchResults?[i], state, false,false);
                                                      _searchController.text = SearchState.oldSearchResults?[i];
                                                    },
                                                    child: Container(
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(left: 10),
                                                        child: Text(
                                                          // 'hamburg',
                                                          // state.searchResults!.isNotEmpty ? state.searchResults![i] : "",
                                                          SearchState.oldSearchResults?[i],
                                                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w200),
                                                          textAlign: TextAlign.left,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                // SearchResult(
                                                //   index: i,
                                                // )
                                                InkWell(
                                                  onTap: () {
                                                    // state.searchResults?.removeAt(i);
                                                    BlocProvider.of<SearchBloc>(context).add(DeleteSearchResult(i));
                                                    setState(() {});
                                                  },
                                                  child: Align(
                                                    alignment: Alignment.centerRight,
                                                    child: Container(
                                                      child: Padding(
                                                          padding: const EdgeInsets.only(left: 0),
                                                          child: Icon(
                                                            Icons.close_outlined,
                                                            color: Colors.white,
                                                            // size: 30,
                                                          )),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                    ],
                                  )
                                : Container(),
                            // if (SearchState.oldSearchResults?.length != 0) {Container()},

                            Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(30, 20, 30, 20),
                                child: Text(
                                  'Choose a language',
                                  // style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                                  style: Theme.of(context).textTheme.headlineSmall,
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ),
                            SingleChildScrollView(
                              padding: EdgeInsets.fromLTRB(10, 0, 30, 0),
                              physics: RangeMaintainingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(20, 0, 10, 5),
                                    child: Container(
                                      // width: MediaQuery.of(context).size.width * 0.40,
                                      height: MediaQuery.of(context).size.width * 0.1,

                                      child: FloatingActionButton.extended(
                                        // heroTag: 'location_offers',
                                        key: UniqueKey(),
                                        heroTag: 'All(${NavbarState.magazinePublishedGetLastWithLimit!.response!.length})',
                                        splashColor: Colors.white,
                                        elevation: 1,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(8)), side: BorderSide(color: Colors.white, width: 0.2)),

                                        label: Text(
                                          'All(${NavbarState.magazinePublishedGetLastWithLimit!.response!.length})',
                                          // 'All($counterALL)',
                                          // BlocProvider.of<NavbarBloc>(context).state.magazinePublishedGetLastWithLimit!.response!.length.toString(),
                                          style:Theme.of(context).textTheme.titleSmall,
                                        ),
                                        // <-- Text
                                        backgroundColor: Colors.grey.withOpacity(0.1),
                                        // icon: Icon(
                                        //   // <-- Icon
                                        //   Icons.menu_book,
                                        //   size: 16.0,
                                        // ),
                                        onPressed: () {
                                          print("!breakpoint");
                                          // BlocProvider.of<SearchBloc>(context).add(OpenLanguageResults(context, "all"));
                                          // BlocProvider.of<SearchBloc>(context).add(OpenLanguageResults(context, "all"));
                                          Navigator.of(context).push(
                                            CupertinoPageRoute(
                                              builder: (context) => LanguagePage(
                                                titleText: 'All(${NavbarState.magazinePublishedGetLastWithLimit!.response!.length})',
                                                language: "all",
                                              ),
                                            ),
                                          );
                                          // Navigator.of(context).push(
                                          //   PageRouteBuilder(
                                          //     // transitionDuration:
                                          //     // Duration(seconds: 2),
                                          //
                                          //     pageBuilder: (_, __, ___) {
                                          //       // return StartSearch();
                                          //
                                          //       return LanguagePage(
                                          //         titleText: 'All(${NavbarState.magazinePublishedGetLastWithLimit!.response!.length})',
                                          //         language: "all",
                                          //       );
                                          //     },
                                          //   ),
                                          // );
                                        },
                                        // extendedPadding: EdgeInsets.all(50),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 0, 10, 5),
                                    child: Container(
                                      // width: MediaQuery.of(context).size.width * 0.40,
                                      height: MediaQuery.of(context).size.width * 0.1,
                                      child: FloatingActionButton.extended(
                                        // heroTag: 'location_offers',
                                        key: UniqueKey(),
                                        heroTag: 'German(${NavbarState.counterDE})',
                                        elevation: 1,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(8)), side: BorderSide(color: Colors.white, width: 0.2)),

                                        label: Text(
                                          'German(${NavbarState.counterDE})',
                                          style:Theme.of(context).textTheme.titleSmall,
                                        ),
                                        // <-- Text
                                        backgroundColor: Colors.grey.withOpacity(0.1),
                                        // icon: Icon(
                                        //   // <-- Icon
                                        //   Icons.account_box,
                                        //   size: 16.0,
                                        // ),
                                        onPressed: () {
                                          // BlocProvider.of<SearchBloc>(context).add(OpenLanguageResults(context, "all"));
                                          Navigator.of(context).push(
                                            CupertinoPageRoute(
                                              builder: (context) => LanguagePage(
                                                titleText: 'German(${NavbarState.counterDE})',
                                                language: "de",
                                              ),
                                            ),
                                          );
                                          // Navigator.of(context).push(
                                          //   PageRouteBuilder(
                                          //     // transitionDuration:
                                          //     // Duration(seconds: 2),
                                          //
                                          //     pageBuilder: (_, __, ___) {
                                          //       // return StartSearch();
                                          //
                                          //       return LanguagePage(
                                          //         titleText: 'German(${NavbarState.counterDE})',
                                          //         language: "de",
                                          //       );
                                          //     },
                                          //     // maintainState: true,
                                          //
                                          //     // transitionDuration: Duration(milliseconds: 1000),
                                          //     // transitionsBuilder: (context, animation, anotherAnimation, child) {
                                          //     //   // animation = CurvedAnimation(curve: curveList[index], parent: animation);
                                          //     //   return ScaleTransition(
                                          //     //     scale: animation,
                                          //     //     alignment: Alignment.topRight,
                                          //     //     child: child,
                                          //     //   );
                                          //     // }
                                          //   ),
                                          // );
                                          // BlocProvider.of<SearchBloc>(context).add(OpenLanguageResults(context, "de"));
                                        },
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 0, 10, 5),
                                    child: Container(
                                      // width: MediaQuery.of(context).size.width * 0.40,
                                      height: MediaQuery.of(context).size.width * 0.1,
                                      child: FloatingActionButton.extended(
                                        // heroTag: 'location_offers',
                                        key: UniqueKey(),
                                        heroTag: 'English(${NavbarState.counterEN})',
                                        elevation: 1,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(8)), side: BorderSide(color: Colors.white, width: 0.2)),
                                        label: Text(
                                          'English(${NavbarState.counterEN})',
                                          style:Theme.of(context).textTheme.titleSmall,
                                        ),
                                        // <-- Text
                                        backgroundColor: Colors.grey.withOpacity(0.1),
                                        // icon: Icon(
                                        //   // <-- Icon
                                        //   Icons.coffee,
                                        //   size: 16.0,
                                        // ),
                                        onPressed: () {
                                          Navigator.of(context).push(
                                            CupertinoPageRoute(
                                              builder: (context) => LanguagePage(
                                                titleText: 'English(${NavbarState.counterEN})',
                                                language: "en",
                                              ),
                                            ),
                                          );
                                          // Navigator.of(context).push(
                                          //   PageRouteBuilder(
                                          //     // transitionDuration:
                                          //     // Duration(seconds: 2),
                                          //
                                          //     pageBuilder: (_, __, ___) {
                                          //       // return StartSearch();
                                          //
                                          //       return LanguagePage(
                                          //         titleText: 'English(${NavbarState.counterEN})',
                                          //         language: "en",
                                          //       );
                                          //     },
                                          //   ),
                                          // );
                                          // BlocProvider.of<SearchBloc>(context).add(OpenLanguageResults(context, "en"));
                                        },
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 0, 10, 5),
                                    child: Container(
                                      // width: MediaQuery.of(context).size.width * 0.40,
                                      height: MediaQuery.of(context).size.width * 0.1,
                                      child: FloatingActionButton.extended(
                                        // heroTag: 'location_offers',
                                        key: UniqueKey(),
                                        heroTag: 'French(${NavbarState.counterFR})',
                                        elevation: 1,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(8)), side: BorderSide(color: Colors.white, width: 0.2)),
                                        label: Text(
                                          'French(${NavbarState.counterFR})',
                                          style: Theme.of(context).textTheme.titleSmall,
                                        ),
                                        // <-- Text
                                        backgroundColor: Colors.grey.withOpacity(0.1),
                                        // icon: Icon(
                                        //   // <-- Icon
                                        //   Icons.coffee,
                                        //   size: 16.0,
                                        // ),
                                        onPressed: () {
                                          Navigator.of(context).push(
                                            CupertinoPageRoute(
                                              builder: (context) => LanguagePage(
                                                titleText: 'French(${NavbarState.counterFR})',
                                                language: "fr",
                                              ),
                                            ),
                                          );
                                          // Navigator.of(context).push(
                                          //   PageRouteBuilder(
                                          //     // transitionDuration:
                                          //     // Duration(seconds: 2),
                                          //
                                          //     pageBuilder: (_, __, ___) {
                                          //       // return StartSearch();
                                          //
                                          //       return LanguagePage(
                                          //         titleText: 'French(${NavbarState.counterFR})',
                                          //         language: "fr",
                                          //       );
                                          //     },
                                          //   ),
                                          // );
                                          // BlocProvider.of<SearchBloc>(context).add(OpenLanguageResults(context, "fr"));
                                        },
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 0, 10, 5),
                                    child: Container(
                                      // width: MediaQuery.of(context).size.width * 0.40,
                                      height: MediaQuery.of(context).size.width * 0.1,
                                      child: FloatingActionButton.extended(
                                        // heroTag: 'location_offers',
                                        key: UniqueKey(),
                                        heroTag: 'Spanish(${NavbarState.counterES})',
                                        elevation: 1,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(8)), side: BorderSide(color: Colors.white, width: 0.2)),
                                        label: Text(
                                          'Spanish(${NavbarState.counterES})',
                                          style: Theme.of(context).textTheme.titleSmall,
                                        ),
                                        // <-- Text
                                        backgroundColor: Colors.grey.withOpacity(0.1),
                                        // icon: Icon(
                                        //   // <-- Icon
                                        //   Icons.coffee,
                                        //   size: 16.0,
                                        // ),
                                        onPressed: () {
                                          Navigator.of(context).push(
                                            PageRouteBuilder(
                                              // transitionDuration:
                                              // Duration(seconds: 2),

                                              pageBuilder: (_, __, ___) {
                                                // return StartSearch();

                                                return LanguagePage(
                                                  titleText: 'Spanish(${NavbarState.counterES})',
                                                  language: "es",
                                                );
                                              },
                                            ),
                                          );
                                          // BlocProvider.of<SearchBloc>(context).add(OpenLanguageResults(context, "fr"));
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(30, 20, 30, 20),
                                child: Text(
                                  'Versuchen Sie, nach zu suchen',
                                  style:Theme.of(context).textTheme.headlineSmall,
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(30, 5, 30, 00),
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.search,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Text(
                                      'die beliebtesten Channel',
                                      style: Theme.of(context).textTheme.bodyLarge,
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(30, 5, 30, 20),
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.search,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                  Flexible(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text(
                                        'magazinen, die Sie gelesen haben',
                                        style:  Theme.of(context).textTheme.bodyLarge,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
              ),
            ),
          );

          // );
        }),
      ],
    );
    // return Scaffold(
    //     back: Image.asset("assets/images/Background.png", fit: BoxFit.cover),
    //     appBar: AppBar(
    //       backgroundColor: Colors.transparent,
    //       elevation: 0,
    //       flexibleSpace: SafeArea(child: Container()),
    //     ));p
    // // },
    // // );
  }

  Widget SearchResults(BuildContext context, GoToSearchResults state, double heightSearchbar) {
    ScrollController _scrollController = ScrollController();
    return GestureDetector(
      onTap: () => {FocusManager.instance.primaryFocus?.unfocus()
      // ,handleSearchClick(text, state, false,true)
      },
      onPanDown: (details) => FocusManager.instance.primaryFocus?.unfocus(),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.8,
          child:CustomScrollView(
            controller: _scrollController,
            slivers: [
              VerticalListCover(items: state.searchResults!,height_News_aus_deiner_Region:  heightSearchbar,scrollController:_scrollController ),
            ],
          )
        // child: GridView.builder(
        //     gridDelegate:
        //         const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 45, crossAxisSpacing: 15, childAspectRatio: 0.7),
        //     itemCount: state.searchResults!.response?.length,
        //     physics: RangeMaintainingScrollPhysics(),
        //     itemBuilder: (BuildContext context, int index) {
        //       return Card(
        //           color: Colors.transparent,
        //           // clipBehavior: Clip.hardEdge,
        //           // borderOnForeground: true,
        //           // margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
        //           // elevation: 0,
        //           // semanticContainer: false,
        //
        //           ///maybe 0?
        //           // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        //           child: GestureDetector(
        //             behavior: HitTestBehavior.translucent,
        //             onTap: () => {
        //               Navigator.of(context).push(
        //                 CupertinoPageRoute(
        //                   builder: (context) => StartReader(
        //                     magazine: state.searchResults!.response![index],
        //                     heroTag: "searchresult_$index",
        //
        //                     // noofpages: 5,
        //                   ),
        //                 ),
        //               )
        //             },
        //             child: Stack(
        //               clipBehavior: Clip.none,
        //               alignment: Alignment.center,
        //               children: [
        //                 CachedNetworkImage(
        //                   imageUrl: state.searchResults!.response![index].idMagazinePublication! +
        //                       "_" +
        //                       state.searchResults!.response![index].dateOfPublication! +
        //                       "_0",
        //                   // imageUrl: NavbarState.magazinePublishedGetLastWithLimit!.response!.where((i) => i.magazineLanguage == "de").toList()[index].idMagazinePublication! +
        //                   //     "_" +
        //                   //     NavbarState.magazinePublishedGetLastWithLimit!.response!.where((i) => i.magazineLanguage == "de").toList()[index].dateOfPublication!,
        //                   // progressIndicatorBuilder: (context, url, downloadProgress) => Container(
        //                   //   // color: Colors.grey.withOpacity(0.1),
        //                   //   decoration: BoxDecoration(
        //                   //     // image: DecorationImage(image: imageProvider, fit: BoxFit.fill),
        //                   //     borderRadius: BorderRadius.all(Radius.circular(5.0)),
        //                   //     color: Colors.grey.withOpacity(0.1),
        //                   //   ),
        //                   //   child: SpinKitFadingCircle(
        //                   //     color: Colors.white,
        //                   //     size: 50.0,
        //                   //   ),
        //                   // ),
        //
        //                   imageBuilder: (context, imageProvider) => Hero(
        //                     tag: 'searchresult_$index',
        //                     child: Container(
        //                       decoration: BoxDecoration(
        //                         image: DecorationImage(image: imageProvider, fit: BoxFit.fill),
        //                         borderRadius: BorderRadius.all(Radius.circular(5.0)),
        //                       ),
        //                     ),
        //                   ),
        //                   useOldImageOnUrlChange: true,
        //                   // very important: keep both placeholder and errorWidget
        //                   placeholder: (context, url) => Container(
        //                     // color: Colors.grey.withOpacity(0.1),
        //                     decoration: BoxDecoration(
        //                       // image: DecorationImage(image: imageProvider, fit: BoxFit.fill),
        //                       borderRadius: BorderRadius.all(Radius.circular(5.0)),
        //                       // color: Colors.grey.withOpacity(0.05),
        //                       color: Colors.grey.withOpacity(0.1),
        //                     ),
        //                     child: SpinKitFadingCircle(
        //                       color: Colors.white,
        //                       size: 50.0,
        //                     ),
        //                   ),
        //                   errorWidget: (context, url, error) => Container(
        //                     // color: Colors.grey.withOpacity(0.1),
        //                     decoration: BoxDecoration(
        //                       // image: DecorationImage(image: imageProvider, fit: BoxFit.fill),
        //                       borderRadius: BorderRadius.all(Radius.circular(5.0)),
        //                       color: Colors.grey.withOpacity(0.1),
        //                     ),
        //                     child: SpinKitFadingCircle(
        //                       color: Colors.white,
        //                       // size: 50.0,
        //                     ),
        //                   ),
        //                   // errorWidget: (context, url, error) => Container(
        //                   //     alignment: Alignment.center,
        //                   //     child: Icon(
        //                   //       Icons.error,
        //                   //       color: Colors.grey.withOpacity(0.8),
        //                   //     )),
        //                 ),
        //                 // Spacer(),
        //                 Positioned(
        //                   // top: -50,
        //                   bottom: -35,
        //                   // height: -50,
        //                   width: MediaQuery.of(context).size.width / 2 - 20,
        //                   child: Align(
        //                     alignment: Alignment.center,
        //                     child: MarqueeWidget(
        //                       child: Text(
        //                         // state.magazinePublishedGetLastWithLimit.response![i + 1].name!,
        //                         DateFormat("d. MMMM yyyy").format(DateTime.parse(state.searchResults!.response![index].dateOfPublication!)),
        //                         // " asd",
        //                         // "Card ${i + 1}",
        //                         textAlign: TextAlign.center,
        //                         style: TextStyle(
        //                           fontSize: 14,
        //                           color: Colors.grey,
        //                           backgroundColor: Colors.transparent,
        //                         ),
        //                       ),
        //                     ),
        //                   ),
        //                 ),
        //                 Positioned(
        //                   // top: -50,
        //                   bottom: -20,
        //                   // height: -50,
        //                   width: MediaQuery.of(context).size.width / 2 - 20,
        //                   child: Align(
        //                     alignment: Alignment.center,
        //                     child: MarqueeWidget(
        //                       // crossAxisAlignment: CrossAxisAlignment.start,
        //                       child: Text(
        //                         // state.magazinePublishedGetLastWithLimit.response![i + 1].name!,
        //                         state.searchResults!.response![index].name!,
        //                         // " asd",
        //                         // "Card ${i + 1}",
        //                         textAlign: TextAlign.center,
        //
        //                         style: TextStyle(
        //                           fontSize: 14,
        //                           color: Colors.white,
        //                           backgroundColor: Colors.transparent,
        //                         ),
        //                       ),
        //                     ),
        //                   ),
        //                 ),
        //
        //                 // return GestureDetector(
        //                 //   behavior: HitTestBehavior.translucent,
        //                 //   onTap: () => {
        //                 //     // Navigator.push(
        //                 //     //     context,
        //                 //     //     new ReaderRoute(
        //                 //     //         widget: StartReader(
        //                 //     //       id: state
        //                 //     //           .magazinePublishedGetLastWithLimit
        //                 //     //           .response![i + 1]
        //                 //     //           .idMagazinePublication!,
        //                 //     //       tagindex: i,
        //                 //     //       cover: state.bytes[i],
        //                 //     //     ))),
        //                 //     // print('Asf'),
        //                 //     Navigator.push(
        //                 //       context,
        //                 //       PageRouteBuilder(
        //                 //         // transitionDuration:
        //                 //         // Duration(seconds: 2),
        //                 //         pageBuilder: (_, __, ___) => StartReader(
        //                 //           id: state.magazinePublishedGetLastWithLimit.response![i + 1].idMagazinePublication!,
        //                 //
        //                 //           index: i.toString(),
        //                 //           cover: state.bytes![i],
        //                 //           noofpages: state.magazinePublishedGetLastWithLimit.response![i + 1].pageMax!,
        //                 //           readerTitle: state.magazinePublishedGetLastWithLimit.response![i + 1].name!,
        //                 //
        //                 //           // noofpages: 5,
        //                 //         ),
        //                 //       ),
        //                 //     )
        //                 //     // Navigator.push(context,
        //                 //     //     MaterialPageRoute(
        //                 //     //         builder: (context) {
        //                 //     //   return StartReader(
        //                 //     //     id: state
        //                 //     //         .magazinePublishedGetLastWithLimit
        //                 //     //         .response![i + 1]
        //                 //     //         .idMagazinePublication!,
        //                 //     //     index: i,
        //                 //     //   );
        //                 //     // }))
        //                 //   },
        //                 //   child: Image.memory(
        //                 //       // state.bytes![i],
        //                 //       snapshot.data!
        //                 //       // fit: BoxFit.fill,
        //                 //       // frameBuilder: ((context, child, frame, wasSynchronouslyLoaded) {
        //                 //       //   if (wasSynchronouslyLoaded) return child;
        //                 //       //   return AnimatedSwitcher(
        //                 //       //     duration: const Duration(milliseconds: 200),
        //                 //       //     child: frame != null
        //                 //       //         ? child
        //                 //       //         : SizedBox(
        //                 //       //             height: 60,
        //                 //       //             width: 60,
        //                 //       //             child: CircularProgressIndicator(strokeWidth: 6),
        //                 //       //           ),
        //                 //       //   );
        //                 //       // }),
        //                 //       ),
        //                 // );
        //
        //                 // Align(
        //                 //   alignment: Alignment.bottomCenter,
        //                 //   child: Text(
        //                 //     state.magazinePublishedGetLastWithLimit.response![i + 1].name!,
        //                 //     // " asd",
        //                 //     // "Card ${i + 1}",
        //                 //     textAlign: TextAlign.center,
        //                 //
        //                 //     style: TextStyle(fontSize: 32, color: Colors.white, backgroundColor: Colors.transparent),
        //                 //   ),
        //                 // ),
        //               ],
        //             ),
        //           )
        //           // : Container(
        //           //     color: Colors.grey.withOpacity(0.1),
        //           //     child: SpinKitFadingCircle(
        //           //       color: Colors.white,
        //           //       size: 50.0,
        //           //     ),
        //           //   ),
        //           );
        //     }),
      ),
    );
  }

  void handleSearchClick(String text, SearchState state, bool cancelButton, bool savedResults) {
    print(cancelButton);
    if (cancelButton == true) {
      _searchController.text = "";
      BlocProvider.of<SearchBloc>(context).add(OpenSearch());
      setState(() {});
      return;
    }
    if (text.isEmpty) {
      _searchController.text = "";
      BlocProvider.of<SearchBloc>(context).add(OpenSearch());
      setState(() {});
    } else {
      BlocProvider.of<SearchBloc>(context).add(OpenSearchResults(context, text, savedResults));
      setState(() {});
    }
    // if (state is GoToSearchPage && text.isNotEmpty) {
    //   BlocProvider.of<SearchBloc>(context).add(OpenSearchResults(context, text));
    // } else if (state is GoToSearchResults && text.isNotEmpty) {
    //   if (cancelButton == true) {
    //     _searchController.text = "";
    //     BlocProvider.of<SearchBloc>(context).add(OpenSearch());
    //   } else {
    //     if (state is GoToSearchResults) {
    //       print("where im stuck");
    //     }
    //     // _searchController.text = "";
    //     BlocProvider.of<SearchBloc>(context).add(OpenSearchResults(context, text));
    //     setState(() {});
    //   }
    // }
  }
}

class CategoryImages extends StatefulWidget {
  const CategoryImages({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final PageController controller;

  @override
  State<CategoryImages> createState() => _CategoryImagesState();
}

class _CategoryImagesState extends State<CategoryImages> {
  late List<Uint8List> decodedImages;

  @override
  void initState() {
    super.initState();
    print('CategoryImage initialized');
    decodedImages = NavbarState.magazineCategoryGetAllActive!.response!.map((item) => base64.decode(item.image!)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.17,
      child: PageView.builder(
        controller: widget.controller,

        itemCount: NavbarState.magazineCategoryGetAllActive?.response!.length,
        allowImplicitScrolling: false,
        // pageSnapping: false,
        scrollDirection: Axis.horizontal,
        dragStartBehavior: DragStartBehavior.start,
        pageSnapping: false,
        padEnds: false,
// scrollBehavior: ScrollBehavior.,

        itemBuilder: (context, i) {
          return Transform.scale(
            scale: 0.95,
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: () => {
                // print(NavbarState.magazineCategoryGetAllActive!.response![i].id),
// print ("category name ${NavbarState.magazineCategoryGetAllActive!.response![i].name!}"),
                Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (context) => CategoryPage(
                      titleText: NavbarState.magazineCategoryGetAllActive!.response![i].name!,
                      categoryID: NavbarState.magazineCategoryGetAllActive!.response![i].id!,
                    ),
                  ),
                )
              },
              child: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.13,
                    // width: 100,
                    // color: Colors.green,
                    child: Card(
                      color: Colors.transparent,

                      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1)),
                      shape: CircleBorder(
                        side: BorderSide(color: Colors.white.withOpacity(0.5), width: 1),
                        // borderRadius: BorderRadius.circular(100),
                      ),

                      clipBehavior: Clip.hardEdge,
                      // margin: EdgeInsets.all(10.0),
                      child: ClipRRect(
                        // borderRadius: BorderRadius.circular(11.0),

                        child: Image.memory(
                          // state.bytes![i],

                          decodedImages[i],
                          key: ValueKey(NavbarState.magazineCategoryGetAllActive!.response![i].id!), // assuming id is unique

                          fit: BoxFit.cover,
                          alignment: Alignment.center,

                          // scale: 0.001,
                          // filterQuality: FilterQuality.high,
                          // colorBlendMode: BlendMode.colorBurn,
                          // height: MediaQuery.of(context).size.height * 0.1,
                          // width: MediaQuery.of(context).size.width * 0.9,
                          // height: 20,
                        ),
                      ),
                      // child: Icon(
                      //   Icons.ac_unit,
                      //   size: 50,
                      //   color: Colors.amber,
                      // ),
                    ),
                  ),
                  // Spacer(),
                  Hero(
                    tag: NavbarState.magazineCategoryGetAllActive!.response![i].name!,
                    child: Text(
                      NavbarState.magazineCategoryGetAllActive!.response![i].name!
                      // +                                    " " +
                      // NavbarState.magazineCategoryGetAllActive!.response![i].id!
                      ,
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ), // Spacer()
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}