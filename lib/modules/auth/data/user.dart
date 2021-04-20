import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;

import '../../../imports.dart';
import '../../notifications/data/notifications.dart';
import '../../notifications/models/notification.dart';
import '../models/user.dart';

mixin UserRepository {
  static final auth = FirebaseAuth.instance;
  static String get _uid => auth.currentUser?.uid;

  static final usersCol = FirebaseFirestore.instance.collection('users');
  static DocumentReference userDoc([String id]) => usersCol.doc(id ?? _uid);

  static Future<User> fetchUser([String id]) async {
    final doc = await userDoc(id ?? _uid).get();
    if (!doc.exists) return null;
    return User.fromMap(doc.data());
  }

  static Stream<User> userStream([String id]) {
    final uid = id ?? _uid ?? '';
    if (uid.isEmpty) return null;
    return userDoc(uid)
        .snapshots()
        .map((s) => User.fromMap(s.data()))
        .handleError((e) => logError(e));
  }

  static Future<void> editProfile(User ed) async {
    final c = authProvider.user;
    try {
      FirebaseFunctions.instance.httpsCallable('editProfile').call({
        'id': c.id,
        if (c.firstName != ed.firstName) 'firstName': ed.firstName,
        if (c.lastName != ed.lastName) 'lastName': ed.lastName,
        if (c.fullName != ed.fullName) 'fullName': ed.fullName,
        if (c.photoURL != ed.photoURL) 'photoURL': ed.photoURL,
        if (c.coverPhotoURL != ed.coverPhotoURL)
          'coverPhotoURL': ed.coverPhotoURL,
      });
      authProvider.rxUser(ed);
      saveMyInfo();
    } catch (e) {
      logError(e);
    }
  }

  static Future<void> saveMyInfo() async {
    if (_uid == null) return;
    await userDoc().set(
      authProvider.user.toMap(),
      SetOptions(merge: true),
    );
  }

  static Future<void> updateActiveAt(bool isActive) async {
    userDoc().update(
      {
        "isActive": isActive,
        "activeAt": FieldValue.serverTimestamp(),
      },
    ).catchError((e) => logError(e));
  }

  static Future<void> followUser(User user) async {
    await FirebaseFirestore.instance.runTransaction((tr) async {
      tr.update(userDoc(_uid), {
        'following': FieldValue.arrayUnion([user.id])
      });
      tr.update(userDoc(user.id), {
        'followers': FieldValue.arrayUnion([_uid])
      });
    });
    if (user.isFollowing) {
      NotificationRepo.sendNotificaion(NotificationModel.create(
        toId: user.id,
        type: NotificationType.Follow,
      ));
    }
  }

  static Future<void> toggleBlock(User user) async {
    user.toggleBlock();
    userDoc(user.id).update({
      'blockedBy': user.isBlocked()
          ? FieldValue.arrayUnion([_uid])
          : FieldValue.arrayRemove([_uid])
    });
  }

  static Future<void> banUser(String userID) async {
    FirebaseFunctions.instance
        .httpsCallable('banUser')
        .call({'userID': userID});
  }
}
