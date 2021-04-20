import 'package:flutter/material.dart';

class LogoIconKaichon extends StatelessWidget {
  const LogoIconKaichon({
    Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Image(
        image: ExactAssetImage("assets/images/SP-Brushthai1.png"),
        height: 50.0,
        width: 50.0,
      ),
    );
  }
}
