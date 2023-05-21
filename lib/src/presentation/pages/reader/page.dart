import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sharemagazines_flutter/src/presentation/pages/reader/readerpage.dart';

class ReaderPage extends StatefulWidget {
  final Reader reader;

  final int pageNumber;

  const ReaderPage({Key? key, required this.reader, required this.pageNumber}) : super(key: key);

  @override
  State<ReaderPage> createState() => _ReaderPageState();
}

class _ReaderPageState extends State<ReaderPage> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin<ReaderPage> {
  static ValueNotifier<int> _networklHasErrorNotifier = ValueNotifier(0);
  late AnimationController? _spinKitController;
  static Matrix4 matrix4 = Matrix4(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1);

  // TransformationController _controller = TransformationController(matrix4);

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _spinKitController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    // _controller.dispose();
    // pdfController.dispose();

    _spinKitController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      clipBehavior: Clip.hardEdge,
      alignPanAxis: true,
      transformationController: widget.reader.transformationController,
      minScale: 0.01,
      maxScale: 3.5,

      // boundaryMargin: Orientation == Orientation.portrait
      //     ? EdgeInsets.only(right: 150, bottom: 500)
      //     : EdgeInsets.only(right: -MediaQuery.of(context).size.width * 0.3, left: -MediaQuery.of(context).size.width * 0.3),
      // ,
      // key: _flipKey,
      // constrained: false,

      // onInteractionUpdate: (ScaleUpdateDetails details) {
      //   // get the scale from the ScaleUpdateDetails callback
      //   setState(() {
      //     pageScale = _controller.value.getMaxScaleOnAxis();
      //   });
      //   // print(pageScale);
      //   // print the scale here
      // },
      child: Hero(
        tag: widget.pageNumber == 0 ? widget.reader.heroTag : "etwas_${widget.pageNumber}",
        child: CachedNetworkImage(
            key: ValueKey(_networklHasErrorNotifier.value),
            filterQuality: FilterQuality.none,
            imageUrl:
                widget.reader.magazine.idMagazinePublication! + "_" + widget.reader.magazine.dateOfPublication! + "_" + widget.pageNumber.toString(),
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
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  // color: Colors.red,
                  decoration: BoxDecoration(
                    image: DecorationImage(image: imageProvider, fit: BoxFit.contain),
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                ),
            // useOldImageOnUrlChange: true,
            // very important: keep both placeholder and errorWidget
            placeholder: (context, url)
            {
              Future.delayed(Duration(milliseconds: 100), () {
                setState(() {
                  _networklHasErrorNotifier.value++;
                });
              });
              return CachedNetworkImage(
                key: ValueKey(_networklHasErrorNotifier.value),
                filterQuality: FilterQuality.none,
                imageUrl: widget.reader.magazine.idMagazinePublication! +
                    "_" +
                    widget.reader.magazine.dateOfPublication! +
                    "_" +
                    widget.pageNumber.toString() +
                    "_" +
                    "thumbnail",
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

                imageBuilder: (context, imageProvider) =>
                    Container(
                      height: MediaQuery
                          .of(context)
                          .size
                          .height,
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      // color: Colors.red,
                      decoration: BoxDecoration(
                        image: DecorationImage(image: imageProvider, fit: BoxFit.contain),
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      ),
                    ),
                // useOldImageOnUrlChange: true,
                // very important: keep both placeholder and errorWidget
                placeholder: (context, url) =>
                    Container(
                      // color: Colors.grey.withOpacity(0.1),
                      decoration: BoxDecoration(
                        // image: DecorationImage(image: imageProvider, fit: BoxFit.fill),
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        // color: Colors.grey.withOpacity(0.1),
                      ),
                      child: SpinKitFadingCircle(
                        color: Colors.white,
                        size: 50.0,
                        controller: _spinKitController,
                      ),
                    ),
                errorWidget: (context, url, error) {
                  Future.delayed(Duration(milliseconds: 100), () {
                    setState(() {
                      _networklHasErrorNotifier.value++;
                    });
                  });
                  return Container(
                    // color: Colors.grey.withOpacity(0.1),

                    decoration: BoxDecoration(
                      // image: DecorationImage(image: imageProvider, fit: BoxFit.fill),
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      // color: Colors.grey.withOpacity(0.1),
                    ),
                    child: SpinKitFadingCircle(
                      color: Colors.white,
                      size: 50.0,
                      controller: _spinKitController,
                    ),
                  );
                }
              // errorWidget: (context, url, error) => Container(
              //     alignment: Alignment.center,
              //     child: Icon(
              //       Icons.error,
              //       color: Colors.grey.withOpacity(0.8),
              //     )),
            );},
            // Container(
            //   // color: Colors.grey.withOpacity(0.1),
            //   decoration: BoxDecoration(
            //     // image: DecorationImage(image: imageProvider, fit: BoxFit.fill),
            //     borderRadius: BorderRadius.all(Radius.circular(5.0)),
            //     // color: Colors.grey.withOpacity(0.1),
            //   ),
            //   child: SpinKitFadingCircle(
            //     color: Colors.white,
            //     size: 50.0,
            //     controller: _spinKitController,
            //   ),
            // ),
            errorWidget: (context, url, error) {
              // Future.delayed(Duration(milliseconds: 100), () {
              //   setState(() {
              //     _networklHasErrorNotifier.value++;
              //   });
              // });
              return CachedNetworkImage(
                  key: ValueKey(_networklHasErrorNotifier.value),
                  filterQuality: FilterQuality.none,
                  imageUrl: widget.reader.magazine.idMagazinePublication! +
                      "_" +
                      widget.reader.magazine.dateOfPublication! +
                      "_" +
                      widget.pageNumber.toString() +
                      "_" +
                      "thumbnail",
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
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    // color: Colors.red,
                    decoration: BoxDecoration(
                      image: DecorationImage(image: imageProvider, fit: BoxFit.contain),
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                  ),
                  // useOldImageOnUrlChange: true,
                  // very important: keep both placeholder and errorWidget
                  placeholder: (context, url) => Container(
                    // color: Colors.grey.withOpacity(0.1),
                    decoration: BoxDecoration(
                      // image: DecorationImage(image: imageProvider, fit: BoxFit.fill),
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      // color: Colors.grey.withOpacity(0.1),
                    ),
                    child: SpinKitFadingCircle(
                      color: Colors.white,
                      size: 50.0,
                      controller: _spinKitController,
                    ),
                  ),
                  errorWidget: (context, url, error) {
                    Future.delayed(Duration(milliseconds: 100), () {
                      setState(() {
                        _networklHasErrorNotifier.value++;
                      });
                    });
                    return Container(
                      // color: Colors.grey.withOpacity(0.1),

                      decoration: BoxDecoration(
                        // image: DecorationImage(image: imageProvider, fit: BoxFit.fill),
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        // color: Colors.grey.withOpacity(0.1),
                      ),
                      child: SpinKitFadingCircle(
                        color: Colors.white,
                        size: 50.0,
                        controller: _spinKitController,
                      ),
                    );
                  }
                // errorWidget: (context, url, error) => Container(
                //     alignment: Alignment.center,
                //     child: Icon(
                //       Icons.error,
                //       color: Colors.grey.withOpacity(0.8),
                //     )),
              );
              // return Container(
              //   // color: Colors.grey.withOpacity(0.1),
              //
              //   decoration: BoxDecoration(
              //     // image: DecorationImage(image: imageProvider, fit: BoxFit.fill),
              //     borderRadius: BorderRadius.all(Radius.circular(5.0)),
              //     // color: Colors.grey.withOpacity(0.1),
              //   ),
              //   child: SpinKitFadingCircle(
              //     color: Colors.white,
              //     size: 50.0,
              //     controller: _spinKitController,
              //   ),
              // );
            }
            // errorWidget: (context, url, error) => Container(
            //     alignment: Alignment.center,
            //     child: Icon(
            //       Icons.error,
            //       color: Colors.grey.withOpacity(0.8),
            //     )),
            ),
      ),
    );
  }
}