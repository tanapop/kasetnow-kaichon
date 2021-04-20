import 'package:flutter/material.dart';

class LogoIcon extends StatelessWidget {
  const LogoIcon({
    Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Image(
        image: ExactAssetImage("assets/images/kaichon2.png"),
        height: 32.0,
        width: 220.0,
      ),
    );
  }
}
