import 'package:admob_flutter/admob_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../imports.dart';
import '../modules/feeds/data/post_ads.dart';
import '../modules/feeds/models/post_ads.dart';
import '../modules/feeds/pages/posts/widgets/post_ads_item.dart';

class AdsHelper {
  _AdsUnitID adsUnitId = _AdsUnitID.test();

  int nbrBeforeShowAds = 0;

  AdmobInterstitial interstitialAd;
  AdmobReward rewardAd;
  PostAds post;

  AdsHelper() {
    init();
  }

  Future<void> init() async {
    Admob.initialize();
    adsUnitId = await _AdsUnitID.fromFirebase();
    interstitialAd = AdmobInterstitial(adUnitId: adsUnitId.interstitialId);
    rewardAd = AdmobReward(adUnitId: adsUnitId.rewardedId);
    await Admob.requestTrackingAuthorization();
    loadFullAds();
    final String pid = await PostAdsRepository.getDataRandom();
    post = await PostAdsRepository.randomPostStream(pid);
  }

  Future<void> loadFullAds() async {
    if (!adsUnitId.show) return;
    if (!await rewardAd.isLoaded) rewardAd.load();
    if (!await interstitialAd.isLoaded) interstitialAd.load();
  }

  Future<void> showFullAds() async {
    if (!adsUnitId.show) return;
    nbrBeforeShowAds++;
    if (nbrBeforeShowAds < 10) return;
    nbrBeforeShowAds = 0;
    if (await rewardAd.isLoaded) {
      rewardAd.show();
    } else if (await interstitialAd.isLoaded) {
      interstitialAd.show();
    }
    loadFullAds();
  }

  Widget banner() => !adsUnitId.show
      ? SizedBox()
      : AdmobBanner(
          adUnitId: adsUnitId.bannedId,
          adSize: AdmobBannerSize.BANNER,
        );

  Widget supporter() => !adsUnitId.show ? SizedBox() : PostAdsWidget(post);

  void dispose() {
    interstitialAd.dispose();
    rewardAd.dispose();
  }
}

class _AdsUnitID extends Equatable {
  final bool test;
  final bool show;
  final String bannedId;
  final String interstitialId;
  final String rewardedId;
  const _AdsUnitID({
    @required this.test,
    @required this.show,
    @required this.bannedId,
    @required this.interstitialId,
    @required this.rewardedId,
  });

  static Future<_AdsUnitID> fromFirebase() async {
    _AdsUnitID ads = _AdsUnitID.test();
    try {
      final doc = await FirebaseFirestore.instance.doc('app/ads').get();
      if (!doc.exists) {
        await doc.reference.set({
          "test": false,
          'show': true,
          ..._TEST_ADS,
        });
      }
      ads = _AdsUnitID.fromMap(doc.data());
    } catch (e) {
      logError(e);
    }
    return ads;
  }

  factory _AdsUnitID.fromMap(Map map) {
    var ids = GetPlatform.isAndroid ? map['android'] : map['ios'];
    final isTest = map['test'] == true;
    if (isTest) {
      ids = GetPlatform.isAndroid ? _TEST_ADS['android'] : _TEST_ADS['ios'];
    }
    return _AdsUnitID(
      test: isTest,
      show: map['show'] as bool ?? true,
      bannedId: ids['banner'] as String,
      interstitialId: ids['interstitial'] as String,
      rewardedId: ids['rewarded'] as String,
    );
  }
  factory _AdsUnitID.test() => _AdsUnitID.fromMap(_TEST_ADS);

  static const _TEST_ADS = {
    "android": {
      "appId": "ca-app-pub-3940256099942544~3347511713",
      "banner": "ca-app-pub-3940256099942544/6300978111",
      "interstitial": "ca-app-pub-3940256099942544/1033173712",
      "rewarded": "ca-app-pub-3940256099942544/5224354917"
    },
    "ios": {
      "appId": "ca-app-pub-3940256099942544~1458002511",
      "banner": "ca-app-pub-3940256099942544/2934735716",
      "interstitial": "ca-app-pub-3940256099942544/4411468910",
      "rewarded": "ca-app-pub-3940256099942544/5135589807"
    },
  };

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [show, bannedId, interstitialId, rewardedId];
}
