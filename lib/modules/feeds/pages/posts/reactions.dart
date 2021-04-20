import 'package:flutter/material.dart';

import '../../../../components/user_list.dart';
import '../../../../imports.dart';

class ReactionsPage extends StatelessWidget {
  final List<String> likeIDs;

  const ReactionsPage(
    this.likeIDs, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: AppStyles.primaryColorGray,
      appBar: Appbar(
        backgroundColor: AppStyles.primaryColorWhite,
        title: Text(
          t.Likes,
          style: theme.textTheme.headline6
              .copyWith(color: AppStyles.primaryColorTextField),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppStyles.primaryColorTextField),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: UsersList(usersId: likeIDs),
    );
  }
}
