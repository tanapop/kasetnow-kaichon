import 'dart:async';

import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../../../imports.dart';
import '../../../auth/data/user.dart';
import '../../../notifications/provider.dart';
import '../../data/posts.dart';
import '../../models/post.dart';
import 'widgets/post_add.dart';
import 'widgets/post_item.dart';
import 'widgets/shimmer.dart';

class CategoryPage extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryPage>
    with WidgetsBindingObserver {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final scrolleController = ScrollController();
  String get uid => authProvider.user.id;
  final paging = PagingController<int, Post>(firstPageKey: 0);
  StreamSubscription<User> userSub;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    paging.addPageRequestListener((page) async {
      try {
        final res = await PostsRepository.fetchPosts(page);
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
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: AppStyles.primaryColorGray,
      body: Stack(children: [
        Center(
          child: SizedBox(
            height: 100,
            child: Text(
              "เร็วๆ นี้",
              style: TextStyle(
                  color: AppStyles.primaryColorTextField, fontSize: 20),
            ),
          ),
        ),
        //Text("เร็วๆ นี้"),
        /*Container(
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage("assets/images/icons/image-small.png"),
            fit: BoxFit.none,
            alignment: Alignment.topCenter,
          )),
        )*/
      ]),
    );
    /*final theme = Theme.of(context);
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
        body: PagedListView<int, Post>(
          pagingController: paging,
          builderDelegate: PagedChildBuilderDelegate(
            itemBuilder: (_, p, i) => Column(
              children: <Widget>[
                //Text("เร็วๆ นี้"),
                /*if (i == 0)
                  AddPostWidget()
                else if (i % 5 == 0)
                  //Get.find<AdsHelper>().banner(),
                  if (p.show) PostWidget(p),*/
              ],
            ),
            //newPageProgressIndicatorBuilder: (_) => ShimmerPost(),
            //firstPageProgressIndicatorBuilder: (_) => ShimmerPost(),
            noItemsFoundIndicatorBuilder: (_) => Align(
              alignment: Alignment.topCenter,
              child: AddPostWidget(),
            ),
          ),
        ),
      ),
    );*/
  }
}
