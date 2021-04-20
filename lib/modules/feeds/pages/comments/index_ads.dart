import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:profanity_filter/profanity_filter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../imports.dart';
import '../../data/ads_comments.dart';
import '../../models/ads_comment.dart';
import '../../models/post_ads.dart';
import 'widgets/ads_comment_widget.dart';
import 'widgets/ads_shimmer.dart';
import 'widgets/input.dart';

class AdsCommentsPage extends StatefulWidget {
  final PostAds post;
  const AdsCommentsPage(
    this.post, {
    Key key,
  }) : super(key: key);

  @override
  _AdsCommentsPageState createState() => _AdsCommentsPageState();
}

class _AdsCommentsPageState extends State<AdsCommentsPage> {
  final scrollController = ScrollController();
  final refreshController = RefreshController();
  final textController = TextEditingController();

  PostAds get post => widget.post;
  List<AdsComment> comments = <AdsComment>[];

  int limit = 20;

  @override
  void dispose() {
    textController.dispose();
    scrollController.dispose();
    refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: AppStyles.primaryBackBlackKnowText,
      appBar: AppBar(
        backgroundColor: AppStyles.primaryColorBlackKnow,
        centerTitle: true,
        title: Text(
          t.Comments,
          style: theme.textTheme.headline6
              .copyWith(color: AppStyles.primaryColorTextField),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppStyles.primaryColorTextField),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(height: 10),
          Expanded(
            child: StreamBuilder<List<AdsComment>>(
              stream: AdsCommentsRepository.commentsStream(post.id, limit),
              builder: (_, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return AdsCommentShimmer();
                }
                comments = snap.data ?? comments;
                return SmartRefresher(
                  controller: refreshController,
                  enablePullDown: limit <= comments.length,
                  dragStartBehavior: DragStartBehavior.down,
                  onRefresh: () async {
                    limit = comments.length + 10;
                    refreshController.loadComplete();
                  },
                  child: ListView.builder(
                    controller: scrollController,
                    reverse: true,
                    itemCount: comments.length,
                    itemBuilder: (_, index) => AdsCommentWidget(
                      comments[index],
                      onEdit: (v) => onEditComment(comments[index], v),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 10),
          CommentInput(
            onSubmit: (content) async {
              if (content.isEmpty) return;
              await Future.delayed(Duration(milliseconds: 50))
                  .then((_) => textController.clear());
              await addComment(content);
            },
          ),
        ],
      ),
    );
  }

  Future<void> addComment(String content) async {
    if (ProfanityFilter().hasProfanity(content)) {
      BotToast.showText(
        text: 'Bad words detected, your account may get suspended!',
        duration: Duration(seconds: 5),
      );
      return;
    }
    try {
      final comment = AdsComment.create(
        content: content,
        postID: post.id,
        postAuthorID: post.authorID,
      );
      post?.commentsIDs?.add(comment.id);
      comments.insert(0, comment);
      await AdsCommentsRepository.addComment(comment);
    } catch (e) {
      logError(e);
    }
  }

  Future<void> onEditComment(AdsComment comment, String content) async {
    if (ProfanityFilter().hasProfanity(content)) {
      BotToast.showText(
        text: 'Bad words detected, your account may get suspended!',
        duration: Duration(seconds: 5),
      );
      return;
    }
    await AdsCommentsRepository.updateComment(
        comment.copyWith(content: content));
  }

  Future<void> addOrRemoveReaction(AdsComment comment) async {
    await AdsCommentsRepository.toggleLike(comment);
  }
}
