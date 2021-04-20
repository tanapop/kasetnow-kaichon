import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class MessageNotification extends Equatable {
  final String fromID;
  final String fromName;
  final String fromPhotoURL;
  final String groupID;
  final String groupName;
  final String type;
  final String title;
  final String body;
  const MessageNotification({
    @required this.fromID,
    @required this.fromName,
    @required this.fromPhotoURL,
    @required this.groupID,
    @required this.groupName,
    @required this.type,
    @required this.title,
    @required this.body,
  });

  bool get isGroup => groupID.isNotEmpty;

  factory MessageNotification.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return MessageNotification(
      fromID: map['fromID'] as String ?? '',
      fromName: map['fromName'] as String ?? '',
      fromPhotoURL: map['fromPhotoURL'] as String ?? '',
      groupID: map['groupID'] as String ?? '',
      groupName: map['groupName'] as String ?? '',
      type: map['type'] as String ?? '',
      title: map['title'] as String ?? '',
      body: map['body'] as String ?? '',
    );
  }

  MessageNotification copyWith({
    String fromID,
    String fromName,
    String fromPhotoURL,
    String groupID,
    String groupName,
    String type,
    String title,
    String body,
  }) {
    return MessageNotification(
      fromID: fromID ?? this.fromID,
      fromName: fromName ?? this.fromName,
      fromPhotoURL: fromPhotoURL ?? this.fromPhotoURL,
      groupID: groupID ?? this.groupID,
      groupName: groupName ?? this.groupName,
      type: type ?? this.type,
      title: title ?? this.title,
      body: body ?? this.body,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      fromID,
      fromName,
      fromPhotoURL,
      groupID,
      groupName,
      type,
      title,
      body,
    ];
  }
}
