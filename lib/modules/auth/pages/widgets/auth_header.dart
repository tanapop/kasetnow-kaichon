import 'package:flutter/material.dart';
import '../../../../imports.dart';

class AuthTopHeader extends StatelessWidget {
  final double height;
  const AuthTopHeader({
    Key key,
    this.height,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width,
      height: height ?? context.height / 1.9,
      decoration: BoxDecoration(
        color: AppStyles.primaryColorBlackKnow,
        //gradient: AppStyles.primaryGradientGray
      ),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            alignment: Alignment.topCenter,
            decoration: BoxDecoration(
                image: DecorationImage(
              image: AssetImage("assets/images/login-header-bg/login-head.png"),
              fit: BoxFit.fitWidth,
              alignment: Alignment.topCenter,
            )),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 200, bottom: 20),
            child: Image.asset(Assets.images.logo.path),
          ),
          Padding(
              padding: const EdgeInsets.only(top: 400, bottom: 20),
              child: Container(
                  child: Text(
                "เข้าสู่ระบบ",
                style: TextStyle(color: Colors.black, fontSize: 22),
              ))),
          /*Positioned.fill(
            child: Appbar(
              backgroundColor: Colors.transparent,
            ),
          ),*/
        ],
      ),
    );
  }
}
