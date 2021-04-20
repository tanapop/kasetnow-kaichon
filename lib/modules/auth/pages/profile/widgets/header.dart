import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaichon/components/button_profile.dart';

import '../../../../../imports.dart';
import '../../../data/user.dart';
import 'appbar.dart';

class ProfileHeader extends StatelessWidget implements PreferredSizeWidget {
  final Rx<User> rxUser;
  //final bool isBackShow;

  const ProfileHeader(
    this.rxUser,
    //this.isBackShow,
    {
    Key key,
  }) : super(key: key);

  User get user => rxUser();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: user.isMe ? 450 : 500,
      color: AppStyles.primaryColorBlackKnow,
      child: Stack(
        children: <Widget>[
          Positioned(
            bottom: user.isMe ? 200 : 250,
            left: 0,
            right: 0,
            child: AppImage(
              ImageModel(user.coverPhotoURL, height: 250),
              fit: BoxFit.fill,
              errorWidget: Container(
                width: context.width,
                height: 260,
                color: AppStyles.primaryColorBlackKnow,
              ),
            ),
          ),
          Positioned(
            bottom: user.isMe ? 50 : 110,
            left: .6,
            right: .6,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1),
              child: Material(
                /*shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),*/
                //elevation: 5.0,
                color: AppStyles.primaryBackBlackKnowText,
                child: Column(
                  children: [
                    SizedBox(height: 80),
                    Text(
                      '@${user.username}',
                      style: TextStyle(
                        fontSize: 28,
                        color: AppStyles.primaryColorTextField,
                      ),
                      maxLines: 1,
                    ),
                    Text(
                      user.fullName,
                      style: TextStyle(
                        fontSize: 20,
                        color: AppStyles.primaryColorTextField,
                      ),
                    ),
                    SizedBox(height: 20),
                    AppText(
                      user.status,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: user.isMe ? 350 : 410,
            child: ProfileAppBar(rxUser),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: user.isMe ? 180 : 230,
            child: Center(
              child: Material(
                elevation: 5,
                shadowColor: Colors.grey,
                shape: CircleBorder(),
                child: AvatarWidget(
                  user.photoURL,
                  radius: 180,
                ),
              ),
            ),
          ),
          //Follow And Message Buttons
          if (!user.isMe)
            Positioned(
              right: 0,
              left: 0,
              bottom: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppProfileButton(
                    user.isFollowing ? t.Following : t.Follow,
                    width: 180,
                    borderRadius: 50,
                    color: AppStyles.primaryColorWhite,
                    backgroundColor: user.isFollowing
                        ? AppStyles.primaryColorGray
                        : AppStyles.primaryColorLight,
                    onTap: () {
                      user.toggleFollowing();
                      rxUser.refresh();
                      UserRepository.followUser(user);
                    },
                  ),
                  AppProfileButton(
                    t.Message,
                    color: AppStyles.primaryColorWhite,
                    backgroundColor: AppStyles.primaryColorLight,
                    width: 180,
                    borderRadius: 50,
                    onTap: () => AppNavigator.toPrivateChat(user.id),
                  ),
                ],
              ),
            ),
          if (user.isAdmin && user.isMe)
            Positioned(
              right: 0,
              left: 0,
              bottom: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppProfileButton(
                    "โฆษณา",
                    color: AppStyles.primaryColorWhite,
                    backgroundColor: AppStyles.primaryColorRedKnow,
                    width: 180,
                    borderRadius: 50,
                    onTap: () => AppNavigator.toAddPostAds(),
                  ),
                ],
              ),
            )
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(300);
}
