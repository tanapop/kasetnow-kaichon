// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'router.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
class _$AppPageTearOff {
  const _$AppPageTearOff();

// ignore: unused_element
  _Chatting chatting(String userId) {
    return _Chatting(
      userId,
    );
  }

// ignore: unused_element
  _GroupChatting groupChatting(String groupId) {
    return _GroupChatting(
      groupId,
    );
  }

// ignore: unused_element
  _Commenting commenting(String postID) {
    return _Commenting(
      postID,
    );
  }

// ignore: unused_element
  _Others others() {
    return const _Others();
  }
}

/// @nodoc
// ignore: unused_element
const $AppPage = _$AppPageTearOff();

/// @nodoc
mixin _$AppPage {
  @optionalTypeArgs
  TResult when<TResult extends Object>({
    @required TResult chatting(String userId),
    @required TResult groupChatting(String groupId),
    @required TResult commenting(String postID),
    @required TResult others(),
  });
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>({
    TResult chatting(String userId),
    TResult groupChatting(String groupId),
    TResult commenting(String postID),
    TResult others(),
    @required TResult orElse(),
  });
  @optionalTypeArgs
  TResult map<TResult extends Object>({
    @required TResult chatting(_Chatting value),
    @required TResult groupChatting(_GroupChatting value),
    @required TResult commenting(_Commenting value),
    @required TResult others(_Others value),
  });
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult chatting(_Chatting value),
    TResult groupChatting(_GroupChatting value),
    TResult commenting(_Commenting value),
    TResult others(_Others value),
    @required TResult orElse(),
  });
}

/// @nodoc
abstract class $AppPageCopyWith<$Res> {
  factory $AppPageCopyWith(AppPage value, $Res Function(AppPage) then) =
      _$AppPageCopyWithImpl<$Res>;
}

/// @nodoc
class _$AppPageCopyWithImpl<$Res> implements $AppPageCopyWith<$Res> {
  _$AppPageCopyWithImpl(this._value, this._then);

  final AppPage _value;
  // ignore: unused_field
  final $Res Function(AppPage) _then;
}

/// @nodoc
abstract class _$ChattingCopyWith<$Res> {
  factory _$ChattingCopyWith(_Chatting value, $Res Function(_Chatting) then) =
      __$ChattingCopyWithImpl<$Res>;
  $Res call({String userId});
}

/// @nodoc
class __$ChattingCopyWithImpl<$Res> extends _$AppPageCopyWithImpl<$Res>
    implements _$ChattingCopyWith<$Res> {
  __$ChattingCopyWithImpl(_Chatting _value, $Res Function(_Chatting) _then)
      : super(_value, (v) => _then(v as _Chatting));

  @override
  _Chatting get _value => super._value as _Chatting;

  @override
  $Res call({
    Object userId = freezed,
  }) {
    return _then(_Chatting(
      userId == freezed ? _value.userId : userId as String,
    ));
  }
}

/// @nodoc
class _$_Chatting implements _Chatting {
  const _$_Chatting(this.userId) : assert(userId != null);

  @override
  final String userId;

  @override
  String toString() {
    return 'AppPage.chatting(userId: $userId)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _Chatting &&
            (identical(other.userId, userId) ||
                const DeepCollectionEquality().equals(other.userId, userId)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(userId);

  @JsonKey(ignore: true)
  @override
  _$ChattingCopyWith<_Chatting> get copyWith =>
      __$ChattingCopyWithImpl<_Chatting>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object>({
    @required TResult chatting(String userId),
    @required TResult groupChatting(String groupId),
    @required TResult commenting(String postID),
    @required TResult others(),
  }) {
    assert(chatting != null);
    assert(groupChatting != null);
    assert(commenting != null);
    assert(others != null);
    return chatting(userId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>({
    TResult chatting(String userId),
    TResult groupChatting(String groupId),
    TResult commenting(String postID),
    TResult others(),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (chatting != null) {
      return chatting(userId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object>({
    @required TResult chatting(_Chatting value),
    @required TResult groupChatting(_GroupChatting value),
    @required TResult commenting(_Commenting value),
    @required TResult others(_Others value),
  }) {
    assert(chatting != null);
    assert(groupChatting != null);
    assert(commenting != null);
    assert(others != null);
    return chatting(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult chatting(_Chatting value),
    TResult groupChatting(_GroupChatting value),
    TResult commenting(_Commenting value),
    TResult others(_Others value),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (chatting != null) {
      return chatting(this);
    }
    return orElse();
  }
}

abstract class _Chatting implements AppPage {
  const factory _Chatting(String userId) = _$_Chatting;

  String get userId;
  @JsonKey(ignore: true)
  _$ChattingCopyWith<_Chatting> get copyWith;
}

/// @nodoc
abstract class _$GroupChattingCopyWith<$Res> {
  factory _$GroupChattingCopyWith(
          _GroupChatting value, $Res Function(_GroupChatting) then) =
      __$GroupChattingCopyWithImpl<$Res>;
  $Res call({String groupId});
}

/// @nodoc
class __$GroupChattingCopyWithImpl<$Res> extends _$AppPageCopyWithImpl<$Res>
    implements _$GroupChattingCopyWith<$Res> {
  __$GroupChattingCopyWithImpl(
      _GroupChatting _value, $Res Function(_GroupChatting) _then)
      : super(_value, (v) => _then(v as _GroupChatting));

  @override
  _GroupChatting get _value => super._value as _GroupChatting;

  @override
  $Res call({
    Object groupId = freezed,
  }) {
    return _then(_GroupChatting(
      groupId == freezed ? _value.groupId : groupId as String,
    ));
  }
}

/// @nodoc
class _$_GroupChatting implements _GroupChatting {
  const _$_GroupChatting(this.groupId) : assert(groupId != null);

  @override
  final String groupId;

  @override
  String toString() {
    return 'AppPage.groupChatting(groupId: $groupId)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _GroupChatting &&
            (identical(other.groupId, groupId) ||
                const DeepCollectionEquality().equals(other.groupId, groupId)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(groupId);

  @JsonKey(ignore: true)
  @override
  _$GroupChattingCopyWith<_GroupChatting> get copyWith =>
      __$GroupChattingCopyWithImpl<_GroupChatting>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object>({
    @required TResult chatting(String userId),
    @required TResult groupChatting(String groupId),
    @required TResult commenting(String postID),
    @required TResult others(),
  }) {
    assert(chatting != null);
    assert(groupChatting != null);
    assert(commenting != null);
    assert(others != null);
    return groupChatting(groupId);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>({
    TResult chatting(String userId),
    TResult groupChatting(String groupId),
    TResult commenting(String postID),
    TResult others(),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (groupChatting != null) {
      return groupChatting(groupId);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object>({
    @required TResult chatting(_Chatting value),
    @required TResult groupChatting(_GroupChatting value),
    @required TResult commenting(_Commenting value),
    @required TResult others(_Others value),
  }) {
    assert(chatting != null);
    assert(groupChatting != null);
    assert(commenting != null);
    assert(others != null);
    return groupChatting(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult chatting(_Chatting value),
    TResult groupChatting(_GroupChatting value),
    TResult commenting(_Commenting value),
    TResult others(_Others value),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (groupChatting != null) {
      return groupChatting(this);
    }
    return orElse();
  }
}

abstract class _GroupChatting implements AppPage {
  const factory _GroupChatting(String groupId) = _$_GroupChatting;

  String get groupId;
  @JsonKey(ignore: true)
  _$GroupChattingCopyWith<_GroupChatting> get copyWith;
}

/// @nodoc
abstract class _$CommentingCopyWith<$Res> {
  factory _$CommentingCopyWith(
          _Commenting value, $Res Function(_Commenting) then) =
      __$CommentingCopyWithImpl<$Res>;
  $Res call({String postID});
}

/// @nodoc
class __$CommentingCopyWithImpl<$Res> extends _$AppPageCopyWithImpl<$Res>
    implements _$CommentingCopyWith<$Res> {
  __$CommentingCopyWithImpl(
      _Commenting _value, $Res Function(_Commenting) _then)
      : super(_value, (v) => _then(v as _Commenting));

  @override
  _Commenting get _value => super._value as _Commenting;

  @override
  $Res call({
    Object postID = freezed,
  }) {
    return _then(_Commenting(
      postID == freezed ? _value.postID : postID as String,
    ));
  }
}

/// @nodoc
class _$_Commenting implements _Commenting {
  const _$_Commenting(this.postID) : assert(postID != null);

  @override
  final String postID;

  @override
  String toString() {
    return 'AppPage.commenting(postID: $postID)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _Commenting &&
            (identical(other.postID, postID) ||
                const DeepCollectionEquality().equals(other.postID, postID)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(postID);

  @JsonKey(ignore: true)
  @override
  _$CommentingCopyWith<_Commenting> get copyWith =>
      __$CommentingCopyWithImpl<_Commenting>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object>({
    @required TResult chatting(String userId),
    @required TResult groupChatting(String groupId),
    @required TResult commenting(String postID),
    @required TResult others(),
  }) {
    assert(chatting != null);
    assert(groupChatting != null);
    assert(commenting != null);
    assert(others != null);
    return commenting(postID);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>({
    TResult chatting(String userId),
    TResult groupChatting(String groupId),
    TResult commenting(String postID),
    TResult others(),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (commenting != null) {
      return commenting(postID);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object>({
    @required TResult chatting(_Chatting value),
    @required TResult groupChatting(_GroupChatting value),
    @required TResult commenting(_Commenting value),
    @required TResult others(_Others value),
  }) {
    assert(chatting != null);
    assert(groupChatting != null);
    assert(commenting != null);
    assert(others != null);
    return commenting(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult chatting(_Chatting value),
    TResult groupChatting(_GroupChatting value),
    TResult commenting(_Commenting value),
    TResult others(_Others value),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (commenting != null) {
      return commenting(this);
    }
    return orElse();
  }
}

abstract class _Commenting implements AppPage {
  const factory _Commenting(String postID) = _$_Commenting;

  String get postID;
  @JsonKey(ignore: true)
  _$CommentingCopyWith<_Commenting> get copyWith;
}

/// @nodoc
abstract class _$OthersCopyWith<$Res> {
  factory _$OthersCopyWith(_Others value, $Res Function(_Others) then) =
      __$OthersCopyWithImpl<$Res>;
}

/// @nodoc
class __$OthersCopyWithImpl<$Res> extends _$AppPageCopyWithImpl<$Res>
    implements _$OthersCopyWith<$Res> {
  __$OthersCopyWithImpl(_Others _value, $Res Function(_Others) _then)
      : super(_value, (v) => _then(v as _Others));

  @override
  _Others get _value => super._value as _Others;
}

/// @nodoc
class _$_Others implements _Others {
  const _$_Others();

  @override
  String toString() {
    return 'AppPage.others()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other is _Others);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object>({
    @required TResult chatting(String userId),
    @required TResult groupChatting(String groupId),
    @required TResult commenting(String postID),
    @required TResult others(),
  }) {
    assert(chatting != null);
    assert(groupChatting != null);
    assert(commenting != null);
    assert(others != null);
    return others();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>({
    TResult chatting(String userId),
    TResult groupChatting(String groupId),
    TResult commenting(String postID),
    TResult others(),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (others != null) {
      return others();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object>({
    @required TResult chatting(_Chatting value),
    @required TResult groupChatting(_GroupChatting value),
    @required TResult commenting(_Commenting value),
    @required TResult others(_Others value),
  }) {
    assert(chatting != null);
    assert(groupChatting != null);
    assert(commenting != null);
    assert(others != null);
    return others(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult chatting(_Chatting value),
    TResult groupChatting(_GroupChatting value),
    TResult commenting(_Commenting value),
    TResult others(_Others value),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (others != null) {
      return others(this);
    }
    return orElse();
  }
}

abstract class _Others implements AppPage {
  const factory _Others() = _$_Others;
}
