import 'dart:async';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flare_flutter/flare_controls.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:kaichon/modules/live/model/live.dart';
import 'package:kaichon/modules/live/join.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../imports.dart';
import '../auth/data/user.dart';
import '../notifications/provider.dart';
import '../feeds/data/posts.dart';
import '../feeds/models/post.dart';
import '../feeds/pages/posts/widgets/post_add.dart';
import '../feeds/pages/posts/widgets/post_item.dart';
import '../feeds/pages/posts/widgets/shimmer.dart';

class LivePage extends StatefulWidget {
  final BuildContext menuScreenContext;
  final Function onScreenHideButtonPressed;
  final bool hideStatus;
  const LivePage(
      {Key key,
      this.menuScreenContext,
      this.onScreenHideButtonPressed,
      this.hideStatus = false})
      : super(key: key);
  @override
  _LiveScreenState createState() => _LiveScreenState();
}

class _LiveScreenState extends State<LivePage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final scrolleController = ScrollController();
  String get uid => authProvider.user.id;
  final paging = PagingController<int, Post>(firstPageKey: 0);
  //StreamSubscription<User> userSub;

  final FlareControls flareControls = FlareControls();
  final databaseReference = FirebaseFirestore.instance;
  List<Live> list = [];
  bool ready = false;
  Live liveUser;
  String userId;
  String fullName;
  var photoURL =
      'https://nichemodels.co/wp-content/uploads/2019/03/user-dummy-pic.png';
  var logo = Image.asset('assets/images/2.png');
  String username;
  var postUsername;

  @override
  void initState() {
    super.initState();

    loadSharedPref();
    //username = authProvider.user.username;
    //image = authProvider.user.photoURL;
    list = [];
    liveUser = Live(username: username, me: true, photoURL: photoURL);
    setState(() {
      list.add(liveUser);
    });
    dbChangeListen();
  }

  Future<void> loadSharedPref() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = authProvider.user.id ?? '0';
      fullName = authProvider.user.fullName ?? 'Jon Doe';
      username = authProvider.user.username ?? 'jon';
      photoURL = authProvider.user.photoURL ??
          'https://nichemodels.co/wp-content/uploads/2019/03/user-dummy-pic.png';
    });
  }

  void dbChangeListen() {
    databaseReference
        .collection('liveuser')
        .orderBy("time", descending: true)
        .snapshots()
        .listen((result) {
      // Listens to update in appointment collection

      setState(() {
        list = [];
        liveUser = Live(username: username, me: true, photoURL: photoURL);
        list.add(liveUser);
      });
      // ignore: avoid_function_literals_in_foreach_calls
      result.docs.forEach((result) {
        setState(() {
          list.add(Live(
              username: result.data()['username'].toString(),
              fullName: result.data()['fullName'].toString(),
              photoURL: result.data()['photoURL'].toString(),
              channelId: int.parse(result.data()['channelId'].toString()),
              channelName: result.data()['channelName'].toString(),
              me: false));
        });
      });
    });
  }

  Widget getStories() {
    return ListView(
        scrollDirection: Axis.horizontal, children: getUserStories());
  }

  List<Widget> getUserStories() {
    List<Widget> stories = [];
    for (Live users in list) {
      stories.add(getStory(users));
    }
    return stories;
  }

  Widget getStory(Live users) {
    String card =
        "https://firebasestorage.googleapis.com/v0/b/kasetnow-39a7b.appspot.com/o/event%2Fqrbg%2F47156823_525961837885484_4306773830384222208_n.jpg?alt=media&token=83681361-08a7-4689-a0e5-07dd5d6966f0";
    return Container(
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(color: AppStyles.primaryColorGray),
      child: Column(
        children: <Widget>[
          if (!users.me)
            Container(
                height: 200,
                // height: 75,
                width: 120,
                // width: 60,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(card),
                    fit: BoxFit.cover,
                  ),
                ),
                child: GestureDetector(
                  onTap: () {
                    /*if (users.me == true) {
                    // Host function
                    onCreate(username: users.username, image: users.image);
                  } else {*/
                    // Join function
                    onJoin(
                        channelName: users.username,
                        channelId: users.channelId,
                        userId: userId,
                        fullName: fullName,
                        hostImage: users.photoURL,
                        userImage: photoURL);
                    //}
                    /*onJoin(
                      channelName: users.username,
                      channelId: users.channelId,
                      username: username,
                      hostImage: users.image,
                      userImage: image);*/
                  },
                  child: Stack(
                    alignment: Alignment(0, 0),
                    children: <Widget>[
                      if (!users.me)
                        Container(
                          //height: 120,
                          //width: 120,
                          height: 60,
                          width: 60,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              //gradient: AppStyles.primaryGradient
                              color: AppStyles.primaryColorRedKnow,
                            ),
                          ),
                        )
                      else
                        SizedBox(
                          height: 0,
                        ),
                      /*Container(
                      height: 110,
                      width: 110,
                      child: CircleAvatar(
                        backgroundColor: Colors.black,
                      ),
                    ),*/
                      if (!users.me)
                        CachedNetworkImage(
                          imageUrl: users.photoURL,
                          imageBuilder: (context, imageProvider) => Container(
                            // width: 104.0,
                            // height: 104.0,
                            width: 55.0,
                            height: 55.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: imageProvider, fit: BoxFit.cover),
                            ),
                          ),
                        )
                      else
                        Container(),
                      if (users.me)
                        Container(
                            /*height: 110,
                            width: 110,
                            alignment: Alignment.bottomRight,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1,
                                ),
                              ),
                              child: Icon(
                                Icons.add,
                                size: 13.5,
                                color: Colors.white,
                              ),
                            )*/
                            )
                      else
                        Container(
                            height: 180,
                            width: 200,
                            alignment: Alignment.bottomCenter,
                            child: Stack(
                              alignment: Alignment.center,
                              children: <Widget>[
                                Container(
                                  height: 17,
                                  width: 25,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            4.0) //         <--- border radius here
                                        ),
                                    //gradient: AppStyles.primaryGradient,
                                    color: AppStyles.primaryColorRedKnow,
                                  ),
                                ),
                                Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              2.0) //         <--- border radius here
                                          ),
                                      gradient: LinearGradient(colors: [
                                        Colors.indigo,
                                        AppStyles.primaryColorRed
                                      ]),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: Text(
                                        'LIVE',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )),
                              ],
                            ))
                    ],
                  ),
                ))
          else
            Container(),
          //SizedBox(
          //height: 3,
          //),
          if (!users.me)
            Container(
              height: 20,
              child: Text(users.fullName ?? '',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: AppStyles.primaryColorTextField, fontSize: 14)),
            )
          else
            Container()
        ],
      ),
    );
  }

  Future<void> onJoin(
      {String channelName,
      int channelId,
      String userId,
      String fullName,
      String hostImage,
      String userImage}) async {
    // update input validation
    if (channelName.isNotEmpty != null) {
      // push video page with given channel name
      //
      await AppNavigator.toJoinLive(
          channelName, channelId, userId, fullName, hostImage, userImage);
      /*await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => JoinPage(
            channelName: channelName,
            channelId: channelId,
            username: username,
            hostImage: hostImage,
            userImage: userImage,
          ),
        ),
      );*/
    }
  }

  @override
  void dispose() {
    scrolleController.dispose();
    //userSub.cancel();
    notificationProvider.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      UserRepository.updateActiveAt(false);
    } else if (state == AppLifecycleState.resumed) {
      UserRepository.updateActiveAt(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    //var width =
    return Scaffold(
      appBar: Appbar(
        backgroundColor: AppStyles.primaryColorBlackKnow,
        title: Text(
          t.Live,
          style: TextStyle(
              fontSize: 20,
              //fontWeight: FontWeight.bold,
              color: AppStyles.primaryColorWhite),
        ),
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
        /*actions: const [
          IconButton(
            icon: Icon(Icons.search, color: AppStyles.primaryColorTextField),
            onPressed: AppNavigator.toUsersSearchPage,
          ),
        ],
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppStyles.primaryColorTextField),
          onPressed: () => Navigator.of(context).pop(),
        ),*/
      ),
      key: scaffoldKey,
      backgroundColor: AppStyles.primaryBackBlackKnowText,
      body: Stack(children: [
        Container(
            color: AppStyles.primaryBackBlackKnowText,
            child: ListView(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    // Divider(
                    //   height: 0,
                    // ),
                    Container(
                      decoration: BoxDecoration(
                          color: AppStyles.primaryBackBlackKnowText),
                      height: 260,
                      child: list.length > 1
                          ? getStories()
                          : Padding(
                              padding: const EdgeInsets.only(top: 50),
                              child: Text(
                                "ไม่มีรายการถ่ายทอดสด",
                                style: TextStyle(
                                    color: AppStyles.primaryColorTextField),
                              ),
                            ),
                    ),
                    // Divider(
                    //   height: 0,
                    // ),
                    //Column(
                    //  children: getPosts(context),
                    //),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                )
              ],
            )),
        //Text("เร็วๆ นี้"),
        /*Container(
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage("assets/images/icons/image-small.png"),
            fit: BoxFit.none,
            alignment: Alignment.topCenter,
          )),
        )*/
      ]),
    );
    /*final theme = Theme.of(context);
    return RefreshIndicator(
      onRefresh: () async {
        paging.refresh();
        await 1.delay();
      },
      backgroundColor: AppStyles.primaryColorLight,
      color: AppStyles.primaryColorWhite,
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: AppStyles.primaryColorGray,
        //drawer: HomeDrawer(),
        /*appBar: AppBar(
          centerTitle: true,
          backgroundColor: AppStyles.primaryColorWhite,
          title: LogoIcon(),
          actions: const [
            NotificationIcon(),
            ChatIcon(),
          ],
        ),*/
        body: PagedListView<int, Post>(
          pagingController: paging,
          builderDelegate: PagedChildBuilderDelegate(
            itemBuilder: (_, p, i) => Column(
              children: <Widget>[
                //Text("เร็วๆ นี้"),
                /*if (i == 0)
                  AddPostWidget()
                else if (i % 5 == 0)
                  //Get.find<AdsHelper>().banner(),
                  if (p.show) PostWidget(p),*/
              ],
            ),
            //newPageProgressIndicatorBuilder: (_) => ShimmerPost(),
            //firstPageProgressIndicatorBuilder: (_) => ShimmerPost(),
            noItemsFoundIndicatorBuilder: (_) => Align(
              alignment: Alignment.topCenter,
              child: AddPostWidget(),
            ),
          ),
        ),
      ),
    );*/
  }

  /*var date = DateTime.now();
    var newDate = '${DateFormat("dd-MM-yyyy hh:mm:ss").format(date)}';
    */
}
