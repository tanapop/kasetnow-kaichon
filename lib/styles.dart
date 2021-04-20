import 'dart:ui';

import 'package:flutter/material.dart';

mixin AppStyles {
  static const primaryColorLight = Color(0xff80BDBE);
  static const primaryColorDark = Color(0xff013245);
  static const primaryColorBlack = Color(0xff000000);
  static const primaryBackBlackKnowText = Color(0xff151515);
  static const primaryColorBlackKnow = Color(0xff030504);
  static const primaryColorWhite = Color(0xffFFFFFF);
  static const primaryColorGray = Color(0xffEAEBED);
  static const primaryColorRed = Color(0xffFF0000);
  static const primaryColorRedKnow = Color(0xffE50B15);

  static const accentColor = Color(0xff00ebff);
  static const secondaryHeaderColor = Color(0xffffb8e7);
  static const primaryColorTextField = Color(0xff8D8D8D);

  static const primaryColorGradient1 = Color(0xff8AC68B);
  static const primaryColorGradient2 = Color(0xff80BDBE);

  static final lightTheme = ThemeData(fontFamily: 'LucidaGrande').copyWith(
    primaryColor: primaryColorLight,
    primaryColorLight: primaryColorLight,
    primaryColorDark: primaryColorDark,
    accentColor: accentColor,
    secondaryHeaderColor: secondaryHeaderColor,
  );

  static final darkTheme = ThemeData.dark().copyWith(
    primaryColor: primaryColorDark,
    primaryColorLight: primaryColorLight,
    primaryColorDark: primaryColorDark,
    accentColor: accentColor,
    secondaryHeaderColor: secondaryHeaderColor,
  );

  static final primaryGradient = LinearGradient(
    colors: const [primaryColorGradient1, primaryColorGradient2],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static final primaryGradientGray = LinearGradient(
    colors: const [primaryColorGray, primaryColorGray],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

extension ThemeDataEx on ThemeData {
  Color get inversePrimaryColor =>
      brightness == Brightness.dark ? primaryColorLight : primaryColorDark;
}
