import 'package:flutter/material.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../data/posts.dart';
import '../../../models/post.dart';
import 'post_item.dart';
import 'shimmer.dart';

class UserPosts extends StatefulWidget {
  final String userId;

  const UserPosts(
    this.userId, {
    Key key,
  }) : super(key: key);
  @override
  _UserPostsState createState() => _UserPostsState();
}

class _UserPostsState extends State<UserPosts> {
  int offset = 10;
  final _refreshController = RefreshController();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Post>>(
      stream: PostsRepository.getUserPostsStream(widget.userId, offset),
      builder: (_, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return ShimmerPost();
        }
        final posts = snap.data ?? [];
        if (posts.isEmpty) return SizedBox();

        return SmartRefresher(
          controller: _refreshController,
          enablePullUp: offset <= posts.length,
          enablePullDown: false,
          onLoading: () async {
            setState(() {
              offset = posts.length + 10;
            });
            await Future.delayed(Duration(seconds: 2));
            _refreshController.loadComplete();
          },
          child: ListView.builder(
            key: PageStorageKey('user_posts'),
            itemCount: posts.length,
            itemBuilder: (_, i) => PostWidget(posts[i]),
          ),
        );
      },
    );
  }
}
