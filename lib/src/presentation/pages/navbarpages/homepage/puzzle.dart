//
// //
// // import 'package:flutter/material.dart';
// // import 'package:webviewx/webviewx.dart';
// //
// // class Puzzle extends StatefulWidget {
// //   const Puzzle({Key? key}) : super(key: key);
// //
// //   @override
// //   State<Puzzle> createState() => _PuzzleState();
// // }
// //
// // class _PuzzleState extends State<Puzzle> {
// //   late WebViewXController webviewController;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     // webviewController.
// //     webviewController.loadContent(
// //       'https://flutter.dev',
// //       SourceType.url,
// //     );
// //   }
// //
// //   Future<void> _getWebviewContent() async {
// //     try {
// //       final content = await webviewController.getContent();
// //       showAlertDialog(content.source, context);
// //     } catch (e) {
// //       showAlertDialog('Failed to execute this task.', context);
// //     }
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Column(
// //       children: [
// //         WebViewX(
// //             initialContent: '<h2> Hello, world! </h2>',
// //             initialSourceType: SourceType.html,
// //             onWebViewCreated: (controller) => webviewController = controller,
// //            height: 100,
// //           width: 100,
// //
// //         ),
// //         createButton(
// //           text: 'Show current webview content',
// //           onTap: _getWebviewContent,
// //         ),
// //       ],
// //     );
// //   }
// // }
// import 'dart:math';
//
// import 'package:flutter/material.dart';
// import 'package:webviewx/webviewx.dart';
//
// import 'helpers.dart';
//
// // import 'helpers.dart';
//
// class WebViewXPage extends StatefulWidget {
//   const WebViewXPage({
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   _WebViewXPageState createState() => _WebViewXPageState();
// }
//
// class _WebViewXPageState extends State<WebViewXPage> {
//   late WebViewXController webviewController;
//   final initialContent = '<h4> This is some hardcoded HTML code embedded inside the webview <h4> <h2> Hello world! <h2>';
//   final executeJsErrorMessage = 'Failed to execute this task because the current content is (probably) URL that allows iframe embedding, on Web.\n\n'
//       'A short reason for this is that, when a normal URL is embedded in the iframe, you do not actually own that content so you cant call your custom functions\n'
//       '(read the documentation to find out why).';
//
//   Size get screenSize => MediaQuery.of(context).size;
//
//   @override
//   void dispose() {
//     webviewController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('WebViewX Page'),
//       ),
//       body: Center(
//         child: Container(
//           padding: const EdgeInsets.all(10.0),
//           child: Column(
//             children: <Widget>[
//               buildSpace(direction: Axis.vertical, amount: 10.0, flex: false),
//               Container(
//                 padding: const EdgeInsets.only(bottom: 20.0),
//                 child: Text(
//                   'Play around with the buttons below',
//                   style: Theme.of(context).textTheme.headline6,
//                 ),
//               ),
//               buildSpace(direction: Axis.vertical, amount: 10.0, flex: false),
//               Container(
//                 decoration: BoxDecoration(
//                   border: Border.all(width: 0.2),
//                 ),
//                 child: _buildWebViewX(),
//               ),
//               Expanded(
//                 child: Scrollbar(
//                   // isAlwaysShown: true,
//                   child: SizedBox(
//                     width: min(screenSize.width * 0.8, 512),
//                     child: ListView(
//                       children: _buildButtons(),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildWebViewX() {
//     return WebViewX(
//       key: const ValueKey('webviewx'),
//
//       initialContent: "https://web.keesing.com/pub/config/sharemagazinesde/css/custom_client.css",
//       initialSourceType: SourceType.url,
//       height: screenSize.height / 2,
//       width: min(screenSize.width * 0.8, 1024),
//       javascriptMode: JavascriptMode.unrestricted,
//       onWebViewCreated: (controller) => webviewController = controller,
//       onPageStarted: (src) => debugPrint('A new page has started loading: $src\n'),
//       onPageFinished: (src) => debugPrint('The page has finished loading: $src\n'),
//       jsContent: const {
//         EmbeddedJsContent(
//           js: "function testPlatformIndependentMethod() { console.log('Hi from JS') }",
//         ),
//         EmbeddedJsContent(
//           webJs:
//           "function testPlatformSpecificMethod(msg) { TestDartCallback('Web callback says: ' + msg) }",
//           mobileJs:
//           "function testPlatformSpecificMethod(msg) { TestDartCallback.postMessage('Mobile callback says: ' + msg) }",
//         ),
//       },
//       dartCallBacks: {
//         DartCallback(
//           name: 'TestDartCallback',
//           callBack: (msg) => showSnackBar(msg.toString(), context),
//         )
//       },
//       webSpecificParams: const WebSpecificParams(
//         printDebugInfo: true,
//       ),
//       mobileSpecificParams: const MobileSpecificParams(
//         androidEnableHybridComposition: true,
//       ),
//       navigationDelegate: (navigation) {
//         debugPrint(navigation.content.sourceType.toString());
//         return NavigationDecision.navigate;
//       },
//     );
//   }
//
//   void _setUrl() {
//     webviewController.loadContent(
//       '''
//       <!DOCTYPE html>
//       <html>
//    <head>
//       <link rel="stylesheet" href="https://web.keesing.com/pub/config/sharemagazinesde/css/custom_client.css">
//    </head>
//    <body>
//       <div id="puzzle-portal" data-customerid="sharemagazinesde" data-gametype="camping" data-puzzleid="camping_today"></div>
//
//    </body>
// </html>''',
//       SourceType.html,
//     );
//   }
//
//   void _setUrlBypass() {
//     webviewController.loadContent(
//       'https://news.ycombinator.com/',
//       SourceType.urlBypass,
//     );
//   }
//
//   void _setHtml() {
//     webviewController.loadContent(
//       '<!DOCTYPE html><html><head> <link rel="stylesheet" href="https://web.keesing.com/pub/config/sharemagazinesde/css/custom_client.css"></head><body> <div id="puzzle-portal" data-customerid="sharemagazinesde" data-gametype="camping_mini" data-puzzleid="camping_mini_today"></div> <script async type="text/javascript" data-wlpp-bundle="player" src="https://web.keesing.com/pub/bundle-loader/bundle-loader.js"></script></body></html>',
//       SourceType.html,
//     );
//   }
//
//   void _setHtmlFromAssets() {
//     webviewController.loadContent(
//       'assets/test.html',
//       SourceType.html,
//       fromAssets: true,
//     );
//   }
//
//   Future<void> _goForward() async {
//     if (await webviewController.canGoForward()) {
//       await webviewController.goForward();
//       showSnackBar('Did go forward', context);
//     } else {
//       showSnackBar('Cannot go forward', context);
//     }
//   }
//
//   Future<void> _goBack() async {
//     if (await webviewController.canGoBack()) {
//       await webviewController.goBack();
//       showSnackBar('Did go back', context);
//     } else {
//       showSnackBar('Cannot go back', context);
//     }
//   }
//
//   void _reload() {
//     webviewController.reload();
//   }
//
//   void _toggleIgnore() {
//     final ignoring = webviewController.ignoresAllGestures;
//     webviewController.setIgnoreAllGestures(!ignoring);
//     showSnackBar('Ignore events = ${!ignoring}', context);
//   }
//
//   Future<void> _evalRawJsInGlobalContext() async {
//     try {
//       final result = await webviewController.evalRawJavascript(
//         '2+2',
//         inGlobalContext: true,
//       );
//       showSnackBar('The result is $result', context);
//     } catch (e) {
//       showAlertDialog(
//         executeJsErrorMessage,
//         context,
//       );
//     }
//   }
//
//   Future<void> _callPlatformIndependentJsMethod() async {
//     try {
//       await webviewController.callJsMethod('testPlatformIndependentMethod', []);
//     } catch (e) {
//       showAlertDialog(
//         executeJsErrorMessage,
//         context,
//       );
//     }
//   }
//
//   Future<void> _callPlatformSpecificJsMethod() async {
//     try {
//       await webviewController.callJsMethod('testPlatformSpecificMethod', ['Hi']);
//     } catch (e) {
//       showAlertDialog(
//         executeJsErrorMessage,
//         context,
//       );
//     }
//   }
//
//   Future<void> _getWebviewContent() async {
//     try {
//       final content = await webviewController.getContent();
//       showAlertDialog(content.source, context);
//     } catch (e) {
//       showAlertDialog('Failed to execute this task.', context);
//     }
//   }
//
//   Widget buildSpace({
//     Axis direction = Axis.horizontal,
//     double amount = 0.2,
//     bool flex = true,
//   }) {
//     return flex
//         ? Flexible(
//       child: FractionallySizedBox(
//         widthFactor: direction == Axis.horizontal ? amount : null,
//         heightFactor: direction == Axis.vertical ? amount : null,
//       ),
//     )
//         : SizedBox(
//       width: direction == Axis.horizontal ? amount : null,
//       height: direction == Axis.vertical ? amount : null,
//     );
//   }
//
//   List<Widget> _buildButtons() {
//     return [
//       buildSpace(direction: Axis.vertical, flex: false, amount: 20.0),
//       Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Expanded(child: createButton(onTap: _goBack, text: 'Back')),
//           buildSpace(amount: 12, flex: false),
//           Expanded(child: createButton(onTap: _goForward, text: 'Forward')),
//           buildSpace(amount: 12, flex: false),
//           Expanded(child: createButton(onTap: _reload, text: 'Reload')),
//         ],
//       ),
//       buildSpace(direction: Axis.vertical, flex: false, amount: 20.0),
//       createButton(
//         text: 'Change content to URL that allows iframes embedding\n(https://flutter.dev)',
//         onTap: _setUrl,
//       ),
//       buildSpace(direction: Axis.vertical, flex: false, amount: 20.0),
//       createButton(
//         text: 'Change content to URL that doesnt allow iframes embedding\n(https://news.ycombinator.com/)',
//         onTap: _setUrlBypass,
//       ),
//       buildSpace(direction: Axis.vertical, flex: false, amount: 20.0),
//       createButton(
//         text: 'Change content to HTML (hardcoded)',
//         onTap: _setHtml,
//       ),
//       buildSpace(direction: Axis.vertical, flex: false, amount: 20.0),
//       createButton(
//         text: 'Change content to HTML (from assets)',
//         onTap: _setHtmlFromAssets,
//       ),
//       buildSpace(direction: Axis.vertical, flex: false, amount: 20.0),
//       createButton(
//         text: 'Toggle on/off ignore any events (click, scroll etc)',
//         onTap: _toggleIgnore,
//       ),
//       buildSpace(direction: Axis.vertical, flex: false, amount: 20.0),
//       createButton(
//         text: 'Evaluate 2+2 in the global "window" (javascript side)',
//         onTap: _evalRawJsInGlobalContext,
//       ),
//       buildSpace(direction: Axis.vertical, flex: false, amount: 20.0),
//       createButton(
//         text: 'Call platform independent Js method (console.log)',
//         onTap: _callPlatformIndependentJsMethod,
//       ),
//       buildSpace(direction: Axis.vertical, flex: false, amount: 20.0),
//       createButton(
//         text: 'Call platform specific Js method, that calls back a Dart function',
//         onTap: _callPlatformSpecificJsMethod,
//       ),
//       buildSpace(direction: Axis.vertical, flex: false, amount: 20.0),
//       createButton(
//         text: 'Show current webview content',
//         onTap: _getWebviewContent,
//       ),
//     ];
//   }
// }
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';


// const String kLocalExamplePage = '''
//       <!DOCTYPE html>
//       <html>
//       <meta name="viewport" content="width=device-width, initial-scale=0.8">
//    <head>
//       <link rel="stylesheet" href="https://web.keesing.com/pub/config/sharemagazinesde/css/custom_client.css">
//    </head>
//    <body>
//       <div id="puzzle-portal" data-customerid="sharemagazinesde" data-gametype="wordsearch" data-puzzleid="wordsearch_today"></div>
// <script async type="text/javascript" data-wlpp-bundle="player" src="https://web.keesing.com/pub/bundle-loader/bundle-loader.js"></script>
//    </body>
// </html>''';

class Puzzle extends StatefulWidget {
  final String title;
  final String puzzleID;
  final String gameType;
  const Puzzle({key, this.cookieManager,required this.title, required this.puzzleID, required this.gameType});

  final PlatformWebViewCookieManager? cookieManager;

  @override
  State<Puzzle> createState() => _PuzzleState();
}

class _PuzzleState extends State<Puzzle> {
  late final PlatformWebViewController _controller;
  late String kLocalExamplePage ;

  @override
  void initState() {
    super.initState();
    kLocalExamplePage = '''
      <!DOCTYPE html>
      <html>
      <meta name="viewport" content="width=device-width, initial-scale=0.9">
   <head>
      <link rel="stylesheet" href="https://web.keesing.com/pub/config/sharemagazinesde/css/custom_client.css">
   </head>
   <body>
      <div id="puzzle-portal" data-customerid="sharemagazinesde" data-gametype="${widget.gameType}" data-puzzleid="${widget.puzzleID}"></div>
<script async type="text/javascript" data-wlpp-bundle="player" src="https://web.keesing.com/pub/bundle-loader/bundle-loader.js"></script>
   </body>
</html>''';
    _controller = PlatformWebViewController(
      WebKitWebViewControllerCreationParams(allowsInlineMediaPlayback: true),
    )
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..setPlatformNavigationDelegate(
        PlatformNavigationDelegate(
          const PlatformNavigationDelegateCreationParams(),
        )
          ..setOnProgress((int progress) {
            debugPrint('WebView is loading (progress : $progress%)');
          })
          ..setOnPageStarted((String url) {
            debugPrint('Page started loading: $url');
          })
          ..setOnPageFinished((String url) {
            debugPrint('Page finished loading: $url');
            injectCSS();
          })
          ..setOnWebResourceError((WebResourceError error) {
            debugPrint('''
Page resource error:
  code: ${error.errorCode}
  description: ${error.description}
  errorType: ${error.errorType}
  isForMainFrame: ${error.isForMainFrame}
  url: ${error.url}
          ''');
          })
          ..setOnNavigationRequest((NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              debugPrint('blocking navigation to ${request.url}');
              return NavigationDecision.prevent;
            }
            debugPrint('allowing navigation to ${request.url}');
            return NavigationDecision.navigate;
          })
          ..setOnUrlChange((UrlChange change) {
            debugPrint('url change to ${change.url}');
          })
          // ..setOnHttpAuthRequest((HttpAuthRequest request) {
          //   openDialog(request);
          // }),
      )
      ..addJavaScriptChannel(JavaScriptChannelParams(
        name: 'Toaster',
        onMessageReceived: (JavaScriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        },
      ))
      ..setOnPlatformPermissionRequest(
        (PlatformWebViewPermissionRequest request) {
          debugPrint(
            'requesting permissions for ${request.types.map((WebViewPermissionResourceType type) => type.name)}',
          );
          request.grant();
        },
      )
      // ..loadRequest(LoadRequestParams(
      //   uri: Uri.parse('https://flutter.dev'),
      // ))
      ..loadHtmlString(kLocalExamplePage, baseUrl: "https://web.keesing.com/pub/config/sharemagazinesde/css/custom_client.css")
      ..setOnScrollPositionChange((ScrollPositionChange scrollPositionChange) {
        debugPrint(
          'Scroll position change to x = ${scrollPositionChange.x}, y = ${scrollPositionChange.y}',
        );
      });
  }

  void injectCSS() {
    // Your CSS code as a single string, with necessary escapes for JavaScript
    String cssCode = """
    "body {margin: 0} #puzzle-portal {height: 50vh;}"
    @viewport {
      width: device-width;
      zoom: 1.0;
    }
  """;

    // JavaScript code to create a style element, set its innerHTML to your CSS, and append it to the head
    String jsCode = """
    (function() {
      var style = document.createElement('style');
      style.type = 'text/css';
      style.innerHTML = $cssCode;
      document.head.appendChild(style);
    })();
  """;

    // Evaluate the JavaScript code in the web view
    _controller.runJavaScript(jsCode);
    // _controller.evaluateJavascript(jsCode);
  }

  @override
  Widget build(BuildContext context) {
    final Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers = {
      // Factory for vertical drag gestures.
      Factory<VerticalDragGestureRecognizer>(
        () => VerticalDragGestureRecognizer(),
      ),
      // Add other gesture recognizers here as needed.
      // For example, to recognize horizontal drags:
      // Factory<HorizontalDragGestureRecognizer>(
      //   () => HorizontalDragGestureRecognizer(),
      // ),
    };
    return  Stack(
        children: [
          Positioned.fill(
            child: Image.asset("assets/images/background/Background.png", fit: BoxFit.cover),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            // extendBody: true,
            extendBodyBehindAppBar: false,

            appBar: AppBar(

              automaticallyImplyLeading: false,
              title:  Row(
                children: [
                  Container(
                    width: 35,
                    color: Colors.transparent,
                    child: InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        // BlocProvider.of<SearchBloc>(context).add(OpenSearch());
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Text(
                          "${widget.title}",
                          style: Theme.of(context).textTheme.headlineSmall,
                          textAlign: TextAlign.center,
                          // textAlign: TextAlign.center,
                        )),
                  )

                ],
              ),

              backgroundColor: Colors.transparent,
              // This drop down menu demonstrates that Flutter widgets can be shown over the web view.
              // actions: <Widget>[
              //   NavigationControls(webViewController: _controller),
              //   SampleMenu(
              //     webViewController: _controller,
              //     cookieManager: widget.cookieManager,
              //   ),
              // ],
            ),
            body: Align(
              alignment: Alignment.center,
              child: SizedBox(
                height: 650,
                width: 500,

                child: PlatformWebViewWidget(
                  PlatformWebViewWidgetCreationParams(controller: _controller, gestureRecognizers: gestureRecognizers),
                ).build(context),
              ),
            ),
          ),
        ],
      )
    ;
  }


}

// import 'package:flutter/material.dart';
// import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
//
// // import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
// import 'package:fwfh_webview/fwfh_webview.dart';
//
// class Puzzle extends StatelessWidget {
//   const Puzzle({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final String base64Html ='''
//        <!DOCTYPE html>
//       <html>
//    <head>
//       <link rel="stylesheet" href="https://web.keesing.com/pub/config/sharemagazinesde/css/custom_client.css">
//    </head>
//    <body>
//       <div id="puzzle-portal" data-customerid="sharemagazinesde" data-gametype="wordsearch" data-puzzleid="wordsearch_today"></div>
// <script async type="text/javascript" data-wlpp-bundle="player" src="https://web.keesing.com/pub/bundle-loader/bundle-loader.js"></script>
//    </body>
// </html>''';
//     return HtmlWidget(
//       base64Html,
// //       '''
// //
// //       <h1>Some title</h1>
// // <p>Some text and the image</p>
// // <img src="https://online.schtandart.com/sites/default/files/inline-images/mailservice%20%2845%29_0.png"
// //     data-entity-uuid="7575acb9-2cb1-4caf-84d0-7768199fd85a" data-entity-type="file">
// // <p>&nbsp;</p>
// // <p><strong>Some bold text</strong> and the link <a
// //         href="https://www.youtube.com/watch?v=Fcoo_KWp1GA&amp;t=628s">here</a> in the text.</p>
// // <p>And video at the end</p>
// // <p><iframe  src="https://web.keesing.com/pub/config/sharemagazinesde/css/custom_client.css" ></iframe></p>
// //         ''',
//       baseUrl: Uri.parse("https://web.keesing.com/pub/config/sharemagazinesde/css/custom_client.css"),
//
//       // renderMode: RenderMode.listView,
//       //   <p><iframe width="560" height="315" src="data:text/html,<!DOCTYPE html> <html> <head> <link rel="stylesheet" href="https://web.keesing.com/pub/config/sharemagazinesde/css/custom_client.css"> </head> <body> <div id="puzzle-portal" data-customerid="sharemagazinesde" data-gametype="wordsearch" data-puzzleid="wordsearch_today"></div> <script async type="text/javascript" data-wlpp-bundle="player" src="https://web.keesing.com/pub/bundle-loader/bundle-loader.js"></script> </body> </html>"
//
// //       '''
// // //       <!DOCTYPE html>
// // //       <html>
// // //    <head>
// // //       <link rel="stylesheet" href="https://web.keesing.com/pub/config/sharemagazinesde/css/custom_client.css">
// // //    </head>
// // //    <body>
// // //       <div id="puzzle-portal" data-customerid="sharemagazinesde" data-gametype="camping" data-puzzleid="camping_today"></div>
// // //
// // //    </body>
// // // </html>''',
//       factoryBuilder: () => MyWidgetFactory(),
//     );
//   }
// }
//
// class MyWidgetFactory extends WidgetFactory with WebViewFactory {
//   bool get webViewMediaPlaybackAlwaysAllow => true;
//
//   String? get webViewUserAgent => 'My app';
//
//   bool get webViewDebuggingEnabled => true;
//
//   bool get webView => true;
// }