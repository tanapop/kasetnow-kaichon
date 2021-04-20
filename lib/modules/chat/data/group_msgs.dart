import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

import '../../../imports.dart';
import 'groups.dart';

mixin GroupMessagesRepository {
  static String get _uid => authProvider.user.id;

  static CollectionReference _msgsCol(String groudId) =>
      GroupsRepository.groupDoc(groudId).collection('messages');

  static DocumentReference msgDoc(String groudId, String msgId) =>
      _msgsCol(groudId).doc(msgId);

  static Stream<List<Message>> msgsStream(String groupId, int limit) =>
      _msgsCol(groupId)
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .snapshots()
          .map(
            (s) => [for (final g in s.docs) Message.fromMap(g.data())],
          )
          .map(
            (s) => [
              for (final m in s)
                if (m.isSent || m.isSending) m
            ],
          )
          .handleError((e) => logError(e));

  static Stream<List<Message>> unseenMsgsStream(
          String groupId, String userId) =>
      _msgsCol(groupId)
          .orderBy('createdAt', descending: true)
          .where('seenBy', arrayContains: userId)
          .limit(10)
          .snapshots()
          .map(
            (s) => [for (final g in s.docs) Message.fromMap(g.data())],
          );
  static Future<void> sendMessage(Message msg) => msgDoc(msg.groupID, msg.id)
      .set(msg.toMap()..['createdAt'] = FieldValue.serverTimestamp());

  static Future<void> editMessage(Message msg) =>
      msgDoc(msg.groupID, msg.id).update({'content': msg.content});
  static Future<void> deleteMessage({
    @required String groupId,
    @required String msgId,
  }) =>
      msgDoc(groupId, msgId).delete();

  static void updateSeenBy(List<Message> msgs) {
    for (final m in msgs) {
      if (m.groupID.isEmpty || !m.isSent) continue;
      msgDoc(m.groupID, m.id).update({
        'seenBy': FieldValue.arrayUnion([_uid])
      }).catchError((e) => logError(e));
    }
  }
}
