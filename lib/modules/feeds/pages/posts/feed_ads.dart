import 'dart:async';

import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:kaichon/modules/feeds/data/post_ads.dart';
import 'package:kaichon/modules/feeds/models/post_ads.dart';
import 'package:kaichon/modules/feeds/pages/posts/widgets/post_ads_add.dart';
import 'package:kaichon/modules/feeds/pages/posts/widgets/post_ads_item.dart';
import 'package:kaichon/modules/feeds/pages/posts/widgets/shimmer_ads.dart';
import '../../../../imports.dart';
import '../../../auth/data/user.dart';
import '../../../notifications/provider.dart';
import '../../data/posts.dart';
import '../../models/post.dart';
import 'widgets/post_add.dart';
import 'widgets/post_item.dart';
import 'widgets/shimmer.dart';

class FeedAdsPage extends StatefulWidget {
  @override
  _PostAdsScreenState createState() => _PostAdsScreenState();
}

class _PostAdsScreenState extends State<FeedAdsPage>
    with WidgetsBindingObserver {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final scrolleController = ScrollController();
  String get uid => authProvider.user.id;
  final paging = PagingController<int, PostAds>(firstPageKey: 0);
  StreamSubscription<User> userSub;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    paging.addPageRequestListener((page) async {
      try {
        final res = await PostAdsRepository.fetchPosts(page);
        if (res.length < 20) {
          paging.appendLastPage(res);
        } else {
          paging.appendPage(res, page + 1);
        }
      } catch (error) {
        paging.error = error;
      }
    });

    Get.put<PagingController>(paging);
    userSub = UserRepository.userStream()?.listen(authProvider.updateUser);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    scrolleController.dispose();
    userSub.cancel();
    notificationProvider.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      UserRepository.updateActiveAt(false);
    } else if (state == AppLifecycleState.resumed) {
      UserRepository.updateActiveAt(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return RefreshIndicator(
      onRefresh: () async {
        paging.refresh();
        await 1.delay();
      },
      backgroundColor: AppStyles.primaryColorLight,
      color: AppStyles.primaryColorWhite,
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: AppStyles.primaryColorGray,
        //drawer: HomeDrawer(),
        /*appBar: AppBar(
          centerTitle: true,
          backgroundColor: AppStyles.primaryColorWhite,
          title: LogoIcon(),
          actions: const [
            NotificationIcon(),
            ChatIcon(),
          ],
        ),*/
        body: PagedListView<int, PostAds>(
          pagingController: paging,
          builderDelegate: PagedChildBuilderDelegate(
            itemBuilder: (_, p, i) => Column(
              children: <Widget>[
                if (i == 0)
                  AddPostAdsWidget()
                else if (i % 5 == 0)
                  //Get.find<AdsHelper>().banner(),
                  if (p.show) PostAdsWidget(p),
              ],
            ),
            newPageProgressIndicatorBuilder: (_) => ShimmerPostAds(),
            firstPageProgressIndicatorBuilder: (_) => ShimmerPostAds(),
            noItemsFoundIndicatorBuilder: (_) => Align(
              alignment: Alignment.topCenter,
              child: AddPostAdsWidget(),
            ),
          ),
        ),
      ),
    );
  }
}
