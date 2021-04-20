import 'dart:async';

import 'package:flutter/material.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../imports.dart';
import '../../../auth/data/user.dart';
import '../../data/chat_msgs.dart';
import '../../data/chats.dart';
import '../../models/chat.dart';
import '../../models/message.dart';
import 'widgets/appbar_user.dart';
import 'widgets/input.dart';
import 'widgets/message/item.dart';
import 'widgets/msg_overview.dart';

class PrivateChatPage extends StatefulWidget {
  final String userID;

  const PrivateChatPage(
    this.userID, {
    Key key,
  }) : super(key: key);

  @override
  _PrivateChatPageState createState() => _PrivateChatPageState();
}

class _PrivateChatPageState extends State<PrivateChatPage> {
  final scrollController = ScrollController();
  final refreshController = RefreshController();

  User get currentUser => authProvider.user;
  final uploader = AppUploader();

  List<Message> msgs = [];
  int limit = 20;

  Message msgToEdit;
  String get chatID => Chat.getChatId(widget.userID);
  StreamSubscription<Chat> chatSub;
  Chat chat;
  StreamSubscription<User> userSub;
  User user;
  bool get isTyping => chat?.isTyping ?? false;
  @override
  void initState() {
    chatSub =
        ChatsRepository.chatStream(Chat.getChatId(widget.userID)).listen((e) {
      if (chat == e) return;
      chat = e;
      if (mounted) {
        setState(() {});
      } else {
        .2.delay(() => setState(() {}));
      }
    });
    userSub = UserRepository.userStream(widget.userID).listen((e) {
      if (user == e) return;
      user = e;
      if (mounted) {
        setState(() {});
      } else {
        .2.delay(() => setState(() {}));
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    refreshController.dispose();
    chatSub.cancel();
    userSub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) return Scaffold();
    return Scaffold(
      appBar: UserAppBarTile(
        user,
        isTyping: isTyping,
      ),
      backgroundColor: AppStyles.primaryBackBlackKnowText,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: FocusScope.of(context).unfocus,
        child: Stack(
          children: [
            Positioned.fill(
              bottom: 80,
              child: StreamBuilder<List<Message>>(
                stream: MessagesRepository.msgsStream(chatID, limit),
                builder: (_, snap) {
                  msgs = Message.mergeMsgs(msgs, snap.data);
                  MessagesRepository.updateSeenBy(msgs);
                  return SmartRefresher(
                    controller: refreshController,
                    enablePullUp: msgs.length >= limit,
                    enablePullDown: false,
                    onLoading: () {
                      refreshController.loadComplete();
                      setState(() => limit += 20);
                    },
                    child: ListView.builder(
                      controller: scrollController,
                      reverse: true,
                      itemCount: msgs.length,
                      itemBuilder: (_, i) => MessageItem(
                        msgs: msgs,
                        index: i,
                        onDelete: deleteMessage,
                        onEdit: (v) => setState(() => msgToEdit = v),
                      ),
                    ),
                  );
                },
              ),
            ),
            if (msgToEdit != null)
              Positioned(
                left: 0,
                right: 0,
                bottom: 70,
                child: MsgOverview(
                  msgToEdit,
                  onCancel: () => setState(() => msgToEdit = null),
                ),
              ),
            if (currentUser.isBlocked(user.id))
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Text(
                  t.CannotChatWithUser,
                  textAlign: TextAlign.center,
                ),
              )
            else
              Positioned.fill(
                child: ChatInput(
                  initialValue: msgToEdit?.content,
                  onSendText: onSendText,
                  onAttachemntTap: onAttachemntTap,
                  onTypingChange: (v) =>
                      ChatsRepository.toggleTyping(chat?.id, v),
                ),
              )
          ],
        ),
      ),
    );
  }

  Future<void> onSendText(String content) async {
    if (msgToEdit == null) {
      final msg = Message.create(
        sendToId: widget.userID,
        content: content,
        type: MessageType.Text,
      );
      if (msg == null) return;
      setState(() => msgs = Message.mergeMsgs(msgs, [msg]));
      await MessagesRepository.sendMessage(msg.makeAsSent());
    } else {
      final edit = msgToEdit.copyWith(content: content);
      setState(() => msgToEdit = null);
      await MessagesRepository.editMessage(edit);
    }
    ChatsRepository.toggleTyping(chat?.id, false);
  }

  Future<void> onAttachemntTap() async {
    await uploader.pick(context, true);
    if (!uploader.isPicked) return;
    var msg = Message.create(
      sendToId: widget.userID,
      type: MessageType.Image,
    );
    await uploader.picked.when(
      image: (img) async {
        msg = msg.copyWith(image: img);
        setState(() => msgs = Message.mergeMsgs(msgs, [msg]));
        MessagesRepository.sendMessage(msg);
        await uploader.upload(
          StorageHelper.chatImagesRef,
          onSuccess: (u) async {
            msg = msg.copyWith(
              image: u as ImageModel,
            );
            await MessagesRepository.sendMessage(msg.makeAsSent());
          },
          onFailed: (e) => logError(e),
        );
      },
    );
  }

  Future<void> onPickGIF(String url, MessageType type) async {
    final msg = Message.create(
      sendToId: widget.userID,
      content: url,
      type: type,
    );
    setState(() => msgs = Message.mergeMsgs(msgs, [msg]));
    await MessagesRepository.sendMessage(msg.makeAsSent());
  }

  Future<void> deleteMessage(Message e) async {
    msgs.remove(e);
    await MessagesRepository.deleteMessage(
      chatId: e.chatID,
      msgId: e.id,
    );
  }
}
