/*
 *  Copyright 2020 chaobinwu89@gmail.com
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */

import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'model/badge.dart';
import 'model/choice_value.dart';
import 'model/named_color.dart';

/// tab config used in example
class Data {
  static const gradients = [
    null,
    LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Colors.blue, Colors.redAccent, Colors.green, Colors.blue],
      tileMode: TileMode.repeated,
    ),
    LinearGradient(
      begin: Alignment.center,
      end: Alignment(-1, 1),
      colors: [Colors.redAccent, Colors.green, Colors.blue],
      tileMode: TileMode.repeated,
    ),
    RadialGradient(
      center: const Alignment(0, 0), // near the top right
      radius: 5,
      colors: [Colors.green, Colors.blue, Colors.redAccent],
    )
  ];

  static const namedColors = [
    NamedColor(Colors.blue, 'Blue'),
    NamedColor(Color(0xFFf44336), 'Read'),
    NamedColor(Color(0xFF673AB7), 'Purple'),
    NamedColor(Color(0xFF009688), 'Green'),
    NamedColor(Color(0xFFFFC107), 'Yellow'),
    NamedColor(Color(0xFF607D8B), 'Grey'),
  ];
  static const badges = [
    null,
    Badge('1'),
    Badge('hot',
        badgeColor: Colors.orange, padding: EdgeInsets.only(left: 7, right: 7)),
    Badge('99+', borderRadius: 2)
  ];

  static const curves = [
    ChoiceValue<Curve>(
      title: 'Curves.bounceInOut',
      label: 'The curve bounceInOut is used',
      value: Curves.bounceInOut,
    ),
    ChoiceValue<Curve>(
      title: 'Curves.decelerate',
      value: Curves.decelerate,
      label: 'The curve decelerate is used',
    ),
    ChoiceValue<Curve>(
      title: 'Curves.easeInOut',
      value: Curves.easeInOut,
      label: 'The curve easeInOut is used',
    ),
    ChoiceValue<Curve>(
      title: 'Curves.fastOutSlowIn',
      value: Curves.fastOutSlowIn,
      label: 'The curve fastOutSlowIn is used',
    ),
  ];

  static List<TabItem> items({bool image}) {
    if (image) {
      return [
        TabItem<Image>(
          icon: Image.asset('assets/images/icons/home-inactive.png'),
          activeIcon: Image.asset('assets/images/icons/home-active.png'),
          title: 'หน้าหลัก',
        ),
        TabItem<Image>(
            icon: Image.asset('assets/images/icons/chat-inactive.png'),
            activeIcon: Image.asset('assets/images/icons/chat-active.png'),
            title: 'แชท'),
        TabItem<Image>(
          icon: Image.asset('assets/images/icons/live-inactive.png'),
          activeIcon: Image.asset('assets/images/icons/live-active.png'),
          title: 'Live',
        ),

        // TabItem<Image>(
        //   icon: Image.asset('assets/images/icons/ktv-inactive.png'),
        //   activeIcon: Image.asset('assets/images/icons/ktv-active.png'),
        //   title: 'KTV',
        // ),
        TabItem<Image>(
          icon: Image.asset('assets/images/icons/profile-inactive.png'),
          activeIcon: Image.asset('assets/images/icons/profile-active.png'),
          title: 'โปรไฟล์',
        ),
      ];
    }
    return [
      TabItem<IconData>(icon: Icons.home, title: 'หน้าหลัก'),
      TabItem<IconData>(icon: Icons.map, title: "แชท"),
      TabItem<IconData>(icon: Icons.publish, title: "Live"),
      //TabItem<IconData>(icon: Icons.message, title: 'KTV'),
      TabItem<IconData>(icon: Icons.people, title: 'โปรไฟล์'),
    ];
  }
}
