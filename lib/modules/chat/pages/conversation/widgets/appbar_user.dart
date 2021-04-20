import 'package:flutter/material.dart';

import 'package:timeago/timeago.dart';

import '../../../../../components/confirm_dialog.dart';
import '../../../../../imports.dart';
import '../../../../auth/data/user.dart';
import '../../../data/chats.dart';
import 'typing.dart';

class UserAppBarTile extends StatelessWidget implements PreferredSizeWidget {
  final User user;
  final bool isTyping;

  const UserAppBarTile(
    this.user, {
    Key key,
    this.isTyping = false,
  }) : super(key: key);

  User get currentUser => authProvider.user;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (user == null) return SizedBox();
    return AppBar(
      backgroundColor: AppStyles.primaryColorBlackKnow,
      leading: BackButton(
        color: AppStyles.primaryColorTextField,
      ),
      title: ListTile(
        contentPadding: EdgeInsets.all(0),
        leading: Hero(
          tag: user.id,
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Theme(
              data: ThemeData.dark(),
              child: AvatarWidget(
                user.photoURL,
                radius: 45,
              ),
            ),
          ),
        ),
        title: Container(
          padding: const EdgeInsets.only(top: 20),
          child: Text(
            user.fullName,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: AppStyles.primaryColorTextField),
          ),
        ),
        subtitle: isTyping
            ? TypingWidget()
            : Text(
                user.isOnline
                    ? t.Online
                    : user.onlineStatus
                        ? format(user.activeAt, locale: 'th')
                        : '',
                style: theme.textTheme.headline6.copyWith(
                  fontWeight: FontWeight.w400,
                  fontSize: 11,
                ),
              ),
        onTap: () => AppNavigator.toProfile(user.id),
      ),
      actions: <Widget>[
        PopupMenuButton<int>(
          color: AppStyles.primaryColorWhite,
          icon: Icon(
            Icons.more_vert,
            color: AppStyles.primaryColorTextField,
          ),
          itemBuilder: (_) => [
            PopupMenuItem(
              value: 0,
              child: Text(
                user.isBlocked() ? t.Unblock : t.Block,
                style: TextStyle(color: AppStyles.primaryColorTextField),
              ),
            ),
            PopupMenuItem(
              value: 1,
              child: Text(
                t.RemoveConversation,
                style: TextStyle(color: AppStyles.primaryColorTextField),
              ),
            ),
          ],
          onSelected: (v) {
            if (v == 0) {
              showConfirmDialog(
                context,
                title:
                    '${t.AreYouSure} ${user.isBlocked() ? 'Unblock' : 'Block'} ${user.username}',
                onConfirm: () {
                  UserRepository.toggleBlock(user);
                  Navigator.pop(context);
                },
              );
            } else {
              showConfirmDialog(
                context,
                title: t.ConfirmChatDeletion,
                onConfirm: () {
                  ChatsRepository.removeChat(user.id);
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              );
            }
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
