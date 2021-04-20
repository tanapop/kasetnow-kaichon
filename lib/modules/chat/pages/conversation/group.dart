import 'dart:async';

import 'package:flutter/material.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../imports.dart';
import '../../data/group_msgs.dart';
import '../../data/groups.dart';
import '../../models/group.dart';
import '../../models/message.dart';
import 'widgets/appbar_group.dart';
import 'widgets/input.dart';
import 'widgets/message/item.dart';
import 'widgets/msg_overview.dart';

class GroupChatPage extends StatefulWidget {
  final String groupID;

  const GroupChatPage(
    this.groupID, {
    Key key,
  }) : super(key: key);

  @override
  _GroupChatPageState createState() => _GroupChatPageState();
}

class _GroupChatPageState extends State<GroupChatPage> {
  final scrollController = ScrollController();
  final refreshController = RefreshController();

  String get uid => authProvider.user.id;

  final uploader = AppUploader();

  List<Message> msgs = [];
  Group group;
  int limit = 20;

  Message msgToEdit;

  StreamSubscription<Group> groupSub;
  @override
  void initState() {
    groupSub = GroupsRepository.groupStream(widget.groupID).listen((e) {
      if (group == e || !mounted) return;
      setState(() => group = e);
    });
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    refreshController.dispose();
    groupSub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GroupAppBar(group),
      body: Stack(
        children: [
          Positioned.fill(
            bottom: 80,
            child: StreamBuilder<List<Message>>(
              stream: GroupMessagesRepository.msgsStream(widget.groupID, limit),
              builder: (_, snap) {
                msgs = Message.mergeMsgs(msgs, snap.data);
                GroupMessagesRepository.updateSeenBy(msgs);
                return SmartRefresher(
                  controller: refreshController,
                  enablePullUp: msgs.length >= limit,
                  enablePullDown: false,
                  onLoading: () async {
                    setState(() => limit += 20);
                    refreshController.loadComplete();
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
                      isGroupAdmin: group.isAdmin(),
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
          if (group != null)
            Positioned.fill(
              child: group.isMember() == true
                  ? ChatInput(
                      initialValue: msgToEdit?.content,
                      onSendText: onSendText,
                      onAttachemntTap: onAttachemntTap,
                      onTypingChange: (v) =>
                          GroupsRepository.toggleTyping(widget.groupID, v),
                    )
                  : Align(
                      alignment: Alignment.bottomCenter,
                      child: AppButton(
                        t.Join,
                        onTap: () async {
                          setState(() => group.toggleJoin());
                          await GroupsRepository.joinOrLeaveGroup(group);
                        },
                      ),
                    ),
            ),
        ],
      ),
    );
  }

  Future<void> onSendText(String content) async {
    if (msgToEdit == null) {
      final msg = Message.create(
        groupId: widget.groupID,
        content: content,
        type: MessageType.Text,
      );
      if (msg == null) return;
      setState(() => msgs = Message.mergeMsgs(msgs, [msg]));
      await GroupMessagesRepository.sendMessage(msg.makeAsSent());
    } else {
      final edit = msgToEdit.copyWith(content: content);
      setState(() => msgToEdit = null);
      await GroupMessagesRepository.editMessage(edit);
    }
    GroupsRepository.toggleTyping(widget.groupID, false);
  }

  Future<void> onAttachemntTap() async {
    await uploader.pick(context, true);
    if (!uploader.isPicked) return;
    var msg = Message.create(
      groupId: widget.groupID,
      type: MessageType.Image,
    );

    await uploader.picked.when(
      image: (img) async {
        msg = msg.copyWith(image: img);
        setState(() => msgs = Message.mergeMsgs(msgs, [msg]));
        GroupMessagesRepository.sendMessage(msg);
        await uploader.upload(
          StorageHelper.groupImagesRef(group.name),
          onSuccess: (u) async {
            msg = msg.copyWith(
              image: u as ImageModel,
            );
            await GroupMessagesRepository.sendMessage(msg.makeAsSent());
          },
          onFailed: (e) => logError(e),
        );
      },
    );
  }

  void deleteMessage(Message e) {
    msgs.remove(e);
    GroupMessagesRepository.deleteMessage(
      groupId: e.groupID,
      msgId: e.id,
    );
  }
}
