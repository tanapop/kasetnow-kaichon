import 'package:flutter/material.dart';
import 'package:kaichon/modules/feeds/data/ads_comments.dart';
import 'package:kaichon/modules/feeds/models/ads_comment.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../../imports.dart';
import '../../../data/comments.dart';
import '../../../models/comment.dart';
import '../widgets/input.dart';
import 'widgets/reply_widget.dart';

class AdsReplyPage extends StatefulWidget {
  final AdsComment comment;

  const AdsReplyPage(
    this.comment, {
    Key key,
  }) : super(key: key);

  @override
  _AdsCommentReplyPageState createState() => _AdsCommentReplyPageState();
}

class _AdsCommentReplyPageState extends State<AdsReplyPage> {
  final scrollController = ScrollController();
  final refreshController = RefreshController();

  AdsComment get comment => widget.comment;

  int offset = 10;
  @override
  void dispose() {
    scrollController.dispose();
    refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          t.Replies,
          style: theme.textTheme.headline6,
        ),
      ),
      body: StreamBuilder<Comment>(
        stream: CommentsRepository.singleCommentStream(comment.id),
        builder: (context, snapshot) {
          final comment = snapshot.data;
          if (comment == null) return Container();
          return Column(
            children: <Widget>[
              AbsorbPointer(
                child: ReplyWidget(
                  comment: comment,
                  commentParentId: comment.id,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 10),
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: comment.replyComments?.length ?? 0,
                    itemBuilder: (_, i) => ReplyWidget(
                      comment: comment.replyComments[i],
                      commentParentId: comment.id,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              CommentInput(
                onSubmit: addReplyComment,
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> addReplyComment(String content) async {
    try {
      if (content.isEmpty) return;
      final reply = AdsComment.create(
        content: content,
        postID: comment.postID,
        postAuthorID: comment.postAuthorID,
        parentID: comment.id,
      );
      await AdsCommentsRepository.addCommentReply(comment.id, reply);
      comment.replyComments.add(reply);
    } catch (e) {
      logError(e);
    }
  }
}
