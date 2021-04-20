import 'dart:async';

import 'package:flutter/material.dart';

import 'package:connectivity_widget/connectivity_widget.dart';
import 'package:firebase_core/firebase_core.dart';

import 'components/connectivity.dart';
import 'imports.dart';
import 'modules/auth/pages/home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initalize Fierbase Core for app, necessary for firebase to work
  await Firebase.initializeApp();
  // Init Analytics and crashalytics
  AppAnalytics.init();
  //Load App Configs
  await AppConfigs.init();
  // Initialize app preferences and settings
  await AppPreferences.init();
  // Initialize Authentication, check if user logged In
  await AuthProvider.init();

  runApp(App());
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final ads = Get.put(AdsHelper());

  @override
  void dispose() {
    ads.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: t.AppName,
        /*builder: (_, w) => ConnectivityWidget(
          offlineBanner: ConnectivityBanner(),
          builder: (_, __) => BotToastInit()(_, w),
        ),*/
        navigatorObservers: [
          BotToastNavigatorObserver(),
          appPrefs.routeObserver,
          appAnalytics.observer,
        ],
        themeMode: appPrefs.isDarkMode() ? ThemeMode.dark : ThemeMode.light,
        theme: AppStyles.lightTheme,
        darkTheme: AppStyles.darkTheme,
        home: Navigator(
          onPopPage: (r, res) => r.didPop(res),
          pages: [
            MaterialPage(key: ValueKey('/'), child: HomePage()),
          ],
        ),
      ),
    );
  }
}
