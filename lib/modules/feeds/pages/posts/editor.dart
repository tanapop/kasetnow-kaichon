import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:profanity_filter/profanity_filter.dart';

import '../../../../components/confirm_dialog.dart';
import '../../../../imports.dart';
import '../../data/posts.dart';
import '../../models/post.dart';

class PostEditorPage extends StatefulWidget {
  final Post toEditPost;
  const PostEditorPage({
    Key key,
    this.toEditPost,
  }) : super(key: key);

  @override
  _PostEditorPageState createState() => _PostEditorPageState();
}

class _PostEditorPageState extends State<PostEditorPage> {
  final textController = TextEditingController();

  Post get toEdit => widget.toEditPost;
  User get currentUser => authProvider.user;

  final uploader = AppUploader();

  @override
  void initState() {
    if (toEdit != null) {
      textController.text = toEdit?.content ?? '';
      if (toEdit.hasImage) {
        uploader.setAsUploaded(toEdit.image);
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: AppStyles.primaryBackBlackKnowText,
      appBar: Appbar(
        backgroundColor: AppStyles.primaryColorBlackKnow,
        title: Text(
          t.CreatePost,
          style: theme.textTheme.headline6
              .copyWith(color: AppStyles.primaryColorWhite),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppStyles.primaryColorTextField),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: <Widget>[
          GestureDetector(
            onTap: onShareTap,
            child: Center(
              child: Text(
                t.Post,
                style: TextStyle(
                    fontSize: 20, color: AppStyles.primaryColorTextField),
              ),
            ),
          ),
          if (toEdit == null)
            SizedBox(width: 10)
          else
            PopupMenuButton<int>(
              color: AppStyles.primaryColorWhite,
              icon: Icon(
                Icons.more_vert,
                color: AppStyles.primaryColorTextField,
              ),
              itemBuilder: (_) => [
                PopupMenuItem(
                  value: 0,
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.delete),
                      SizedBox(width: 4),
                      Text(
                        t.Delete,
                        style:
                            TextStyle(color: AppStyles.primaryColorTextField),
                      ),
                      SizedBox(width: 4),
                    ],
                  ),
                ),
              ],
              onSelected: (v) {
                if (v == 0) {
                  showConfirmDialog(
                    context,
                    title: t.PostRemoveConfirm,
                    onConfirm: () {
                      deletePost();
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                  );
                }
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: SizedBox(
          height: context.height - 100,
          child: Column(
            children: <Widget>[
              Row(
                children: [
                  AvatarWidget(
                    currentUser.photoURL,
                    radius: 80,
                  ),
                  SizedBox(width: 12),
                  Text(
                    currentUser.fullName,
                    style: theme.textTheme.bodyText2.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: AppStyles.primaryColorTextField),
                  ),
                ],
              ),
              SizedBox(height: 20),
              TextField(
                style: theme.textTheme.headline5
                    .copyWith(color: AppStyles.primaryColorTextField),
                controller: textController,
                maxLines: null,
                decoration: InputDecoration.collapsed(
                  hintText: t.WhatOnMind,
                  hintStyle:
                      theme.textTheme.headline5.copyWith(color: Colors.grey),
                ),
              ),
              SizedBox(height: 50),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  constraints: BoxConstraints(
                    minHeight: 200,
                    minWidth: context.width,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.withAlpha(120),
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Obx(
                    () => uploader.state.maybeWhen(
                      initial: () => IconButton(
                        icon: Icon(Icons.add, size: 50),
                        onPressed: () => uploader.pick(context, true),
                      ),
                      orElse: () => Stack(
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: (uploader.picked ?? uploader.uploaded).when(
                              image: (img) => AppImage(
                                img.copyWith(
                                  width: double.maxFinite,
                                  height: double.maxFinite,
                                ),
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                          ),
                          if (uploader.isPicked)
                            Positioned(
                              right: -25,
                              top: -6,
                              child: MaterialButton(
                                color: AppStyles.primaryColorTextField,
                                shape: CircleBorder(),
                                onPressed: uploader.reset,
                                child: Icon(Icons.close),
                              ),
                            ),
                        ],
                      ),
                      failed: (e) => GestureDetector(
                        onTap: () => uploader.pick(context),
                        behavior: HitTestBehavior.opaque,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.warning, size: 40),
                            SizedBox(height: 4),
                            Text(t.FailedToUpload)
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> onShareTap() async {
    final content = textController.text.trim();
    if (ProfanityFilter().hasProfanity(content)) {
      BotToast.showText(
        text: t.ProfanityDetected,
        duration: Duration(seconds: 5),
      );
      return;
    }
    if (content.isEmpty && uploader.picked == null) {
      BotToast.showText(text: t.AddSomeContent);
      return;
    }

    if (toEdit != null) {
      if (content == toEdit.content) return;
      await PostsRepository.updatePost(toEdit.copyWith(content: content));
      BotToast.showText(text: t.SuccessPostEdited);
    } else {
      var post = Post.create(
        content: content,
      );
      if (uploader.picked == null) {
        post = post.copyWith(isShared: true);
      } else {
        uploader.picked.when(
          image: (img) {
            post = post.copyWith(image: img);
            uploader.upload(
              StorageHelper.postsImageRef,
              onSuccess: (v) async {
                await PostsRepository.addPost(post.copyWith(
                  image: v as ImageModel,
                  isShared: true,
                ));
                Get.find<PagingController>().refresh();
              },
              onFailed: (e) => BotToast.showText(text: e),
            );
          },
        );
      }
      await PostsRepository.addPost(post);
    }
    Get.find<PagingController>().refresh();
    Navigator.pop(context);
  }

  Future<void> deletePost() async {
    try {
      await PostsRepository.removePost(toEdit.id, toEdit.commentsIDs);
      Get.find<PagingController>().refresh();
    } catch (e) {
      logError(e);
    }
  }
}
