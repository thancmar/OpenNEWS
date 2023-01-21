import 'dart:convert';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sharemagazines_flutter/src/presentation/pages/navbarpages/homepage/categoriepage.dart';

import '../../../../blocs/navbar/navbar_bloc.dart';
import '../../../../blocs/searchpage/search_bloc.dart';
import '../../../../resources/magazine_repository.dart';
import 'languagepage.dart';

// class StartSearch extends StatelessWidget {
//   // final String id;
//   // final String index;
//   // final Uint8List cover;
//   // final String noofpages;
//
//   StartSearch({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     print("StartSearch StatelessWidget ");
//     return BlocProvider(
//         create: (BuildContext context) => SearchBloc(
//               magazineRepository: RepositoryProvider.of<MagazineRepository>(context),
//             ),
//         child: SearchPage());
//   }
// //   return Container();
// }

class SearchPage extends StatefulWidget {
  SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with AutomaticKeepAliveClientMixin<SearchPage> {
  TextEditingController _searchController = TextEditingController();

  @override
  bool get wantKeepAlive => true;

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  void initState() {
    super.initState();

    // BlocProvider.of<SearchBloc>(context).add(Initialize());
    BlocProvider.of<SearchBloc>(context).add(OpenSearch());
    // counterALL = BlocProvider.of<NavbarBloc>(context).state.magazinePublishedGetLastWithLimi!.response!.length;
    // super.initState();
    // // data = BlocProvider.of<NavbarBloc>(context).state.magazinePublishedGetLastWithLimit!.response!.magazineLanguage;
    //
    // // filteredList = [];
    // // for( magazineLanguage in BlocProvider.of<NavbarBloc>(context).state.magazinePublishedGetLastWithLimit!.response!.){
    // //   if (item['locationForDisplay'] != null && item['locationForDisplay']['latitude'] != null && item['locationForDisplay']['longitude'] != null
    // //   ) {
    // //     filteredList.add(item);
    // //   }
    // // }
    // for (var i = 0; i < BlocProvider.of<NavbarBloc>(context).state.magazinePublishedGetLastWithLimit!.response!.length; i++) {
    //   if (BlocProvider.of<NavbarBloc>(context).state.magazinePublishedGetLastWithLimit!.response![i].magazineLanguage!.toLowerCase().contains("de")) {
    //     // print(BlocProvider.of<NavbarBloc>(context).state.magazinePublishedGetLastWithLimit!.response![i].name!);
    //     // futureFunc.add(BlocProvider.of<NavbarBloc>(context).state.futureFunc![i]);
    //     counterDE++;
    //   }
    //   if (BlocProvider.of<NavbarBloc>(context).state.magazinePublishedGetLastWithLimit!.response![i].magazineLanguage!.toLowerCase().contains("en")) {
    //     // print(BlocProvider.of<NavbarBloc>(context).state.magazinePublishedGetLastWithLimit!.response![i].name!);
    //     // futureFunc.add(BlocProvider.of<NavbarBloc>(context).state.futureFunc![i]);
    //     counterEN++;
    //   }
    //   if (BlocProvider.of<NavbarBloc>(context).state.magazinePublishedGetLastWithLimit!.response![i].magazineLanguage!.toLowerCase().contains("fr")) {
    //     // print(BlocProvider.of<NavbarBloc>(context).state.magazinePublishedGetLastWithLimit!.response![i].name!);
    //     // futureFunc.add(BlocProvider.of<NavbarBloc>(context).state.futureFunc![i]);
    //     counterFR++;
    //   }
    //   // if (BlocProvider.of<NavbarBloc>(context).state.magazinePublishedGetLastWithLimit!.response![i].magazineLanguage!.toLowerCase().contains("sp")) {
    //   //   // print(BlocProvider.of<NavbarBloc>(context).state.magazinePublishedGetLastWithLimit!.response![i].name!);
    //   //   // futureFunc.add(BlocProvider.of<NavbarBloc>(context).state.futureFunc![i]);
    //   //   counterSP++;
    //   // }
    //   // futureFunc.add(magazineRepository.GetPage(page: '0', id_mag_pub: magazinePublishedGetLastWithLimitdata.response![i].idMagazinePublication!));
    //   // print(futureFunc[i]);
    // }
    // controller.addListener(zoomListener);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    // return BlocBuilder<NavbarBloc, NavbarState>(
    //   builder: (BuildContext context, state) {
    // if (state is GoToSearch) {
    //   return SafeArea(
    //       child: Stack(
    //     children: <Widget>[
    //       Padding(
    //         padding: EdgeInsets.only(left: 10),
    //         child: Icon(
    //           Icons.search,
    //           color: Colors.white,
    //           size: 40,
    //         ),
    //       ),
    //     ],
    //   ));
    // }
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/Background.png"),
          fit: BoxFit.fill,
        ),
      ),
      child: BlocBuilder<SearchBloc, SearchState>(builder: (context, state) {
        // print("SearchState is ${BlocProvider.of<SearchState>(context).state}");
        // print(BlocProvider.of<NavbarBloc>(context).state);
        // print("rebuild $state");
        // print("search bloc state $state");
        return Scaffold(
          // extendBodyBehindAppBar: true,
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            // automaticallyImplyLeading: false,
            toolbarHeight: 100,
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
                      size: 30,
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
                        onTap: () {
                          if (_searchController.selection == TextSelection.fromPosition(TextPosition(offset: _searchController.text.length - 1))) {
                            setState(() {
                              _searchController.selection = TextSelection.fromPosition(TextPosition(offset: _searchController.text.length));
                            });
                          }
                        },
                        onFieldSubmitted: (text) {
                          print("field submitted");
                          handleSearchClick(text, state, null);
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey.withOpacity(0.1),
                          labelStyle: TextStyle(fontSize: 18.0, color: Colors.white.withOpacity(0.5)),
                          floatingLabelStyle: TextStyle(color: Colors.blue),
                          labelText: "Suchen",
                          border: OutlineInputBorder(borderSide: BorderSide(width: 0.10, color: Colors.white), borderRadius: BorderRadius.all(Radius.circular(15.0))),
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
                  handleSearchClick(_searchController.text, state, state is GoToSearchResults ? true : false),
                  FocusManager.instance.primaryFocus?.unfocus()
                },
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: Hero(
                    tag: "search button",

                    child: Icon(
                      state is GoToSearchPage || state is LoadingSearchState ? Icons.search : Icons.close_rounded,
                      color: Colors.white,
                      size: 40,
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
              children: state is GoToSearchPage
                  ? <Widget>[
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(30, 10, 30, 20),
                          child: Text(
                            'Kategorien',
                            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.17,
                        child: PageView.builder(
                          controller: PageController(viewportFraction: 0.30
                              // keepPage: true
                              ),

                          itemCount: NavbarState.magazineCategoryGetAllActive!.response!.length,
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
                                  print(NavbarState.magazineCategoryGetAllActive!.response![i].id),
                                  Navigator.of(context).push(
                                    PageRouteBuilder(
                                      // transitionDuration:
                                      // Duration(seconds: 2),

                                      pageBuilder: (_, __, ___) {
                                        // return StartSearch();

                                        return CategoryPage(
                                          titleText: NavbarState.magazineCategoryGetAllActive!.response![i].name!,
                                          categoryID: NavbarState.magazineCategoryGetAllActive!.response![i].id!,
                                        );
                                      },
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

                                            base64.decode(NavbarState.magazineCategoryGetAllActive!.response![i].image!),
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
                                        NavbarState.magazineCategoryGetAllActive!.response![i].name!,
                                        style: TextStyle(color: Colors.white),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    // Spacer()
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      state.searchResults?.length != 0
                          ? Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(30, 20, 30, 20),
                                child: Text(
                                  'Letzte Suchanfragen',
                                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            )
                          : Container(),
                      // for (var i = 0; i < state.searchResults!.length; i++)
                      for (var i = state.searchResults!.length - 1; i >= 0; i--)
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
                                      handleSearchClick(state.searchResults?[i], state, false);
                                      _searchController.text = state.searchResults?[i];
                                    },
                                    child: Container(
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 10),
                                        child: Text(
                                          // 'hamburg',
                                          // state.searchResults!.isNotEmpty ? state.searchResults![i] : "",
                                          state.searchResults?[i],
                                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w200),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
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
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(30, 20, 30, 20),
                          child: Text(
                            'Choose a language',
                            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
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

                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8)), side: BorderSide(color: Colors.white, width: 0.2)),

                                  label: Text(
                                    'All(${NavbarState.magazinePublishedGetLastWithLimit!.response!.length})',
                                    // 'All($counterALL)',
                                    // BlocProvider.of<NavbarBloc>(context).state.magazinePublishedGetLastWithLimit!.response!.length.toString(),
                                    style: TextStyle(fontSize: 12),
                                  ), // <-- Text
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
                                      PageRouteBuilder(
                                        // transitionDuration:
                                        // Duration(seconds: 2),

                                        pageBuilder: (_, __, ___) {
                                          // return StartSearch();

                                          return LanguagePage(
                                            titleText: 'All(${NavbarState.magazinePublishedGetLastWithLimit!.response!.length})',
                                            language: "all",
                                          );
                                        },
                                      ),
                                    );
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

                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8)), side: BorderSide(color: Colors.white, width: 0.2)),

                                  label: Text(
                                    'German(${NavbarState.counterDE})',
                                    style: TextStyle(fontSize: 12),
                                  ), // <-- Text
                                  backgroundColor: Colors.grey.withOpacity(0.1),
                                  // icon: Icon(
                                  //   // <-- Icon
                                  //   Icons.account_box,
                                  //   size: 16.0,
                                  // ),
                                  onPressed: () {
                                    // BlocProvider.of<SearchBloc>(context).add(OpenLanguageResults(context, "all"));

                                    Navigator.of(context).push(
                                      PageRouteBuilder(
                                        // transitionDuration:
                                        // Duration(seconds: 2),

                                        pageBuilder: (_, __, ___) {
                                          // return StartSearch();

                                          return LanguagePage(
                                            titleText: 'German(${NavbarState.counterDE})',
                                            language: "de",
                                          );
                                        },
                                        // maintainState: true,

                                        // transitionDuration: Duration(milliseconds: 1000),
                                        // transitionsBuilder: (context, animation, anotherAnimation, child) {
                                        //   // animation = CurvedAnimation(curve: curveList[index], parent: animation);
                                        //   return ScaleTransition(
                                        //     scale: animation,
                                        //     alignment: Alignment.topRight,
                                        //     child: child,
                                        //   );
                                        // }
                                      ),
                                    );
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
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8)), side: BorderSide(color: Colors.white, width: 0.2)),
                                  label: Text(
                                    'English(${NavbarState.counterEN})',
                                    style: TextStyle(fontSize: 12),
                                  ), // <-- Text
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
                                            titleText: 'English(${NavbarState.counterEN})',
                                            language: "en",
                                          );
                                        },
                                      ),
                                    );
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
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8)), side: BorderSide(color: Colors.white, width: 0.2)),
                                  label: Text(
                                    'French(${NavbarState.counterFR})',
                                    style: TextStyle(fontSize: 12),
                                  ), // <-- Text
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
                                            titleText: 'French(${NavbarState.counterFR})',
                                            language: "fr",
                                          );
                                        },
                                      ),
                                    );
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
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8)), side: BorderSide(color: Colors.white, width: 0.2)),
                                  label: Text(
                                    'Spanish(${NavbarState.counterES})',
                                    style: TextStyle(fontSize: 12),
                                  ), // <-- Text
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
                            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
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
                                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w200),
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
                                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w200),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]
                  : state is GoToSearchResults
                      ? SearchResults(context, state)
                      : <Widget>[],
            ),
          ),
        );

        // );
      }),
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

  SearchResults(BuildContext context, SearchState state) {
    return <Widget>[
      // Align(
      //   alignment: Alignment.topLeft,
      //   child: Padding(
      //     padding: EdgeInsets.fromLTRB(30, 15, 30, 20),
      //     child: Text(
      //       'Magazines',
      //       style: TextStyle(color: Colors.white, fontSize: 20),
      //       textAlign: TextAlign.right,
      //     ),
      //   ),
      // ),
      state is GoToSearchResults
          ? SizedBox(
              height: 300, // card height
              child: PageView.builder(
                // itemCount: state.magazinePublishedGetLastWithLimit?.response?.length ?? 0 + 10,
                // itemCount: state.magazinePublishedGetLastWithLimit.response!.length! + 10,
                itemCount: state.searchResultCovers!.response!.length,
                // padEnds: true,
                allowImplicitScrolling: false,
                controller: PageController(
                  viewportFraction: 0.65,
                ),
                // onPageChanged: (int index) => setState(() => _index2 = index),
                pageSnapping: false,
                itemBuilder: (context, i) {
                  // if (state.bytes.isEmpty) {
                  //   setState(() {});
                  // }
                  // print("Herooo $i");
                  return Transform.scale(
                    // origin: Offset(100, 50),

                    // scale: i == _index1 ? 1 : 1,
                    scale: 1,

                    alignment: Alignment.bottomCenter,
                    // alignment: AlignmentGeometry(),
                    child: Card(
                        color: Colors.transparent,
                        // clipBehavior: Clip.hardEdge,
                        borderOnForeground: true,
                        margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
                        elevation: 0,

                        ///maybe 0?
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                        child: Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.center,
                          children: [
                            CachedNetworkImage(
                              imageUrl: (state.searchResultCovers!.response?[i].idMagazinePublication! ?? "") + "_" + (state.searchResultCovers!.response?[i].dateOfPublication! ?? ""),
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

                              imageBuilder: (context, imageProvider) => Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(image: imageProvider, fit: BoxFit.fill),
                                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                ),
                              ),
                              useOldImageOnUrlChange: true,
                              // very important: keep both placeholder and errorWidget
                              placeholder: (context, url) => Container(
                                // color: Colors.grey.withOpacity(0.1),
                                decoration: BoxDecoration(
                                  // image: DecorationImage(image: imageProvider, fit: BoxFit.fill),
                                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                  // color: Colors.grey.withOpacity(0.05),
                                  color: Colors.grey.withOpacity(0.1),
                                ),
                                child: SpinKitFadingCircle(
                                  color: Colors.white,
                                  size: 50.0,
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                // color: Colors.grey.withOpacity(0.1),
                                decoration: BoxDecoration(
                                  // image: DecorationImage(image: imageProvider, fit: BoxFit.fill),
                                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                  color: Colors.grey.withOpacity(0.1),
                                ),
                                child: SpinKitFadingCircle(
                                  color: Colors.white,
                                  // size: 50.0,
                                ),
                              ),
                              // errorWidget: (context, url, error) => Container(
                              //     alignment: Alignment.center,
                              //     child: Icon(
                              //       Icons.error,
                              //       color: Colors.grey.withOpacity(0.8),
                              //     )),
                            ),
                          ],
                        )
                        // : Container(
                        //     color: Colors.grey.withOpacity(0.1),
                        //     child: SpinKitFadingCircle(
                        //       color: Colors.white,
                        //       size: 50.0,
                        //     ),
                        //   ),
                        ),
                  );
                },
              )
              // child: PageView.builder(
              //   // itemCount: state.magazinePublishedGetLastWithLimit.response!.length! + 1,
              //   itemCount: state.magazinePublishedGetLastWithLimit.response!.length! + 1,
              //   // itemCount: 10,
              //   // padEnds: true,
              //   allowImplicitScrolling: false,
              //   controller: PageController(viewportFraction: 0.65),
              //   onPageChanged: (int index) => setState(() => _index2 = index),
              //   pageSnapping: false,
              //   itemBuilder: (context, i) {
              //     // if (state.bytes.isEmpty) {
              //     //   setState(() {});
              //     // }
              //     return Transform.scale(
              //       // origin: Offset(100, 50),
              //
              //       // scale: i == _index1 ? 1 : 1,
              //       scale: 1,
              //
              //       alignment: Alignment.bottomCenter,
              //       // alignment: AlignmentGeometry(),
              //       child: Card(
              //         color: Colors.transparent,
              //         clipBehavior: Clip.antiAliasWithSaveLayer,
              //         margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
              //         elevation: 0,
              //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
              //         child: state.bytes.isNotEmpty
              //             ? Stack(
              //                 children: [
              //                   Hero(
              //                     tag: '$i',
              //                     transitionOnUserGestures: true,
              //                     child: SizedBox(
              //                       width: 450,
              //                       height: 300,
              //                       child: GestureDetector(
              //                         behavior: HitTestBehavior.translucent,
              //                         onTap: () => {
              //                           // Navigator.push(
              //                           //     context,
              //                           //     new ReaderRoute(
              //                           //         widget: StartReader(
              //                           //       id: state
              //                           //           .magazinePublishedGetLastWithLimit
              //                           //           .response![i + 1]
              //                           //           .idMagazinePublication!,
              //                           //       tagindex: i,
              //                           //       cover: state.bytes[i],
              //                           //     ))),
              //                           // print('Asf'),
              //                           Navigator.push(
              //                             context,
              //                             PageRouteBuilder(
              //                               // transitionDuration:
              //                               // Duration(seconds: 2),
              //                               pageBuilder: (_, __, ___) => StartReader(
              //                                 id: state.magazinePublishedGetLastWithLimit.response![i + 1].idMagazinePublication!,
              //
              //                                 index: i.toString(),
              //                                 cover: state.bytes![i],
              //                                 noofpages: state.magazinePublishedGetLastWithLimit.response![i + 1].pageMax!,
              //                                 readerTitle: state.magazinePublishedGetLastWithLimit.response![i + 1].name!,
              //
              //                                 // noofpages: 5,
              //                               ),
              //                             ),
              //                           )
              //                           // Navigator.push(context,
              //                           //     MaterialPageRoute(
              //                           //         builder: (context) {
              //                           //   return StartReader(
              //                           //     id: state
              //                           //         .magazinePublishedGetLastWithLimit
              //                           //         .response![i + 1]
              //                           //         .idMagazinePublication!,
              //                           //     index: i,
              //                           //   );
              //                           // }))
              //                         },
              //                         child: Image.memory(
              //                           state.bytes![i],
              //                           // fit: BoxFit.fill,
              //                           // frameBuilder: ((context, child, frame, wasSynchronouslyLoaded) {
              //                           //   if (wasSynchronouslyLoaded) return child;
              //                           //   return AnimatedSwitcher(
              //                           //     duration: const Duration(milliseconds: 200),
              //                           //     child: frame != null
              //                           //         ? child
              //                           //         : SizedBox(
              //                           //             height: 60,
              //                           //             width: 60,
              //                           //             child: CircularProgressIndicator(strokeWidth: 6),
              //                           //           ),
              //                           //   );
              //                           // }),
              //                         ),
              //                       ),
              //                       // child: Image.network(
              //                       //   'https://via.placeholder.com/300?text=DITTO',
              //                       //   fit: BoxFit.fill,
              //                       // ),
              //                     ),
              //                   ),
              //                   // Align(
              //                   //   alignment: Alignment.bottomCenter,
              //                   //   child: Text(
              //                   //     state.magazinePublishedGetLastWithLimit.response![i + 1].name!,
              //                   //     // " asd",
              //                   //     // "Card ${i + 1}",
              //                   //     textAlign: TextAlign.center,
              //                   //
              //                   //     style: TextStyle(fontSize: 32, color: Colors.white, backgroundColor: Colors.transparent),
              //                   //   ),
              //                   // ),
              //                 ],
              //               )
              //             : Container(
              //                 color: Colors.grey.withOpacity(0.2),
              //                 child: SpinKitFadingCircle(
              //                   color: Colors.white,
              //                   size: 50.0,
              //                 ),
              //               ),
              //       ),
              //     );
              //   },
              // )
              )
          : Container()
    ];
  }

  void handleSearchClick(String text, SearchState state, bool? cancelButton) {
    print(text);
    if (state is GoToSearchPage && text.isNotEmpty) {
      BlocProvider.of<SearchBloc>(context).add(OpenSearchResults(context, text));
    } else if (state is GoToSearchResults && text.isNotEmpty) {
      if (cancelButton == true) {
        _searchController.text = "";
        BlocProvider.of<SearchBloc>(context).add(OpenSearch());
      } else {
        if (state is GoToSearchResults) {
          print("where im stuck");
        }
        // _searchController.text = "";
        BlocProvider.of<SearchBloc>(context).add(OpenSearchResults(context, text));
        setState(() {});
      }
    }
  }
}