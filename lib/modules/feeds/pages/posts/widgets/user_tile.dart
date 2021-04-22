import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as time_ago;

import '../../../../../imports.dart';
import '../../../data/posts.dart';
import '../../../models/post.dart';

class UserTile extends StatelessWidget {
  final User user;
  final Post post;

  const UserTile(
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
        child: Row(
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
                        color: AppStyles.primaryColorWhite,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    time_ago.format(post.createdAt, locale: 'th'),
                    style: TextStyle(
                        color: AppStyles.primaryColorTextField, fontSize: 12),
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
                  AppNavigator.toPostEditor(post);
                } else if (v == 1) {
                  AppNavigator.toReport(post);
                } else if (v == 2) {
                  PostsRepository.unReportPost(post.id);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
