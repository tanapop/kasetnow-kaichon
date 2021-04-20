import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kaichon/modules/feeds/data/post_ads.dart';
import 'package:kaichon/modules/feeds/models/ads_comment.dart';

import '../../../imports.dart';
import '../../notifications/data/notifications.dart';
import '../../notifications/models/notification.dart';
import '../models/comment.dart';
import 'posts.dart';

mixin AdsCommentsRepository {
  static String get _uid => authProvider.uid;

  static final _firestore = FirebaseFirestore.instance;
  static CollectionReference get commentsCol =>
      _firestore.collection('ads_comments');
  static DocumentReference commentDoc(String commentID) =>
      commentsCol.doc(commentID);

  static Stream<List<AdsComment>> commentsStream(String postID, int offset) {
    return commentsCol
        .where('postID', isEqualTo: postID)
        .orderBy('createdAt', descending: true)
        .limit(offset)
        .snapshots()
        .map(
          (s) => [for (final d in s.docs) AdsComment.fromMap(d.data())],
        )
        .handleError((e) => logError(e));
  }

  static Stream<AdsComment> singleCommentStream(String id) {
    return commentDoc(id).snapshots().map(
          (s) => AdsComment.fromMap(s.data()),
        );
  }

  static Future<AdsComment> fetchComment(String id) =>
      commentDoc(id).get().then((v) => AdsComment.fromMap(v.data()));

  static Future<void> addComment(AdsComment comment) async {
    await commentsCol
        .doc(comment.id)
        .set(comment.toMap()..['createdAt'] = FieldValue.serverTimestamp());
    await PostAdsRepository.postDoc(comment.postID).update(
      {
        'commentsIDs': FieldValue.arrayUnion([comment.id]),
        'commentsCount': FieldValue.increment(1)
      },
    );
    if (!comment.isMine) {
      NotificationRepo.sendNotificaion(NotificationModel.create(
        toId: comment.postAuthorID,
        commentID: comment.id,
        postID: comment.postID,
        type: NotificationType.Comment,
      ));
    }
  }

  static Future<void> updateComment(AdsComment comment) =>
      commentDoc(comment.id).update(
        {'content': comment.content},
      );

  static Future<void> removeComment(AdsComment comment) async {
    _firestore.runTransaction((tr) async {
      tr.delete(commentDoc(comment.id));
      tr.update(PostAdsRepository.postDoc(comment.postID), {
        'commentsIDs': FieldValue.arrayRemove([comment.id]),
        'commentsCount': FieldValue.increment(-1),
      });
    });
  }

  static Future<void> addCommentReply(
      String commentID, AdsComment reply) async {
    await commentDoc(commentID).update(
      {
        'replyComments': FieldValue.arrayUnion([reply.toMap()]),
        'replyCount': FieldValue.increment(1),
      },
    );
    NotificationRepo.sendNotificaion(NotificationModel.create(
      toId: reply.postAuthorID,
      commentID: commentID,
      postID: reply.postID,
      type: NotificationType.Reply,
    ));
  }

  static Future<void> removeCommentReply(String commentID, AdsComment reply) =>
      commentDoc(commentID).update({
        'replyComments': FieldValue.arrayRemove([reply.toMap()]),
        'replyCount': FieldValue.increment(-1),
      });

  static Future<void> toggleLike(AdsComment comment) async {
    comment.toggleLike();
    commentDoc(comment.id).update({
      'usersLikeIds': comment.isLiked
          ? FieldValue.arrayUnion([_uid])
          : FieldValue.arrayRemove([_uid])
    });
    if (comment.isLiked && !comment.isMine) {
      NotificationRepo.sendNotificaion(NotificationModel.create(
        toId: comment.postAuthorID,
        commentID: comment.id,
        type: NotificationType.CommentReaction,
      ));
    }
  }
}
