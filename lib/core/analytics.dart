import 'package:flutter/rendering.dart';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:get/get.dart';

AppAnalytics get appAnalytics => Get.find();

class AppAnalytics {
  FirebaseAnalytics _analytics;
  FirebaseAnalyticsObserver observer;
  FirebaseCrashlytics _crashlytics;
  AppAnalytics._();

  static void init() {
    final _ = AppAnalytics._();
    if (!GetPlatform.isDesktop) {
      _._analytics = FirebaseAnalytics();
      _.observer = FirebaseAnalyticsObserver(analytics: _._analytics);
    }
    if (!GetPlatform.isWeb) {
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    }
    if (!GetPlatform.isMobile) {
      _._crashlytics = FirebaseCrashlytics.instance;
    }
    Get.put(_);
  }

  void logUserInfo(String userId) {
    _crashlytics?.setUserIdentifier(userId);
  }
}
