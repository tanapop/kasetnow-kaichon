import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../imports.dart';

class KtvPage extends StatefulWidget {
  final BuildContext menuScreenContext;
  final Function onScreenHideButtonPressed;
  final bool hideStatus;
  const KtvPage(
      {Key key,
      this.menuScreenContext,
      this.onScreenHideButtonPressed,
      this.hideStatus = false})
      : super(key: key);
  @override
  _KtvScreenState createState() => _KtvScreenState();
}

class _KtvScreenState extends State<KtvPage> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  bool isLoading = true;
  final _key = UniqueKey();

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: () async {
          await 1.delay();
        },
        backgroundColor: AppStyles.primaryColorLight,
        color: AppStyles.primaryColorWhite,
        child: Scaffold(
          appBar: Appbar(
            backgroundColor: AppStyles.primaryColorWhite,
            title: Text(
              t.KTV,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppStyles.primaryColorTextField),
            ),
          ),
          /*appBar: AppBar(
        title: const Text('KTV'),
      ),*/
          // We're using a Builder here so we have a context that is below the Scaffold
          // to allow calling Scaffold.of(context) so we can show a snackbar.
          body: Builder(builder: (BuildContext context) {
            return Stack(children: <Widget>[
              WebView(
                key: _key,
                initialUrl: 'https://ktv.kasetnow.com/',
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (WebViewController webViewController) {
                  _controller.complete(webViewController);
                },
                // TODO(iskakaushik): Remove this when collection literals makes it to stable.
                // ignore: prefer_collection_literals
                javascriptChannels: <JavascriptChannel>[
                  _toasterJavascriptChannel(context),
                ].toSet(),
                navigationDelegate: (NavigationRequest request) {
                  if (request.url.startsWith('https://www.youtube.com/')) {
                    print('blocking navigation to $request}');
                    return NavigationDecision.prevent;
                  }
                  print('allowing navigation to $request');
                  return NavigationDecision.navigate;
                },
                onPageStarted: (String url) {
                  print('Page started loading: $url');
                },
                onPageFinished: (String url) {
                  print('Page finished loading: $url');
                  setState(() {
                    isLoading = false;
                  });
                },
                gestureNavigationEnabled: true,
              ),
              if (isLoading)
                Center(
                  child: CircularProgressIndicator(
                    backgroundColor: AppStyles.primaryColorLight,
                  ),
                )
              else
                Stack(),
            ]);
          }),
        ));
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          // ignore: deprecated_member_use
          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }
}
