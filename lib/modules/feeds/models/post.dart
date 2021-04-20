import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../imports.dart';

class Post extends Equatable {
  final String id;
  final String authorID;
  final String authorName;
  final String authorPhotoURL;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String content;
  final List<String> usersLikes;
  final List<String> commentsIDs;
  final List<String> reportedBy;
  final ImageModel image;
  final bool isShared;

  const Post({
    @required this.id,
    @required this.authorID,
    @required this.authorName,
    @required this.authorPhotoURL,
    @required this.createdAt,
    @required this.updatedAt,
    @required this.reportedBy,
    @required this.content,
    @required this.usersLikes,
    @required this.commentsIDs,
    this.isShared,
    this.image,
  });
  String get _uid => authProvider.user.id;

  bool get liked => usersLikes.contains(_uid);
  bool get isMine => authorID == _uid;
  bool get isReported => reportedBy.isNotEmpty;
  bool get hasImage => image?.path?.isNotEmpty == true;
  bool get show => (isShared || isMine) && !reportedBy.contains(_uid);

  void toggleLike() => liked ? usersLikes.remove(_uid) : usersLikes.add(_uid);

  factory Post.create({
    String content,
    ImageModel image,
  }) {
    final currentUser = authProvider.user;
    return Post(
      id: '${DateTime.now().millisecondsSinceEpoch}-${currentUser.username}',
      authorID: currentUser.id,
      authorName: currentUser.username,
      authorPhotoURL: currentUser.photoURL,
      content: content,
      usersLikes: const [],
      createdAt: DateTime.now().toUtc(),
      updatedAt: DateTime.now().toUtc(),
      commentsIDs: const [],
      reportedBy: const [],
      isShared: false,
      image: image,
    );
  }

  User get getUser => User.createNew(
        uid: authorID,
        username: authorName,
        photoURL: authorPhotoURL,
        phone: '',
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'authorID': authorID,
      'authorName': authorName,
      'authorPhotoURL': authorPhotoURL,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'content': content,
      'usersLikes': usersLikes,
      'commentsIDs': commentsIDs,
      'reportedBy': reportedBy,
      'isShared': isShared,
      'image': image?.toMap(),
    }..removeWhere((_, v) => '${v ?? ''}'.isEmpty);
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Post(
      id: map['id'] as String ?? '',
      authorID: map['authorID'] as String ?? '',
      authorName: map['authorName'] as String ?? '',
      authorPhotoURL: map['authorPhotoURL'] as String ?? '',
      createdAt: timeFromJson(map['createdAt']),
      updatedAt: timeFromJson(map['updatedAt']),
      content: map['content'] as String ?? '',
      usersLikes: List<String>.from(map['usersLikes'] as List ?? const []),
      commentsIDs: List<String>.from(map['commentsIDs'] as List ?? const []),
      reportedBy: List<String>.from(map['reportedBy'] as List ?? const []),
      isShared: map['isShared'] as bool ?? true,
      image: ImageModel.fromMap(
        Map<String, dynamic>.from(map['image'] as Map ?? {}),
      ),
    );
  }

  Post copyWith({
    String id,
    String authorID,
    String authorName,
    String authorPhotoURL,
    DateTime createdAt,
    DateTime updatedAt,
    String content,
    List<String> usersLikes,
    List<String> commentsIDs,
    List<String> reportedBy,
    ImageModel image,
    bool isShared,
  }) {
    return Post(
      id: id ?? this.id,
      authorID: authorID ?? this.authorID,
      authorName: authorName ?? this.authorName,
      authorPhotoURL: authorPhotoURL ?? this.authorPhotoURL,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      content: content ?? this.content,
      usersLikes: usersLikes ?? this.usersLikes,
      commentsIDs: commentsIDs ?? this.commentsIDs,
      reportedBy: reportedBy ?? this.reportedBy,
      image: image ?? this.image,
      isShared: isShared ?? this.isShared,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      authorID,
      authorName,
      authorPhotoURL,
      createdAt,
      updatedAt,
      content,
      usersLikes,
      commentsIDs,
      reportedBy,
      image,
      isShared,
    ];
  }
}
