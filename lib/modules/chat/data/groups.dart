import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../imports.dart';
import '../models/group.dart';
import 'users.dart';

mixin GroupsRepository {
  static String get _uid => authProvider.uid;
  static final _firestore = FirebaseFirestore.instance;

  static CollectionReference get groupsCol => _firestore.collection('groups');
  static DocumentReference groupDoc(String id) => groupsCol.doc(id);

  static DocumentSnapshot lastGroupDoc;
  static Stream<List<Group>> myGroupsStream(int limit) => groupsCol
      .where('members', arrayContains: _uid)
      .orderBy('membersCount', descending: true)
      .limit(10)
      .snapshots()
      .map((e) => [for (final d in e.docs) Group.fromMap(d.data())]);

  DocumentSnapshot lastSearchedGroupDoc;
  static Future<List<Group>> fetchAllGroups(int page) async {
    var query = groupsCol
        .where('isPublic', isEqualTo: true)
        .orderBy('membersCount', descending: true)
        .limit(20);

    if (lastGroupDoc != null && page != 0) {
      query = query.startAfterDocument(lastGroupDoc);
    }

    final docs = (await query.get()).docs;
    if (docs.isEmpty) return [];
    lastGroupDoc = docs.last;
    return [
      for (final d in docs)
        if (d.exists) Group.fromMap(d.data())
    ];
  }

  static Future<Group> fetchGroup(String id) async =>
      Group.fromMap((await groupDoc(id).get()).data());

  static Stream<Group> groupStream(String id) => groupDoc(id)
      .snapshots()
      .map((e) => Group.fromMap(e.data()))
      .handleError((e) => logError(e));

  static Future<void> joinOrLeaveGroup(Group group, [String userID]) async {
    userID ??= _uid;
    await _firestore.runTransaction(
      (tr) async => tr.update(groupDoc(group.id), {
        'members': group.isMember()
            ? FieldValue.arrayUnion([userID])
            : FieldValue.arrayRemove([userID]),
        'membersCount': FieldValue.increment(group.isMember() ? -1 : 1),
        'mutedFor': group.isMember()
            ? FieldValue.arrayUnion([userID])
            : FieldValue.arrayRemove([userID]),
        'typing': []
      }).update(_firestore.doc('users/$userID'), {
        'joinedGroups': group.isMember()
            ? FieldValue.arrayUnion([group.id])
            : FieldValue.arrayRemove([group.id]),
      }),
    );
  }

  static Future<void> muteOrUnmuteGroup(Group group) async {
    await groupDoc(group.id).update(
      {
        'mutedFor': group.isMuted()
            ? FieldValue.arrayUnion([_uid])
            : FieldValue.arrayRemove([_uid]),
        'typing': []
      },
    );
  }

  static Future<void> createGroup(Group group) async {
    await groupDoc(group.id).set(group.toMap());
    await joinOrLeaveGroup(group);
  }

  static Future<void> editGroup(Group group) => groupDoc(group.id).update({
        'name': group.name,
        'photoURL': group.photoURL,
        'searchIndexes': group.searchIndexes,
        'typing': [],
      });

  static Future<void> blocUnblocUser(Group group) async {
    groupDoc(group.id).update(
      {
        'blockedUsers': group.isBlocked()
            ? FieldValue.arrayUnion([_uid])
            : FieldValue.arrayRemove([_uid]),
      },
    );
  }

  static DocumentSnapshot lastMemDoc;
  static Future<List<User>> fetchMembers(String groupId, int page) async {
    var query = ChatUsersRepository.usersCol
        .where('joinedGroups', arrayContains: groupId)
        .orderBy('activeAt')
        .limit(20);

    if (lastMemDoc != null && page != 0) {
      query = query.startAfterDocument(lastMemDoc);
    }
    final docs = (await query.get()).docs;
    if (docs.isEmpty) return [];
    lastMemDoc = docs.last;
    return [for (final d in docs) User.fromMap(d.data())];
  }

  static Future<List<Group>> groupsSearch(String query) async {
    final docs = await groupsCol
        .where('searchIndexes', arrayContains: query.toLowerCase())
        .orderBy('membersCount', descending: true)
        .limit(10)
        .get();

    return [for (final g in docs.docs) Group.fromMap(g.data())];
  }

  static Future<void> toggleTyping(String groupID, bool isTyping) async {
    await groupDoc(groupID).update({
      'typing': isTyping
          ? FieldValue.arrayUnion([_uid])
          : FieldValue.arrayRemove([_uid])
    });
  }
}
