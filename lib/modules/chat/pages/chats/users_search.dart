import 'package:flutter/material.dart';

import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flappy_search_bar/search_bar_style.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../imports.dart';
import '../../data/users.dart';

class UsersSearchPage extends StatefulWidget {
  @override
  _UsersSearchPageState createState() => _UsersSearchPageState();
}

class _UsersSearchPageState extends State<UsersSearchPage> {
  final pagingController = PagingController<int, User>(firstPageKey: 0);

  List<User> users;
  @override
  void initState() {
    pagingController.addPageRequestListener((page) async {
      try {
        final res = await ChatUsersRepository.fetchAllUsers(page);
        if (res.length < 20) {
          pagingController.appendLastPage(res);
        } else {
          pagingController.appendPage(res, page + 1);
        }
      } catch (e) {
        logError(e);
        pagingController.error = e;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppStyles.primaryBackBlackKnowText,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: SearchBar<User>(
            icon: BackButton(
              color: AppStyles.primaryColorTextField,
            ),
            onSearch: ChatUsersRepository.usersSearch,
            textStyle: TextStyle(color: AppStyles.primaryColorWhite),
            minimumChars: 2,
            searchBarStyle: SearchBarStyle(
              backgroundColor: AppStyles.primaryColorBlackKnow,
            ),
            cancellationWidget: Icon(Icons.close),
            shrinkWrap: true,
            onItemFound: (item, _) => _SearchResultItem(item),
            placeHolder: PagedListView<int, User>(
              pagingController: pagingController,
              builderDelegate: PagedChildBuilderDelegate(
                itemBuilder: (_, item, __) => _SearchResultItem(item),
                newPageProgressIndicatorBuilder: (_) =>
                    SpinKitCircle(color: AppStyles.primaryColorWhite),
                firstPageProgressIndicatorBuilder: (_) =>
                    SpinKitCircle(color: AppStyles.primaryColorWhite),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SearchResultItem extends StatelessWidget {
  final User user;

  const _SearchResultItem(
    this.user, {
    Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (user.isMe) return SizedBox();
    return ListTile(
      onTap: () => AppNavigator.toProfile(user.id),
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      leading: AvatarWidget(
        user.photoURL,
        radius: 50,
      ),
      title: AppText(
        user.fullName,
        size: 16,
        color: AppStyles.primaryColorTextField,
      ),
      subtitle: Text(
        user.username,
        style: TextStyle(color: AppStyles.primaryColorTextField),
      ),
    );
  }
}
