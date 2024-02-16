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
//       initialContent: initialContent,
//       initialSourceType: SourceType.html,
//       height: screenSize.height / 2,
//       width: min(screenSize.width * 0.8, 1024),
//       javascriptMode: JavascriptMode.unrestricted,
//       onWebViewCreated: (controller) => webviewController = controller,
//       onPageStarted: (src) => debugPrint('A new page has started loading: $src\n'),
//       onPageFinished: (src) => debugPrint('The page has finished loading: $src\n'),
//       jsContent: {
//         // EmbeddedJsContent(
//         //   mobileJs: "function testPlatformSpecificMethod(msg) { TestDartCallback('Web callback says: ' + msg) }"),
//         EmbeddedJsContent(
//           js: """
//     (function() {
//       var script = document.createElement('script');
//       script.async = true;
//       script.type = 'text/javascript';
//       script.setAttribute('data-wlpp-bundle', 'player');
//       script.src = 'https://web.keesing.com/pub/bundle-loader/bundle-loader.js';
//       document.head.appendChild(script);
//     })();
//   """,
//         )
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

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

void main() {
  runApp(const MaterialApp(home: WebViewExample()));
}

const String kNavigationExamplePage = '''
<!DOCTYPE html><html>
<head><title>Navigation Delegate Example</title></head>
<body>
<p>
The navigation delegate is set to block navigation to the youtube website.
</p>
<ul>
<ul><a href="https://www.youtube.com/">https://www.youtube.com/</a></ul>
<ul><a href="https://www.google.com/">https://www.google.com/</a></ul>
</ul>
</body>
</html>
''';

const String kLocalExamplePage =
      '''
      <!DOCTYPE html>
      <html>
   <head>
      <link rel="stylesheet" href="https://web.keesing.com/pub/config/sharemagazinesde/css/custom_client.css">
   </head>
   <body>
      <div id="puzzle-portal" data-customerid="sharemagazinesde" data-gametype="camping" data-puzzleid="camping_today"></div>
<script async type="text/javascript" data-wlpp-bundle="player" src="https://web.keesing.com/pub/bundle-loader/bundle-loader.js"></script>
   </body>
</html>''';

// NOTE: This is used by the transparency test in `example/ios/RunnerUITests/FLTWebViewUITests.m`.
const String kTransparentBackgroundPage = '''
<!DOCTYPE html>
<html>
<head>
  <title>Transparent background test</title>
</head>
<style type="text/css">
  body { background: transparent; margin: 0; padding: 0; }
  #container { position: relative; margin: 0; padding: 0; width: 100vw; height: 100vh; }
  #shape { background: #FF0000; width: 200px; height: 100%; margin: 0; padding: 0; position: absolute; top: 0; bottom: 0; left: calc(50% - 100px); }
  p { text-align: center; }
</style>
<body>
  <div id="container">
    <p>Transparent background test</p>
    <div id="shape"></div>
  </div>
</body>
</html>
''';

const String kLogExamplePage = '''
<!DOCTYPE html>
<html lang="en">
<head>
<title>Load file or HTML string example</title>
</head>
<body onload="console.log('Logging that the page is loading.')">

<h1>Local demo page</h1>
<p>
  This page is used to test the forwarding of console logs to Dart.
</p>

<style>
    .btn-group button {
      padding: 24px; 24px;
      display: block;
      width: 25%;
      margin: 5px 0px 0px 0px;
    }
</style>

<div class="btn-group">
    <button onclick="console.error('This is an error message.')">Error</button>
    <button onclick="console.warn('This is a warning message.')">Warning</button>
    <button onclick="console.info('This is a info message.')">Info</button>
    <button onclick="console.debug('This is a debug message.')">Debug</button>
    <button onclick="console.log('This is a log message.')">Log</button>
</div>

</body>
</html>
''';

const String kAlertTestPage = '''
<!DOCTYPE html>
<html>  
   <head>     
      <script type = "text/javascript">  
            function showAlert(text) {	          
	            alert(text);      
            }  
            
            function showConfirm(text) {
              var result = confirm(text);
              alert(result);
            }
            
            function showPrompt(text, defaultText) {
              var inputString = prompt('Enter input', 'Default text');
	            alert(inputString);            
            }            
      </script>       
   </head>  
     
   <body>  
      <p> Click the following button to see the effect </p>        
      <form>  
        <input type = "button" value = "Alert" onclick = "showAlert('Test Alert');" />
        <input type = "button" value = "Confirm" onclick = "showConfirm('Test Confirm');" />  
        <input type = "button" value = "Prompt" onclick = "showPrompt('Test Prompt', 'Default Value');" />    
      </form>       
   </body>  
</html>  
''';

class WebViewExample extends StatefulWidget {
  const WebViewExample({key, this.cookieManager});

  final PlatformWebViewCookieManager? cookieManager;

  @override
  State<WebViewExample> createState() => _WebViewExampleState();
}

class _WebViewExampleState extends State<WebViewExample> {
  late final PlatformWebViewController _controller;

  @override
  void initState() {
    super.initState();

    _controller = PlatformWebViewController(
      WebKitWebViewControllerCreationParams(allowsInlineMediaPlayback: true),
    )
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x80000000))
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
          ..setOnHttpAuthRequest((HttpAuthRequest request) {
            openDialog(request);
          }),
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
      ..loadRequest(LoadRequestParams(
        uri: Uri.parse('https://flutter.dev'),
      ))

      ..setOnScrollPositionChange((ScrollPositionChange scrollPositionChange) {
        debugPrint(
          'Scroll position change to x = ${scrollPositionChange.x}, y = ${scrollPositionChange.y}',
        );
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4CAF50),
      appBar: AppBar(
        title: const Text('Flutter WebView example'),
        // This drop down menu demonstrates that Flutter widgets can be shown over the web view.
        actions: <Widget>[
          NavigationControls(webViewController: _controller),
          SampleMenu(
            webViewController: _controller,
            cookieManager: widget.cookieManager,
          ),
        ],
      ),
      body: PlatformWebViewWidget(
        PlatformWebViewWidgetCreationParams(controller: _controller),
      ).build(context),
      floatingActionButton: favoriteButton(),
    );
  }

  Widget favoriteButton() {
    return FloatingActionButton(
      onPressed: () async {
        final String? url = await _controller.currentUrl();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Favorited $url')),
          );
        }
      },
      child: const Icon(Icons.favorite),
    );
  }

  Future<void> openDialog(HttpAuthRequest httpRequest) async {
    final TextEditingController usernameTextController = TextEditingController();
    final TextEditingController passwordTextController = TextEditingController();

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('${httpRequest.host}: ${httpRequest.realm ?? '-'}'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  decoration: const InputDecoration(labelText: 'Username'),
                  autofocus: true,
                  controller: usernameTextController,
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Password'),
                  controller: passwordTextController,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            // Explicitly cancel the request on iOS as the OS does not emit new
            // requests when a previous request is pending.
            TextButton(
              onPressed: () {
                httpRequest.onCancel();
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                httpRequest.onProceed(
                  WebViewCredential(
                    user: usernameTextController.text,
                    password: passwordTextController.text,
                  ),
                );
                Navigator.of(context).pop();
              },
              child: const Text('Authenticate'),
            ),
          ],
        );
      },
    );
  }
}

enum MenuOptions {
  showUserAgent,
  listCookies,
  clearCookies,
  addToCache,
  listCache,
  clearCache,
  navigationDelegate,
  doPostRequest,
  loadLocalFile,
  loadFlutterAsset,
  loadHtmlString,
  transparentBackground,
  setCookie,
  logExample,
  basicAuthentication,
  javaScriptAlert,
}

class SampleMenu extends StatelessWidget {
  SampleMenu({
    key,
    required this.webViewController,
    PlatformWebViewCookieManager? cookieManager,
  }) : cookieManager = cookieManager ??
            PlatformWebViewCookieManager(
              const PlatformWebViewCookieManagerCreationParams(),
            );

  final PlatformWebViewController webViewController;
  late final PlatformWebViewCookieManager cookieManager;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MenuOptions>(
      key: const ValueKey<String>('ShowPopupMenu'),
      onSelected: (MenuOptions value) {
        switch (value) {
          case MenuOptions.showUserAgent:
            _onShowUserAgent();
            break;
          case MenuOptions.listCookies:
            _onListCookies(context);
            break;
          case MenuOptions.clearCookies:
            _onClearCookies(context);
            break;
          case MenuOptions.addToCache:
            _onAddToCache(context);
            break;
          case MenuOptions.listCache:
            _onListCache();
            break;
          case MenuOptions.clearCache:
            _onClearCache(context);
            break;
          case MenuOptions.navigationDelegate:
            _onNavigationDelegateExample();
            break;
          case MenuOptions.doPostRequest:
            _onDoPostRequest();
            break;
          case MenuOptions.loadLocalFile:
            _onLoadLocalFileExample();
            break;
          case MenuOptions.loadFlutterAsset:
            _onLoadFlutterAssetExample();
            break;
          case MenuOptions.loadHtmlString:
            _onLoadHtmlStringExample();
            break;
          case MenuOptions.transparentBackground:
            _onTransparentBackground();
            break;
          case MenuOptions.setCookie:
            _onSetCookie();
            break;
          case MenuOptions.logExample:
            _onLogExample();
            break;
          case MenuOptions.basicAuthentication:
            _promptForUrl(context);
            break;
          case MenuOptions.javaScriptAlert:
            _onJavaScriptAlertExample(context);
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuItem<MenuOptions>>[
        const PopupMenuItem<MenuOptions>(
          value: MenuOptions.showUserAgent,
          child: Text('Show user agent'),
        ),
        const PopupMenuItem<MenuOptions>(
          value: MenuOptions.listCookies,
          child: Text('List cookies'),
        ),
        const PopupMenuItem<MenuOptions>(
          value: MenuOptions.clearCookies,
          child: Text('Clear cookies'),
        ),
        const PopupMenuItem<MenuOptions>(
          value: MenuOptions.addToCache,
          child: Text('Add to cache'),
        ),
        const PopupMenuItem<MenuOptions>(
          value: MenuOptions.listCache,
          child: Text('List cache'),
        ),
        const PopupMenuItem<MenuOptions>(
          value: MenuOptions.clearCache,
          child: Text('Clear cache'),
        ),
        const PopupMenuItem<MenuOptions>(
          value: MenuOptions.navigationDelegate,
          child: Text('Navigation Delegate example'),
        ),
        const PopupMenuItem<MenuOptions>(
          value: MenuOptions.doPostRequest,
          child: Text('Post Request'),
        ),
        const PopupMenuItem<MenuOptions>(
          value: MenuOptions.loadHtmlString,
          child: Text('Load HTML string'),
        ),
        const PopupMenuItem<MenuOptions>(
          value: MenuOptions.loadLocalFile,
          child: Text('Load local file'),
        ),
        const PopupMenuItem<MenuOptions>(
          value: MenuOptions.loadFlutterAsset,
          child: Text('Load Flutter Asset'),
        ),
        const PopupMenuItem<MenuOptions>(
          value: MenuOptions.setCookie,
          child: Text('Set cookie'),
        ),
        const PopupMenuItem<MenuOptions>(
          key: ValueKey<String>('ShowTransparentBackgroundExample'),
          value: MenuOptions.transparentBackground,
          child: Text('Transparent background example'),
        ),
        const PopupMenuItem<MenuOptions>(
          value: MenuOptions.logExample,
          child: Text('Log example'),
        ),
        const PopupMenuItem<MenuOptions>(
          value: MenuOptions.basicAuthentication,
          child: Text('Basic Authentication Example'),
        ),
        const PopupMenuItem<MenuOptions>(
          value: MenuOptions.javaScriptAlert,
          child: Text('JavaScript Alert Example'),
        ),
      ],
    );
  }

  Future<void> _onShowUserAgent() {
    // Send a message with the user agent string to the Toaster JavaScript channel we registered
    // with the WebView.
    return webViewController.runJavaScript(
      'Toaster.postMessage("User Agent: " + navigator.userAgent);',
    );
  }

  Future<void> _onListCookies(BuildContext context) async {
    final String cookies = await webViewController.runJavaScriptReturningResult('document.cookie') as String;
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text('Cookies:'),
            _getCookieList(cookies),
          ],
        ),
      ));
    }
  }

  Future<void> _onAddToCache(BuildContext context) async {
    await webViewController.runJavaScript(
      'caches.open("test_caches_entry"); localStorage["test_localStorage"] = "dummy_entry";',
    );
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Added a test entry to cache.'),
      ));
    }
  }

  Future<void> _onListCache() {
    return webViewController.runJavaScript('caches.keys()'
        // ignore: missing_whitespace_between_adjacent_strings
        '.then((cacheKeys) => JSON.stringify({"cacheKeys" : cacheKeys, "localStorage" : localStorage}))'
        '.then((caches) => Toaster.postMessage(caches))');
  }

  Future<void> _onClearCache(BuildContext context) async {
    await webViewController.clearCache();
    await webViewController.clearLocalStorage();
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Cache cleared.'),
      ));
    }
  }

  Future<void> _onClearCookies(BuildContext context) async {
    final bool hadCookies = await cookieManager.clearCookies();
    String message = 'There were cookies. Now, they are gone!';
    if (!hadCookies) {
      message = 'There are no cookies.';
    }
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
      ));
    }
  }

  Future<void> _onNavigationDelegateExample() {
    final String contentBase64 = base64Encode(
      const Utf8Encoder().convert(kNavigationExamplePage),
    );
    return webViewController.loadRequest(
      LoadRequestParams(
        uri: Uri.parse('data:text/html;base64,$contentBase64'),
      ),
    );
  }

  Future<void> _onSetCookie() async {
    await cookieManager.setCookie(
      const WebViewCookie(
        name: 'foo',
        value: 'bar',
        domain: 'httpbin.org',
        path: '/anything',
      ),
    );
    await webViewController.loadRequest(LoadRequestParams(
      uri: Uri.parse('https://httpbin.org/anything'),
    ));
  }

  Future<void> _onDoPostRequest() {
    return webViewController.loadRequest(LoadRequestParams(
      uri: Uri.parse('https://httpbin.org/post'),
      method: LoadRequestMethod.post,
      headers: const <String, String>{
        'foo': 'bar',
        'Content-Type': 'text/plain',
      },
      body: Uint8List.fromList('Test Body'.codeUnits),

    ));
  }

  Future<void> _onLoadLocalFileExample() async {
    final String pathToIndex = await _prepareLocalFile();
    await webViewController.loadFile(pathToIndex);
  }

  Future<void> _onLoadFlutterAssetExample() {
    return webViewController.loadFlutterAsset('assets/www/index.html');
  }

  Future<void> _onLoadHtmlStringExample() {
    return webViewController.loadHtmlString(kLocalExamplePage);
  }

  Future<void> _onTransparentBackground() {
    return webViewController.loadHtmlString(kTransparentBackgroundPage);
  }

  Future<void> _onJavaScriptAlertExample(BuildContext context) {
    webViewController.setOnJavaScriptAlertDialog((JavaScriptAlertDialogRequest request) async {
      await _showAlert(context, request.message);
    });

    webViewController.setOnJavaScriptConfirmDialog((JavaScriptConfirmDialogRequest request) async {
      final bool result = await _showConfirm(context, request.message);
      return result;
    });

    webViewController.setOnJavaScriptTextInputDialog((JavaScriptTextInputDialogRequest request) async {
      final String result = await _showTextInput(context, request.message, request.defaultText);
      return result;
    });

    return webViewController.loadHtmlString(kAlertTestPage);
  }

  Widget _getCookieList(String cookies) {
    if (cookies == '""') {
      return Container();
    }
    final List<String> cookieList = cookies.split(';');
    final Iterable<Text> cookieWidgets = cookieList.map((String cookie) => Text(cookie));
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: cookieWidgets.toList(),
    );
  }

  static Future<String> _prepareLocalFile() async {
    final String tmpDir = (await getTemporaryDirectory()).path;
    final File indexFile = File(<String>{tmpDir, 'www', 'index.html'}.join(Platform.pathSeparator));

    await indexFile.create(recursive: true);
    await indexFile.writeAsString(kLocalExamplePage);

    return indexFile.path;
  }

  Future<void> _onLogExample() {
    webViewController.setOnConsoleMessage((JavaScriptConsoleMessage consoleMessage) {
      debugPrint('== JS == ${consoleMessage.level.name}: ${consoleMessage.message}');
    });

    return webViewController.loadHtmlString(kLogExamplePage);
  }

  Future<void> _promptForUrl(BuildContext context) {
    final TextEditingController urlTextController = TextEditingController(text: 'https://');

    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Input URL to visit'),
          content: TextField(
            decoration: const InputDecoration(labelText: 'URL'),
            autofocus: true,
            controller: urlTextController,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                if (urlTextController.text.isNotEmpty) {
                  final Uri? uri = Uri.tryParse(urlTextController.text);
                  if (uri != null && uri.scheme.isNotEmpty) {
                    webViewController.loadRequest(
                      LoadRequestParams(uri: uri),
                    );
                    Navigator.pop(context);
                  }
                }
              },
              child: const Text('Visit'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showAlert(BuildContext context, String message) async {
    return showDialog<void>(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            content: Text(message),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: const Text('OK'))
            ],
          );
        });
  }

  Future<bool> _showConfirm(BuildContext context, String message) async {
    return await showDialog<bool>(
            context: context,
            builder: (BuildContext ctx) {
              return AlertDialog(
                content: Text(message),
                actions: <Widget>[
                  TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop(false);
                      },
                      child: const Text('Cancel')),
                  TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop(true);
                      },
                      child: const Text('OK')),
                ],
              );
            }) ??
        false;
  }

  Future<String> _showTextInput(BuildContext context, String message, String? defaultText) async {
    return await showDialog<String>(
            context: context,
            builder: (BuildContext ctx) {
              return AlertDialog(
                content: Text(message),
                actions: <Widget>[
                  TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop('Text test');
                      },
                      child: const Text('Enter')),
                ],
              );
            }) ??
        '';
  }
}

class NavigationControls extends StatelessWidget {
  const NavigationControls({key, required this.webViewController});

  final PlatformWebViewController webViewController;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () async {
            if (await webViewController.canGoBack()) {
              await webViewController.goBack();
            } else {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('No back history item')),
                );
              }
            }
          },
        ),
        IconButton(
          icon: const Icon(Icons.arrow_forward_ios),
          onPressed: () async {
            if (await webViewController.canGoForward()) {
              await webViewController.goForward();
            } else {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('No forward history item')),
                );
              }
            }
          },
        ),
        IconButton(
          icon: const Icon(Icons.replay),
          onPressed: () => webViewController.reload(),
        ),
      ],
    );
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
//     return HtmlWidget(
//       '''<iframe src='data:text/html;charset=utf-8,
//          <!DOCTYPE html>
//       <html>
//    <head>
//       <link rel="stylesheet" href="https://web.keesing.com/pub/config/sharemagazinesde/css/custom_client.css">
//    </head>
//    <body>
//       <div id="puzzle-portal" data-customerid="sharemagazinesde" data-gametype="camping" data-puzzleid="camping_today"></div>
//
//    </body>
// </html>
//         '></iframe>''',
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
//   bool get webViewDebuggingEnabled => true;
//   bool get webView => false;
// }