/* import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../imports.dart';

class Event extends Equatable {
  final String uid;
  final String authorID;
  final String authorName;
  final String name;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String content;
  final List<String> usersLikes;
  final List<String> commentsIDs;
  final List<String> reportedBy;
  final ImageModel image;
  final bool isShared;

  const Event({
    @required this.uid,
    @required this.authorID,
    @required this.authorName,
    @required this.name,
    @required this.description,
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


  User get getUser => User.createNew(
        uid: authorID,
        username: authorName,
        photoURL: authorPhotoURL,
        phone: '',
      );

  Map<String, dynamic> toMap() {
    return {
      'id': uid,
      'authorID': authorID,
      'authorName': authorName,
      'name': name,
      'description': description,
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

  factory Event.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Event(
      uid: map['uid'] as String ?? '',
      authorID: map['authorID'] as String ?? '',
      authorName: map['authorName'] as String ?? '',
      name: map['name'] as String ?? '',
      description: map['description'] as String ?? '',
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

  Event copyWith({
    String uid,
    String authorID,
    String authorName,
    String name,
    String description,
    DateTime createdAt,
    DateTime updatedAt,
    String content,
    List<String> usersLikes,
    List<String> commentsIDs,
    List<String> reportedBy,
    ImageModel image,
    bool isShared,
  }) {
    return Event(
      uid: uid ?? this.uid,
      authorID: authorID ?? this.authorID,
      authorName: authorName ?? this.authorName,
      name: name ?? this.name,
      description: description ?? this.description,
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
      uid,
      authorID,
      authorName,
      name,
      name,
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
 */
