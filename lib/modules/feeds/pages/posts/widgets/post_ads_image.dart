import 'package:flutter/material.dart';

import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:kaichon/modules/feeds/data/post_ads.dart';
import 'package:kaichon/modules/feeds/models/post_ads.dart';

import '../../../../../imports.dart';
import '../../../data/posts.dart';
import '../../../models/post.dart';

class PostAdsImageWidget extends StatefulWidget {
  final PostAds post;
  final VoidCallback onTap;

  const PostAdsImageWidget(
    this.post, {
    Key key,
    this.onTap,
  }) : super(key: key);

  @override
  _PostAdsImageWidgetState createState() => _PostAdsImageWidgetState();
}

class _PostAdsImageWidgetState extends State<PostAdsImageWidget> {
  ImageModel get img => widget.post.image;

  @override
  Widget build(BuildContext context) {
    final uploader = AppUploader.find(img.path);
    return GestureDetector(
      onTap: () => pushImagesPage(img),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: 500,
          minWidth: context.width,
        ),
        child: AspectRatio(
          aspectRatio: img.ratio,
          child: Stack(
            children: [
              Positioned.fill(
                child: AppImage(
                  img,
                  fit: BoxFit.fitWidth,
                ),
              ),
              if (img.isLocal)
                uploader != null
                    ? Obx(() => AppLoadingIndicator(
                          value: uploader.state.maybeWhen(
                            orElse: () => null,
                            uploading: (p) => p,
                          ),
                        ))
                    : Center(
                        child: IconButton(
                          icon: Icon(
                            Icons.replay_outlined,
                            size: 40,
                          ),
                          onPressed: resend,
                        ),
                      ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> resend() async {
    AppUploader()
      ..setAsPicked(widget.post.image)
      ..upload(
        StorageHelper.postsImageRef,
        onSuccess: (f) => f.when(
          image: (img) async {
            await PostAdsRepository.addPost(widget.post.copyWith(image: img));
            Get.find<PagingController>().refresh();
          },
        ),
      );
    setState(() {});
  }
}
