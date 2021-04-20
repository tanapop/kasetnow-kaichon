import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../core/utils.dart';
import '../provider.dart';

class User extends Equatable {
  final String id;
  final String username;
  final String firstName;
  final String lastName;
  final String status;
  final String email;
  final String phone;
  final String photoURL;
  final String coverPhotoURL;
  final String country;
  final String gender;
  final bool isBanned;
  final bool isAdmin;
  final bool isActive;
  final DateTime activeAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> reportedBy;
  final List<String> postAds;
  final List<String> posts;
  final List<String> followers;
  final List<String> following;
  final List<String> blockedBy;
  final bool chatNotify;
  final bool groupsNotify;
  final bool onlineStatus;

  const User({
    @required this.id,
    @required this.username,
    @required this.firstName,
    @required this.lastName,
    @required this.status,
    @required this.email,
    @required this.phone,
    @required this.photoURL,
    @required this.coverPhotoURL,
    @required this.country,
    @required this.gender,
    @required this.isBanned,
    @required this.isAdmin,
    @required this.isActive,
    @required this.activeAt,
    @required this.createdAt,
    @required this.updatedAt,
    @required this.reportedBy,
    @required this.postAds,
    @required this.posts,
    @required this.followers,
    @required this.following,
    @required this.blockedBy,
    @required this.chatNotify,
    @required this.groupsNotify,
    @required this.onlineStatus,
  });

  bool get isOnline =>
      isActive && DateTime.now().difference(activeAt).inMinutes < 20;

  String get _uid => authProvider.uid;
  bool get isMe => id == _uid;

  bool get isFollowing => followers.contains(_uid);
  void toggleFollowing() {
    final currentUser = authProvider.user;
    if (isFollowing) {
      followers.remove(_uid);
      currentUser.following.remove(id);
    } else {
      followers.add(_uid);
      currentUser.following.add(id);
    }
    authProvider.rxUser.refresh();
  }

  bool isBlocked([String uid]) => blockedBy.contains(uid ?? _uid);
  void toggleBlock() =>
      isBlocked() ? blockedBy.remove(_uid) : blockedBy.add(_uid);

  String get fullName => '$firstName $lastName';

  factory User.createNew({
    @required String uid,
    @required String phone,
    @required String username,
    String firstName,
    String lastName,
    String country,
    String photoURL,
    String coverPhoto,
    String email,
    String status,
    String gender,
  }) {
    return User(
      id: uid,
      username: username,
      firstName: firstName,
      lastName: lastName,
      email: email ?? '',
      photoURL: photoURL ?? '',
      status: status ?? '',
      coverPhotoURL: coverPhoto ?? '',
      phone: phone,
      country: country,
      gender: gender,
      isBanned: false,
      isAdmin: false,
      isActive: true,
      activeAt: DateTime.now(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      postAds: const <String>[],
      posts: const <String>[],
      followers: const <String>[],
      following: const <String>[],
      blockedBy: const <String>[],
      reportedBy: const <String>[],
      onlineStatus: true,
      chatNotify: true,
      groupsNotify: true,
    );
  }

  List<String> get searchIndexes {
    final indices = <String>[];
    for (final s in [username, firstName, lastName]) {
      for (var i = 1; i < s.length; i++) {
        indices.add(s.substring(0, i).toLowerCase());
      }
    }
    return indices;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'firstName': firstName,
      'lastName': lastName,
      'fullName': fullName,
      'status': status,
      'email': email,
      'phone': phone,
      'photoURL': photoURL,
      'coverPhotoURL': coverPhotoURL,
      'onlineStatus': onlineStatus,
      'country': country,
      'gender': gender,
      'isBanned': isBanned,
      'isAdmin': isAdmin,
      'isActive': isActive,
      'activeAt': activeAt,
      'createdAt': createdAt,
      'reporters': reportedBy,
      'chatNotify': chatNotify,
      'groupsNotify': groupsNotify,
      'postAds': postAds,
      'posts': posts,
      'followers': followers,
      'following': following,
      'blockedBy': blockedBy,
      'searchIndexes': searchIndexes,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return User(
      id: map['id'] as String ?? '',
      username: (map['username'] ?? map['name']) as String ?? '',
      firstName: map['firstName'] as String ?? '',
      lastName: map['lastName'] as String ?? '',
      status: map['status'] as String ?? '',
      email: map['email'] as String ?? '',
      phone: (map['phone'] ?? map['phoneNumber']) as String ?? '',
      photoURL: (map['photoURL'] ?? map['photoURL']) as String ?? '',
      coverPhotoURL: map['coverPhotoURL'] as String ?? '',
      onlineStatus: map['onlineStatus'] as bool ?? false,
      country: map['country'] as String ?? '',
      gender: map['gender'] as String ?? '',
      isBanned: map['isBanned'] as bool ?? false,
      isAdmin: map['isAdmin'] as bool ?? false,
      isActive: map['isActive'] as bool ?? false,
      activeAt: timeFromJson(map['lastTimeSeen'] ?? map['activeAt']),
      createdAt: timeFromJson(map['createdAt']),
      updatedAt: timeFromJson(map['updatedAt']),
      reportedBy: List<String>.from(map['reportedBy'] as List ?? const []),
      chatNotify: map['chatNotify'] as bool ?? false,
      groupsNotify: map['groupsNotify'] as bool ?? false,
      postAds: List<String>.from(map['post_ads'] as List ?? []),
      posts: List<String>.from(map['posts'] as List ?? []),
      followers: List<String>.from(map['followers'] as List ?? []),
      following: List<String>.from(map['following'] as List ?? []),
      blockedBy: List<String>.from(map['blockedBy'] as List ?? []),
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      username,
      firstName,
      lastName,
      status,
      email,
      phone,
      photoURL,
      coverPhotoURL,
      country,
      gender,
      isBanned,
      isAdmin,
      isActive,
      activeAt,
      createdAt,
      updatedAt,
      reportedBy,
      postAds,
      posts,
      followers,
      following,
      blockedBy,
      chatNotify,
      groupsNotify,
      onlineStatus,
    ];
  }

  User copyWith({
    String id,
    String username,
    String firstName,
    String lastName,
    String status,
    String email,
    String phone,
    String photoURL,
    String coverPhotoURL,
    String country,
    String gender,
    bool isBanned,
    bool isAdmin,
    bool isActive,
    DateTime activeAt,
    DateTime createdAt,
    DateTime updatedAt,
    List<String> reportedBy,
    List<String> postAds,
    List<String> posts,
    List<String> followers,
    List<String> following,
    List<String> blockedBy,
    bool chatNotify,
    bool groupsNotify,
    bool onlineStatus,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      status: status ?? this.status,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      photoURL: photoURL ?? this.photoURL,
      coverPhotoURL: coverPhotoURL ?? this.coverPhotoURL,
      country: country ?? this.country,
      gender: gender ?? this.gender,
      isBanned: isBanned ?? this.isBanned,
      isAdmin: isAdmin ?? this.isAdmin,
      isActive: isActive ?? this.isActive,
      activeAt: activeAt ?? this.activeAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      reportedBy: reportedBy ?? this.reportedBy,
      postAds: postAds ?? this.postAds,
      posts: posts ?? this.posts,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      blockedBy: blockedBy ?? this.blockedBy,
      chatNotify: chatNotify ?? this.chatNotify,
      groupsNotify: groupsNotify ?? this.groupsNotify,
      onlineStatus: onlineStatus ?? this.onlineStatus,
    );
  }
}
