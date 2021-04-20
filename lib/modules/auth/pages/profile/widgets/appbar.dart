import 'package:flutter/material.dart';

import '../../../../../components/confirm_dialog.dart';
import '../../../../../imports.dart';
import '../../../data/user.dart';

class ProfileAppBar extends StatelessWidget {
  final Rx<User> rxUser;
  //final bool isBackShow;

  const ProfileAppBar(
    this.rxUser,
    //this.isBackShow,
    {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Obx(() {
        final user = rxUser();
        return AppBar(
          backgroundColor: AppStyles.primaryColorBlackKnow,
          iconTheme: IconThemeData(),
          elevation: 0,
          /*leading: IconButton(
            icon:
                Icon(Icons.arrow_back, color: AppStyles.primaryColorTextField),
            onPressed: () => Navigator.of(context).pop(),
          ),*/
          actions: [
            PopupMenuButton<int>(
              color: AppStyles.primaryColorWhite,
              icon: Icon(
                Icons.more_vert,
                color: AppStyles.primaryColorTextField,
              ),
              itemBuilder: (_) => [
                if (!user.isMe)
                  PopupMenuItem(
                    value: 0,
                    child: Text(
                      user.isBlocked() ? t.Unblock : t.Block,
                      style: TextStyle(
                        color: AppStyles.primaryColorTextField,
                      ),
                    ),
                  ),
                if (!user.isMe && authProvider.user.isAdmin)
                  PopupMenuItem(
                    value: 1,
                    child: Text(
                      user.isBanned ? t.Unban : t.Ban,
                      style: TextStyle(
                        color: AppStyles.primaryColorTextField,
                      ),
                    ),
                  ),
                if (user.isMe)
                  PopupMenuItem(
                    value: 2,
                    child: Text(
                      t.Edit,
                      style: TextStyle(
                        color: AppStyles.primaryColorTextField,
                      ),
                    ),
                  ),
                if (user.isMe)
                  PopupMenuItem(
                    value: 3,
                    child: Text(
                      t.Logout,
                      style: TextStyle(
                        color: AppStyles.primaryColorTextField,
                      ),
                    ),
                  ),
              ],
              onSelected: (v) {
                if (v == 0) {
                  showConfirmDialog(
                    context,
                    title:
                        '${t.AreYouSure} ${user.isBlocked() ? t.Unblock : t.Block} ${user.username}',
                    onConfirm: () {
                      UserRepository.toggleBlock(user);
                      Navigator.pop(context);
                    },
                  );
                } else if (v == 1) {
                  showConfirmDialog(
                    context,
                    title:
                        '${t.AreYouSure} ${user.isBanned ? t.Unban : t.Ban} ${user.username}',
                    onConfirm: () {
                      rxUser(user.copyWith(isBanned: !user.isBanned));
                      UserRepository.banUser(user.id);
                      Navigator.pop(context);
                    },
                  );
                } else if (v == 2) {
                  AppNavigator.toEditProfile();
                } else if (v == 3) {
                  authProvider.logout();
                }
              },
            ),
          ],
        );
      });
}
