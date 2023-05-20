// Need static methods for builders arguments

import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';
import 'package:sharemagazines_flutter/src/presentation/pages/reader/pdf_view_pinch.dart';

class PDFWidget {
  static Widget builder(
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
            child: const SizedBox(),
          );
        case PdfLoadingState.error:
          return KeyedSubtree(
            key: const Key('pdfx.root.error'),
            child: Center(child: Text(loadingError.toString())),
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

  static Widget transitionBuilder(Widget child, Animation<double> animation) =>
      FadeTransition(opacity: animation, child: child);

  // static PhotoViewGalleryPageOptions pageBuilder(
  //   BuildContext context,
  //   Future<PdfPageImage> pageImage,
  //   int index,
  //   PdfDocument document,
  // ) =>
  //     PhotoViewGalleryPageOptions(
  //       imageProvider: PdfPageImageProvider(
  //         pageImage,
  //         index,
  //         document.id,
  //       ),
  //       filterQuality: FilterQuality.high,
  //       // onScaleEnd: (context, scalenddetails, photoviewcontrollervalue) {
  //       //   print("fff");
  //       // }
  //       basePosition: Alignment.center,
  //       minScale: PhotoViewComputedScale.contained * 1,
  //       maxScale: PhotoViewComputedScale.contained * 2.0,
  //       initialScale: PhotoViewComputedScale.contained * 5.0,
  //       heroAttributes: PhotoViewHeroAttributes(tag: '${document.id}-$index'),
  //     );
}
