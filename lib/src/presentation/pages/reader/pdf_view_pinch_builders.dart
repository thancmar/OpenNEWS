// part of 'pdf_view_pinch.dart';
//
// typedef CustumPdfViewPinchBuilder<T> = Widget Function(
//   /// Build context
//   BuildContext context,
//
//   /// All passed builders
//   CustumPdfViewPinchBuilders<T> builders,
//
//   /// Document loading state
//   PdfLoadingState state,
//
//   /// Loaded result builder
//   WidgetBuilder loadedBuilder,
//
//   /// Pdf document when he loaded
//   PdfDocument? document,
//
//   ///
//   // int currentPage,
//
//   /// Error of pdf loading
//   Exception? loadingError,
// );
//
// class CustumPdfViewPinchBuilders<T> {
//   /// Widget showing when pdf document loading
//   final WidgetBuilder? documentLoaderBuilder;
//
//   /// Widget showing when pdf page loading
//   final WidgetBuilder? pageLoaderBuilder;
//
//   /// Show document loading error message inside [PdfView]
//   final Widget Function(BuildContext, Exception error)? errorBuilder;
//
//   /// Root view builder
//   final CustumPdfViewPinchBuilder<T> builder;
//
//   /// Additional options for builder
//   final T options;
//
//   const CustumPdfViewPinchBuilders({
//     required this.options,
//     this.builder = _CustumPdfViewPinchState._builder,
//     this.documentLoaderBuilder,
//     this.pageLoaderBuilder,
//     this.errorBuilder,
//   });
// }