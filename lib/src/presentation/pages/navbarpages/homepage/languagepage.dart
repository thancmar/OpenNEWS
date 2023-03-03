import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:sharemagazines_flutter/src/blocs/searchpage/search_bloc.dart';

import '../../../../blocs/navbar/navbar_bloc.dart';
import '../../../widgets/marquee.dart';

class LanguagePage extends StatefulWidget {
  final String titleText;
  final String language;
  const LanguagePage({Key? key, required this.titleText, required this.language}) : super(key: key);

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> with AutomaticKeepAliveClientMixin<LanguagePage> {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<SearchBloc>(context).add(OpenLanguageResults(context, widget.language));
    // BlocProvider.of<searchBloc.SearchBloc>(context).add(searchBloc.Initialize(context));
  }

  @override
  void dispose() {
    super.dispose();
    // BlocProvider.of<SearchBloc>(context).add(OpenLanguageResults(context, widget.titleText));
    // BlocProvider.of<searchBloc.SearchBloc>(context).add(searchBloc.Initialize(context));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
        // color: Colors.red,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/Background.png"),
            fit: BoxFit.fill,
          ),
        ),
        child: Scaffold(
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
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  BlocProvider.of<SearchBloc>(context).add(OpenSearch());
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(30, 0, 00, 0),
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
                    child: FloatingActionButton.extended(
                      key: UniqueKey(),
                      heroTag: widget.titleText,
                      label: Text(
                        '${widget.titleText}',
                        textAlign: TextAlign.center,

                        // BlocProvider.of<NavbarBloc>(context).state.magazinePublishedGetLastWithLimit!.response!.length.toString(),
                        // style: TextStyle(fontSize: 12),
                      ),
                      onPressed: () {},
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                    ),
                  ),
                )
              ],
            ),
          ),
          body: BlocBuilder<SearchBloc, SearchState>(
            builder: (context, state) {
              print("$state");
              if (state is GoToLanguageResults) {
                return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 45, crossAxisSpacing: 15, childAspectRatio: 0.7),
                    itemCount: state.selectedLanguage!.response?.length,
                    // itemCount: NavbarState.magazinePublishedGetLastWithLimit!.response!.where((i) => i.magazineLanguage == "en").toList().length,
                    physics: RangeMaintainingScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      // print("SearchBloc ${BlocProvider.of<SearchBloc>(context).state.futureLangFunc?.length}");
                      // print(NavbarState.magazinePublishedGetLastWithLimit!.response!.where((i) => i.magazineLanguage == "de").toList()[index].idMagazinePublication! +
                      //     "_" +
                      //     NavbarState.magazinePublishedGetLastWithLimit!.response!.where((i) => i.magazineLanguage == "de").toList()[index].dateOfPublication!);
                      return Card(
                          shadowColor: Colors.transparent,
                          color: Colors.transparent,
                          // clipBehavior: Clip.hardEdge,
                          // borderOnForeground: true,
                          // margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          // elevation: 200,
                          semanticContainer: false,

                          ///maybe 0?
                          // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () => {
                              // Navigator.of(context).push(
                              //   PageRouteBuilder(
                              //     transitionDuration: Duration(milliseconds: 1000),
                              //     pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
                              //       return StartReader(
                              //         id: state.magazinePublishedGetLastWithLimit!.response![i + 1].idMagazinePublication!,
                              //         index: i.toString(),
                              //         cover: snapshot.data!,
                              //         noofpages: state.magazinePublishedGetLastWithLimit!.response![i + 1].pageMax!,
                              //         readerTitle: state.magazinePublishedGetLastWithLimit!.response![i + 1].name!,
                              //
                              //         // noofpages: 5,
                              //       );
                              //     },
                              //     transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
                              //       return Align(
                              //         child: FadeTransition(
                              //           opacity: new CurvedAnimation(parent: animation, curve: Curves.easeIn),
                              //           child: child,
                              //         ),
                              //       );
                              //     },
                              //   ),
                              // )
                              // Navigator.push(
                              //   context,
                              //   PageRouteBuilder(
                              //     // transitionDuration:
                              //     // Duration(seconds: 2),
                              //     pageBuilder: (_, __, ___) => StartReader(
                              //       id: state.magazinePublishedGetLastWithLimit!.response![i].idMagazinePublication!,
                              //       index: i.toString(),
                              //       cover: snapshot.data!,
                              //       noofpages: state.magazinePublishedGetLastWithLimit!.response![i].pageMax!,
                              //       readerTitle: state.magazinePublishedGetLastWithLimit!.response![i].name!,
                              //
                              //       // noofpages: 5,
                              //     ),
                              //   ),
                              // ),
                            },
                            child: Stack(
                              clipBehavior: Clip.none,
                              alignment: Alignment.center,
                              children: [
                                CachedNetworkImage(
                                  imageUrl: state.selectedLanguage!.response![index].idMagazinePublication! + "_" + state.selectedLanguage!.response![index].dateOfPublication!,
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
                                      size: 50.0,
                                    ),
                                  ),
                                  // errorWidget: (context, url, error) => Container(
                                  //     alignment: Alignment.center,
                                  //     child: Icon(
                                  //       Icons.error,
                                  //       color: Colors.grey.withOpacity(0.8),
                                  //     )),
                                ),
                                Positioned(
                                  // top: -50,
                                  bottom: -35,
                                  // height: -50,
                                  width: MediaQuery.of(context).size.width / 2 - 20,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: MarqueeWidget(
                                      child: Text(
                                        // state.magazinePublishedGetLastWithLimit.response![i + 1].name!,
                                        DateFormat("d. MMMM yyyy").format(DateTime.parse(state.selectedLanguage!.response![index].dateOfPublication!)),
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
                                        state.selectedLanguage!.response![index].name!,
                                        // " asd",
                                        // "Card ${i + 1}",
                                        textAlign: TextAlign.center,

                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                          backgroundColor: Colors.transparent,
                                        ),
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
                          )
                          // : Container(
                          //     color: Colors.grey.withOpacity(0.1),
                          //     child: SpinKitFadingCircle(
                          //       color: Colors.white,
                          //       size: 50.0,
                          //     ),
                          //   ),
                          );
                    });
              }
              return Container(
                color: Colors.transparent,
              );
            },
          ),
        ));
  }
}