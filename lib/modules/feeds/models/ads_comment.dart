import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../imports.dart';

class AdsComment extends Equatable {
  final String id;
  final String postID;
  final String postAuthorID;
  final String authorID;
  final String authorName;
  final String authorPhotoURL;
  final String parentID;
  final String content;
  final DateTime createdAt;
  final List<AdsComment> replyComments;
  final List<String> usersLikeIds;
  const AdsComment({
    @required this.id,
    @required this.postID,
    @required this.postAuthorID,
    @required this.authorID,
    @required this.authorName,
    @required this.authorPhotoURL,
    @required this.parentID,
    @required this.content,
    @required this.createdAt,
    @required this.replyComments,
    @required this.usersLikeIds,
  });
  String get uid => authProvider.user.id;

  bool get isMine => authorID == uid;

  bool get isLiked => usersLikeIds.contains(uid);
  void toggleLike() =>
      isLiked ? usersLikeIds.remove(uid) : usersLikeIds.add(uid);

  factory AdsComment.create({
    String content,
    String postID,
    String postAuthorID,
    String parentID,
  }) {
    final currentUser = authProvider.user;
    return AdsComment(
      id: '${DateTime.now().millisecondsSinceEpoch}-${currentUser.username}',
      content: content,
      postID: postID,
      postAuthorID: postAuthorID,
      authorID: currentUser.id,
      authorName: currentUser.fullName,
      authorPhotoURL: currentUser.photoURL,
      createdAt: DateTime.now().toUtc(),
      usersLikeIds: const [],
      replyComments: const [],
      parentID: parentID,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'postID': postID,
      'postAuthorID': postAuthorID,
      'authorID': authorID,
      'authorName': authorName,
      'authorPhotoURL': authorPhotoURL,
      'parentID': parentID,
      'content': content,
      'createdAt': createdAt,
      'replyComments': replyComments?.map((x) => x?.toMap())?.toList(),
      'usersLikeIds': usersLikeIds,
    };
  }

  factory AdsComment.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    return AdsComment(
      id: map['id'] as String ?? '',
      postID: map['postID'] as String ?? '',
      postAuthorID: map['postAuthorID'] as String ?? '',
      authorID: map['authorID'] as String ?? '',
      authorName: map['authorName'] as String ?? '',
      authorPhotoURL: map['authorPhotoURL'] as String ?? '',
      parentID: map['parentID'] as String ?? '',
      content: map['content'] as String ?? '',
      createdAt: timeFromJson(map['createdAt']),
      replyComments: List<Map>.from(map['replyComments'] as List ?? [])
              ?.map<AdsComment>(
                  (e) => AdsComment.fromMap(Map<String, dynamic>.from(e)))
              ?.toList() ??
          <AdsComment>[],
      usersLikeIds: List<String>.from(map['usersLikeIds'] as List ?? const []),
    );
  }

  AdsComment copyWith({
    String id,
    String postID,
    String postAuthorID,
    String authorID,
    String authorName,
    String authorPhotoURL,
    String parentID,
    String content,
    DateTime createdAt,
    List<AdsComment> replyComments,
    List<String> usersLikeIds,
  }) {
    return AdsComment(
      id: id ?? this.id,
      postID: postID ?? this.postID,
      postAuthorID: postAuthorID ?? this.postAuthorID,
      authorID: authorID ?? this.authorID,
      authorName: authorName ?? this.authorName,
      authorPhotoURL: authorPhotoURL ?? this.authorPhotoURL,
      parentID: parentID ?? this.parentID,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      replyComments: replyComments ?? this.replyComments,
      usersLikeIds: usersLikeIds ?? this.usersLikeIds,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      postID,
      postAuthorID,
      authorID,
      authorName,
      authorPhotoURL,
      parentID,
      content,
      createdAt,
      replyComments,
      usersLikeIds,
    ];
  }
}
