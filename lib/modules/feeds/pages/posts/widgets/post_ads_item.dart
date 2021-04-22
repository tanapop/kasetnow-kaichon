import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:kaichon/modules/feeds/data/post_ads.dart';
import 'package:kaichon/modules/feeds/models/post_ads.dart';
import 'package:kaichon/modules/feeds/pages/posts/widgets/post_ads_image.dart';
import 'package:kaichon/modules/feeds/pages/posts/widgets/user_ads_tile.dart';
import '../../../../../imports.dart';
import '../../../../auth/data/user.dart';
import '../../../data/posts.dart';
import '../../../models/post.dart';
import 'post_image.dart';
import 'user_tile.dart';

class PostAdsWidget extends StatefulWidget {
  final PostAds post;
  final bool showMore;

  const PostAdsWidget(
    this.post, {
    Key key,
    this.showMore = true,
  }) : super(key: key);
  @override
  _PostAdsWidgetState createState() => _PostAdsWidgetState();
}

class _PostAdsWidgetState extends State<PostAdsWidget> {
  String get uid => authProvider.user.id;
  PostAds get post => widget.post;
  @override
  Widget build(BuildContext context) {
    final postSentences = post.content.split('\n');
    final theme = Theme.of(context);

    final showMore = widget.showMore && postSentences.length > 5;
    return StreamBuilder<User>(
        stream: UserRepository.userStream(post.authorID),
        builder: (_, snap) {
          final user = snap.data ?? post.getUser;
          return Container(
            margin: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: user.isAdmin
                  ? AppStyles.primaryBackBlackKnowText
                  : AppStyles.primaryBackBlackKnowText,
              border: Border.all(
                  color: AppStyles.primaryBackBlackKnowText, width: 0.5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                UserAdsTile(user, post),
                if (post.content.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Linkify(
                      text: showMore
                          ? postSentences.take(5).join('\n')
                          : post.content,
                      onOpen: (l) => launchURL(l.url),
                      style: TextStyle(
                          color: AppStyles.primaryColorWhite.withOpacity(1.0),
                          fontSize: 18),
                    ),
                  ),
                  if (showMore)
                    Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: '\n${t.ReadMore}\n',
                              style: theme.textTheme.subtitle2.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppStyles.primaryColorLight),
                              recognizer: TapGestureRecognizer()
                                ..onTap =
                                    () => AppNavigator.toSinglePost(post.id),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
                if (post.hasImage) PostAdsImageWidget(post),
                Row(
                  children: <Widget>[
                    SizedBox(width: 10),
                    Container(
                      width: 0.5,
                      height: 20,
                      color: theme.iconTheme.color,
                    ),
                    SizedBox(width: 10),
                    Spacer(),
                    /*RaisedButton(
                      textColor: Colors.white,
                      color: AppStyles.primaryColorLight,
                      child: Text("บริการขนส่งไก่ชน"),
                      onPressed: () async {
                        await AppNavigator.toPrivateChat(
                            'b7Eq1aLsxJQel9IovcurZvBhMRu1');
                        setState(() {});
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),*/
                    /*TextButton.icon(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(),
                      ),
                      icon: Icon(Icons.mode_comment),
                      /*icon: IconButton(
                        icon: post.commentsIDs.length == 0
                            ? Image.asset(
                                'assets/images/icons/comment-inactive.png')
                            : Image.asset(
                                'assets/images/icons/comment-active.png'),
                        iconSize: 32,
                        onPressed: () async {
                          await AppNavigator.toComments(post);
                          setState(() {});
                        },
                      ),*/
                      label: Text(
                        '${post.commentsIDs?.length ?? 0} ความเห็น',
                        style: theme.textTheme.subtitle1.copyWith(
                            color: AppStyles.primaryColorTextField,
                            fontSize: 14),
                      ),
                      onPressed: () async {
                        await AppNavigator.toComments(post);
                        setState(() {});
                      },
                    ),*/
                    SizedBox(width: 10),
                  ],
                ),
                Row(
                  children: <Widget>[
                    SizedBox(width: 10),
                    GestureDetector(
                      onTap: toggleReaction,
                      child: Padding(
                          padding: const EdgeInsets.only(left: 6, right: 12),
                          child: IconButton(
                            icon: post.liked
                                ? Image.asset(
                                    'assets/images/icons/like-active.png')
                                : Image.asset(
                                    'assets/images/icons/like-inactive.png'),
                            iconSize: 32,
                            onPressed: toggleReaction,
                          )
                          /*child: Icon(
                          post.liked ? Icons.favorite : Icons.favorite_border,
                          color: Colors.red,
                        ),*/
                          ),
                    ),
                    Container(
                      width: 0.5,
                      height: 20,
                      color: theme.iconTheme.color,
                    ),
                    SizedBox(width: 10),
                    GestureDetector(
                      onTap: () => AppNavigator.toReactions(post.usersLikes),
                      child: Text(
                        '${post.usersLikes?.length ?? 0} ถูกใจ',
                        style: theme.textTheme.subtitle1.copyWith(
                            color: AppStyles.primaryColorTextField,
                            fontSize: 14),
                      ),
                    ),
                    Spacer(),
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(),
                      ),
                      //icon: Icon(Icons.mode_comment),
                      icon: IconButton(
                        icon: post.commentsIDs.length == 0
                            ? Image.asset(
                                'assets/images/icons/comment-inactive.png')
                            : Image.asset(
                                'assets/images/icons/comment-active.png'),
                        iconSize: 32,
                        onPressed: () async {
                          await AppNavigator.toAdsComments(post);
                          if (!mounted) {
                            setState(() {});
                          }
                        },
                      ),
                      label: Text(
                        '${post.commentsIDs?.length ?? 0} ความเห็น',
                        style: theme.textTheme.subtitle1.copyWith(
                            color: AppStyles.primaryColorTextField,
                            fontSize: 14),
                      ),
                      onPressed: () async {
                        await AppNavigator.toAdsComments(post);
                        if (!mounted) {
                          setState(() {});
                        }
                      },
                    ),
                    SizedBox(width: 10),
                  ],
                ),
              ],
            ),
          );
        });
  }

  Future<void> toggleReaction() async {
    setState(() => post.toggleLike());
    await PostAdsRepository.togglePostReaction(post);
  }
}
