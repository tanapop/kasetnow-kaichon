import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../imports.dart';
import '../../data/chats.dart';
import '../../models/chat.dart';
import 'widgets/chat_tile.dart';
import 'widgets/online_users.dart';

class ChatsPage extends StatefulWidget {
  final BuildContext menuScreenContext;
  final Function onScreenHideButtonPressed;
  final bool hideStatus;
  const ChatsPage(
      {Key key,
      this.menuScreenContext,
      this.onScreenHideButtonPressed,
      this.hideStatus = false})
      : super(key: key);

  @override
  _ChatsPageState createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> with RouteAware {
  final scrollController = ScrollController();
  final refreshController = RefreshController();

  List<Chat> chats = [];
  int limit = 20;

  @override
  void dispose() {
    scrollController.dispose();
    refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: AppStyles.primaryBackBlackKnowText,
      appBar: Appbar(
        backgroundColor: AppStyles.primaryColorBlackKnow,
        title: Text(
          t.Chats,
          style: TextStyle(
              fontSize: 20,
              // fontWeight: FontWeight.bold,
              color: AppStyles.primaryColorWhite),
        ),
        actions: const [
          IconButton(
            icon: Icon(Icons.search, color: AppStyles.primaryColorTextField),
            onPressed: AppNavigator.toUsersSearchPage,
          ),
        ],
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "K",
            style: TextStyle(
                backgroundColor: AppStyles.primaryColorBlackKnow,
                fontFamily: "ZenDots",
                fontSize: 33,
                color: AppStyles.primaryColorRedKnow),
          ),
        ),
        /*leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppStyles.primaryColorTextField),
          onPressed: () => Navigator.of(context).pop(),
        ),*/
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OnlineUsersWidget(),
            //Chats
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                t.RecentChats,
                style: TextStyle(
                    color: AppStyles.primaryColorTextField,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: StreamBuilder<List<Chat>>(
                stream: ChatsRepository.chatsStream(limit),
                builder: (_, snap) {
                  chats = snap.data ?? chats;
                  return SmartRefresher(
                    controller: refreshController,
                    enablePullDown: chats.length >= limit,
                    onLoading: () {
                      refreshController.loadComplete();
                      setState(() => limit += 20);
                    },
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: chats.length,
                      itemBuilder: (_, i) => ChatTile(chats[i]),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
