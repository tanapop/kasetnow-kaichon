import 'package:flutter/material.dart';

import '../../../../../imports.dart';

class AddPostWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: GestureDetector(
        onTap: AppNavigator.toPostEditor,
        child: Row(
          children: <Widget>[
            AvatarWidget(
              authProvider.user.photoURL,
              radius: 40,
            ),
            SizedBox(width: 12),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  //border: Border.all(color: Colors.grey),
                  //borderRadius: BorderRadius.circular(30)),
                  color: AppStyles.primaryBackBlackKnowText,
                  borderRadius: BorderRadius.all(Radius.circular(100.0)),
                  border: Border.all(
                    color: AppStyles.primaryColorWhite,
                    width: 1.0,
                  ),
                ),
                //color: AppStyles.primaryColorGray,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    children: [
                      Text(
                        t.WhatOnMind,
                        style:
                            TextStyle(color: AppStyles.primaryColorTextField),
                      ),
                      Spacer(),
                      Icon(
                        Icons.send,
                        color: AppStyles.primaryColorTextField,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
