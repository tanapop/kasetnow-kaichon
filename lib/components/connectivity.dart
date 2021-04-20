import 'package:flutter/material.dart';

import '../i18n/strings.g.dart';

class ConnectivityBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.all(8),
          width: double.infinity,
          color: Colors.red,
          child: Text(
            t.NoInternet,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
