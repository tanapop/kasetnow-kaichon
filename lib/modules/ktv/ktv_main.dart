import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../imports.dart';

class KtvMainPage extends StatefulWidget {
  @override
  _KtvMainScreenState createState() => _KtvMainScreenState();
}

class _KtvMainScreenState extends State<KtvMainPage> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: AppStyles.primaryColorGray,
      body: Stack(children: [
        Center(
          child: SizedBox(
            height: 100,
            child: Text(
              "เร็วๆ นี้",
              style: TextStyle(
                  color: AppStyles.primaryColorTextField, fontSize: 20),
            ),
          ),
        ),
      ]),
    );
  }
}
