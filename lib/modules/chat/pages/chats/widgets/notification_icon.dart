import 'package:flutter/material.dart';

import 'package:badges/badges.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../imports.dart';

class NotificationIcon extends StatelessWidget {
  const NotificationIcon({
    Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 10, top: 2, bottom: 2),
      child: GestureDetector(
        onTap: AppNavigator.toChats,
        child: Badge(
            position: BadgePosition.topEnd(end: -2, top: -2),
            badgeContent: Text(
              '9',
              style: TextStyle(color: Colors.white),
            ),
            child: IconButton(
              icon: Image.asset('assets/images/icons/notification.png'),
              iconSize: 32,
              onPressed: AppNavigator.toChats,
            )
            /*Icon(
            FontAwesomeIcons.facebookMessenger,
            size: 32,
          ),*/
            ),
      ),
    );
  }
}
