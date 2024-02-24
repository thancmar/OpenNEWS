import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sharemagazines/src/presentation/widgets/src/pageflip/src/builders/builder.dart';

import '../../../../../blocs/reader/reader_bloc.dart';
import '../../../../pages/reader/page.dart';
import '../../../../pages/reader/readeroptionspage.dart';
import '../../../../pages/reader/readerpage.dart';
import '../../../routes/toreaderoption.dart';

class PageFlipWidget extends StatefulWidget {
  const PageFlipWidget(
      {Key? key,
      this.duration = const Duration(milliseconds: 450),
      this.cutoffForward = 0.8,
      this.cutoffPrevious = 0.1,
      this.backgroundColor = Colors.white,
      required this.children,
      this.initialIndex = 0,
      this.lastPage,
      this.isRightSwipe = false,
        required this.transformationController,
        required this.orientation,
        required this.imageDataCache,
      // required this.reader
      })
      : assert(initialIndex < children.length, 'initialIndex cannot be greater than children length'),
        super(key: key);

  final Color backgroundColor;
  final List<Widget> children;
  final Duration duration;
  final int initialIndex;
  final Widget? lastPage;
  final double cutoffForward;
  final double cutoffPrevious;
  final bool isRightSwipe;
  // final Widget reader;
  final Orientation orientation;
  final TransformationController transformationController;
  final List<Uint8List?> imageDataCache;

  @override
  PageFlipWidgetState createState() => PageFlipWidgetState();
}

class PageFlipWidgetState extends State<PageFlipWidget> with TickerProviderStateMixin {
  int pageNumber = 0;

  List<Widget> pages = [];

  final List<AnimationController> _controllers = [];
  bool? _isForward;
  double _scale = 1.0;
  double _baseScale = 1.0;
  Offset _translate = Offset.zero;
  Offset _baseTranslate = Offset.zero;
  Offset _startFocalPoint = Offset.zero;
  static Matrix4 matrix4 = Matrix4(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1);
  // TransformationController transformationController = TransformationController(Matrix4.identity());

  // @override
  // void didUpdateWidget(PageFlipWidget oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   if (widget.reader.pageScrollEnabled == false) {
  //     // widget.reader.transformationController.addListener(() {
  //       // widget.reader.currentPage.value = pageNumber;
  //     // });
  //   } else {
  //     // widget.reader.transformationController.removeListener(_yourListenerMethod);
  //   }
  // }

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    imageData = {};
    currentPage = ValueNotifier(-1);
    // currentWidget = ValueNotifier(Container());
    currentPageIndex = ValueNotifier(0);
    // pagesd
    _setUp();
  }

  void _setUp({bool isRefresh = false}) {
    _controllers.clear();
    pages.clear();
    if (widget.lastPage != null) {
      widget.children.add(widget.lastPage!);
    }
    for (var i = 0; i < widget.children.length; i++) {
      final controller = AnimationController(
        value: 1,
        duration: widget.duration,
        vsync: this,
      );
      _controllers.add(controller);
      final child = PageFlipBuilder(
        amount: controller,
        backgroundColor: widget.backgroundColor,
        isRightSwipe: widget.isRightSwipe,
        pageIndex: i,
        key: Key('item$i'),
        orientation: widget.orientation,
        imageDataCache: widget.imageDataCache,
        // child: widget.children[i],
        child: widget.children[i],
      );
      pages.add(child);
      // pages.add(widget.children[i]);
    }
    pages = pages.reversed.toList();
    if (isRefresh) {
      goToPage(pageNumber);
    } else {
      pageNumber = widget.initialIndex;
      // lastPageLoad = pages.length < 3 ? 0 : 3;
    }
    if (widget.initialIndex != 0) {
      currentPage = ValueNotifier(widget.initialIndex);
      // currentWidget = ValueNotifier(pages[pageNumber]);
      currentPageIndex = ValueNotifier(widget.initialIndex);
    }
  }

  bool get _isLastPage => (pages.length - 1) == pageNumber;

  // int lastPageLoad = 0;

  bool get _isFirstPage => pageNumber == 0;

  bool get _isZoomedIn {
    // Extract the scale values from the matrix
    final double scaleX = widget.transformationController.value.getRow(0).x;
    final double scaleY = widget.transformationController.value.getRow(1).y;

    // Check if the scale values are approximately 1.0 (considering some tolerance for floating-point precision issues)
    const double tolerance = 0.01;
    return (scaleX - 1.0).abs() > tolerance || (scaleY - 1.0).abs() > tolerance;
  }

  void _turnPage(ScaleUpdateDetails details, BoxConstraints dimens) {
    // if ((_isLastPage) || !isFlipForward.value) return;
    // print("is zoomed in ${widget.reader.transformationController.value}");
    // print("trans con valae ${_isZoomedIn}");
    if (_isZoomedIn) return;
    currentPage.value = pageNumber;
    // currentWidget.value = Container();
    final ratio = details.focalPointDelta.dx / dimens.maxWidth;
    if (_isForward == null) {
      if (widget.isRightSwipe ? details.focalPointDelta.dx < 0.0 : details.focalPointDelta.dx > 0.0) {
        _isForward = false;
      } else if (widget.isRightSwipe ? details.focalPointDelta.dx > 0.2 : details.focalPointDelta.dx < -0.2) {
        _isForward = true;
      } else {
        _isForward = null;
      }
    }

    if (_isForward == true || pageNumber == 0) {
      final pageLength = pages.length;
      final pageSize = widget.lastPage != null ? pageLength : pageLength - 1;
      if (pageNumber != pageSize && !_isLastPage) {
        widget.isRightSwipe ? _controllers[pageNumber].value -= ratio : _controllers[pageNumber].value += ratio;
      }
    }
  }

  Future _onDragFinish() async {
    if (_isZoomedIn) return;
    if (_isForward != null) {
      if (_isForward == true) {
        if (!_isLastPage && _controllers[pageNumber].value <= (widget.cutoffForward + 0.15)) {
          // print("nextPage");
          await nextPage();
        } else {
          if (!_isLastPage) {
            // print("_isLastPage");
            await _controllers[pageNumber].forward();
          }
        }
      } else {
        if (!_isFirstPage && _controllers[pageNumber - 1].value >= widget.cutoffPrevious) {
          await previousPage();
        } else {
          if (_isFirstPage) {
            await _controllers[pageNumber].forward();
          } else {
            await _controllers[pageNumber - 1].reverse();
            if (!_isFirstPage) {
              // print("_isFirstPage");
              await previousPage();
            }
          }
        }
      }
    }

    _isForward = null;
    currentPage.value = -1;
  }

  Future nextPage() async {
    await _controllers[pageNumber].reverse();
    if (mounted) {
      setState(() {
        pageNumber++;
      });
    }

    if (pageNumber < pages.length) {
      currentPageIndex.value = pageNumber;
      // currentWidget.value = pages[pageNumber];
    }

    if (_isLastPage) {
      currentPageIndex.value = pageNumber;
      // currentWidget.value = pages[pageNumber];
      return;
    }
  }

  Future previousPage() async {
    await _controllers[pageNumber - 1].forward();
    if (mounted) {
      setState(() {
        pageNumber--;
      });
    }
    currentPageIndex.value = pageNumber;
    // currentWidget.value = pages[pageNumber];
    imageData[pageNumber + 1] = null;
  }

  Future goToPage(int index) async {
    if (mounted) {
      setState(() {
        pageNumber = index;
      });
    }
    print("goToPage $index");
    for (var i = 0; i < _controllers.length; i++) {
      if (i == index) {
        print("i $i");
        _controllers[i].forward();
      } else if (i < index) {
        _controllers[i].reverse();
      } else {
        if (_controllers[i].status == AnimationStatus.reverse) {
          _controllers[i].value = 1;
        }
      }
    }
    currentPageIndex.value = pageNumber;
    // currentWidget.value = pages[pageNumber];
    currentPage.value = pageNumber;
  }

  // Function to handle the start of a scaling gesture
  void _handleScaleStart(ScaleStartDetails details) {
    if (details.localFocalPoint >= Offset.zero) {
      _baseScale = _scale;
      _startFocalPoint = details.localFocalPoint;
      _baseTranslate = _translate;
    }
  }

// Function to handle the updating of a scaling gesture
  void _handleScaleUpdate(ScaleUpdateDetails details) {
    if (_baseScale * details.scale >= 1.0) {
      setState(() {
        _scale = (_baseScale * details.scale); // Example scale limits

        // Calculate the translation offset
        final Offset focalPointDelta = details.localFocalPoint - _startFocalPoint;
        _translate = _baseTranslate + focalPointDelta * _scale;
      });
    }
  }

// Function to handle the end of a scaling gesture
  void _handleScaleEnd(ScaleEndDetails details) {
    // You can implement any additional logic needed when scaling ends
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, dimens) => InteractiveViewer(
        // alignPanAxis: true,
        transformationController: widget.transformationController,
        minScale: 0.01,
        maxScale: 3.5,
        // behavior: HitTestBehavior.opaque,
        // onTapDown: (details) {},
        // //   onTapUp: _isZoomedIn ?(details) {
        // //     _onTap();
        // // }:null,
        //
        // onPanDown: (details) {},
        // onPanEnd: (details) {},
        // onTapCancel: () {},
        // onHorizontalDragCancel: widget.reader.pageScrollEnabled == true ? _isForward = null : null,
        // onHorizontalDragUpdate: widget.reader.pageScrollEnabled == true
        //     ? (details) {
        //         _turnPage(details, dimens);
        //       }
        //     : null,
        // onHorizontalDragEnd: widget.reader.pageScrollEnabled == true ? _isForward = null : null,
        // onHorizontalDragCancel:  !_isZoomedIn ?_isForward = null:null,
        // onHorizontalDragUpdate: _isZoomedIn ?null:(details)=> _turnPage(details, dimens),
        // onHorizontalDragEnd:  _isZoomedIn ?null:(details)=>_onDragFinish(),
        onInteractionUpdate: (details) => _turnPage(details, dimens),
        onInteractionEnd: (details) => _onDragFinish(),
        child: Stack(
          // fit: StackFit.expand,
          children: <Widget>[
            if (widget.lastPage != null) ...[
              widget.lastPage!,
            ],
            if (pages.isNotEmpty) ...pages else ...[const SizedBox.shrink()],
          ],
        ),
      ),
    );
  }
}