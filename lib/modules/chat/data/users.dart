import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../imports.dart';

mixin ChatUsersRepository {
  static String get _uid => authProvider.user.id;

  static final _firestore = FirebaseFirestore.instance;
  static CollectionReference get usersCol => _firestore.collection('users');
  static DocumentReference userDoc([String id]) => usersCol.doc(id ?? _uid);

  static Stream<List<User>> onlineUsers() => usersCol
      .where('isActive', isEqualTo: true)
      .where('onlineStatus', isEqualTo: true)
      .limit(30)
      .snapshots()
      .map((e) => [for (final d in e.docs) User.fromMap(d.data())])
      .map((e) => [
            for (final u in e)
              if (!u.isMe && !u.isBanned && u.isOnline) u
          ])
      .handleError((e) => logError(e));

  static DocumentSnapshot lastMemDoc;
  static Future<List<User>> fetchAllUsers(int page) async {
    var query = usersCol.orderBy('activeAt', descending: true).limit(20);

    if (lastMemDoc != null && page != 0) {
      query = query.startAfterDocument(lastMemDoc);
    }
    final docs = (await query.get()).docs;
    if (docs.isEmpty) return [];
    lastMemDoc = docs.last;
    return [for (final d in docs) User.fromMap(d.data())];
  }

  static Future<List<User>> usersSearch(String query) async {
    final docs = await usersCol
        .where('searchIndexes', arrayContains: query.toLowerCase())
        .limit(10)
        .get();

    return [for (final g in docs.docs) User.fromMap(g.data())];
  }
}
