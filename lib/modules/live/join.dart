import 'dart:async';
import 'dart:math' as math;

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:agora_rtm/agora_rtm.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:wakelock/wakelock.dart';

import '../../core/config.dart';
import '../../styles.dart';
import '../feeds/pages/posts/widgets/HearAnim.dart';
import '../feeds/pages/posts/widgets/Loading.dart';
import 'data/firestoreDB.dart';
//import 'package:kaichon/imports.dart';
import 'model/message.dart';

class JoinPage extends StatefulWidget {
  /// non-modifiable channel name of the page
  final String channelName;
  final int channelId;
  final String userId;
  final String fullName;
  final String hostImage;
  final String userImage;

  /// Creates a call page with given channel name.
  const JoinPage(
      {Key key,
      this.channelName,
      this.channelId,
      this.userId,
      this.fullName,
      this.hostImage,
      this.userImage})
      : super(key: key);

  @override
  _JoinPageState createState() => _JoinPageState();
}

class _JoinPageState extends State<JoinPage> {
  bool loading = true;
  bool completed = false;
  static final _users = <int>[];
  bool muted = true;
  int userNo = 0;
  var viewCount = "0";
  var userMap;
  bool heart = false;
  bool requested = false;

  bool _isLogin = true;
  final bool _isInChannel = true;

  final _channelMessageController = TextEditingController();

  final _infoStrings = <Message>[];

  AgoraRtmClient _client;
  AgoraRtmChannel _channel;

  //Love animation
  final _random = math.Random();
  Timer _timer;
  double height = 0.0;
  final int _numConfetti = 10;
  var len;
  bool accepted = false;
  bool stop = false;

  var tryingToEnd = false;
  bool personBool = false;
  String logo1 =
      "https://firebasestorage.googleapis.com/v0/b/kasetnow-39a7b.appspot.com/o/logo%2F%E0%B8%9F%E0%B8%B2%E0%B8%A3%E0%B9%8C%E0%B8%A1%E0%B8%AA%E0%B8%B2%E0%B8%A1%E0%B8%9E%E0%B8%A2%E0%B8%B1%E0%B8%84%E0%B8%86%E0%B9%8C.png?alt=media&token=ab17fc5d-e419-41cb-a240-454092355632";
  String logo2 =
      "https://firebasestorage.googleapis.com/v0/b/kasetnow-39a7b.appspot.com/o/logo%2FA%20logo.png?alt=media&token=4cdc4fa4-1792-459a-bfbf-9cc4c664dc2c";

  //String userId;
  //String fullName;
  var photoDummy =
      'https://firebasestorage.googleapis.com/v0/b/kasetnow-39a7b.appspot.com/o/user-dummy-pic.png?alt=media&token=3066914e-dcfe-405c-ad18-d1392e2368a2';
  var logo = Image.asset('assets/images/2.png');
  String eventName = "ส.มีสุวรรณ ฟาร์ม VS ป.วุฒิฟาร์ม";
  //String username;
  @override
  void dispose() {
    // clear users
    _users.clear();
    // destroy sdk
    AgoraRtcEngine.leaveChannel();
    AgoraRtcEngine.destroy();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // initialize agora sdk
    initialize();
    userMap = {widget.userId: widget.userImage};
    _createClient();
  }

  /*Future<void> loadSharedPref() async {
    //final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = authProvider.user.id ?? '0';
      fullName = authProvider.user.fullName ?? 'Jon Doe';
      username = authProvider.user.username ?? 'jon';
      photoURL = authProvider.user.photoURL ??
          'https://nichemodels.co/wp-content/uploads/2019/03/user-dummy-pic.png';
    });
  }*/

  Future<void> initialize() async {
    await _initAgoraRtcEngine();
    _addAgoraEventHandlers();
    await AgoraRtcEngine.enableWebSdkInteroperability(true);
    await AgoraRtcEngine.setParameters(
        '''{\"che.video.lowBitRateStreamParameter\":{\"width\":320,\"height\":180,\"frameRate\":15,\"bitRate\":140}}''');
    await AgoraRtcEngine.joinChannel(null, widget.channelName, null, 0);
  }

  /// Create agora sdk instance and initialize
  Future<void> _initAgoraRtcEngine() async {
    await AgoraRtcEngine.create(appConfigs.agoraAppID);
    await AgoraRtcEngine.enableVideo();
    //await AgoraRtcEngine.muteLocalAudioStream(true);
    await AgoraRtcEngine.enableLocalAudio(false);
    await AgoraRtcEngine.enableLocalVideo(!muted);
  }

  /// Add agora event handlers
  void _addAgoraEventHandlers() {
    AgoraRtcEngine.onJoinChannelSuccess = (
      String channel,
      int uid,
      int elapsed,
    ) {
      Wakelock.enable();
    };

    AgoraRtcEngine.onUserJoined = (int uid, int elapsed) {
      setState(() {
        _users.add(uid);
      });
    };

    AgoraRtcEngine.onUserOffline = (int uid, int reason) {
      if (uid == widget.channelId) {
        setState(() {
          completed = true;
          Future.delayed(const Duration(milliseconds: 1500), () async {
            await Wakelock.disable();
            Navigator.pop(context);
          });
        });
      }
      _users.remove(uid);
    };
  }

  /// Helper function to get list of native views
  List<Widget> _getRenderViews() {
    final List<AgoraRenderWidget> list = [];
    //user.add(widget.channelId);
    _users.forEach((int uid) {
      if (uid == widget.channelId) {
        list.add(AgoraRenderWidget(uid));
      }
    });
    if (accepted == true) {
      list.add(AgoraRenderWidget(0, local: true, preview: true));
    }
    if (list.isEmpty) {
      setState(() {
        loading = true;
      });
    } else {
      setState(() {
        loading = false;
      });
    }

    return list;
  }

  /// Video view wrapper
  Widget _videoView(Widget view) {
    return Expanded(child: ClipRRect(child: view));
  }

  /// Video view row wrapper
  Widget _expandedVideoRow(List<Widget> views) {
    final wrappedViews = views.map<Widget>(_videoView).toList();
    return Expanded(
      child: Row(
        children: wrappedViews,
      ),
    );
  }

  /// Video layout wrapper
  Widget _viewRows() {
    final views = _getRenderViews();

    switch (views.length) {
      case 1:
        return (loading == true) && (completed == false)
            ?
            //LoadingPage()
            LoadingPage()
            : Container(
                child: Column(
                children: <Widget>[_videoView(views[0])],
              ));
      case 2:
        return (loading == true) && (completed == false)
            ?
            //LoadingPage()
            LoadingPage()
            : Container(
                child: Column(
                children: <Widget>[
                  _expandedVideoRow([views[0]]),
                  _expandedVideoRow([views[1]])
                ],
              ));
    }
    return Container();
  }

  void popUp() async {
    setState(() {
      heart = true;
    });
    Timer(
        Duration(seconds: 4),
        () => {
              _timer.cancel(),
              setState(() {
                heart = false;
              })
            });
    _timer = Timer.periodic(Duration(milliseconds: 125), (Timer t) {
      setState(() {
        height += _random.nextInt(20);
      });
    });
  }

  Widget heartPop() {
    final size = MediaQuery.of(context).size;
    final confetti = <Widget>[];
    for (var i = 0; i < _numConfetti; i++) {
      final height = _random.nextInt(size.height.floor());
      final width = 20;
      confetti.add(HeartAnim(height % 200.0, width.toDouble(), 1));
    }

    return Container(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Align(
          alignment: Alignment.bottomRight,
          child: Container(
            height: 400,
            width: 200,
            child: Stack(
              children: confetti,
            ),
          ),
        ),
      ),
    );
  }

  /// Info panel to show logs
  Widget _messageList() {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      alignment: Alignment.bottomCenter,
      child: FractionallySizedBox(
        heightFactor: 0.5,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 48),
          child: ListView.builder(
            reverse: true,
            itemCount: _infoStrings.length,
            itemBuilder: (BuildContext context, int index) {
              if (_infoStrings.isEmpty) {
                return null;
              }
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 3,
                  horizontal: 10,
                ),
                child: (_infoStrings[index].type == 'join')
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            CachedNetworkImage(
                              imageUrl: _infoStrings[index].photoURL,
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                width: 32.0,
                                height: 32.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: imageProvider, fit: BoxFit.cover),
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color:
                                    AppStyles.primaryColorGray.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  '${_infoStrings[index].fullName ?? ''} เข้าร่วมแล้ว',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : (_infoStrings[index].type == 'message')
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                CachedNetworkImage(
                                  imageUrl: _infoStrings[index].photoURL,
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    width: 32.0,
                                    height: 32.0,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: AppStyles.primaryColorGray
                                          .withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                          ),
                                          child: Text(
                                            _infoStrings[index].fullName ?? "",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                          ),
                                          child: Text(
                                            _infoStrings[index].message,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        : null,
              );
            },
          ),
        ),
      ),
    );
  }

  Future<bool> _willPopCallback() async {
    await Wakelock.disable();
    _leaveChannel();
    _logout();
    AgoraRtcEngine.leaveChannel();
    AgoraRtcEngine.destroy();
    if (personBool == true) {
      setState(() {
        personBool = false;
      });
    } else {
      setState(() {
        tryingToEnd = !tryingToEnd;
      });
    }
    return false;
    return true;
    // return true if the route to be popped
    //Navigator.pop(context);
  }

  Widget _ending() {
    return Container(
      color: Colors.black.withOpacity(.7),
      child: Center(
          child: Container(
        width: double.infinity,
        color: Colors.grey[700],
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Text(
            'The Live has ended',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              letterSpacing: 1.5,
              color: Colors.white,
            ),
          ),
        ),
      )),
    );
  }

  Widget _liveText() {
    // In this you won't have to worry about the symbol of the currency.

    return Container(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    /*gradient: LinearGradient(
                      colors: <Color>[
                        Colors.indigo,
                        AppStyles.primaryColorLight
                      ],
                    ),*/
                    color: AppStyles.primaryColorRedKnow,
                    borderRadius: BorderRadius.all(Radius.circular(4.0))),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 5.0, horizontal: 8.0),
                  child: Text(
                    'LIVE',
                    style: TextStyle(
                        color: AppStyles.primaryColorWhite,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Container(
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(.6),
                        borderRadius: BorderRadius.all(Radius.circular(4.0))),
                    height: 28,
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            FontAwesomeIcons.eye,
                            color: Colors.white,
                            size: 13,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            '$viewCount',
                            style: TextStyle(
                                color: AppStyles.primaryColorWhite,
                                fontSize: 11),
                          ),
                        ],
                      ),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _username() {
    return Padding(
      padding: const EdgeInsets.only(top: 50, left: 10),
      child: Container(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            CachedNetworkImage(
              imageUrl: widget.hostImage,
              imageBuilder: (context, imageProvider) => Container(
                width: 40.0,
                height: 40.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image:
                      DecorationImage(image: imageProvider, fit: BoxFit.cover),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
              child: Text(
                "${widget.fullName}",
                style: TextStyle(
                    shadows: [
                      Shadow(
                        blurRadius: 4,
                        color: Colors.black,
                        offset: Offset(0, 1.3),
                      ),
                    ],
                    color: AppStyles.primaryColorWhite,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sponsorLogo1(String logo) {
    return Padding(
      padding: const EdgeInsets.only(top: 50, left: 10),
      child: Container(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            CachedNetworkImage(
              imageUrl: logo,
              imageBuilder: (context, imageProvider) => Container(
                width: 50.0,
                height: 50.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image:
                      DecorationImage(image: imageProvider, fit: BoxFit.cover),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sponsorLogo2(String logo) {
    return Padding(
      padding: const EdgeInsets.only(top: 50, left: 10),
      child: Container(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            CachedNetworkImage(
              imageUrl: logo,
              imageBuilder: (context, imageProvider) => Container(
                width: 50.0,
                height: 50.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image:
                      DecorationImage(image: imageProvider, fit: BoxFit.cover),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget requestedWidget() {
    return Container(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: MediaQuery.of(context).size.height,
        color: Colors.black,
        child: Wrap(
          direction: Axis.horizontal,
          alignment: WrapAlignment.center,
          spacing: 0,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(
                top: 20,
              ),
              width: 130,
              alignment: Alignment.center,
              child: Stack(
                children: <Widget>[
                  Container(
                    width: 130,
                    alignment: Alignment.centerLeft,
                    child: Stack(
                      alignment: Alignment(0, 0),
                      children: <Widget>[
                        Container(
                          width: 75,
                          height: 75,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                        CachedNetworkImage(
                          imageUrl: widget.hostImage,
                          imageBuilder: (context, imageProvider) => Container(
                            width: 70.0,
                            height: 70.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: imageProvider, fit: BoxFit.cover),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 130,
                    alignment: Alignment.centerRight,
                    child: Stack(
                      alignment: Alignment(0, 0),
                      children: <Widget>[
                        Container(
                          width: 75,
                          height: 75,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                        CachedNetworkImage(
                          imageUrl: widget.userImage,
                          imageBuilder: (context, imageProvider) => Container(
                            width: 70.0,
                            height: 70.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: imageProvider, fit: BoxFit.cover),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                '${widget.channelName} Wants You To Be In This Live Video.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 20,
                top: 0,
                bottom: 20,
                right: 20,
              ),
              child: Text(
                'Anyone can watch, and some of your followers may get notified.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[300],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              width: double.maxFinite,
              child: RaisedButton(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Text(
                    'Go Live with ${widget.channelName}',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                elevation: 2.0,
                color: Colors.blue[400],
                onPressed: () async {
                  await AgoraRtcEngine.enableLocalVideo(true);
                  await AgoraRtcEngine.enableLocalAudio(true);
                  await _channel.sendMessage(
                      AgoraRtmMessage.fromText('k1r2i3s4t5i6e7 confirming'));
                  setState(() {
                    accepted = true;
                    requested = false;
                  });
                },
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              width: double.maxFinite,
              child: RaisedButton(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Text(
                    'Decline',
                    style: TextStyle(color: Colors.pink[300]),
                  ),
                ),
                elevation: 2.0,
                color: Colors.transparent,
                onPressed: () async {
                  await _channel.sendMessage(AgoraRtmMessage.fromText(
                      'R1e2j3e4c5t6i7o8n9e0d Rejected'));
                  setState(() {
                    requested = false;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void stopFunction() async {
    await AgoraRtcEngine.enableLocalVideo(!muted);
    await AgoraRtcEngine.enableLocalAudio(!muted);
    setState(() {
      accepted = false;
    });
  }

  Widget stopSharing() {
    return Container(
      height: MediaQuery.of(context).size.height / 2 + 40,
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: MaterialButton(
          minWidth: 0,
          onPressed: () async {
            await _channel
                .sendMessage(AgoraRtmMessage.fromText('E1m2I3l4i5E6 stoping'));
            stopFunction();
          },
          child: Icon(
            Icons.clear,
            color: Colors.white,
            size: 15.0,
          ),
          shape: CircleBorder(),
          elevation: 2.0,
          color: Colors.blue[400],
          padding: const EdgeInsets.all(5.0),
        ),
      ),
    );
  }

  // Agora RTM

  Widget _bottomBar() {
    if (!_isLogin || !_isInChannel) {
      return Container();
    }
    return Container(
      alignment: Alignment.bottomRight,
      child: Container(
        color: AppStyles.primaryColorBlackKnow,
        child: Padding(
          padding: const EdgeInsets.only(left: 8, top: 5, right: 8, bottom: 5),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
            new Expanded(
                child: Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 0, 0, 0),
              child: new TextField(
                  cursorColor: AppStyles.primaryColorRedKnow,
                  textInputAction: TextInputAction.go,
                  onSubmitted: _sendMessage,
                  style: TextStyle(
                    color: AppStyles.primaryColorTextField,
                  ),
                  controller: _channelMessageController,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: 'แสดงความเห็น',
                    hintStyle:
                        TextStyle(color: AppStyles.primaryColorTextField),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50.0),
                        borderSide:
                            BorderSide(color: AppStyles.primaryColorWhite)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50.0),
                        borderSide:
                            BorderSide(color: AppStyles.primaryColorWhite)),
                  )),
            )),
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 0, 0, 0),
              child: MaterialButton(
                minWidth: 0,
                onPressed: _toggleSendChannelMessage,
                child: Icon(
                  Icons.send,
                  color: AppStyles.primaryColorWhite,
                  size: 20.0,
                ),
                shape: CircleBorder(),
                elevation: 2.0,
                color: AppStyles.primaryColorRedKnow,
                padding: const EdgeInsets.all(12.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: MaterialButton(
                minWidth: 0,
                onPressed: () async {
                  popUp();
                  await _channel.sendMessage(
                      AgoraRtmMessage.fromText('m1x2y3z4p5t6l7k8'));
                },
                child: Icon(
                  Icons.favorite_border,
                  color: AppStyles.primaryColorRedKnow,
                  size: 30.0,
                ),
                padding: const EdgeInsets.all(12.0),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  void _logout() async {
    try {
      await _client.logout();
      // _log('Logout success.');
    } catch (errorCode) {
      //_log('Logout error: ' + errorCode.toString());
    }
  }

  void _leaveChannel() async {
    try {
      await _channel.leave();
      //_log('Leave channel success.');
      _client.releaseChannel(_channel.channelId);
      _channelMessageController.text = null;
    } catch (errorCode) {
      //_log('Leave channel error: ' + errorCode.toString());
    }
  }

  void _toggleSendChannelMessage() async {
    String text = _channelMessageController.text;
    if (text.isEmpty) {
      return;
    }
    try {
      _channelMessageController.clear();
      await _channel.sendMessage(AgoraRtmMessage.fromText(text));
      _log(
          userId: widget.userId,
          info: text,
          fullName: widget.fullName,
          photoURL: widget.userImage ?? photoDummy,
          type: 'message');
    } catch (errorCode) {
      //_log('Send channel message error: ' + errorCode.toString());
    }
  }

  void _sendMessage(String text) async {
    if (text.isEmpty) {
      return;
    }
    try {
      _channelMessageController.clear();
      await _channel.sendMessage(AgoraRtmMessage.fromText(text));
      _log(
          userId: widget.userId,
          fullName: widget.fullName,
          info: text,
          photoURL: widget.userImage ?? photoDummy,
          type: 'message');
    } catch (errorCode) {
      //_log('Send channel message error: ' + errorCode.toString());
    }
  }

  void _createClient() async {
    _client =
        await AgoraRtmClient.createInstance('b42ce8d86225475c9558e478f1ed4e8e');
    _client.onMessageReceived = (AgoraRtmMessage message, String peerId) async {
      //var img = await FireStoreClass.getImage(username: peerId);
      //userMap.putIfAbsent(peerId, () => img);
      _log(
          userId: peerId,
          fullName: widget.fullName,
          info: message.text,
          type: 'message');
    };
    _client.onConnectionStateChanged = (int state, int reason) {
      if (state == 5) {
        _client.logout();
        // _log('Logout.');
        setState(() {
          _isLogin = false;
        });
      }
    };
    await _client.login(null, widget.userId);
    _channel = await _createChannel(widget.channelName);
    await _channel.join();
    var len = 0;
    _channel.getMembers().then((value) {
      len = value.length;

      setState(() {
        userNo = len - 1;
        viewCount = NumberFormat.compact().format(userNo);
        print('Formatted Number is $viewCount');
      });
    });
  }

  Future<AgoraRtmChannel> _createChannel(String name) async {
    AgoraRtmChannel channel = await _client.createChannel(name);
    String img;
    String fullname;
    channel.onMemberJoined = (AgoraRtmMember member) async {
      img = await FireStoreClass.getImage(userId: member.userId);
      fullname = await FireStoreClass.getName(userId: member.userId);
      var len = 0;
      //userMap.putIfAbsent(member.userId, () => img);

      _channel.getMembers().then((value) {
        len = value.length;
        setState(() {
          userNo = len - 1;
          viewCount = NumberFormat.compact().format(userNo);
          print('Formatted Number is $viewCount');
        });
      });

      _log(
          info: 'Member joined: ',
          userId: member.userId,
          fullName: fullname,
          photoURL: img,
          type: 'join');
    };
    channel.onMemberLeft = (AgoraRtmMember member) {
      var len = 0;
      _channel.getMembers().then((value) {
        len = value.length;
        setState(() {
          userNo = len - 1;
          viewCount = NumberFormat.compact().format(userNo);
          print('Formatted Number is $viewCount');
        });
      });
    };
    channel.onMessageReceived =
        (AgoraRtmMessage message, AgoraRtmMember member) async {
      img = await FireStoreClass.getImage(userId: member.userId);
      if (img == "") {
        img = photoDummy;
      }
      fullname = await FireStoreClass.getName(userId: member.userId);
      _log(
          userId: member.userId,
          fullName: fullname,
          info: message.text,
          photoURL: img,
          type: 'message');
    };
    return channel;
  }

  void _log(
      {String info,
      String type,
      String userId,
      String fullName,
      String photoURL}) {
    if (type == 'message' && info.contains('m1x2y3z4p5t6l7k8')) {
      popUp();
    } else if (type == 'message' && info.contains('E1m2I3l4i5E6')) {
      stopFunction();
    } else {
      Message m;
      String image = userMap[userId].toString();
      if (info.contains('d1a2v3i4s5h6')) {
        var mess = info.split(' ');
        if (mess[1] == widget.userId) {
          /*m = new Message(
              message: 'working', type: type, user: user, image: image);*/
          setState(() {
            //_infoStrings.insert(0, m);
            requested = true;
          });
        }
      } else {
        if (photoURL == "") {
          photoURL = photoDummy;
        }
        m = Message(
            message: info,
            type: type,
            userId: userId,
            fullName: fullName,
            photoURL: photoURL);
        setState(() {
          _infoStrings.insert(0, m);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: SafeArea(
          child: Scaffold(
            //backgroundColor: AppStyles.primaryBackBlackKnowText,
            body: Container(
              color: AppStyles.primaryColorWhite,
              child: Center(
                child: (completed == true)
                    ? _ending()
                    : Stack(
                        children: <Widget>[
                          _viewRows(),
                          if (completed == false) _bottomBar(),
                          _username(),
                          _liveText(),
                          if (completed == false) _messageList(),
                          if (heart == true && completed == false) heartPop(),
                          if (requested == true) requestedWidget(),
                          if (accepted == true) stopSharing(),

                          //_ending()
                          Positioned(
                            top: 0,
                            left: 5,
                            child: FloatingActionButton(
                              heroTag: 'close',
                              onPressed: Navigator.of(context).pop,
                              mini: true,
                              backgroundColor:
                                  AppStyles.primaryBackBlackKnowText,
                              child: Icon(
                                Icons.clear,
                                color: AppStyles.primaryColorRed,
                              ),
                            ),
                          ),
                          //_ending()
                          Positioned(
                            top: 0,
                            right: 10,
                            child: _sponsorLogo1(logo1),
                          ),
                          Positioned(
                            top: 0,
                            right: 60,
                            child: _sponsorLogo2(logo2),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ),
        onWillPop: _willPopCallback);
  }
}
