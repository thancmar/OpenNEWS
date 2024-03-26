// import 'package:epub_view/epub_view.dart' as ebook;
import 'dart:async';

// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sharemagazines/src/models/ebooksForLocationGetAllActive.dart';

import '../../../../blocs/navbar/navbar_bloc.dart';
import '../../../widgets/src/epub/epub_view.dart' as ebook;

class FontSizeNotifier extends ValueNotifier<double> {
  final double min;
  final double max;

  FontSizeNotifier(double value, {this.min = 12.0, this.max = 26.0}) : super(value);

  @override
  set value(double newValue) {
    // Clamp the newValue between min and max values before setting it
    super.value = newValue.clamp(min, max);
  }
}

class Ebookreader extends StatefulWidget {
  ResponseEbook ebook;

  Ebookreader({Key? key, required this.ebook}) : super(key: key);

  @override
  State<Ebookreader> createState() => _EbookreaderState();
}

class _EbookreaderState extends State<Ebookreader> {
  bool lightTheme = false;
  late ebook.EpubController _epubReaderController;
  bool _isControllerInitialized = false;
  final fontSize = FontSizeNotifier(14);

  @override
  void initState() {
    super.initState();

    loadDataAsync();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  // Define an asynchronous operation
  Future<void> loadDataAsync() async {
    // Simulate a network request or any async operation
    Uint8List somthin = await BlocProvider.of<NavbarBloc>(context).getEbookFile(widget.ebook.id!, widget.ebook.dateOfPublication!);
    _epubReaderController = ebook.EpubController(
      document:
          // EpubDocument.openAsset('assets/New-Findings-on-Shirdi-Sai-Baba.epub'),
          ebook.EpubDocument.openData(somthin),
      // ebook.EpubDocument.openAsset('assets/epub30-spec.epub'),
      // epubCfi:
      //     'epubcfi(/6/26[id4]!/4/2/2[id4]/22)', // book.epub Chapter 3 paragraph 10
      // epubCfi:
      //     'epubcfi(/6/6[chapter-2]!/4/2/1612)', // book_2.epub Chapter 16 paragraph 3
    );
    setState(() {
      _isControllerInitialized = true; // Step 2: Update the state once initialization is complete
    });
  }

  @override
  void dispose() {
    _epubReaderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          Positioned.fill(
              // child: Hero(tag: 'bg',
              child: Image.asset("assets/images/background/Background.png", fit: BoxFit.cover)
              // ),
              ),
          _isControllerInitialized
              ? Scaffold(
                  backgroundColor: lightTheme ? Colors.white : Colors.transparent,
                  extendBodyBehindAppBar: false,
                  extendBody: true,
                  appBar: AppBar(
                    iconTheme: IconThemeData(color: lightTheme ? Colors.black : Colors.white),
                    surfaceTintColor: Colors.transparent,
                    backgroundColor: Colors.transparent,
                    title: ebook.EpubViewActualChapter(
                        controller: _epubReaderController,
                        builder: (chapterValue) {
                          // print("chapterValue ${chapterValue?.chapterNumber}");
                          return Text(
                            chapterValue?.chapter?.Title?.replaceAll('\n', '').trim() ?? '',
                            textAlign: TextAlign.start,
                            style: Theme.of(context).textTheme.titleLarge!.copyWith(color: lightTheme ? Colors.black : Colors.white),
                          );
                        }),
                    // actions: <Widget>[
                    //   IconButton(
                    //     icon:  Icon(Icons.save_alt),
                    //     color: Colors.white,
                    //     onPressed: () => _showCurrentEpubCfi(context),
                    //   ),
                    // ],
                  ),
                  endDrawer: Drawer(
                    // surfaceTintColor: Colors.blue,

                    child: ebook.EpubViewTableOfContents(controller: _epubReaderController),
                  ),

                  floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
                  floatingActionButton: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                      // textBaseline: TextBaseline.alphabetic,

                      children: [
                        Padding(
                          padding:  EdgeInsets.all(4.0),
                          child: FloatingActionButton(
                            // mini: true, // Makes the button smaller
                            shape: CircleBorder(
                              side: BorderSide(color: Colors.grey, width: 0.50,style: BorderStyle.none),
                            ),
                            backgroundColor:  Colors.blue.withOpacity(0.95),
                            child: Icon(Icons.text_decrease),
                            onPressed: () {
                              // Decrement font size
                              fontSize.value--;
                            },
                          ),
                        ),
                        Padding(
                          padding:  EdgeInsets.all(4.0),
                          child: FloatingActionButton(
                            // mini: true, // Makes the button smaller
                            shape: CircleBorder(
                              side: BorderSide(color: Colors.grey, width: 0.50,style: BorderStyle.none),
                            ),
                            backgroundColor: Colors.blue.withOpacity(0.95),
                            child: Icon(Icons.text_increase),
                            onPressed: () {
                              // Increment font size
                              fontSize.value++;
                            },
                          ),
                        ),

                        Padding(
                          padding:  EdgeInsets.all(4.0),
                          child: FloatingActionButton(
                            shape: CircleBorder(
                              side: BorderSide(color: Colors.grey, width: 0.50,style: BorderStyle.none),
                            ),
                            backgroundColor: lightTheme ? Colors.grey.withOpacity(0.2) : Colors.blue.withOpacity(0.95),
                            elevation: 2,
                            child: Icon(lightTheme ? Icons.dark_mode_outlined : Icons.dark_mode),
                            onPressed: () {
                              setState(() {
                                lightTheme = !lightTheme;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  body: Stack(
                    children: [
                      ebook.EpubView(
                        builders: ebook.EpubViewBuilders<ebook.DefaultBuilderOptions>(
                          options: const ebook.DefaultBuilderOptions(),
                          chapterDividerBuilder: (context, _) => const Divider(),
                        ),
                        controller: _epubReaderController,
                        lightTheme: lightTheme,
                        fontSize: fontSize,
                      ),
                      // Positioned(
                      //   bottom: 80, // Adjusts the position to ensure buttons don't overlap and are accessible
                      //   left: 10,
                      //   child: FloatingActionButton(
                      //     mini: true, // Makes the button smaller
                      //     backgroundColor: Colors.green,
                      //     child: Icon(Icons.add),
                      //     onPressed: () {
                      //       // Increment font size
                      //       fontSize.value++;
                      //     },
                      //   ),
                      // ),
                      // Positioned(
                      //   bottom: 140, // Adjusts the position to ensure buttons don't overlap and are accessible
                      //   left: 10,
                      //   child: FloatingActionButton(
                      //     mini: true, // Makes the button smaller
                      //     backgroundColor: Colors.red,
                      //     child: Icon(Icons.remove),
                      //     onPressed: () {
                      //       // Decrement font size
                      //       fontSize.value--;
                      //     },
                      //   ),
                      // ),
                    ],
                  ),
                )
              : Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    // color: Colors.grey.withOpacity(0.1),
                  ),
                  child: SpinKitFadingCircle(
                    color: Colors.white,
                    size: 50.0,
                    // controller: widget.spinKitController,
                  ),
                )
        ],
      );

  void _showCurrentEpubCfi(context) {
    final cfi = _epubReaderController.generateEpubCfi();

    if (cfi != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(cfi),
          action: SnackBarAction(
            label: 'GO',
            onPressed: () {
              _epubReaderController.gotoEpubCfi(cfi);
            },
          ),
        ),
      );
    }
  }
}
// class Ebookreader1 extends StatefulWidget {
//   ResponseEbook ebook;
//    Ebookreader1({Key? key,required this.ebook}) : super(key: key);
//
//   @override
//   State<Ebookreader1> createState() => _Ebookreader1State();
// }
//
// class _Ebookreader1State extends State<Ebookreader1> {
//   String pathPDF = "";
//   String landscapePathPdf = "";
//   String remotePDFpath = "";
//   String corruptedPathPDF = "";
//
//   @override
//   void initState() {
//     super.initState();
//     fromAsset('assets/corrupted.pdf', 'corrupted.pdf').then((f) {
//       setState(() {
//         corruptedPathPDF = f.path;
//       });
//     });
//     fromAsset('assets/9783841216083.pdf', '9783841216083.pdf').then((f) {
//       setState(() {
//         pathPDF = f.path;
//       });
//     });
//     fromAsset('assets/demo-landscape.pdf', 'landscape.pdf').then((f) {
//       setState(() {
//         landscapePathPdf = f.path;
//       });
//     });
//
//     createFileOfPdfUrl().then((f) {
//       setState(() {
//         remotePDFpath = f.path;
//       });
//     });
//   }
//
//   Future<File> createFileOfPdfUrl() async {
//     Completer<File> completer = Completer();
//     print("Start download file from internet!");
//     try {
//       // "https://berlin2017.droidcon.cod.newthinking.net/sites/global.droidcon.cod.newthinking.net/files/media/documents/Flutter%20-%2060FPS%20UI%20of%20the%20future%20%20-%20DroidconDE%2017.pdf";
//       // final url = "https://pdfkit.org/docs/guide.pdf";
//       final url = "http://www.pdf995.com/samples/pdf.pdf";
//       final filename = url.substring(url.lastIndexOf("/") + 1);
//       var request = await HttpClient().getUrl(Uri.parse(url));
//       var response = await request.close();
//       var bytes = await consolidateHttpClientResponseBytes(response);
//       var dir = await getApplicationDocumentsDirectory();
//       print("Download files");
//       print("${dir.path}/$filename");
//       File file = File("${dir.path}/$filename");
//
//       await file.writeAsBytes(bytes, flush: true);
//       completer.complete(file);
//     } catch (e) {
//       throw Exception('Error parsing asset file! ${e.toString()}');
//     }
//
//     return completer.future;
//   }
//
//   Future<File> fromAsset(String asset, String filename) async {
//     // To open from assets, you can copy them to the app storage folder, and the access them "locally"
//     Completer<File> completer = Completer();
//
//     try {
//       var dir = await getApplicationDocumentsDirectory();
//       File file = File("${dir.path}/$filename");
//       var data = await rootBundle.load(asset);
//       var bytes = data.buffer.asUint8List();
//       await file.writeAsBytes(bytes, flush: true);
//       completer.complete(file);
//     } catch (e) {
//       throw Exception('Error parsing asset file!${e.toString()}');
//     }
//
//     return completer.future;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter PDF View',
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         appBar: AppBar(title: const Text('Plugin example app')),
//         body: Center(child: Builder(
//           builder: (BuildContext context) {
//             return Column(
//               children: <Widget>[
//                 TextButton(
//                   child: Text("Open PDF"),
//                   onPressed: () {
//                     if (pathPDF.isNotEmpty) {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => PDFScreen(path: pathPDF),
//                         ),
//                       );
//                     }
//                   },
//                 ),
//                 TextButton(
//                   child: Text("Open Landscape PDF"),
//                   onPressed: () {
//                     if (landscapePathPdf.isNotEmpty) {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) =>
//                               PDFScreen(path: landscapePathPdf),
//                         ),
//                       );
//                     }
//                   },
//                 ),
//                 TextButton(
//                   child: Text("Remote PDF"),
//                   onPressed: () {
//                     if (remotePDFpath.isNotEmpty) {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => PDFScreen(path: remotePDFpath),
//                         ),
//                       );
//                     }
//                   },
//                 ),
//                 TextButton(
//                   child: Text("Open Corrupted PDF"),
//                   onPressed: () {
//                     if (pathPDF.isNotEmpty) {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) =>
//                               PDFScreen(path: corruptedPathPDF),
//                         ),
//                       );
//                     }
//                   },
//                 )
//               ],
//             );
//           },
//         )),
//       ),
//     );
//   }
// }

class PDFScreen extends StatefulWidget {
  final String? path;

  PDFScreen({Key? key, this.path}) : super(key: key);

  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> with WidgetsBindingObserver {
  final Completer<PDFViewController> _controller = Completer<PDFViewController>();
  int? pages = 0;
  int? currentPage = 0;
  bool isReady = false;
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Document"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          PDFView(
            filePath: widget.path,
            enableSwipe: true,
            swipeHorizontal: true,
            autoSpacing: false,
            pageFling: true,
            pageSnap: true,
            defaultPage: currentPage!,
            fitPolicy: FitPolicy.BOTH,
            preventLinkNavigation: false,
            // if set to true the link is handled in flutter
            onRender: (_pages) {
              setState(() {
                pages = _pages;
                isReady = true;
              });
            },
            onError: (error) {
              setState(() {
                errorMessage = error.toString();
              });
              print(error.toString());
            },
            onPageError: (page, error) {
              setState(() {
                errorMessage = '$page: ${error.toString()}';
              });
              print('$page: ${error.toString()}');
            },
            onViewCreated: (PDFViewController pdfViewController) {
              _controller.complete(pdfViewController);
            },
            onLinkHandler: (String? uri) {
              print('goto uri: $uri');
            },
            onPageChanged: (int? page, int? total) {
              print('page change: $page/$total');
              setState(() {
                currentPage = page;
              });
            },
          ),
          errorMessage.isEmpty
              ? !isReady
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Container()
              : Center(
                  child: Text(errorMessage),
                )
        ],
      ),
      floatingActionButton: FutureBuilder<PDFViewController>(
        future: _controller.future,
        builder: (context, AsyncSnapshot<PDFViewController> snapshot) {
          if (snapshot.hasData) {
            return FloatingActionButton.extended(
              label: Text("Go to ${pages! ~/ 2}"),
              onPressed: () async {
                await snapshot.data!.setPage(pages! ~/ 2);
              },
            );
          }

          return Container();
        },
      ),
    );
  }
}