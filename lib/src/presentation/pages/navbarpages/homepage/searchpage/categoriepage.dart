import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:sharemagazines/src/blocs/searchpage/search_bloc.dart';
import 'package:sharemagazines/src/presentation/pages/navbarpages/homepage/homepage.dart';

import '../../../../../blocs/navbar/navbar_bloc.dart';
import '../../../../widgets/marquee.dart';
import '../../../../widgets/src/coversverticallist.dart';
import '../../../reader/readerpage.dart';

class CategoryPage extends StatefulWidget {
  final String titleText;

  // final String categoryID;

  CategoryPage({Key? key, required this.titleText}) : super(key: key);

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> with AutomaticKeepAliveClientMixin<CategoryPage> {
  @override
  bool get wantKeepAlive => true;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // BlocProvider.of<SearchBloc>(context).add(OpenCategoryPage(context, widget.categoryID));
    // BlocProvider.of<searchBloc.SearchBloc>(context).add(searchBloc.Initialize(context));
  }

  @override
  void dispose() {
    // BlocProvider.of<SearchBloc>(context).add(OpenSearch());
    // Navigator.pop(context, true);
    _scrollController.dispose();
    // BlocProvider.of<SearchBloc>(context).add(OpenSearch());
    super.dispose();
    // BlocProvider.of<SearchBloc>(context).add(OpenLanguageResults(context, widget.titleText));
    // BlocProvider.of<searchBloc.SearchBloc>(context).add(searchBloc.Initialize(context));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(
      children: [
        Positioned.fill(
          child: Hero(tag: 'bg', child: Image.asset("assets/images/background/Background.png", fit: BoxFit.cover)),
        ),
        Scaffold(
          // extendBodyBehindAppBar: true,
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            automaticallyImplyLeading: false,
            // toolbarHeight: 100,
            leading: Container(
              // width: 35,
              color: Colors.transparent,
              child: GestureDetector(
                behavior: HitTestBehavior.deferToChild,
                onTap: () {
                  BlocProvider.of<SearchBloc>(context).add(OpenSearch());
                  Navigator.pop(context, true);
                  // Navigator.maybePop(context, true);
                  // NavigatorObserver();
                  // BlocProvider.of<SearchBloc>(context).add(OpenSearch());
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(30, 0, 00, 0),
                  child: Hero(
                    tag: 'backbutton',
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
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      child: MarqueeWidget(
                        child: FloatingActionButton.extended(
                          key: UniqueKey(),
                          heroTag: widget.titleText,
                          clipBehavior: Clip.hardEdge,
                          label: MarqueeWidget(
                            child: Text(
                              '${widget.titleText}',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleMedium!,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              // BlocProvider.of<NavbarBloc>(context).state.magazinePublishedGetLastWithLimit!.response!.length.toString(),
                              // style: TextStyle(fontSize: 12),
                            ),
                          ),
                          onPressed: () {},
                          backgroundColor: Colors.transparent,
                          elevation: 0,

                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          body: BlocBuilder<SearchBloc, SearchState>(
            builder: (context, state) {
              print("$state");
              if (state is GoToCategoryPage) {
                return CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    VerticalListCover(
                      items: state.selectedCategory!,
                      height_News_aus_deiner_Region: 0.0,
                      scrollController: _scrollController,
                    )
                  ],
                );
              } else if (state is GoToLanguageResults) {
                return CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    VerticalListCover(
                      items: state.selectedLanguage!,
                      height_News_aus_deiner_Region: 0.0,
                      scrollController: _scrollController,
                    )
                  ],
                );
              }else if (state is SearchError) {
                return AlertDialog(
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
                        Navigator.pop(context);
                      },
                      child: Text('OK', style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.blue)),
                    ),
                  ],
                );
              }
              return Container(
                // height: 100,
                // color: Colors.red,
                // width: 100,
              );
            },
          ),
        ),
      ],
    );
  }
}