import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../blocs/navbar/navbar_bloc.dart';
import '../../../models/magazineCategoryGetAllActive.dart';
import '../../../models/magazinePublishedGetAllLastByHotspotId_model.dart';
import '../../widgets/marquee.dart';
import '../reader/readerpage.dart';
import 'homepage/homepage.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> with AutomaticKeepAliveClientMixin<MenuPage> {
  @override
  bool get wantKeepAlive => true;

  RefreshController _refreshController = RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    await BlocProvider.of<NavbarBloc>(context).checkLocation();
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Size size = MediaQuery.of(context).size;
    return BlocBuilder<NavbarBloc, NavbarState>(builder: (BuildContext context, state) {
      return SafeArea(
        child: SmartRefresher(
          enablePullDown: true,
          controller: _refreshController,
          onRefresh: _onRefresh,
          child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: NavbarState.magazineCategoryGetAllActive?.response!.length,
              itemBuilder: (context, i) {
                MagazinePublishedGetAllLastByHotspotId items = MagazinePublishedGetAllLastByHotspotId(response: []);
                MagazinePublishedGetAllLastByHotspotId bookmarks;

                items = MagazinePublishedGetAllLastByHotspotId(
                    response: NavbarState.magazinePublishedGetLastWithLimit!.response!
                        .where((element) => element.idsMagazineCategory!.contains(NavbarState.magazineCategoryGetAllActive!.response![i].id!) == true)
                        // .toSet()
                        .toList());
                return ValueListenableBuilder<MagazinePublishedGetAllLastByHotspotId>(
                  valueListenable: NavbarState.bookmarks,
                  builder: (context, value, child) {
                    if (value.response!.isNotEmpty && i == 0) {
                      bookmarks = value;
                    } else {
                      bookmarks = MagazinePublishedGetAllLastByHotspotId(response: []);
                    }
                    return Column(
                      // crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        if (value.response!.isNotEmpty && i == 0)
                          Align(
                            alignment: Alignment.center,
                            child: Padding(
                              // padding: EdgeInsets.fromLTRB(25, NavbarState.getTopMagazines!.length != 0 ? 60 : 20, 25, 20),
                              padding: EdgeInsets.fromLTRB(0, size.aspectRatio * 40, 0, size.aspectRatio * 20),

                              child: Text(
                                // 'Meistgelesene Artikel',
                                //   element.idsMagazineCategory!,
                                "Bookmarks",
                                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        if (value.response!.isNotEmpty && i == 0)
                          ListMagazineCover(
                            cover: bookmarks,
                            heroTag: 'menu_bookmarks',
                          ),
                        Align(
                          alignment: Alignment.center,
                          child: Padding(
                            // padding: EdgeInsets.fromLTRB(25, NavbarState.getTopMagazines!.length != 0 ? 60 : 20, 25, 20),
                            padding: EdgeInsets.fromLTRB(0, size.aspectRatio * 40, 0, size.aspectRatio * 20),

                            child: Text(
                              // 'Meistgelesene Artikel',
                              //   element.idsMagazineCategory!,
                              NavbarState.magazineCategoryGetAllActive!.response![i].name!,
                              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        ListMagazineCover(
                          cover: items,
                          heroTag: 'menu_$i',
                        ),
                        if (i == NavbarState.magazineCategoryGetAllActive!.response!.length!)
                          Container(
                            height: size.height * 0.1,
                            color: Colors.transparent,
                          )

                        //Add as padding
                      ],
                    );
                  },
                );
              }),
        ),
      );
    });
  }
}