import 'dart:async';
import 'dart:math';

import 'package:flutter/widgets.dart'
    hide InteractiveViewer, TransformationController;
import 'package:pdfx/src/renderer/has_pdf_support.dart';
import 'package:pdfx/src/renderer/interfaces/document.dart';
import 'package:pdfx/src/renderer/interfaces/page.dart';
import 'package:pdfx/src/viewer/base/base_pdf_builders.dart';
import 'package:pdfx/src/viewer/base/base_pdf_controller.dart';
import 'package:pdfx/src/viewer/interactive_viewer.dart';
import 'package:pdfx/src/viewer/wrappers/pdf_texture.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:vector_math/vector_math_64.dart' as math64;

export 'package:pdfx/src/viewer/pdf_page_image_provider.dart';
export 'package:photo_view/photo_view.dart';
export 'package:photo_view/photo_view_gallery.dart';

part 'pdf_controller_pinch.dart';
part 'pdf_view_pinch_builders.dart';

/// Widget for viewing PDF documents with pinch to zoom feature
class CustumPdfViewPinch extends StatefulWidget {
  const CustumPdfViewPinch({
    required this.controller,
    this.onPageChanged,
    this.onDocumentLoaded,
    this.onDocumentError,
    this.builders = const CustumPdfViewPinchBuilders<DefaultBuilderOptions>(
      options: DefaultBuilderOptions(),
    ),
    this.scrollDirection = Axis.vertical,
    this.padding = 10,
    this.backgroundDecoration = const BoxDecoration(),
    Key? key,
  }) : super(key: key);

  /// Padding for the every page.
  final double padding;

  /// Page management
  final CustumPdfControllerPinch controller;

  /// Called whenever the page in the center of the viewport changes
  final void Function(int page)? onPageChanged;

  /// Called when a document is loaded
  final void Function(PdfDocument document)? onDocumentLoaded;

  /// Called when a document loading error
  final void Function(Object error)? onDocumentError;

  /// Builders
  final CustumPdfViewPinchBuilders builders;

  /// Page turning direction
  final Axis scrollDirection;

  /// Pdf widget page background decoration
  final BoxDecoration? backgroundDecoration;

  /// Default page builder
  @override
  State<CustumPdfViewPinch> createState() => _CustumPdfViewPinchState();
}

class _CustumPdfViewPinchState extends State<CustumPdfViewPinch>
    with SingleTickerProviderStateMixin {
  CustumPdfControllerPinch get _controller => widget.controller;
  final List<_PdfPageState> _pages = [];
  final List<_PdfPageState> _pendedPageDisposes = [];
  Exception? _loadingError;
  Size? _lastViewSize;
  Timer? _realSizeUpdateTimer;
  Size? _docSize;
  final Map<int, double> _visiblePages = <int, double>{};

  late AnimationController _animController;
  Animation<Matrix4>? _animGoTo;

  bool _firstControllerAttach = true;
  bool _forceUpdatePagePreviews = true;

  double get _padding => widget.padding;

  @override
  void initState() {
    super.initState();
    if (UniversalPlatform.isWindows) {
      throw UnimplementedError(
          'PdfViewPinch not supported in Windows, usage PdfView instead');
    }
    _controller._attach(this);
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    widget.controller.loadingState.addListener(() {
      switch (widget.controller.loadingState.value) {
        case PdfLoadingState.loading:
          _pages.clear();
          break;
        case PdfLoadingState.success:
          widget.onDocumentLoaded?.call(widget.controller._document!);
          break;
        case PdfLoadingState.error:
          widget.onDocumentError?.call(_loadingError!);
          break;
      }

      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _controller._detach();
    _cancelLastRealSizeUpdate();
    _releasePages();
    _handlePendedPageDisposes();
    _controller.removeListener(_determinePagesToShow);
    _animController.dispose();
    super.dispose();
  }

  void _releasePages() {
    if (_pages.isEmpty) {
      return;
    }
    for (final p in _pages) {
      p.releaseTextures();
    }
    _pendedPageDisposes.addAll(_pages);
    _pages.clear();
  }

  void _handlePendedPageDisposes() {
    for (final p in _pendedPageDisposes) {
      p.releaseTextures();
    }
    _pendedPageDisposes.clear();
  }

  /// Go to the specified location by the matrix.
  Future<void> _goTo({
    Matrix4? destination,
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
  }) async {
    try {
      if (destination == null) {
        return;
      } // do nothing
      _animGoTo?.removeListener(_updateControllerMatrix);
      _animController.reset();
      _animGoTo = Matrix4Tween(begin: _controller.value, end: destination)
          .animate(_animController);
      _animGoTo!.addListener(_updateControllerMatrix);
      await _animController
          .animateTo(1.0, duration: duration, curve: curve)
          .orCancel;
    } on TickerCanceled {
      // expected
    }
  }

  void _updateControllerMatrix() {
    _controller.value = _animGoTo!.value;
  }

  void _reLayout(Size? viewSize) {
    if (_pages.isEmpty) {
      return;
    }
    // if (widget.params?.layoutPages == null) {
    _reLayoutDefault(viewSize!);
    // } else {
    // final contentSize =
    //     Size(viewSize!.width - _padding * 2, viewSize.height - _padding * 2);
    // final rects = widget.params!.layoutPages!(
    //     contentSize, _pages!.map((p) => p.pageSize).toList());
    // var allRect = Rect.fromLTWH(0, 0, viewSize.width, viewSize.height);
    // for (int i = 0; i < _pages!.length; i++) {
    //   final rect = rects[i].translate(_padding, _padding);
    //   _pages![i].rect = rect;
    //   allRect = allRect.expandToInclude(rect.inflate(_padding));
    // }
    // _docSize = allRect.size;
    // }
    _lastViewSize = viewSize;

    if (_firstControllerAttach) {
      _firstControllerAttach = false;

      Future.delayed(Duration.zero, () {
        // NOTE: controller should be associated
        // after first layout calculation finished.
        _controller
          ..addListener(_determinePagesToShow)
          .._setViewerState(this);
        // widget.params?.onViewerControllerInitialized?.call(_controller);

        if (mounted) {
          final initialPage = _controller.initialPage;
          if (initialPage != 1) {
            // final m =
            // // _controller.calculatePageFitMatrix(pageNumber: initialPage);
            // if (m != null) {
            //   _controller.value = m;
            // }
          }
          _forceUpdatePagePreviews = true;
          _determinePagesToShow();
        }
      });
      return;
    }

    _determinePagesToShow();
  }

  /// Default page layout logic that layouts pages vertically.
  void _reLayoutDefault(Size viewSize) {
    final maxWidth = _pages.fold<double>(
        0.0, (maxWidth, page) => max(maxWidth, page.pageSize.width));
    final ratio = (viewSize.width - _padding) / maxWidth;
    if (widget.scrollDirection == Axis.horizontal) {
      var left = _padding;
      for (int i = 0; i < _pages.length; i++) {
        final page = _pages[i];
        final w = page.pageSize.width * ratio;
        final h = page.pageSize.height * ratio;
        page.rect = Rect.fromLTWH(left, _padding, w, h);
        left += w + _padding;
      }
      _docSize = Size(left, viewSize.height);
    } else {
      var top = _padding;
      for (int i = 0; i < _pages.length; i++) {
        final page = _pages[i];
        final w = page.pageSize.width * ratio;
        final h = page.pageSize.height * ratio;
        page.rect = Rect.fromLTWH(_padding, top, w, h);
        top += h + _padding;
      }
      _docSize = Size(viewSize.width, top);
    }
  }

  /// Not to purge loaded page previews if they're "near"
  ///  from the current exposed view
  static const _extraBufferAroundView = 200.0;

  void _determinePagesToShow() {
    if (_lastViewSize == null || _pages.isEmpty) {
      return;
    }
    final m = _controller.value;
    final r = m.row0[0];
    final exposed = Rect.fromLTWH(
        -m.row0[3], -m.row1[3], _lastViewSize!.width, _lastViewSize!.height);
    var pagesToUpdate = 1;
    var changeCount = 0;
    _visiblePages.clear();
    _visiblePages[_controller.page];
    // for (final page in _pages) {
    //   if (page.rect == null) {
    //     page.isVisibleInsideView = false;
    //     continue;
    //   }
    //   final pageRectZoomed = Rect.fromLTRB(page.rect!.left * r, page.rect!.top * r, page.rect!.right * r, page.rect!.bottom * r);
    //   final part = pageRectZoomed.intersect(exposed);
    //   final isVisible = !part.isEmpty;
    //   if (isVisible) {
    //     _visiblePages[page.pageNumber] = part.width * part.height;
    //   }
    //   if (page.isVisibleInsideView != isVisible) {
    //     page.isVisibleInsideView = isVisible;
    //     changeCount++;
    //     if (isVisible) {
    //       pagesToUpdate++; // the page gets inside the view
    //     }
    //   }
    // }

    _cancelLastRealSizeUpdate();

    if (changeCount > 0) {
      _needReLayout();
    }
    if (pagesToUpdate > 0 || _forceUpdatePagePreviews) {
      _needPagePreviewGeneration();
    } else {
      _needRealSizeOverlayUpdate();
    }
  }

  void _needReLayout() {
    Future.delayed(Duration.zero, () => setState(() {}));
  }

  void _needPagePreviewGeneration() {
    Future.delayed(Duration.zero, _updatePageState);
  }

  Future<void> _updatePageState() async {
    if (_pages.isEmpty) {
      return;
    }
    _forceUpdatePagePreviews = false;
    for (final page in _pages) {
      if (page.rect == null) {
        continue;
      }
      final m = _controller.value;
      final r = m.row0[0];
      final exposed = Rect.fromLTWH(-m.row0[3], -m.row1[3],
              _lastViewSize!.width, _lastViewSize!.height)
          .inflate(_extraBufferAroundView);

      final pageRectZoomed = Rect.fromLTRB(page.rect!.left * r,
          page.rect!.top * r, page.rect!.right * r, page.rect!.bottom * r);
      final part = pageRectZoomed.intersect(exposed);
      if (part.isEmpty) {
        continue;
      }

      if (page.status == _PdfPageLoadingStatus.notInitialized) {
        page
          ..status = _PdfPageLoadingStatus.initializing
          ..pdfPage = await _controller._document!.getPage(
            page.pageNumber,
            autoCloseAndroid: true,
          );
        final prevPageSize = page.pageSize;
        page
          ..pageSize = Size(page.pdfPage.width, page.pdfPage.height)
          ..status = _PdfPageLoadingStatus.initialized;
        if (prevPageSize != page.pageSize && mounted) {
          _reLayout(_lastViewSize);
          return;
        }
      }
      if (page.status == _PdfPageLoadingStatus.initialized) {
        page
          ..status = _PdfPageLoadingStatus.pageLoading
          ..preview = await page.pdfPage.createTexture();
        final w = page.pdfPage.width; // * 2;
        final h = page.pdfPage.height; // * 2

        await page.preview!.updateRect(
          documentId: _controller._document!.id,
          width: w.toInt(),
          height: h.toInt(),
          textureWidth: w.toInt(),
          textureHeight: h.toInt(),
          fullWidth: w,
          fullHeight: h,
          allowAntiAliasing: true,
          backgroundColor: '#ffffff',
        );

        page..status = _PdfPageLoadingStatus.pageLoaded;
        // ..updatePreview();
      }
    }

    _needRealSizeOverlayUpdate();
  }

  Future<void> _updateRealSizeOverlay() async {
    if (_pages.isEmpty) {
      return;
    }

    const fullPurgeDistThreshold = 33;
    const partialRemovalDistThreshold = 8;

    final dpr = MediaQuery.of(context).devicePixelRatio;
    final m = _controller.value;
    final r = m.row0[0];
    final exposed = Rect.fromLTWH(
        -m.row0[3], -m.row1[3], _lastViewSize!.width, _lastViewSize!.height);
    final distBase = max(_lastViewSize!.height, _lastViewSize!.width);
    for (final page in _pages) {
      if (page.rect == null ||
          page.status != _PdfPageLoadingStatus.pageLoaded) {
        continue;
      }
      final pageRectZoomed = Rect.fromLTRB(page.rect!.left * r,
          page.rect!.top * r, page.rect!.right * r, page.rect!.bottom * r);
      final part = pageRectZoomed.intersect(exposed);
      if (part.isEmpty) {
        final dist = (exposed.center - pageRectZoomed.center).distance;
        if (dist > distBase * fullPurgeDistThreshold) {
          page.releaseTextures();
        } else if (dist > distBase * partialRemovalDistThreshold) {
          page.releaseRealSize();
        }
        continue;
      }
      final fw = pageRectZoomed.width * dpr;
      final fh = pageRectZoomed.height * dpr;
      if (page.preview?.hasUpdatedTexture == true &&
          fw <= page.preview!.textureWidth! &&
          fh <= page.preview!.textureHeight!) {
        // no real-size overlay needed; use preview
        page.realSizeOverlayRect = null;
      } else {
        // render real-size overlay
        final offset = part.topLeft - pageRectZoomed.topLeft;
        page
          ..realSizeOverlayRect = Rect.fromLTWH(
            offset.dx / r,
            offset.dy / r,
            part.width / r,
            part.height / r,
          )
          ..realSize ??= await page.pdfPage.createTexture();
        final w = (part.width * dpr).toInt();
        final h = (part.height * dpr).toInt();
        await page.realSize!.updateRect(
          documentId: _controller._document!.id,
          width: w,
          height: h,
          sourceX: (offset.dx * dpr).toInt(),
          sourceY: (offset.dy * dpr).toInt(),
          textureWidth: w,
          textureHeight: h,
          fullWidth: fw,
          fullHeight: fh,
          allowAntiAliasing: true,
          backgroundColor: '#ffffff',
        );
        page._updateRealSizeOverlay();
      }
    }
  }

  void _cancelLastRealSizeUpdate() {
    if (_realSizeUpdateTimer != null) {
      _realSizeUpdateTimer!.cancel();
      _realSizeUpdateTimer = null;
    }
  }

  final _realSizeOverlayUpdateBufferDuration =
      const Duration(milliseconds: 100);

  void _needRealSizeOverlayUpdate() {
    _cancelLastRealSizeUpdate();
    // Using Timer as cancellable version of [Future.delayed]
    _realSizeUpdateTimer =
        Timer(_realSizeOverlayUpdateBufferDuration, _updateRealSizeOverlay);
  }

  @override
  Widget build(BuildContext context) {
    return widget.builders.builder(
      context,
      widget.builders,
      _controller.loadingState.value,
      _buildLoaded,
      widget.controller._document,
      _loadingError,
    );
  }

  static Widget _builder(
    BuildContext context,
    CustumPdfViewPinchBuilders builders,
    PdfLoadingState state,
    WidgetBuilder loadedBuilder,
    PdfDocument? document,
    Exception? loadingError,
  ) {
    final Widget content = () {
      switch (state) {
        case PdfLoadingState.loading:
          return KeyedSubtree(
            key: const Key('pdfx.root.loading'),
            child: builders.documentLoaderBuilder?.call(context) ??
                const SizedBox(),
          );
        case PdfLoadingState.error:
          return KeyedSubtree(
            key: const Key('pdfx.root.error'),
            child: builders.errorBuilder?.call(context, loadingError!) ??
                Center(child: Text(loadingError.toString())),
          );
        case PdfLoadingState.success:
          return KeyedSubtree(
            key: Key('pdfx.root.success.${document!.id}'),
            child: loadedBuilder(context),
          );
      }
    }();

    final defaultBuilder =
        builders as CustumPdfViewPinchBuilders<DefaultBuilderOptions>;
    final options = defaultBuilder.options;

    return AnimatedSwitcher(
      duration: options.loaderSwitchDuration,
      transitionBuilder: options.transitionBuilder,
      child: content,
    );
  }

  Widget _buildLoaded(BuildContext context) {
    Future.microtask(_handlePendedPageDisposes);
    return LayoutBuilder(
      builder: (context, constraints) {
        final viewSize = Size(constraints.maxWidth, constraints.maxHeight);
        _reLayout(viewSize);
        final docSize = _docSize ?? const Size(10, 10); // dummy size
        return InteractiveViewer(
          transformationController: _controller,
          scrollControls: InteractiveViewerScrollControls.scrollPans,
          constrained: false,
          alignPanAxis: false,
          boundaryMargin: EdgeInsets.zero,
          minScale: 1.0,
          maxScale: 20,
          panEnabled: true,
          scaleEnabled: true,
          child: SafeArea(
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: <Widget>[
                Container(
                    color: Color.fromARGB(255, 239, 16, 255),
                    child: SizedBox(
                        width: docSize.width,
                        // width: MediaQuery.of(context).size.width - (2 * MediaQuery.of(context).padding.left),
//                           // width: MediaQuery.of(context).size.width,
//                           // height: docSize.height - 2 * MediaQuery.of(context).padding.top - 100)
                        height: MediaQuery.of(context).size.height -
                            (2 * MediaQuery.of(context).padding.top))),
                ...iterateLaidOutPages(viewSize)
              ],
            ),
          ),
        );
      },
    );
  }

  Iterable<Widget> iterateLaidOutPages(Size viewSize) sync* {
    if (!_firstControllerAttach && _pages.isNotEmpty) {
      final m = _controller.value;
      final r = m.row0[0];
      final exposed =
          Rect.fromLTWH(-m.row0[3], -m.row1[3], viewSize.width, viewSize.height)
              .inflate(_padding);

      for (final page in _pages) {
        if (page.rect == null) {
          continue;
        }
        final pageRectZoomed = Rect.fromLTRB(page.rect!.left * r,
            page.rect!.top * r, page.rect!.right * r, page.rect!.bottom * r);
        final part = pageRectZoomed.intersect(exposed);
        page.isVisibleInsideView = !part.isEmpty;
        if (!page.isVisibleInsideView) {
          continue;
        }

        yield Positioned(
          left: page.rect!.left,
          // left: (MediaQuery.of(context).size.width - page.rect!.width) / 2,
          top: page.rect!.top,
          width: page.rect!.width,
          height: page.rect!.height,
          child: Container(
            width: page.rect!.width,
            height: page.rect!.height,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 250, 250, 250),
              boxShadow: [
                BoxShadow(
                  color: Color(0x73000000),
                  blurRadius: 4,
                  offset: Offset(2, 2),
                ),
              ],
            ),
            child: Stack(
              children: [
                ValueListenableBuilder<int>(
                  valueListenable: page._previewNotifier,
                  builder: (context, value, child) => page.preview != null
                      ? Positioned.fill(
                          child: PdfTexture(textureId: page.preview!.id),
                        )
                      : Container(),
                ),
                ValueListenableBuilder<int>(
                  valueListenable: page._realSizeNotifier,
                  builder: (context, value, child) =>
                      page.realSizeOverlayRect != null && page.realSize != null
                          ? Positioned(
                              left: page.realSizeOverlayRect!.left,
                              top: page.realSizeOverlayRect!.top,
                              width: page.realSizeOverlayRect!.width,
                              height: page.realSizeOverlayRect!.height,
                              child: PdfTexture(textureId: page.realSize!.id),
                            )
                          : Container(),
                ),
              ],
            ),
          ),
        );
      }
    }
  }
}

// import 'dart:async';
// import 'dart:math';
//
// import 'package:flutter/widgets.dart' hide InteractiveViewer, TransformationController;
// import 'package:pdfx/src/renderer/has_pdf_support.dart';
// import 'package:pdfx/src/renderer/interfaces/document.dart';
// import 'package:pdfx/src/renderer/interfaces/page.dart';
// import 'package:pdfx/src/viewer/base/base_pdf_builders.dart';
// import 'package:pdfx/src/viewer/base/base_pdf_controller.dart';
// import 'package:pdfx/src/viewer/interactive_viewer.dart';
// import 'package:pdfx/src/viewer/wrappers/pdf_texture.dart';
// import 'package:sharemagazines_flutter/src/presentation/pages/reader/readeroptionspage.dart';
// import 'package:universal_platform/universal_platform.dart';
// import 'package:vector_math/vector_math_64.dart' as math64;
//
// export 'package:pdfx/src/viewer/pdf_page_image_provider.dart';
// export 'package:photo_view/photo_view.dart';
// export 'package:photo_view/photo_view_gallery.dart';
//
// part 'pdf_controller_pinch.dart';
// part 'pdf_view_pinch_builders.dart';
//
// /// Widget for viewing PDF documents with pinch to zoom feature
// class CustumPdfViewPinch extends StatefulWidget {
//   const CustumPdfViewPinch({
//     required this.controller,
//     this.onPageChanged,
//     this.onDocumentLoaded,
//     this.onDocumentError,
//     this.builders = const CustumPdfViewPinchBuilders<DefaultBuilderOptions>(
//       options: DefaultBuilderOptions(),
//     ),
//     this.scrollDirection = Axis.horizontal,
//     // this.padding = 10,
//     this.padding = 0,
//     this.backgroundDecoration = const BoxDecoration(),
//     Key? key,
//   }) : super(key: key);
//
//   /// Padding for the every page.
//   final double padding;
//
//   /// Page management
//   final CustumPdfControllerPinch controller;
//
//   /// Called whenever the page in the center of the viewport changes
//   final void Function(int page)? onPageChanged;
//
//   /// Called when a document is loaded
//   final void Function(PdfDocument document)? onDocumentLoaded;
//
//   /// Called when a document loading error
//   final void Function(Object error)? onDocumentError;
//
//   /// Builders
//   final CustumPdfViewPinchBuilders builders;
//
//   /// Page turning direction
//   final Axis scrollDirection;
//
//   /// Pdf widget page background decoration
//   final BoxDecoration? backgroundDecoration;
//
//   /// Default page builder
//   @override
//   State<CustumPdfViewPinch> createState() => _CustumPdfViewPinchState();
// }
//
// class _CustumPdfViewPinchState extends State<CustumPdfViewPinch> with SingleTickerProviderStateMixin {
//   CustumPdfControllerPinch get _controller => widget.controller;
//   final List<_PdfPageState> _pages = [];
//   // final _PdfPageState _page ;
//   final List<_PdfPageState> _pendedPageDisposes = [];
//   Exception? _loadingError;
//   Size? _lastViewSize;
//   Timer? _realSizeUpdateTimer;
//   Size? _docSize;
//   // Size? _pageSize;//instead of _docSize
//   // final Map<int, double> _visiblePages = <int, double>{};
//
//   late AnimationController _animController;
//   Animation<Matrix4>? _animGoTo;
//
//   bool _firstControllerAttach = true;
//   bool _forceUpdatePagePreviews = true;
//
//   double get _padding => widget.padding;
//
//   @override
//   void initState() {
//     super.initState();
//     if (UniversalPlatform.isWindows) {
//       throw UnimplementedError('PdfViewPinch not supported in Windows, usage PdfView instead');
//     }
//     _controller._attach(this);
//     _animController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 200),
//     );
//     widget.controller.loadingState.addListener(() {
//       switch (widget.controller.loadingState.value) {
//         case PdfLoadingState.loading:
//           _pages.clear();
//           break;
//         case PdfLoadingState.success:
//           widget.onDocumentLoaded?.call(widget.controller._document!);
//           break;
//         case PdfLoadingState.error:
//           widget.onDocumentError?.call(_loadingError!);
//           break;
//       }
//
//       if (mounted) {
//         setState(() {});
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     _controller._detach();
//     _cancelLastRealSizeUpdate();
//     _releasePages();
//     _handlePendedPageDisposes();
//     _controller.removeListener(_determinePagesToShow);
//     _animController.dispose();
//     super.dispose();
//   }
//
//   void _releasePages() {
//     if (_pages.isEmpty) {
//       return;
//     }
//     for (final p in _pages) {
//       p.releaseTextures();
//     }
//     _pendedPageDisposes.addAll(_pages);
//     _pages.clear();
//   }
//
//   void _handlePendedPageDisposes() {
//     for (final p in _pendedPageDisposes) {
//       p.releaseTextures();
//     }
//     _pendedPageDisposes.clear();
//   }
//
//   /// Go to the specified location by the matrix.
//   // Future<void> _goTo({
//   //   Matrix4? destination,
//   //   Duration duration = const Duration(milliseconds: 30),
//   //   Curve curve = Curves.easeInOut,
//   // }) async {
//   //   try {
//   //     if (destination == null) {
//   //       return;
//   //     } // do nothing
//   //     _animGoTo?.removeListener(_updateControllerMatrix);
//   //     _animController.reset();
//   //     _animGoTo = Matrix4Tween(begin: _controller.value, end: destination).animate(_animController);
//   //     _animGoTo!.addListener(_updateControllerMatrix);
//   //     await _animController.animateTo(1.0, duration: duration, curve: curve).orCancel;
//   //   } on TickerCanceled {
//   //     // expected
//   //   }
//   // }
//
//   void _updateControllerMatrix() {
//     // _controller.value = _animGoTo!.value;
//   }
//
//   void _reLayout(Size? viewSize, int pgNumber_reLayout) {
//     // void _reLayout(Size? viewSize) {
//     // print("_reLayout");
//     if (_pages.isEmpty) {
//       return;
//     }
//     // if (widget.params?.layoutPages == null) {
//     _reLayoutDefault(viewSize!, pgNumber_reLayout);
//     // } else {
//     // final contentSize =
//     //     Size(viewSize!.width - _padding * 2, viewSize.height - _padding * 2);
//     // final rects = widget.params!.layoutPages!(
//     //     contentSize, _pages!.map((p) => p.pageSize).toList());
//     // var allRect = Rect.fromLTWH(0, 0, viewSize.width, viewSize.height);
//     // for (int i = 0; i < _pages!.length; i++) {
//     //   final rect = rects[i].translate(_padding, _padding);
//     //   _pages![i].rect = rect;
//     //   allRect = allRect.expandToInclude(rect.inflate(_padding));
//     // }
//     // _docSize = allRect.size;
//     // }
//     _lastViewSize = viewSize;
//
//     if (_firstControllerAttach) {
//       _firstControllerAttach = false;
//
//       Future.delayed(Duration.zero, () {
//         // NOTE: controller should be associated
//         // after first layout calculation finished.
//         _controller
//           ..addListener(_determinePagesToShow)
//           .._setViewerState(this);
//         // widget.params?.onViewerControllerInitialized?.call(_controller);
//
//         // if (mounted) {
//         //   final initialPage = _controller.initialPage;
//         //   if (initialPage != 1) {
//         // final m = _controller.calculatePageFitMatrix(pageNumber: initialPage);
//         // if (m != null) {
//         //   _controller.value = m;
//         // }
//         // }
//         // _forceUpdatePagePreviews = true;
//         // _determinePagesToShow();
//         // }
//       });
//       return;
//     }
//
//     _determinePagesToShow();
//   }
//
//   /// Default page layout logic that layouts pages vertically.
//   void _reLayoutDefault(Size viewSize, int pgNumber_reLayoutDefault) {
//     // void _reLayoutDefault(Size viewSize) {
//     // print("_reLayoutDefault");
//     final maxWidth = _pages.fold<double>(0.0, (maxWidth, page) => max(maxWidth, page.pageSize.width));
//     final ratio = (viewSize.width - _padding) / maxWidth;
//     if (widget.scrollDirection == Axis.horizontal) {
//       var left = _padding;
//       // // for (int i = 0; i < _pages.length; i++) {
//       // final page = _pages[pgNumber_reLayoutDefault];
//       // final w = page.pageSize.width * ratio;
//       // final h = page.pageSize.height * ratio;
//       // // final h = page.pageSize.height;
//       // page.rect = Rect.fromLTWH(left, _padding, w, h);
//       // left += w + _padding;
//       //
//       // _docSize = Size(left, viewSize.height - 100);
//       for (int i = 0; i < _pages.length; i++) {
//         final page = _pages[i];
//         final w = page.pageSize.width * ratio;
//         final h = page.pageSize.height * ratio;
//         page.rect = Rect.fromLTWH(left, _padding, w, h);
//         left += w + _padding;
//       }
//       _docSize = Size(left, viewSize.height);
//       // _docSize = Size(left - (2 * MediaQuery.of(context).padding.left), _pages[0].pageSize.height * ratio);
//       // for (int i = 0; i < _pages.length; i++) {}
//       // for (int i = 2; i < 3; i++) {
//       //   final page = _pages[i];
//       //   final w = page.pageSize.width * ratio;
//       //   final h = page.pageSize.height * ratio;
//       //   // final h = page.pageSize.height;
//       //   page.rect = Rect.fromLTWH(left, _padding, w, h);
//       //   // left += w + _padding;
//       // }
//       // _docSize = Size(left, _pages[0].pageSize.height);
//       // _docSize = Size(left, viewSize.height);
//     } else {
//       var top = _padding;
//       for (int i = 0; i < _pages.length; i++) {
//         final page = _pages[i];
//         final w = page.pageSize.width * ratio;
//         final h = page.pageSize.height * ratio;
//         page.rect = Rect.fromLTWH(_padding, top, w, h);
//         top += h + _padding;
//       }
//       _docSize = Size(viewSize.width, top);
//     }
//   }
//
//   /// Not to purge loaded page previews if they're "near"
//   ///  from the current exposed view
//   static const _extraBufferAroundView = 200.0;
//
//   void _determinePagesToShow() {
//     // print("_determinePagesToShow");
//     if (_lastViewSize == null || _pages.isEmpty) {
//       print("_determinePagesToShow return");
//       return;
//     }
//     final m = _controller.value;
//     final r = m.row0[0];
//     final exposed = Rect.fromLTWH(-m.row0[3], -m.row1[3], _lastViewSize!.width, _lastViewSize!.height);
//
//     var changeCount = 0;
//     // _visiblePages.clear();
//     // for (final page in _pages) {
//     //   if (page.rect == null) {
//     //     // page.isVisibleInsideView = false;
//     //     continue;
//     //   }
//     //   final pageRectZoomed = Rect.fromLTRB(page.rect!.left * r, (page.rect!.top) * r, page.rect!.right * r, page.rect!.bottom * r);
//     //   final part = pageRectZoomed.intersect(exposed);
//     //   // final isVisible = !part.isEmpty;
//     //   // if (isVisible) {
//     //   //   _visiblePages[page.pageNumber] = part.width * part.height;
//     //   // }
//     //   // if (page.isVisibleInsideView != isVisible) {
//     //   //   page.isVisibleInsideView = isVisible;
//     //   //   changeCount++;
//     //   //   if (isVisible) {
//     //   //     pagesToUpdate++; // the page gets inside the view
//     //   //   }
//     //   // }
//     // }
//
//     _cancelLastRealSizeUpdate();
//
//     // if (changeCount > 0) {
//     //   // _needReLayout();
//     // }
//     if (_forceUpdatePagePreviews) {
//       _needPagePreviewGeneration();
//     } else {
//       _needRealSizeOverlayUpdate();
//     }
//   }
//
//   void _needReLayout() {
//     Future.delayed(Duration.zero, () => setState(() {}));
//   }
//
//   void _needPagePreviewGeneration() {
//     Future.delayed(Duration.zero, _updatePageState);
//   }
//
//   Future<void> _updatePageState() async {
//     // print("_updatePageState");
//     if (_pages.isEmpty) {
//       return;
//     }
//     _forceUpdatePagePreviews = false;
//     for (final page in _pages) {
//       if (page.rect == null) {
//         continue;
//       }
//       // final m = _controller.value;
//       // final r = m.row0[0];
//       // final exposed = Rect.fromLTWH(-m.row0[3], -m.row1[3] - 200, _lastViewSize!.width, _lastViewSize!.height).inflate(_extraBufferAroundView);
//       //
//       // final pageRectZoomed = Rect.fromLTRB(page.rect!.left * r, page.rect!.top * r, page.rect!.right * r, page.rect!.bottom * r);
//       // final part = pageRectZoomed.intersect(exposed);
//       // if (part.isEmpty) {
//       //   continue;
//       // }
//
//       if (page.status == _PdfPageLoadingStatus.notInitialized) {
//         page
//           ..status = _PdfPageLoadingStatus.initializing
//           ..pdfPage = await _controller._document!.getPage(
//             page.pageNumber,
//             autoCloseAndroid: true,
//           );
//         final prevPageSize = page.pageSize;
//         page
//           ..pageSize = Size(page.pdfPage.width, page.pdfPage.height)
//           ..status = _PdfPageLoadingStatus.initialized;
//         // if (prevPageSize != page.pageSize && mounted) {
//         //   _reLayout(_lastViewSize);
//         //   return;
//         // }
//       }
//       if (page.status == _PdfPageLoadingStatus.initialized) {
//         page
//           ..status = _PdfPageLoadingStatus.pageLoading
//           ..preview = await page.pdfPage.createTexture();
//         final w = page.pdfPage.width; // * 2;
//         final h = page.pdfPage.height; // * 2;
//
//         // await page.preview!.updateRect(
//         //   // destinationY: -100,
//         //   documentId: _controller._document!.id,
//         //   width: w.toInt(),
//         //   height: h.toInt(),
//         //   textureWidth: w.toInt(),
//         //   textureHeight: h.toInt(),
//         //   fullWidth: w,
//         //   fullHeight: h,
//         //   allowAntiAliasing: true,
//         //   backgroundColor: '#ffffff',
//         //   // backgroundColor: '#7FFF00',
//         // );
//
//         page..status = _PdfPageLoadingStatus.pageLoaded
//             // ..updatePreview()
//             ;
//       }
//     }
//
//     _needRealSizeOverlayUpdate();
//   }
//
//   Future<void> _updateRealSizeOverlay() async {
//     print("_updateRealSizeOverlay");
//
//     if (_pages.isEmpty) {
//       return;
//     }
//
//     const fullPurgeDistThreshold = 33;
//     const partialRemovalDistThreshold = 8;
//
//     final dpr = MediaQuery.of(context).devicePixelRatio;
//     final m = _controller.value;
//     final r = m.row0[0];
//     print(r);
//     // print(m);
//     // print("sdfs ${m.row0[3]} ${_lastViewSize!.height}");
//     final exposed = Rect.fromLTWH(-m.row0[3], -m.row1[3], _lastViewSize!.width, _lastViewSize!.height);
//     final distBase = max(_lastViewSize!.height, _lastViewSize!.width);
//     for (final page in _pages) {
//       if (page.rect == null || page.status != _PdfPageLoadingStatus.pageLoaded) {
//         continue;
//       }
//       final pageRectZoomed = Rect.fromLTRB(page.rect!.left * r, (page.rect!.top + ((_lastViewSize!.height - page.rect!.height) / 2)) * r, page.rect!.right * r,
//           (page.rect!.bottom + ((_lastViewSize!.height - page.rect!.height) / 2)) * r);
//       // final pageRectZoomed = Rect.fromLTRB(page.rect!.left * r, page.rect!.top * r + ((_lastViewSize!.height - page.rect!.height) / 2), page.rect!.right * r, page.rect!.bottom * r);
//       final part = pageRectZoomed.intersect(exposed);
//       // print("sdvsv $part ${(_lastViewSize!.height - page.rect!.height) / 2}");
//       if (part.isEmpty) {
//         final dist = (exposed.center - pageRectZoomed.center).distance;
//         if (dist > distBase * fullPurgeDistThreshold) {
//           page.releaseTextures();
//         } else if (dist > distBase * partialRemovalDistThreshold) {
//           page.releaseRealSize();
//         }
//         continue;
//       }
//       final fw = pageRectZoomed.width * dpr;
//       final fh = pageRectZoomed.height * dpr;
//       if (page.preview?.hasUpdatedTexture == true && fw <= page.preview!.textureWidth! && fh <= page.preview!.textureHeight!) {
//         // no real-size overlay needed; use preview
//         page.realSizeOverlayRect = null;
//       } else {
//         // render real-size overlay
//         final offset = part.topLeft - pageRectZoomed.topLeft;
//         // final offset = Offset(0, 200);
//         page
//           ..realSizeOverlayRect = Rect.fromLTWH(
//             offset.dx / r,
//             offset.dy / r,
//             part.width / r,
//             part.height / r,
//           )
//           ..realSize ??= await page.pdfPage.createTexture();
//         final w = (part.width * dpr).toInt();
//         final h = (part.height * dpr).toInt();
//         await page.realSize!.updateRect(
//           documentId: _controller._document!.id,
//           width: w,
//           height: h,
//           sourceX: (offset.dx * dpr).toInt(),
//           sourceY: (offset.dy * dpr).toInt(),
//           textureWidth: w,
//           textureHeight: h,
//           fullWidth: fw,
//           fullHeight: fh,
//           allowAntiAliasing: true,
//           backgroundColor: '#ffffff', //blue
//           // backgroundColor: '#00FFFF', //blue
//         );
//         page._updateRealSizeOverlay();
//       }
//     }
//   }
//
//   void _cancelLastRealSizeUpdate() {
//     if (_realSizeUpdateTimer != null) {
//       _realSizeUpdateTimer!.cancel();
//       _realSizeUpdateTimer = null;
//     }
//   }
//
//   final _realSizeOverlayUpdateBufferDuration = const Duration(milliseconds: 100);
//   // final _realSizeOverlayUpdateBufferDuration = const Duration(milliseconds: 10);
//
//   void _needRealSizeOverlayUpdate() {
//     // print("_needRealSizeOverlayUpdate");
//     _cancelLastRealSizeUpdate();
//     // Using Timer as cancellable version of [Future.delayed]
//     _realSizeUpdateTimer = Timer(_realSizeOverlayUpdateBufferDuration, _updateRealSizeOverlay);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return widget.builders.builder(
//       context,
//       widget.builders,
//       _controller.loadingState.value,
//       _buildLoaded,
//       widget.controller._document,
//       _loadingError,
//     );
//   }
//
//   static Widget _builder(
//     BuildContext context,
//     CustumPdfViewPinchBuilders builders,
//     PdfLoadingState state,
//     WidgetBuilder loadedBuilder,
//     PdfDocument? document,
//     Exception? loadingError,
//   ) {
//     final Widget content = () {
//       switch (state) {
//         case PdfLoadingState.loading:
//           return KeyedSubtree(
//             key: const Key('pdfx.root.loading'),
//             child: builders.documentLoaderBuilder?.call(context) ?? const SizedBox(),
//           );
//         case PdfLoadingState.error:
//           return KeyedSubtree(
//             key: const Key('pdfx.root.error'),
//             child: builders.errorBuilder?.call(context, loadingError!) ?? Center(child: Text(loadingError.toString())),
//           );
//         case PdfLoadingState.success:
//           return KeyedSubtree(
//             key: Key('pdfx.root.success.${document!.id}'),
//             child: loadedBuilder(context),
//           );
//       }
//     }();
//
//     final defaultBuilder = builders as CustumPdfViewPinchBuilders<DefaultBuilderOptions>;
//     final options = defaultBuilder.options;
//
//     return AnimatedSwitcher(
//       duration: options.loaderSwitchDuration,
//       transitionBuilder: options.transitionBuilder,
//       child: content,
//     );
//   }
//
//   Widget _buildLoaded(BuildContext context) {
//     Future.microtask(_handlePendedPageDisposes);
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         final viewSize = Size(constraints.maxWidth, constraints.maxHeight);
//         // _reLayout(viewSize, _controller.currentPageNumber);
//         _reLayout(viewSize, _controller.page);
//         final docSize = _docSize ?? const Size(10, 10); // dummy size
//         return InteractiveViewer(
//           transformationController: _controller,
//           // scrollControls: InteractiveViewerScrollControls.scrollScales,
//           scrollControls: InteractiveViewerScrollControls.scrollPans,
//           constrained: true,
//           alignPanAxis: false,
//           boundaryMargin: EdgeInsets.zero,
//           minScale: 1.0,
//           maxScale: 20.0,
//           panEnabled: true,
//           scaleEnabled: true,
//           // onInteractionEnd: (scaleEndDetails) {
//           //   double scale = _controller.value.getMaxScaleOnAxis();
//           //
//           //   if (widget.onScaleChanged != null) {
//           //     widget.onScaleChanged!(scale);
//           //   }
//           // },
//           child: SafeArea(
//             child: Stack(
//               alignment: AlignmentDirectional.center,
//               children: <Widget>[
//                 Container(
//                     color: Color.fromARGB(255, 239, 16, 255),
//                     child: SizedBox(
//                         width: docSize.width + 100,
//                         // width: MediaQuery.of(context).size.width - (2 * MediaQuery.of(context).padding.left),
//                         // width: MediaQuery.of(context).size.width,
//                         // height: docSize.height - 2 * MediaQuery.of(context).padding.top - 100)
//                         height: MediaQuery.of(context).size.height - (2 * MediaQuery.of(context).padding.top))),
//                 // height: MediaQuery.of(context).size.height)),
//                 // height: MediaQuery.of(context).size.height )),
//
//                 ...iterateLaidOutPages(docSize)
//                 // layOutPage(docSize, _controller.page)
//
//                 // layOutPage(docSize, 0)
//               ],
//               // children: <Widget>[
//               //   // Container(
//               //   //   color: Color.fromARGB(255, 145, 199, 116),
//               //   //   height: MediaQuery.of(context).size.height,
//               //   //   width: 400,
//               //   // ),
//               //   Container(
//               //     alignment: Alignment.center,
//               //     color: Color.fromARGB(255, 175, 27, 110),
//               //     // height: viewSize.height,
//               //     height: MediaQuery.of(context).size.height,
//               //     width: MediaQuery.of(context).size.width,
//               //   ),
//               //   ...iterateLaidOutPages(viewSize)
//               // ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   Iterable<Widget> iterateLaidOutPages(Size viewSize) sync* {
//     print("safearea ${MediaQuery.of(context).padding.top}");
//     if (!_firstControllerAttach && _pages.isNotEmpty) {
//       final m = _controller.value;
//       final r = m.row0[0];
//       final exposed = Rect.fromLTWH(-m.row0[3], -m.row1[3], viewSize.width, viewSize.height).inflate(_padding);
//       // _pages[2].isVisibleInsideView = false;
//       _pages[_controller.page].isVisibleInsideView = true;
//       // _pages[_controller.page + 1].isVisibleInsideView = true;
//       for (final page in _pages) {
//         if (page.rect == null) {
//           continue;
//         }
//         final pageRectZoomed = Rect.fromLTRB(page.rect!.left * r, page.rect!.top * r, page.rect!.right + 100 * r, page.rect!.bottom * r);
//         final part = pageRectZoomed.intersect(exposed);
//         // page.isVisibleInsideView = !part.isEmpty;
//
//         if (!page.isVisibleInsideView) {
//           continue;
//         }
//
//         yield Positioned(
//           // left: page.rect!.left,
//           left: (MediaQuery.of(context).size.width - page.rect!.width) / 2,
//
//           // top: page.rect!.top,
//           // top: (viewSize.height - page.rect!.height - 2 * MediaQuery.of(context).padding.top) / 2,
//           top: (MediaQuery.of(context).size.height - page.rect!.height - 2 * MediaQuery.of(context).padding.top) / 2,
//
//           // top: (MediaQuery.of(context).size.height - page.rect!.height) / 2,
//           // top: 0,
//           width: page.rect!.width,
//           // width: MediaQuery.of(context).size.width,
//           height: page.rect!.height,
//           child: Container(
//             // width: page.rect!.width,
//             // height: page.rect!.height,
//             decoration: const BoxDecoration(
//               color: Color.fromARGB(0, 10, 48, 199),
//               boxShadow: [
//                 BoxShadow(
//                   color: Color(0x7300FF27),
//                   blurRadius: 4,
//                   offset: Offset(2, 2),
//                 ),
//               ],
//             ),
//             child: Stack(
//               // alignment: Alignment.center,
//               children: [
//                 // Positioned.fill(
//                 //   child: Image.asset("assets/images/Background.png"),
//                 // ),
//                 ValueListenableBuilder<int>(
//                   valueListenable: page._previewNotifier,
//                   builder: (context, value, child) => page.preview != null
//                       ? Positioned.fill(
//                           child: PdfTexture(textureId: page.preview!.id),
//                         )
//                       : Container(
//                           color: Color(0xFFFFFFFF),
//                         ),
//                 ),
//                 ValueListenableBuilder<int>(
//                   valueListenable: page._realSizeNotifier,
//                   builder: (context, value, child) => page.realSizeOverlayRect != null && page.realSize != null
//                       ? Positioned(
//                           left: page.realSizeOverlayRect!.left,
//                           top: page.realSizeOverlayRect!.top,
//                           // top: page.realSizeOverlayRect!.top - ((viewSize.height - page.rect!.height) / 2) + 10,
//                           width: page.realSizeOverlayRect!.width,
//                           height: page.realSizeOverlayRect!.height,
//                           child: PdfTexture(textureId: page.realSize!.id),
//                         )
//                       : Container(
//                           color: Color(0xFFFF0000),
//                         ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       }
//     }
//   }
//
//   // Widget layOutPage(Size viewSize, int pgNumber) {
//   //   print("safearea ${MediaQuery.of(context).padding.top}");
//   //   // if (!_firstControllerAttach && _pages.isNotEmpty) {
//   //   final m = _controller.value;
//   //   final r = m.row0[0];
//   //   final exposed = Rect.fromLTWH(-m.row0[3], -m.row1[3], viewSize.width, viewSize.height).inflate(_padding);
//   //
//   //   // for (final page in _pages) {
//   //   //   if (_pages[pgNumber].rect == null) {
//   //   //     continue;
//   //   //   }
//   //   final pageRectZoomed = Rect.fromLTRB(_pages[pgNumber].rect!.left * r, _pages[pgNumber].rect!.top * r, _pages[pgNumber].rect!.right * r, _pages[pgNumber].rect!.bottom * r);
//   //   final part = pageRectZoomed.intersect(exposed);
//   //   // _pages[pgNumber].isVisibleInsideView = !part.isEmpty;
//   //   // if (!_pages[pgNumber].isVisibleInsideView) {
//   //   //   continue;
//   //   // }
//   //
//   //   return Positioned(
//   //     // left: page.rect!.left,
//   //     left: (MediaQuery.of(context).size.width - _pages[pgNumber].rect!.width) / 2,
//   //
//   //     // top: page.rect!.top,
//   //     // top: (viewSize.height - page.rect!.height - 2 * MediaQuery.of(context).padding.top) / 2,
//   //     top: (MediaQuery.of(context).size.height - _pages[pgNumber].rect!.height - 2 * MediaQuery.of(context).padding.top) / 2,
//   //
//   //     // top: (MediaQuery.of(context).size.height - page.rect!.height) / 2,
//   //     // top: 0,
//   //     width: _pages[pgNumber].rect!.width,
//   //     // width: MediaQuery.of(context).size.width,
//   //     height: _pages[pgNumber].rect!.height,
//   //     child: Container(
//   //       // width: page.rect!.width,
//   //       // height: page.rect!.height,
//   //       decoration: const BoxDecoration(
//   //         color: Color.fromARGB(0, 10, 48, 199),
//   //         boxShadow: [
//   //           BoxShadow(
//   //             color: Color(0x73000000),
//   //             blurRadius: 4,
//   //             offset: Offset(2, 2),
//   //           ),
//   //         ],
//   //       ),
//   //       child: Stack(
//   //         // alignment: Alignment.center,
//   //         children: [
//   //           // Positioned.fill(
//   //           //   child: Image.asset("assets/images/Background.png"),
//   //           // ),
//   //           ValueListenableBuilder<int>(
//   //             valueListenable: _pages[pgNumber]._previewNotifier,
//   //             builder: (context, value, child) => _pages[pgNumber].preview != null
//   //                 ? Positioned.fill(
//   //                     child: PdfTexture(textureId: _pages[pgNumber].preview!.id),
//   //                   )
//   //                 : Container(
//   //                     color: Color(0x73EA1111),
//   //                   ),
//   //           ),
//   //           ValueListenableBuilder<int>(
//   //             valueListenable: _pages[pgNumber]._realSizeNotifier,
//   //             builder: (context, valuCustumPdfControllerPinche, child) => _pages[pgNumber].realSizeOverlayRect != null && _pages[pgNumber].realSize != null
//   //                 ? Positioned(
//   //                     left: _pages[pgNumber].realSizeOverlayRect!.left,
//   //                     top: _pages[pgNumber].realSizeOverlayRect!.top,
//   //                     // top: page.realSizeOverlayRect!.top - ((viewSize.height - page.rect!.height) / 2) + 10,
//   //                     width: _pages[pgNumber].realSizeOverlayRect!.width,
//   //                     height: _pages[pgNumber].realSizeOverlayRect!.height,
//   //                     child: PdfTexture(textureId: _pages[pgNumber].realSize!.id),
//   //                   )
//   //                 : Container(
//   //                     color: Color(0x73F8D20C),
//   //                   ),
//   //           ),
//   //         ],
//   //       ),
//   //     ),
//   //   );
//   //   // }
//   //   // }
//   // }
// }
