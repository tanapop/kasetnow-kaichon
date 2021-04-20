import 'package:flutter/material.dart';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:kaichon/modules/feeds/pages/posts/widgets/user_post_ads.dart';
import '../../../../components/user_list.dart';
import '../../../../imports.dart';
import '../../../feeds/pages/posts/widgets/user_posts.dart';
import '../../data/user.dart';
import '../../provider.dart';
import 'widgets/header.dart';

class ProfilePage extends StatefulWidget {
  final BuildContext menuScreenContext;
  final Function onScreenHideButtonPressed;
  final bool hideStatus;
  final String userID;
  final bool isBackShow;

  const ProfilePage(
      {Key key,
      this.userID,
      this.isBackShow,
      this.menuScreenContext,
      this.onScreenHideButtonPressed,
      this.hideStatus = false})
      : super(key: key);
  @override
  _MyProfilePageState createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<ProfilePage> {
  Rx<User> rxUser = Rx<User>();
  @override
  void initState() {
    if (widget.userID?.isNotEmpty == true) {
      UserRepository.fetchUser(widget.userID).then(rxUser);
    } else {
      rxUser = authProvider.rxUser;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) => Obx(() {
        final user = rxUser();
        if (user == null) return Scaffold();
        if (user.isAdmin) {
          return DefaultTabController(
            length: 4,
            child: Scaffold(
              backgroundColor: AppStyles.primaryColorBlackKnow,
              body: NestedScrollView(
                headerSliverBuilder: (_, v) => [
                  SliverAppBar(
                    expandedHeight: user.isMe ? 400 : 450,
                    //elevation: 0,
                    //brightness: Brightness.light,
                    title: Text(
                      t.Profile,
                      style: TextStyle(
                          color: AppStyles.primaryColorTextField,
                          fontWeight: FontWeight.bold),
                    ),
                    automaticallyImplyLeading: false,
                    pinned: true,
                    floating: true,
                    backgroundColor: AppStyles.primaryColorBlackKnow,
                    flexibleSpace: ProfileHeader(rxUser),
                    leading: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "K",
                        style: TextStyle(
                            backgroundColor: AppStyles.primaryColorBlackKnow,
                            fontFamily: "ZenDots",
                            fontSize: 33,
                            color: AppStyles.primaryColorRedKnow),
                      ),
                    ),
                    bottom: TabBar(
                      labelColor: AppStyles.primaryColorBlackKnow,
                      indicatorColor: AppStyles.primaryColorRedKnow,
                      indicatorWeight: 4.0,
                      tabs: [
                        _Item(
                          title: t.POSTS_ADS,
                          info: '${user.postAds.length}',
                        ),
                        _Item(
                          title: t.POSTS,
                          info: '${user.posts.length}',
                        ),
                        _Item(
                          title: t.FOLLOWERS,
                          info: '${user.followers.length}',
                        ),
                        _Item(
                          title: t.FOLLOWINGS,
                          info: '${user.following.length}',
                        ),
                      ],
                    ),
                  ),
                ],
                body: TabBarView(
                  children: [
                    UserPostAds(
                      user.id,
                      key: PageStorageKey('0'),
                    ),
                    UserPosts(
                      user.id,
                      key: PageStorageKey('1'),
                    ),
                    UsersList(
                      usersId: user.followers,
                      key: PageStorageKey('2'),
                    ),
                    UsersList(
                      usersId: user.following,
                      key: PageStorageKey('3'),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return DefaultTabController(
            length: 3,
            child: Scaffold(
              backgroundColor: AppStyles.primaryColorBlackKnow,
              body: NestedScrollView(
                headerSliverBuilder: (_, v) => [
                  SliverAppBar(
                    title: Text(
                      t.Profile,
                      style: TextStyle(
                          color: AppStyles.primaryColorTextField,
                          fontWeight: FontWeight.bold),
                    ),
                    //elevation: 0,
                    //brightness: Brightness.light,
                    expandedHeight: user.isMe ? 400 : 450,
                    automaticallyImplyLeading: false,
                    snap: true,
                    pinned: true,
                    floating: true,
                    backgroundColor: AppStyles.primaryColorBlackKnow,
                    flexibleSpace: ProfileHeader(rxUser),
                    //leading: SizedBox(),
                    bottom: TabBar(
                      labelColor: AppStyles.primaryColorBlack,
                      indicatorColor: AppStyles.primaryColorLight,
                      indicatorWeight: 4.0,
                      tabs: [
                        _Item(
                          title: t.POSTS,
                          info: '${user.posts.length}',
                        ),
                        _Item(
                          title: t.FOLLOWERS,
                          info: '${user.followers.length}',
                        ),
                        _Item(
                          title: t.FOLLOWINGS,
                          info: '${user.following.length}',
                        ),
                      ],
                    ),
                  ),
                ],
                body: TabBarView(
                  children: [
                    UserPosts(
                      user.id,
                      key: PageStorageKey('0'),
                    ),
                    UsersList(
                      usersId: user.followers,
                      key: PageStorageKey('1'),
                    ),
                    UsersList(
                      usersId: user.following,
                      key: PageStorageKey('2'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      });
}

class _Item extends StatelessWidget {
  final String title;
  final String info;
  final VoidCallback onTap;

  const _Item({
    Key key,
    @required this.title,
    @required this.info,
    this.onTap,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: <Widget>[
          AutoSizeText(
            title,
            maxLines: 1,
            style: TextStyle(
              fontWeight: FontWeight.w900,
              color: AppStyles.primaryColorTextField,
            ),
          ),
          SizedBox(height: 2),
          AppText(
            info,
            fontWeight: FontWeight.w900,
            size: 18.0,
            color: AppStyles.primaryColorTextField,
          ),
        ],
      ),
    );
  }
}
