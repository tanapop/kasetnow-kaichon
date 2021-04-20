import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kaichon/modules/auth/provider.dart';
import 'package:kaichon/modules/chat/pages/chats/widgets/notification_icon.dart';
import 'package:kaichon/modules/feeds/pages/posts/category_post.dart';
import 'package:kaichon/modules/feeds/pages/posts/feed_ads.dart';
import 'package:kaichon/modules/ktv/ktv.dart';
import 'package:kaichon/modules/ktv/ktv_main.dart';
import 'package:kaichon/modules/live/live.dart';
import 'package:kaichon/modules/feeds/pages/posts/widgets/logo_icon.dart';

import '../styles.dart';
import 'auth/pages/profile/index.dart';
import 'chat/pages/chats/widgets/chat_icon.dart';
import 'feeds/pages/posts/feed.dart';

class MainTabPage extends StatefulWidget {
  final Widget child;
  MainTabPage({Key key, this.child}) : super(key: key);
  _HomeTabPageState createState() => _HomeTabPageState();
}

Color PrimaryColor = Color(0xff109618);

class _HomeTabPageState extends State<MainTabPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 4);
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    setState(() {
      //widget.colorVal=0xff990099;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isAdmin = authProvider.user.isAdmin;
    return DefaultTabController(
      length: 4,
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: AppStyles.primaryColorWhite,
            title: LogoIcon(),
            actions: const [
              //NotificationIcon(),
              ChatIcon(),
            ],
            bottom: TabBar(
              isScrollable: true,
              indicatorWeight: 4.0,
              indicatorColor: AppStyles.primaryColorLight,
              unselectedLabelColor: Colors.grey,
              controller: _tabController,
              tabs: <Widget>[
                Tab(
                  /*icon: Icon(FontAwesomeIcons.book,
                      color: _tabController.index == 0
                          ? AppStyles.primaryColorLight
                          : Colors.grey),*/
                  icon: _tabController.index == 0
                      ? Image.asset(
                          'assets/images/icons/home-active.png',
                          width: 40,
                          height: 40,
                        )
                      : Image.asset(
                          'assets/images/icons/home-inactive.png',
                          width: 40,
                          height: 40,
                        ),
                  iconMargin: const EdgeInsets.only(left: 15, right: 15),
                  child: Text('หน้าหลัก',
                      style: TextStyle(
                          color: _tabController.index == 0
                              ? AppStyles.primaryColorLight
                              : Colors.grey)),
                ),
                Tab(
                  icon: _tabController.index == 1
                      ? Image.asset(
                          'assets/images/icons/live-active.png',
                          width: 40,
                          height: 40,
                        )
                      : Image.asset(
                          'assets/images/icons/live-inactive.png',
                          width: 40,
                          height: 40,
                        ),
                  iconMargin: const EdgeInsets.only(left: 15, right: 15),
                  child: Text('ถ่ายทอดสด',
                      style: TextStyle(
                          color: _tabController.index == 1
                              ? AppStyles.primaryColorLight
                              : Colors.grey)),
                ),
                Tab(
                  icon: _tabController.index == 2
                      ? Image.asset(
                          'assets/images/icons/ktv-active.png',
                          width: 40,
                          height: 40,
                        )
                      : Image.asset(
                          'assets/images/icons/ktv-inactive.png',
                          width: 40,
                          height: 40,
                        ),
                  iconMargin: const EdgeInsets.only(left: 15, right: 15),
                  child: Text('KTV',
                      style: TextStyle(
                          color: _tabController.index == 2
                              ? AppStyles.primaryColorLight
                              : Colors.grey)),
                ),
                Tab(
                  icon: _tabController.index == 3
                      ? Image.asset(
                          'assets/images/icons/profile-active.png',
                          width: 40,
                          height: 40,
                        )
                      : Image.asset(
                          'assets/images/icons/profile-inactive.png',
                          width: 40,
                          height: 40,
                        ),
                  iconMargin: const EdgeInsets.only(left: 15, right: 15),
                  child: Text('โปรไฟล์',
                      style: TextStyle(
                          color: _tabController.index == 3
                              ? AppStyles.primaryColorLight
                              : Colors.grey)),
                ),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            physics: NeverScrollableScrollPhysics(),
            children: <Widget>[
              FeedPage(),
              LivePage(),
              //if (isAdmin == true) FeedAdsPage() else CategoryPage(),
              KtvPage(),
              ProfilePage(),
              //HomeTopTabs(0xffff5722), //ff5722
              //GamesTopTabs(0xff3f51b5), //3f51b5
              //MoviesTopTabs(0xffe91e63), //e91e63
              //BooksTopTabs(0xff9c27b0), //9c27b0
              //MusicTopTabs(0xff2196f3), //2196f3 //4CAF50
            ],
          )),
    );
  }
}
