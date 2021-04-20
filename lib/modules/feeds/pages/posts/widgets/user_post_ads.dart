import 'package:flutter/material.dart';
import 'package:kaichon/modules/feeds/data/post_ads.dart';
import 'package:kaichon/modules/feeds/models/post_ads.dart';
import 'package:kaichon/modules/feeds/pages/posts/widgets/post_ads_item.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../data/posts.dart';
import '../../../models/post.dart';
import 'post_item.dart';
import 'shimmer.dart';

class UserPostAds extends StatefulWidget {
  final String userId;

  const UserPostAds(
    this.userId, {
    Key key,
  }) : super(key: key);
  @override
  _UserPostAdsState createState() => _UserPostAdsState();
}

class _UserPostAdsState extends State<UserPostAds> {
  int offset = 10;
  final _refreshController = RefreshController();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<PostAds>>(
      stream: PostAdsRepository.getUserPostsStream(widget.userId, offset),
      builder: (_, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return ShimmerPost();
        }
        final postAds = snap.data ?? [];
        if (postAds.isEmpty) return SizedBox();

        return SmartRefresher(
          controller: _refreshController,
          enablePullUp: offset <= postAds.length,
          enablePullDown: false,
          onLoading: () async {
            setState(() {
              offset = postAds.length + 10;
            });
            await Future.delayed(Duration(seconds: 2));
            _refreshController.loadComplete();
          },
          child: ListView.builder(
            key: PageStorageKey('user_post_ads'),
            itemCount: postAds.length,
            itemBuilder: (_, i) => PostAdsWidget(postAds[i]),
          ),
        );
      },
    );
  }
}
