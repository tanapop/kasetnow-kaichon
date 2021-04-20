import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../imports.dart';
import '../../notifications/data/notifications.dart';
import '../../notifications/models/notification.dart';
import '../models/post.dart';
import 'comments.dart';

mixin PostsRepository {
  static String get _uid => authProvider.uid;
  static final _firestore = FirebaseFirestore.instance;

  static final postsCol = _firestore.collection('posts');
  static DocumentReference postDoc(String postID) => postsCol.doc(postID);
  static final reportedPostsCol = _firestore.collection('reported_posts');
  static DocumentReference reportedDoc(String id) => reportedPostsCol.doc(id);
  //SECTION ------------------------------Posts
  static DocumentSnapshot lastPostDoc;
  static Future<List<Post>> fetchPosts(int page) async {
    var col = postsCol.limit(20).orderBy('createdAt', descending: true);
    if (page != 0 && lastPostDoc != null) {
      col = col.startAfterDocument(lastPostDoc);
    }
    final docs = (await col.get()).docs;
    if (docs.isNotEmpty) lastPostDoc = docs.last;
    return docs.map((s) => Post.fromMap(s.data())).toList();
  }

  static Stream<Post> singlePostStream(String postID) {
    return postDoc(postID).snapshots().map(
          (s) => Post.fromMap(s.data()),
        );
  }

  static Future<Post> fetchPost(String id) =>
      postDoc(id).get().then((v) => Post.fromMap(v.data()));

  static Stream<List<Post>> getUserPostsStream(String userId, int offset) {
    return _firestore
        .collection('posts')
        .where('authorID', isEqualTo: userId)
        .limit(offset)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((s) => [for (final d in s.docs) Post.fromMap(d.data())])
        .handleError((e) => logError(e));
  }

  static Future<void> addPost(Post post) async {
    await postDoc(post.id).set(post.toMap());
    await _firestore.doc('users/${post.authorID}').update(
      {
        'posts': FieldValue.arrayUnion([post.id])
      },
    );
  }

  static Future<void> updatePost(Post post) async {
    await postDoc(post.id).update({
      'content': post.content,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  static Future<void> removePost(String postID, List<String> comments) async {
    await postDoc(postID).delete();
    for (final id in comments ?? <String>[]) {
      await CommentsRepository.commentDoc(id).delete();
    }
    await _firestore.doc('users/$_uid').update(
      {
        'posts': FieldValue.arrayRemove([postID])
      },
    );
  }

//SECTION ------------------------------Post Ractions

  static Future<void> togglePostReaction(Post post) async {
    await postDoc(post.id).update({
      'usersLikes': post.liked
          ? FieldValue.arrayUnion([_uid])
          : FieldValue.arrayRemove([_uid]),
      'likesCount':
          post.liked ? FieldValue.increment(1) : FieldValue.increment(-1),
    });
    if (post.liked && !post.isMine) {
      NotificationRepo.sendNotificaion(NotificationModel.create(
        toId: post.authorID,
        postID: post.id,
        type: NotificationType.PostReaction,
      ));
    }
  }

//SECTION ------------------------------Post Report

  static Stream<List<Post>> reportedPostsStream() =>
      reportedPostsCol.orderBy('id', descending: true).snapshots().map(
            (s) => [for (final d in s.docs) Post.fromMap(d.data())],
          );

  static Future<void> reportPost(Post post) async {
    post.reportedBy.add(_uid);
    await reportedDoc(post.id).set(
      post.toMap(),
      SetOptions(merge: true),
    );
    await postDoc(post.id).update({
      'reportedBy': FieldValue.arrayUnion([_uid])
    });
  }

  static Future<void> unReportPost(String id) async {
    _firestore.runTransaction((tr) async => tr
      ..update(postDoc(id), {
        'reportedBy': FieldValue.arrayRemove([_uid])
      })
      ..delete(reportedDoc(id)));
  }
}
