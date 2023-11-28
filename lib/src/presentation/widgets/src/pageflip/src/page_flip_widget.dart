import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sharemagazines_flutter/src/presentation/widgets/src/pageflip/src/builders/builder.dart';

import '../../../../../blocs/reader/reader_bloc.dart';
import '../../../../pages/reader/page.dart';
import '../../../../pages/reader/readeroptionspage.dart';
import '../../../../pages/reader/readerpage.dart';
import '../../../routes/toreaderoption.dart';



class PageFlipWidget extends StatefulWidget {
  const PageFlipWidget({
    Key? key,
    this.duration = const Duration(milliseconds: 450),
    this.cutoffForward = 0.8,
    this.cutoffPrevious = 0.1,
    this.backgroundColor = Colors.white,
    required this.children,
    this.initialIndex = 0,
    this.lastPage,
    this.isRightSwipe = false,
    required this.reader

  })  : assert(initialIndex < children.length,
            'initialIndex cannot be greater than children length'),
        super(key: key);

  final Color backgroundColor;
  final List<ReaderPage> children;
  final Duration duration;
  final int initialIndex;
  final ReaderPage? lastPage;
  final double cutoffForward;
  final double cutoffPrevious;
  final bool isRightSwipe;
  final Reader reader;

  @override
  PageFlipWidgetState createState() => PageFlipWidgetState();
}

class PageFlipWidgetState extends State<PageFlipWidget>
    with TickerProviderStateMixin {
  int pageNumber = 0;
  List<Widget> pages = [];
  final List<AnimationController> _controllers = [];
  bool? _isForward;

  @override
  void didUpdateWidget(PageFlipWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // if (widget.reader.pageScrollEnabled == false) {
    //   widget.reader.transformationController.addListener((){
    //   // widget.reader.currentPage.value = pageNumber;
    //   });
    // } else {
    //   // widget.reader.transformationController.removeListener(_yourListenerMethod);
    // }
  }

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
    currentWidget = ValueNotifier(Container());
    currentPageIndex = ValueNotifier(0);
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
        child: widget.children[i],
      );
      pages.add(child);
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
    if (_isForward == null ) {
      if (widget.isRightSwipe
          ? details.delta.dx < 0.0
          : details.delta.dx > 0.0) {
        _isForward = false;
      } else if (widget.isRightSwipe
          ? details.delta.dx > 0.2
          : details.delta.dx < -0.2) {
        _isForward = true;
      } else {
        _isForward = null;
      }
    }

    if (_isForward == true || pageNumber == 0) {
      final pageLength = pages.length;
      final pageSize = widget.lastPage != null ? pageLength : pageLength - 1;
      if (pageNumber != pageSize && !_isLastPage) {
        widget.isRightSwipe
            ? _controllers[pageNumber].value -= ratio
            : _controllers[pageNumber].value += ratio;
      }
    }
  }

  Future _onDragFinish() async {
    // if(widget.reader.pageScrollEnabled == true) return;
    if (_isForward != null) {
      if (_isForward == true) {
        if (!_isLastPage &&
            _controllers[pageNumber].value <= (widget.cutoffForward + 0.15)) {
          await nextPage();
        } else {
          if (!_isLastPage) {
            await _controllers[pageNumber].forward();
          }
        }
      } else {
        if (!_isFirstPage &&
            _controllers[pageNumber - 1].value >= widget.cutoffPrevious) {
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
    // if(widget.reader.pageScrollEnabled == false) return;
    Navigator.push(
        context,
        ReaderOptionRoute(
            widget: ReaderOptionsPage(
              reader: widget.reader,
              bloc: BlocProvider.of<ReaderBloc>(context),
              // currentPage:  widget.reader.currentPage,
            )));

    // _controllers[pageNumber].
    // if (_isForward != null) {
    //   if (_isForward == true) {
    //     if (!_isLastPage &&
    //         _controllers[pageNumber].value <= (widget.cutoffForward + 0.15)) {
    //       await nextPage();
    //     } else {
    //       if (!_isLastPage) {
    //         await _controllers[pageNumber].forward();
    //       }
    //     }
    //   } else {
    //     if (!_isFirstPage &&
    //         _controllers[pageNumber - 1].value >= widget.cutoffPrevious) {
    //       await previousPage();
    //     } else {
    //       if (_isFirstPage) {
    //         await _controllers[pageNumber].forward();
    //       } else {
    //         await _controllers[pageNumber - 1].reverse();
    //         if (!_isFirstPage) {
    //           await previousPage();
    //         }
    //       }
    //     }
    //   }
    // }
    //
    // _isForward = null;
    // currentPage.value = -1;
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
         currentPageIndex.value = pageNumber+1;
         currentWidget.value = pages[pageNumber+1];
         currentPage.value = pageNumber+1;
      } else {
        // if (_controllers[i].status == AnimationStatus.reverse) {
        //   _controllers[i].value = 1;
        //   _isForward = null;
        // }
      }

    }
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
        onTapUp: (details) {_onTap();},
        onPanDown: (details) {},
        onPanEnd: (details) {},
        onTapCancel: () {},
        // onHorizontalDragCancel:widget.reader.pageScrollEnabled==true?  _isForward = null:null,
        // onHorizontalDragUpdate: widget.reader.pageScrollEnabled==true? (details){_turnPage(details, dimens);}:null,
        // onHorizontalDragEnd: widget.reader.paeader.pageScrollEnabled==true?  _isForward = null:null,
        onHorizontalDragCancel:  _isForward = null,
        onHorizontalDragUpdate: (details)=> _turnPage(details, dimens),
        onHorizontalDragEnd:  (details)=>_onDragFinish(),

        child: Stack(
          fit: StackFit.expand,
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