// import 'package:flip_widget/flip_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sharemagazines/src/blocs/reader/reader_bloc.dart';
import 'package:sharemagazines/src/presentation/pages/reader/page.dart';
import 'package:sharemagazines/src/presentation/pages/reader/readeroptionspage.dart';
import 'package:sharemagazines/src/presentation/widgets/routes/toreaderoption.dart';
import 'package:sharemagazines/src/resources/magazine_repository.dart';
import '../../../models/magazinePublishedGetAllLastByHotspotId_model.dart' as model;
import '../../widgets/src/pageflip/src/page_flip_widget.dart';

class Reader extends StatefulWidget {
  final model.ResponseMagazine magazine;
  final String heroTag;
  final controllerflip = GlobalKey<PageFlipWidgetState>();
  ValueNotifier<Orientation> currentOrientation = ValueNotifier<Orientation>(Orientation.portrait);
  ValueNotifier<bool> darkMode = ValueNotifier<bool>(true);
  List<Uint8List?> pagesDataCache = [];
  List<GlobalKey> allImagekey = [];
  TransformationController transformationController = TransformationController(Matrix4.identity());

  Reader({Key? key, required this.magazine, required this.heroTag}) : super(key: key);

  @override
  State<Reader> createState() => _ReaderState();
}

class _ReaderState extends State<Reader> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin<Reader> {

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    widget.pagesDataCache = List<Uint8List?>.filled(int.parse(widget.magazine.pageMax!), null, growable: false);
    widget.allImagekey = List<GlobalKey>.filled(int.parse(widget.magazine.pageMax!), GlobalKey(), growable: false);

    // BlocProvider.of<ReaderBloc>(context).add(
    //   // OpenReader(idMagazinePublication: widget.magazine.idMagazinePublication!, dateofPublicazion: widget.magazine.dateOfPublication!, pageNo: widget.magazine.pageMax!),
    //   OpenReader(magazine: widget.magazine),
    // );
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Positioned.fill(
          child: Hero(
              tag: 'bg',
              child: Image.asset("assets/images/background/Background.png", fit: BoxFit.cover)),
        ),
        OrientationBuilder(builder: (context, orientation) {
          widget.currentOrientation.value =orientation;
          return GestureDetector(
              onTap: () => {
                    print("ds"),
                    Navigator.push(
                        context,
                        ReaderOptionRoute(
                            widget: ReaderOverlayPage(
                          reader: this.widget,
                          // currentPage: widget.currentPage,
                        ))),
                  },
              onDoubleTapDown: (details) {
                final RenderBox renderBox = context.findRenderObject() as RenderBox;
                final Offset localPosition = renderBox.globalToLocal(details.globalPosition);

                final Matrix4 currentMatrix = widget.transformationController.value;
                final double currentScale = currentMatrix.getMaxScaleOnAxis();

                if (currentScale == 1.0) {
                  // Define your desired zoom-in scale
                  final double zoomInScale = 3.0;

                  // Get the position of the double tap in the viewport
                  final RenderBox renderBox = context.findRenderObject() as RenderBox;
                  final Offset localPosition = renderBox.globalToLocal(details.globalPosition);

                  // Calculate the translation needed to get the tap location to the center of the viewport
                  final Size viewportSize = MediaQuery.of(context).size;
                  final double dx = (viewportSize.width / 2 - zoomInScale * localPosition.dx);
                  final double dy = (viewportSize.height / 2 - zoomInScale * localPosition.dy);

                  // Create the zoom-in transformation matrix
                  final Matrix4 zoomInMatrix = Matrix4.identity()
                    ..translate(dx, dy)
                    ..scale(zoomInScale);

                  widget.transformationController.value = zoomInMatrix;
                } else {
                  // If the image is zoomed in, reset to the original scale
                  widget.transformationController.value = Matrix4.identity();
                }
              },
              // onHorizontalDragEnd: ,

              // onDoubleTap: () => {
              //       // if (widget.isOnPageTurning = true) {Navigator.of(context).pop(), print("double tap reader")}
              //       print("controller"),
              //       widget.transformationController.value = Matrix4.identity(),
              //       // setState(() {
              //       // setState(() {
              //       //   pageScale = _controller.value.getMaxScaleOnAxis();
              //       // }),
              //       // });
              //     },
              child: ValueListenableBuilder<bool>(
                valueListenable: widget.darkMode,
                builder: (_, darkModeValue, child) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        color: darkModeValue?Colors.transparent:Colors.white,
                        child: PageFlipWidget(
                          key: widget.controllerflip,
                          orientation: widget.currentOrientation.value,
                          backgroundColor: Colors.transparent,
                          transformationController: widget.transformationController,
                          imageDataCache: widget.pagesDataCache,
                          // reader: this.widget,
                          children: <ReaderPage>[
                            for (var index = 0; index < int.parse(widget.magazine.pageMax!); index++)
                              ReaderPage(
                                reader: this.widget,
                                pageNumber: index,
                              ),
                          ],
                        ),
                      ),
                      Positioned(
                          bottom: 40,
                          right: 20,
                          child: FloatingActionButton(
                            shape: CircleBorder(
                              side: BorderSide(color: Colors.grey, width: 0.50,style: BorderStyle.none),
                            ),
                            key: UniqueKey(),
                            heroTag: "FAB",

                            onPressed: () => {widget.darkMode.value = !widget.darkMode.value},
                            backgroundColor: !darkModeValue?Colors.blue:Colors.white.withOpacity(0.2),

                            child: Icon(
                              widget.darkMode.value?Icons.dark_mode:Icons.light_mode,

                            ),
                          )),
                    ],
                  );
                }
              ));
        }),
      ],
    );
  }
}