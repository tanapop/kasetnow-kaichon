import 'package:flutter/material.dart';
import 'package:kaichon/modules/feeds/models/post_ads.dart';
import 'package:timeago/timeago.dart' as time_ago;

import '../../../../../imports.dart';
import '../../../data/posts.dart';
import '../../../models/post.dart';

class UserAdsTile extends StatelessWidget {
  final User user;
  final PostAds post;

  const UserAdsTile(
    this.user,
    this.post, {
    Key key,
  }) : super(key: key);

  bool get isAdmin => authProvider.user.isAdmin;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: post.isMine ? null : () => AppNavigator.toProfile(post.authorID),
        child: Column(
          children: [
            Row(
              children: <Widget>[
                AvatarWidget(
                  user.photoURL,
                  radius: 45,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '${user.fullName} ${user.isAdmin ? "(${t.Admin})" : ""}',
                        maxLines: 1,
                        style: TextStyle(
                            color: AppStyles.primaryColorTextField,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        time_ago.format(post.createdAt, locale: 'th'),
                        style: TextStyle(
                          color: AppStyles.primaryColorTextField,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<int>(
                  color: AppStyles.primaryColorWhite,
                  icon: Icon(
                    Icons.more_vert,
                    color: AppStyles.primaryColorTextField,
                  ),
                  itemBuilder: (_) => [
                    if (post.isMine || isAdmin)
                      PopupMenuItem(
                          value: 0,
                          child: Text(
                            t.Edit,
                            style: TextStyle(
                              color: AppStyles.primaryColorTextField,
                            ),
                          )),
                    if (!post.isMine && !isAdmin)
                      PopupMenuItem(
                          value: 1,
                          child: Text(
                            t.Report,
                            style: TextStyle(
                              color: AppStyles.primaryColorTextField,
                            ),
                          ))
                    else if (post.isReported && isAdmin)
                      PopupMenuItem(
                          value: 2,
                          child: Text(
                            t.Unreport,
                            style: TextStyle(
                              color: AppStyles.primaryColorTextField,
                            ),
                          )),
                  ],
                  onSelected: (v) {
                    if (v == 0) {
                      AppNavigator.toPostAdsEditor(post);
                    } else if (v == 1) {
                      AppNavigator.toReportAds(post);
                    } else if (v == 2) {
                      PostsRepository.unReportPost(post.id);
                    }
                  },
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  t.AdsSupporter,
                  style: TextStyle(
                      color: AppStyles.primaryColorGray, fontSize: 10),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
