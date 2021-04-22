import 'package:flutter/material.dart';

import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flappy_search_bar/search_bar_style.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../imports.dart';
import '../../data/groups.dart';
import '../../models/group.dart';

class GroupsSearch extends StatefulWidget {
  @override
  _GroupsSearchState createState() => _GroupsSearchState();
}

class _GroupsSearchState extends State<GroupsSearch> {
  final pagingController = PagingController<int, Group>(firstPageKey: 0);

  List<Group> groups;
  @override
  void initState() {
    pagingController.addPageRequestListener((page) async {
      try {
        final res = await GroupsRepository.fetchAllGroups(page);
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: SearchBar<Group>(
            icon: BackButton(),
            onSearch: GroupsRepository.groupsSearch,
            textStyle: TextStyle(color: Colors.white),
            minimumChars: 2,
            searchBarStyle: SearchBarStyle(
              backgroundColor: theme.primaryColor,
            ),
            cancellationWidget: Icon(Icons.close),
            shrinkWrap: true,
            onItemFound: (group, _) => _SearchResultItem(group),
            placeHolder: PagedListView<int, Group>(
              pagingController: pagingController,
              builderDelegate: PagedChildBuilderDelegate(
                itemBuilder: (_, group, __) => _SearchResultItem(group),
                newPageProgressIndicatorBuilder: (_) =>
                    SpinKitCircle(color: Colors.green),
                firstPageProgressIndicatorBuilder: (_) =>
                    SpinKitCircle(color: Colors.green),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SearchResultItem extends StatelessWidget {
  final Group group;

  const _SearchResultItem(
    this.group, {
    Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: ListTile(
        onTap: () => AppNavigator.toGroupInfo(group),
        leading: AvatarWidget(
          group.photoURL,
          radius: 50,
        ),
        title: Text(
          group.name,
          style: TextStyle(color: AppStyles.primaryColorWhite),
          // style: GoogleFonts.basic(
          //     textStyle: Theme.of(context).textTheme.subtitle1),
        ),
      ),
    );
  }
}
