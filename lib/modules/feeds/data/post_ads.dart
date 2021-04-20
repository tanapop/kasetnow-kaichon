import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kaichon/modules/feeds/models/post_ads.dart';
import 'package:rnd/rnd.dart';

import '../../../imports.dart';
import '../../notifications/data/notifications.dart';
import '../../notifications/models/notification.dart';
import '../models/post.dart';
import 'comments.dart';

mixin PostAdsRepository {
  static String get _uid => authProvider.uid;
  static final _firestore = FirebaseFirestore.instance;

  static final postAdsCol = _firestore.collection('post_ads');
  static DocumentReference postDoc(String postID) => postAdsCol.doc(postID);
  static final reportedPostsCol = _firestore.collection('reported_posts');
  static DocumentReference reportedDoc(String id) => reportedPostsCol.doc(id);
  //SECTION ------------------------------Posts
  static DocumentSnapshot lastPostDoc;
  static Future<List<PostAds>> fetchPosts(int page) async {
    var col = postAdsCol.limit(20).orderBy('createdAt', descending: true);
    if (page != 0 && lastPostDoc != null) {
      col = col.startAfterDocument(lastPostDoc);
    }
    final docs = (await col.get()).docs;
    if (docs.isNotEmpty) lastPostDoc = docs.last;
    return docs.map((s) => PostAds.fromMap(s.data())).toList();
  }

  static Stream<PostAds> singlePostStream(String postID) {
    return postDoc(postID).snapshots().map(
          (s) => PostAds.fromMap(s.data()),
        );
  }

  static Future<String> getDataRandom() async {
    final _ads = <String>[];
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await _firestore.collection('post_ads').get();
    querySnapshot.docs.forEach((document) {
      //print("A>>>" + document["id"].toString());
      _ads.add(document["id"].toString());
    });
    List shuffled = rnd.shuffle(_ads, copy: true);
    print("A>>>" + shuffled[0].toString());

    // Get data from docs and convert map to List
    //final allData = querySnapshot.docs.map((doc) => doc.data()).toList();

    //print(allData.expand((element) => null));
    return shuffled[0].toString();
  }

  static Future<PostAds> randomPostStream(String id) =>
      postDoc(id).get().then((v) => PostAds.fromMap(v.data()));

  static Future<PostAds> fetchPost(String id) =>
      postDoc(id).get().then((v) => PostAds.fromMap(v.data()));

  static Stream<List<PostAds>> getUserPostsStream(String userId, int offset) {
    return _firestore
        .collection('post_ads')
        .where('authorID', isEqualTo: userId)
        .limit(offset)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((s) => [for (final d in s.docs) PostAds.fromMap(d.data())])
        .handleError((e) => logError(e));
  }

  static Future<void> addPost(PostAds post) async {
    await postDoc(post.id).set(post.toMap());
    await _firestore.doc('users/${post.authorID}').update(
      {
        'post_ads': FieldValue.arrayUnion([post.id])
      },
    );
  }

  static Future<void> updatePost(PostAds post) async {
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
        'post_ads': FieldValue.arrayRemove([postID])
      },
    );
  }

//SECTION ------------------------------Post Ractions

  static Future<void> togglePostReaction(PostAds post) async {
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

  static Stream<List<PostAds>> reportedPostsStream() =>
      reportedPostsCol.orderBy('id', descending: true).snapshots().map(
            (s) => [for (final d in s.docs) PostAds.fromMap(d.data())],
          );

  static Future<void> reportPost(PostAds post) async {
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
