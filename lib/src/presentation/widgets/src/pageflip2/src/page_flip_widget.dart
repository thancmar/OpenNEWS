import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sharemagazines/src/presentation/widgets/src/pageflip2/src/builders/builder.dart';

import '../../../../../blocs/navbar/navbar_bloc.dart';
import '../../../../../blocs/reader/reader_bloc.dart';
import '../../../../pages/reader/page.dart';
import '../../../../pages/reader/readeroptionspage.dart';
import '../../../../pages/reader/readerpage.dart';
import '../../../routes/toreaderoption.dart';
import 'builders/builder.dart';
// import 'image_sizer.dart';

class PageFlipWidget2 extends StatefulWidget {
  const PageFlipWidget2(
      {Key? key,
      this.duration = const Duration(milliseconds: 450),
      this.cutoffForward = 0.8,
      this.cutoffPrevious = 0.1,
      this.backgroundColor = Colors.transparent,
      // required this.children,
      this.initialIndex = 0,
      this.lastPage,
      this.isRightSwipe = false,
      required this.reader,
      required this.pageMax})
      :
        // assert(
        // initialIndex < children.length,
        //           'initialIndex cannot be greater than children length'
        // ),
        super(key: key);

  final Color backgroundColor;

  // final List<ReaderPage> children;
  final Duration duration;
  final int initialIndex;
  final ReaderPage? lastPage;
  final double cutoffForward;
  final double cutoffPrevious;
  final bool isRightSwipe;
  final Reader reader;
  final int pageMax;

  @override
  PageFlipWidget2State createState() => PageFlipWidget2State();
}

class PageFlipWidget2State extends State<PageFlipWidget2> with TickerProviderStateMixin {
  int pageNumber = 0;

  // ValueNotifier<int> pageNumber2 = ValueNotifier(0);
  List<Widget> pages = [];
  List<Uint8List?> pagesdata = [];

  // List<ReaderPage> pages = [];
  final List<AnimationController> _controllers = [];
  bool? _isForward;
  List<GlobalKey> repaintBoundaryKeys = [];
  List<Size> imageSize = [];

  @override
  void dispose() {
    // pageNumber2.removeListener(_pageNumberChanged);
    // pageNumber2.dispose();
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
    currentWidget = ValueNotifier(Container());
    // pagesdata = List.generate(widget.pageMax, (index) => null);
    pages = List.generate(
        widget.pageMax,
        (index) => SizedBox(
              height: 100,
              width: 100,
            ));
    repaintBoundaryKeys = List.generate(widget.pageMax, (index) => GlobalKey());
    imageSize = List.generate(widget.pageMax, (index) => Size.zero);
    currentPageIndex = ValueNotifier(0);
    currentPageIndex.addListener(_pageNumberChanged);
    _setUp();
    _pageNumberChanged();
  }

  void _pageNumberChanged() async {
    // This method is called every time pageNumber changes
    // Implement your logic here that should happen when pageNumber changes
    // For example, fetching new data
    // if (pageNumber2.value < pagesdata.length && pagesdata[pageNumber2.value] == null) {
    // Fetch data if it's not already present
    print("current index ${currentPageIndex.value}");

  }


  void _setUp({bool isRefresh = false}) {
    _controllers.clear();
    // pages.clear();
    if (widget.lastPage != null) {
      // widget.children.add(widget.lastPage!);
    }
    for (var i = 0; i < int.parse(widget.reader.magazine.pageMax!); i++) {
      final controller = AnimationController(
        value: 1,
        duration: widget.duration,
        vsync: this,
      );
      _controllers.add(controller);
      final child = PageFlipBuilder2(
        amount: controller,
        backgroundColor: widget.backgroundColor,
        isRightSwipe: widget.isRightSwipe,
        pageIndex: i,
        bKey: repaintBoundaryKeys[i],
        key: Key('item$i'),
        imageSize: imageSize[i],
        // child: widget.children[i],
        // child: widget.children[i],
        child: pages[i],
      );
      pages.add(child);
      // pages.add(widget.children[i]);
    }
    pages = pages.reversed.toList();

    if (isRefresh) {
      goToPage(pageNumber);
    } else {
      pageNumber = widget.initialIndex;
      lastPageLoad = pages.length < 3 ? 0 : 3;
    }
    if (widget.initialIndex != 0) {
      currentPage = ValueNotifier(widget.initialIndex);
      currentWidget = ValueNotifier(pages[pageNumber]);
      currentPageIndex = ValueNotifier(widget.initialIndex);
    }
  }

  bool get _isLastPage => (pages.length - 1) == pageNumber;

  int lastPageLoad = 0;

  bool get _isFirstPage => pageNumber == 0;

  void _turnPage(DragUpdateDetails details, BoxConstraints dimens) {
    // if ((_isLastPage) || !isFlipForward.value) return;
    // if(widget.reader.pageScrollEnabled == true) return;
    currentPage.value = pageNumber;
    currentWidget.value = Container();
    final ratio = details.delta.dx / dimens.maxWidth;
    if (_isForward == null) {
      if (widget.isRightSwipe ? details.delta.dx < 0.0 : details.delta.dx > 0.0) {
        _isForward = false;
      } else if (widget.isRightSwipe ? details.delta.dx > 0.2 : details.delta.dx < -0.2) {
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
    // if(widget.reader.pageScrollEnabled == true) return;
    if (_isForward != null) {
      if (_isForward == true) {
        if (!_isLastPage && _controllers[pageNumber].value <= (widget.cutoffForward + 0.15)) {
          await nextPage();
        } else {
          if (!_isLastPage) {
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
              await previousPage();
            }
          }
        }
      }
    }

    _isForward = null;
    currentPage.value = -1;
  }

  Future _onTap() async {
    if (_isForward != null) {
      if (_isForward == true) {
        if (!_isLastPage && _controllers[pageNumber].value <= (widget.cutoffForward + 0.15)) {
          await nextPage();
        } else {
          if (!_isLastPage) {
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
      currentWidget.value = pages[pageNumber];
    }

    if (_isLastPage) {
      currentPageIndex.value = pageNumber;
      currentWidget.value = pages[pageNumber];
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
    currentWidget.value = pages[pageNumber];
    imageData[pageNumber] = null;
  }

  Future goToPage(int index) async {
    if (mounted) {
      setState(() {
        pageNumber = index;
      });
    }
    for (var i = 0; i < _controllers.length; i++) {
      if (i == index) {
        _controllers[i].forward();
      } else if (i < index) {
        _controllers[i].reverse();
        // currentPageIndex.value = pageNumber+1;
        // currentWidget.value = pages[pageNumber+1];
        // currentPage.value = pageNumber+1;
      } else {
        if (_controllers[i].status == AnimationStatus.reverse) {
          _controllers[i].value = 1;
          // _isForward = null;
        }
      }
    }
    currentPageIndex.value = pageNumber;
    // currentPageIndex.value = pageNumber-1;
    currentWidget.value = pages[pageNumber];
    // currentWidget.value = pages[pageNumber-1];
    currentPage.value = pageNumber;
    // setState(() {
    // currentPageIndex.value = pageNumber-1;
    // currentWidget.value = pages[pageNumber-1];
    // currentPage.value = pageNumber-1;
    // _isForward = null;
    // currentPage.value = -1;

    // });
    // widget.reader. =pageNumber;
  }

  // Future goToPage(int targetIndex) async {
  //   if (targetIndex < 0 || targetIndex >= _controllers.length) {
  //     return; // Target index is out of range.
  //   }
  //
  //   // Determine the direction of navigation
  //   int step = (targetIndex > pageNumber) ? 1 : -1;
  //
  //   while (pageNumber != targetIndex) {
  //     if (step > 0) {
  //       // Moving forwards
  //       await _controllers[pageNumber].forward();
  //       if (pageNumber + 1 < _controllers.length) {
  //         pageNumber++;
  //       }
  //     } else {
  //       // Moving backwards
  //       if (pageNumber - 1 >= 0) {
  //         await _controllers[pageNumber - 1].reverse();
  //         pageNumber--;
  //       }
  //     }
  //
  //     // Update the state after each animation
  //     setState(() {
  //       currentPageIndex.value = pageNumber;
  //       currentWidget.value = pages[pageNumber];
  //       currentPage.value = pageNumber;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, dimens) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (details) {},
        onTapUp: (details) {
          _onTap();
        },
        onPanDown: (details) {},
        onPanEnd: (details) {},
        onTapCancel: () {},
        // onHorizontalDragCancel:widget.reader.pageScrollEnabled==true?  _isForward = null:null,
        // onHorizontalDragUpdate: widget.reader.pageScrollEnabled==true? (details){_turnPage(details, dimens);}:null,
        // onHorizontalDragEnd: widget.reader.pageScrollEnabled==true?  _isForward = null:null,
        onHorizontalDragCancel: _isForward = null,
        onHorizontalDragUpdate: (details) => _turnPage(details, dimens),
        onHorizontalDragEnd:  (details) => _onDragFinish() ,

        child: Stack(
          // fit: StackFit.loose,
          alignment: Alignment.center,
          children: <Widget>[
            if (widget.lastPage != null) ...[
              widget.lastPage!,
            ],
            if (pages.isNotEmpty) ...pages else ...[const SizedBox.shrink()],
            // pagesdata[pageNumber2.value] != null?Align(
            //   alignment: Alignment.center,
            //   child: Image.memory(
            //     pagesdata[pageNumber2.value]!,
            //     fit: BoxFit.contain, // This ensures the image keeps its aspect ratio.
            //   ),
            // ):Container()
          ],
        ),
      ),
    );
  }
}