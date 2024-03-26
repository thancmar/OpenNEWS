import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sharemagazines/src/presentation/pages/navbarpages/homepage/searchpage/categoriepage.dart';
import 'package:sharemagazines/src/presentation/widgets/src/covershorizontallist.dart';

import '../../../../../blocs/navbar/navbar_bloc.dart';
import '../../../../../blocs/searchpage/search_bloc.dart';

class SearchPage extends StatefulWidget {
  final bool hasEbooksAudiobooks;
  SearchPage({Key? key, required this.hasEbooksAudiobooks}) : super(key: key);

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
  int counterDE = NavbarState.magazinePublishedGetLastWithLimit.response()!.where((element) => element.magazineLanguage == "de").length;
  int counterEN = NavbarState.magazinePublishedGetLastWithLimit.response()!.where((element) => element.magazineLanguage == "en").length;
  int counterFR = NavbarState.magazinePublishedGetLastWithLimit.response()!.where((element) => element.magazineLanguage == "fr").length;
  int counterES = NavbarState.magazinePublishedGetLastWithLimit.response()!.where((element) => element.magazineLanguage == "es").length;

  @override
  bool get wantKeepAlive => true;

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  bool isTablet(BuildContext context) {
    // Get the device's physical screen size
    var screenSize = MediaQuery.of(context).size;

    // Arbitrary cutoff for device width that differentiates between phones and tablets
    // This can be adjusted based on your needs or specific device metrics
    const double deviceWidthCutoff = 600;

    return screenSize.width > deviceWidthCutoff;
  }

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
    bool tablet = isTablet(context);

    return Stack(
      children: [
        Positioned.fill(
            // child: Hero(tag: 'bg1',
            child: Image.asset("assets/images/background/Background.png", fit: BoxFit.cover)
            // ),
            ),
        BlocBuilder<SearchBloc, SearchState>(builder: (context, state) {
          // print("SearchState is ${BlocProvider.of<SearchState>(context).state}");
          // print(BlocProvider.of<NavbarBloc>(context).state);
          // print("rebuild $state");
          // print("search bloc state $state");
          if(state is SearchError){return AlertDialog(
            backgroundColor: Colors.white,
            title: Text(
              ('error').tr(),
              // 'Navbarerror',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.grey),
            ),
            content: Text(state.error.toString(), style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.grey)),
            actions: <Widget>[
              // TextButton(
              //   onPressed: () => Navigator.pop(context, 'Cancel'),
              //   child: const Text('Cancel'),
              // ),
              TextButton(
                onPressed: () async {
                  BlocProvider.of<SearchBloc>(context).add(OpenSearch());
                  // var result = await Navigator.of(context).push(
                  //   CupertinoPageRoute(
                  //     builder: (context) => const StartPage(
                  //       title: "notitle",
                  //     ),
                  //   ),
                  // );
                },
                child: Text('OK', style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.blue)),
              ),
            ],
          );}
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
                        size: 40,
                        // size: size.width * 0.1,
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
                            handleSearchClick(text, state, false, true);
                          },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey.withOpacity(0.2),
                            labelStyle: Theme.of(context).textTheme.titleLarge,
                            floatingLabelStyle: Theme.of(context).textTheme.bodyLarge,
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
                GestureDetector(
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
                        // size: size.width * 0.1,
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

            body:SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: state is GoToSearchResults
                    ? <Widget>[SearchResults(context, state, MediaQuery.of(context).size.height * 0.12)]
                    :
                         <Widget>[
                            Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                                child: Text(
                                  'Kategorien',
                                  style: Theme.of(context).textTheme.headlineSmall,
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ),
                            // CategoryImages(),
                            Align(
                                alignment: Alignment.center,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Flexible(child: CategoryImages())
                                  ],
                                )),
                            SearchState.oldSearchResults.isEmpty == false
                                ? Column(
                                    children: [
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Padding(
                                          padding: EdgeInsets.fromLTRB(30, 0, 30, 20),
                                          child: Text(
                                            'Letzte Suchanfragen',
                                            style: Theme.of(context).textTheme.headlineSmall,
                                            textAlign: TextAlign.right,
                                          ),
                                        ),
                                      ),
                                      // for (var i = 0; i < SearchState.oldSearchResults.length; i++)
                                      // if (SearchState.oldSearchResults?.length != 0)
                                      for (var i = SearchState.oldSearchResults.length - 1;
                                          i >= max(0, SearchState.oldSearchResults.length - 5);
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
                                                      handleSearchClick(SearchState.oldSearchResults[i], state, false, false);
                                                      _searchController.text = SearchState.oldSearchResults[i];
                                                    },
                                                    child: Container(
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(left: 10),
                                                        child: Text(
                                                          // 'hamburg',
                                                          // state.searchResults!.isNotEmpty ? state.searchResults![i] : "",
                                                          SearchState.oldSearchResults[i],
                                                          style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.w200),
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
                                                     setState(() {BlocProvider.of<SearchBloc>(context).add(DeleteSearchResult(i));
                                                     });
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
                              alignment: tablet ? Alignment.center : Alignment.topLeft,
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                                child: Text(
                                  'Choose a language',
                                  // style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                                  style: Theme.of(context).textTheme.headlineSmall,
                                  textAlign: tablet ? TextAlign.center : TextAlign.right,
                                ),
                              ),
                            ),
                            // ShowCategoryList(counterDE: counterDE, counterEN: counterEN, counterFR: counterFR, counterES: counterES),
                            ShowCategoryList(
                              listItems: ['all', 'de', 'en', 'es', 'fr'],
                              isAudioBook: false,
                            ),
                           widget.hasEbooksAudiobooks? Align(
                              alignment: tablet ? Alignment.center : Alignment.topLeft,
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(30, 20, 30, 10),
                                child: Text(
                                  'Choose a Ebook',
                                  // style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                                  style: Theme.of(context).textTheme.headlineSmall,
                                  textAlign: tablet ? TextAlign.center : TextAlign.right,
                                ),
                              ),
                            ):Container(),
                            // ShowCategoryList(counterDE: counterDE, counterEN: counterEN, counterFR: counterFR, counterES: counterES),
                  widget.hasEbooksAudiobooks?ShowCategoryList(
                              listItems: NavbarState.ebookCategoryGetAllActiveByLocale.response!.map((category) => category.name!).toList(),
                              isAudioBook: false,
                              categoryType: CategoryStatus.ebooks,
                            ):Container(),
                  widget.hasEbooksAudiobooks?Align(
                              alignment: tablet ? Alignment.center : Alignment.topLeft,
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(30, 20, 30, 10),
                                child: Text(
                                  'Choose a Audiobook',
                                  // style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                                  style: Theme.of(context).textTheme.headlineSmall,
                                  textAlign: tablet ? TextAlign.center : TextAlign.right,
                                ),
                              ),
                            ):Container(),
                            // ShowCategoryList(counterDE: counterDE, counterEN: counterEN, counterFR: counterFR, counterES: counterES),
                  widget.hasEbooksAudiobooks?ShowCategoryList(
                              listItems: NavbarState.audioBooksCategoryGetAllActiveByLocale.response!.map((category) => category.name!).toList(),
                              isAudioBook: true,
                              categoryType: CategoryStatus.hoerbuecher,
                            ):Container(),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(30, 20, 30, 20),
                                child: Text(
                                  'Versuchen Sie, nach zu suchen',
                                  style: Theme.of(context).textTheme.headlineSmall,
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
                                        style: Theme.of(context).textTheme.bodyLarge,
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

    // Define a list of search result types and their corresponding labels
    final List<Map<String, dynamic>> searchResultTypes = [
      if (state.searchResultsMagazines.response()!.isNotEmpty) {'label': 'Magazines', 'data': state.searchResultsMagazines},
      if (state.searchResultsEbooks.response()!.isNotEmpty) {'label': 'Ebooks', 'data': state.searchResultsEbooks},
      if (state.searchResultsAudiobooks.response()!.isNotEmpty) {'label': 'Audiobooks', 'data': state.searchResultsAudiobooks},
    ];

    return GestureDetector(
      // onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      onPanDown: (details) => FocusManager.instance.primaryFocus?.unfocus(),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.98,
        child: ListView.builder(
          controller: _scrollController,
          itemCount: searchResultTypes.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(30, 20, 30, 20),
                    child: Text(
                      searchResultTypes[index]['label'],
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                ),
                ListMagazineCover(
                  cover: searchResultTypes[index]['data'],
                  heroTag: "heroTag$index", // Unique heroTag for each type
                  scrollDirection: Axis.horizontal,
                  isSearchResults: true,
                ),
                if (index == searchResultTypes.length - 1)
                  Container(
                    height: heightSearchbar * 1.7,
                    color: Colors.transparent,
                  ),
              ],
            );
          },
        ),
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

class ShowCategoryList extends StatelessWidget {
  const ShowCategoryList({Key? key, required this.listItems, required this.isAudioBook, this.categoryType}) : super(key: key);

  final List<String> listItems;
  final bool isAudioBook;
  final CategoryStatus? categoryType;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      physics: RangeMaintainingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          listItems.length, // Assuming widget.listItems is your list
          (index) => Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 5),
            child: Container(
              // width: MediaQuery.of(context).size.width * 0.40,
              height: MediaQuery.of(context).size.aspectRatio * 75,

              child: FloatingActionButton.extended(
                // heroTag: 'location_offers',
                key: UniqueKey(),
                heroTag: listItems[index] + (isAudioBook ? '_audiobook' : ''),
                // splashColor: Colors.blue,
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8)), side: BorderSide(color: Colors.white, width: 0.2)),

                label: Text(
                  (listItems[index]),
                  // 'All($counterALL)',
                  // BlocProvider.of<NavbarBloc>(context).state.magazinePublishedGetLastWithLimit!.response!.length.toString(),
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                // <-- Text
                backgroundColor: Colors.grey.withOpacity(0.15),
                // icon: Icon(
                //   // <-- Icon
                //   Icons.menu_book,
                //   size: 16.0,
                // ),
                onPressed: () {
                  if (categoryType == null) {
                    BlocProvider.of<SearchBloc>(context).add(OpenLanguageResults(context, listItems[index]));
                  } else {
                    BlocProvider.of<SearchBloc>(context).add(OpenCategory(
                      listItems[index],
                      categoryType,
                    ));
                  }
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (context) => CategoryPage(
                        titleText: listItems[index] + (isAudioBook ? '_audiobook' : ''),
                        // categoryID: element.id!,
                      ),
                    ),
                  );
                },
                // extendedPadding: EdgeInsets.all(50),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CategoryImages extends StatelessWidget {
  CategoryImages({
    Key? key,
  }) : super(key: key);

  static late PageController controller = PageController(viewportFraction: 0.30, keepPage: true);

  late List<Uint8List> decodedImages;

  @override
  Widget build(BuildContext context) {
    decodedImages = NavbarState.magazineCategoryGetAllActive!.response!.map((item) => base64.decode(item.image!)).toList();

    return Container(
      height: MediaQuery.of(context).size.height * 0.133,

      width: double.infinity,
      // color: Colors.blue,
          child: ListView.builder(
            controller: controller,
            // shrinkWrap: true,
            // physics: NeverScrollableScrollPhysics(),
            itemCount: NavbarState.magazineCategoryGetAllActive?.response!.length,
            // allowImplicitScrolling: false,
            // pageSnapping: false,
            scrollDirection: Axis.horizontal,
            dragStartBehavior: DragStartBehavior.start,
            // pageSnapping: false,
            // padEnds: false,
          // scrollBehavior: ScrollBehavior.,

      itemBuilder: (context, i) {
        return Padding(
          padding: EdgeInsets.fromLTRB(4, 0, 4, 0),
          child: GestureDetector(
            onTap: () => {
              // print(NavbarState.magazineCategoryGetAllActive!.response![i].id),
              // print ("category name ${NavbarState.magazineCategoryGetAllActive!.response![i].name!}"),
            BlocProvider.of<SearchBloc>(context).add(OpenCategory(
            NavbarState.magazineCategoryGetAllActive!.response![i].name!,
            CategoryStatus.presse

            )),
              Navigator.of(context).push(
                CupertinoPageRoute(
                  builder: (context) => CategoryPage(
                    titleText: NavbarState.magazineCategoryGetAllActive!.response![i].name!,
                    // categoryID: NavbarState.magazineCategoryGetAllActive!.response![i].id!,
                  ),
                ),
              )
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  flex: 3,
                  child: Card(
                    color: Colors.transparent,
elevation: 5,
                        // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1)),
                        // shape: CircleBorder(
                        //   side: BorderSide(color: Colors.transparent, width: 0,style: BorderStyle.none),
                        //   // borderRadius: BorderRadius.circular(100),
                        //
                        // ),
                        // shape: StadiumBorder(),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.0)),

                        clipBehavior: Clip.hardEdge,
                        // margin: EdgeInsets.all(10.0),
                        child: ClipRRect(
                          // borderRadius: BorderRadius.circular(11.0),

                          child: Image.memory(
                            // state.bytes![i],

                            decodedImages[i],
                            key: ValueKey(NavbarState.magazineCategoryGetAllActive!.response![i].id!), // assuming id is unique

                            fit: BoxFit.contain,
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
                    Flexible(
                      child: Hero(
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
                      ),
                    ), // Spacer()
                  ],
                ),
              ));
            },
          ),
    );
  }
}

// class CategoryImages extends StatefulWidget {
//   // final PageController controller;
//   CategoryImages({
//     Key? key,
//     // required this.controller,
//   }) : super(key: key);
//
//   @override
//   State<CategoryImages> createState() => _CategoryImagesState();
// }
//
// class _CategoryImagesState extends State<CategoryImages> {
//   // List<Uint8List> decodedImages = [];
//   List<Widget> widgets = [];
//
//   @override
//   void initState() {
//     // super.initState();
//     print('CategoryImage initialized');
//     // decodedImages = NavbarState.magazineCategoryGetAllActive!.response!.map((item) => base64.decode(item.image!)).toList();
//     NavbarState.magazineCategoryGetAllActive?.response!.forEach((element) {
//       Uint8List di = base64.decode(element.image!);
//       widgets.add(
//         Column(
//           children: [
//             Expanded(
//               child: GestureDetector(
//                 onTap: () => {
//                   // print(NavbarState.magazineCategoryGetAllActive!.response![i].id),
//                   // print ("category name ${NavbarState.magazineCategoryGetAllActive!.response![i].name!}"),
//                   BlocProvider.of<SearchBloc>(context).add(OpenCategoryPage(context, element.id!)),
//                   Navigator.of(context).push(
//                     CupertinoPageRoute(
//                       builder: (context) => CategoryPage(
//                         titleText: element.name!,
//                         // categoryID: element.id!,
//                       ),
//                     ),
//                   )
//                 },
//                 child: Card(
//                   color: Colors.transparent,
//
//                   // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1)),
//                   // shape: CircleBorder(
//                   //   side: BorderSide(color: Colors.transparent, width: 0,style: BorderStyle.none),
//                   //   // borderRadius: BorderRadius.circular(100),
//                   //
//                   // ),
//                   // shape: StadiumBorder(),
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
//
//                   clipBehavior: Clip.hardEdge,
//                   // margin: EdgeInsets.all(10.0),
//                   child: Column(
//                     children: [
//                       ClipRRect(
//                         // borderRadius: BorderRadius.circular(11.0),
//
//                         child: Image.memory(
//                           // state.bytes![i],
//                           di,
//                           // decodedImages[element.],
//                           key: ValueKey(element.id!), // assuming id is unique
//
//                           fit: BoxFit.fill,
//                           alignment: Alignment.center,
//
//                           // scale: 0.001,
//                           // filterQuality: FilterQuality.high,
//                           // colorBlendMode: BlendMode.colorBurn,
//                           // height: MediaQuery.of(context).size.height * 0.1,
//                           // width: MediaQuery.of(context).size.width * 0.9,
//                           // height: 20,
//                         ),
//                       ),
//                       const Expanded(
//                         child: const SizedBox(
//                           child: const Text("sdcds"),
//                         ),
//                       )
//                     ],
//                   ),
//                   // child: Icon(
//                   //   Icons.ac_unit,
//                   //   size: 50,
//                   //   color: Colors.amber,
//                   // ),
//                 ),
//               ),
//             ),
//
//             // Expanded(flex: 1,child: Text(
//             //   element.name!
//             //                 // +                                    " " +
//             //                 // NavbarState.magazineCategoryGetAllActive!.response![i].id!
//             //                 ,
//             //                 // style: Theme.of(context).textTheme.bodyLarge,
//             //                 // textAlign: TextAlign.center,
//             //                 overflow: TextOverflow.ellipsis,
//             //               ),)
//           ],
//         ),
//       );
//     });
//     // widgets = List.generate(
//     //   10,
//     //   (index) => Padding(
//     //     padding: EdgeInsets.all(16),
//     //     child: AspectRatio(
//     //       aspectRatio: 9 / 5,
//     //       child: GestureDetector(
//     //         onTap: () => {
//     //           // print(NavbarState.magazineCategoryGetAllActive!.response![i].id),
//     //           // print ("category name ${NavbarState.magazineCategoryGetAllActive!.response![i].name!}"),
//     //           Navigator.of(context).push(
//     //             CupertinoPageRoute(
//     //               builder: (context) => CategoryPage(
//     //                 titleText: NavbarState.magazineCategoryGetAllActive!.response![index].name!,
//     //                 categoryID: NavbarState.magazineCategoryGetAllActive!.response![index].id!,
//     //               ),
//     //             ),
//     //           )
//     //         },
//     //         child: Column(
//     //           children: [
//     //             Container(
//     //               // height: MediaQuery.of(context).size.height * 0.13,
//     //               // height: MediaQuery.of(context).size.height * 0.13,
//     //               // width: 100,
//     //               // color: Colors.green,
//     //               child: Card(
//     //                 color: Colors.transparent,
//     //
//     //                 // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1)),
//     //                 // shape: CircleBorder(
//     //                 //   side: BorderSide(color: Colors.transparent, width: 0,style: BorderStyle.none),
//     //                 //   // borderRadius: BorderRadius.circular(100),
//     //                 //
//     //                 // ),
//     //                 // shape: StadiumBorder(),
//     //                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.0)),
//     //
//     //                 clipBehavior: Clip.hardEdge,
//     //                 // margin: EdgeInsets.all(10.0),
//     //                 child: ClipRRect(
//     //                   // borderRadius: BorderRadius.circular(11.0),
//     //
//     //                   child: Image.memory(
//     //                     // state.bytes![i],
//     //
//     //                     decodedImages[index],
//     //                     key: ValueKey(NavbarState.magazineCategoryGetAllActive!.response![index].id!), // assuming id is unique
//     //
//     //                     fit: BoxFit.fitHeight,
//     //                     alignment: Alignment.center,
//     //
//     //                     // scale: 0.001,
//     //                     // filterQuality: FilterQuality.high,
//     //                     // colorBlendMode: BlendMode.colorBurn,
//     //                     // height: MediaQuery.of(context).size.height * 0.1,
//     //                     // width: MediaQuery.of(context).size.width * 0.9,
//     //                     // height: 20,
//     //                   ),
//     //                 ),
//     //                 // child: Icon(
//     //                 //   Icons.ac_unit,
//     //                 //   size: 50,
//     //                 //   color: Colors.amber,
//     //                 // ),
//     //               ),
//     //             ),
//     //             // Spacer(),
//     //             Hero(
//     //               tag: NavbarState.magazineCategoryGetAllActive!.response![index].name!,
//     //               child: Text(
//     //                 NavbarState.magazineCategoryGetAllActive!.response![index].name!
//     //                 // +                                    " " +
//     //                 // NavbarState.magazineCategoryGetAllActive!.response![i].id!
//     //                 ,
//     //                 style: Theme.of(context).textTheme.bodyLarge,
//     //                 textAlign: TextAlign.center,
//     //                 overflow: TextOverflow.ellipsis,
//     //               ),
//     //             ), // Spacer()
//     //           ],
//     //         ),
//     //       ),
//     //     ),
//     //   ),
//     // );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 200,
//       // height: 150,
//       width: double.infinity,
//       child: OverlappedCarousel(
//         widgets: widgets,
//
//         //List of widgets
//         currentIndex: 2,
//         onClicked: (index) {
//           // ScaffoldMessenger.of(context).showSnackBar(
//           //   SnackBar(
//           //     content: Text("You clicked at $index"),
//           //   ),
//           // );
//         },
//         obscure: 0.4,
//         skewAngle: 0.1,
//       ),
//     );
//   }
// }