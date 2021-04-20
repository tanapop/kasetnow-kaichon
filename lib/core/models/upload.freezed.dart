// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'upload.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
class _$UploadStateTearOff {
  const _$UploadStateTearOff();

// ignore: unused_element
  _UploadInitial initial() {
    return const _UploadInitial();
  }

// ignore: unused_element
  _UploadPicked picked(FileModel file) {
    return _UploadPicked(
      file,
    );
  }

// ignore: unused_element
  _Uploading uploading(double progress) {
    return _Uploading(
      progress,
    );
  }

// ignore: unused_element
  _UploadSuccess success(FileModel file) {
    return _UploadSuccess(
      file,
    );
  }

// ignore: unused_element
  _UploadFailed failed(String msg) {
    return _UploadFailed(
      msg,
    );
  }
}

/// @nodoc
// ignore: unused_element
const $UploadState = _$UploadStateTearOff();

/// @nodoc
mixin _$UploadState {
  @optionalTypeArgs
  TResult when<TResult extends Object>({
    @required TResult initial(),
    @required TResult picked(FileModel file),
    @required TResult uploading(double progress),
    @required TResult success(FileModel file),
    @required TResult failed(String msg),
  });
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>({
    TResult initial(),
    TResult picked(FileModel file),
    TResult uploading(double progress),
    TResult success(FileModel file),
    TResult failed(String msg),
    @required TResult orElse(),
  });
  @optionalTypeArgs
  TResult map<TResult extends Object>({
    @required TResult initial(_UploadInitial value),
    @required TResult picked(_UploadPicked value),
    @required TResult uploading(_Uploading value),
    @required TResult success(_UploadSuccess value),
    @required TResult failed(_UploadFailed value),
  });
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult initial(_UploadInitial value),
    TResult picked(_UploadPicked value),
    TResult uploading(_Uploading value),
    TResult success(_UploadSuccess value),
    TResult failed(_UploadFailed value),
    @required TResult orElse(),
  });
}

/// @nodoc
abstract class $UploadStateCopyWith<$Res> {
  factory $UploadStateCopyWith(
          UploadState value, $Res Function(UploadState) then) =
      _$UploadStateCopyWithImpl<$Res>;
}

/// @nodoc
class _$UploadStateCopyWithImpl<$Res> implements $UploadStateCopyWith<$Res> {
  _$UploadStateCopyWithImpl(this._value, this._then);

  final UploadState _value;
  // ignore: unused_field
  final $Res Function(UploadState) _then;
}

/// @nodoc
abstract class _$UploadInitialCopyWith<$Res> {
  factory _$UploadInitialCopyWith(
          _UploadInitial value, $Res Function(_UploadInitial) then) =
      __$UploadInitialCopyWithImpl<$Res>;
}

/// @nodoc
class __$UploadInitialCopyWithImpl<$Res> extends _$UploadStateCopyWithImpl<$Res>
    implements _$UploadInitialCopyWith<$Res> {
  __$UploadInitialCopyWithImpl(
      _UploadInitial _value, $Res Function(_UploadInitial) _then)
      : super(_value, (v) => _then(v as _UploadInitial));

  @override
  _UploadInitial get _value => super._value as _UploadInitial;
}

/// @nodoc
class _$_UploadInitial implements _UploadInitial {
  const _$_UploadInitial();

  @override
  String toString() {
    return 'UploadState.initial()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) || (other is _UploadInitial);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object>({
    @required TResult initial(),
    @required TResult picked(FileModel file),
    @required TResult uploading(double progress),
    @required TResult success(FileModel file),
    @required TResult failed(String msg),
  }) {
    assert(initial != null);
    assert(picked != null);
    assert(uploading != null);
    assert(success != null);
    assert(failed != null);
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>({
    TResult initial(),
    TResult picked(FileModel file),
    TResult uploading(double progress),
    TResult success(FileModel file),
    TResult failed(String msg),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object>({
    @required TResult initial(_UploadInitial value),
    @required TResult picked(_UploadPicked value),
    @required TResult uploading(_Uploading value),
    @required TResult success(_UploadSuccess value),
    @required TResult failed(_UploadFailed value),
  }) {
    assert(initial != null);
    assert(picked != null);
    assert(uploading != null);
    assert(success != null);
    assert(failed != null);
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult initial(_UploadInitial value),
    TResult picked(_UploadPicked value),
    TResult uploading(_Uploading value),
    TResult success(_UploadSuccess value),
    TResult failed(_UploadFailed value),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class _UploadInitial implements UploadState {
  const factory _UploadInitial() = _$_UploadInitial;
}

/// @nodoc
abstract class _$UploadPickedCopyWith<$Res> {
  factory _$UploadPickedCopyWith(
          _UploadPicked value, $Res Function(_UploadPicked) then) =
      __$UploadPickedCopyWithImpl<$Res>;
  $Res call({FileModel file});
}

/// @nodoc
class __$UploadPickedCopyWithImpl<$Res> extends _$UploadStateCopyWithImpl<$Res>
    implements _$UploadPickedCopyWith<$Res> {
  __$UploadPickedCopyWithImpl(
      _UploadPicked _value, $Res Function(_UploadPicked) _then)
      : super(_value, (v) => _then(v as _UploadPicked));

  @override
  _UploadPicked get _value => super._value as _UploadPicked;

  @override
  $Res call({
    Object file = freezed,
  }) {
    return _then(_UploadPicked(
      file == freezed ? _value.file : file as FileModel,
    ));
  }
}

/// @nodoc
class _$_UploadPicked implements _UploadPicked {
  const _$_UploadPicked(this.file) : assert(file != null);

  @override
  final FileModel file;

  @override
  String toString() {
    return 'UploadState.picked(file: $file)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _UploadPicked &&
            (identical(other.file, file) ||
                const DeepCollectionEquality().equals(other.file, file)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(file);

  @JsonKey(ignore: true)
  @override
  _$UploadPickedCopyWith<_UploadPicked> get copyWith =>
      __$UploadPickedCopyWithImpl<_UploadPicked>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object>({
    @required TResult initial(),
    @required TResult picked(FileModel file),
    @required TResult uploading(double progress),
    @required TResult success(FileModel file),
    @required TResult failed(String msg),
  }) {
    assert(initial != null);
    assert(picked != null);
    assert(uploading != null);
    assert(success != null);
    assert(failed != null);
    return picked(file);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>({
    TResult initial(),
    TResult picked(FileModel file),
    TResult uploading(double progress),
    TResult success(FileModel file),
    TResult failed(String msg),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (picked != null) {
      return picked(file);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object>({
    @required TResult initial(_UploadInitial value),
    @required TResult picked(_UploadPicked value),
    @required TResult uploading(_Uploading value),
    @required TResult success(_UploadSuccess value),
    @required TResult failed(_UploadFailed value),
  }) {
    assert(initial != null);
    assert(picked != null);
    assert(uploading != null);
    assert(success != null);
    assert(failed != null);
    return picked(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult initial(_UploadInitial value),
    TResult picked(_UploadPicked value),
    TResult uploading(_Uploading value),
    TResult success(_UploadSuccess value),
    TResult failed(_UploadFailed value),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (picked != null) {
      return picked(this);
    }
    return orElse();
  }
}

abstract class _UploadPicked implements UploadState {
  const factory _UploadPicked(FileModel file) = _$_UploadPicked;

  FileModel get file;
  @JsonKey(ignore: true)
  _$UploadPickedCopyWith<_UploadPicked> get copyWith;
}

/// @nodoc
abstract class _$UploadingCopyWith<$Res> {
  factory _$UploadingCopyWith(
          _Uploading value, $Res Function(_Uploading) then) =
      __$UploadingCopyWithImpl<$Res>;
  $Res call({double progress});
}

/// @nodoc
class __$UploadingCopyWithImpl<$Res> extends _$UploadStateCopyWithImpl<$Res>
    implements _$UploadingCopyWith<$Res> {
  __$UploadingCopyWithImpl(_Uploading _value, $Res Function(_Uploading) _then)
      : super(_value, (v) => _then(v as _Uploading));

  @override
  _Uploading get _value => super._value as _Uploading;

  @override
  $Res call({
    Object progress = freezed,
  }) {
    return _then(_Uploading(
      progress == freezed ? _value.progress : progress as double,
    ));
  }
}

/// @nodoc
class _$_Uploading implements _Uploading {
  const _$_Uploading(this.progress) : assert(progress != null);

  @override
  final double progress;

  @override
  String toString() {
    return 'UploadState.uploading(progress: $progress)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _Uploading &&
            (identical(other.progress, progress) ||
                const DeepCollectionEquality()
                    .equals(other.progress, progress)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(progress);

  @JsonKey(ignore: true)
  @override
  _$UploadingCopyWith<_Uploading> get copyWith =>
      __$UploadingCopyWithImpl<_Uploading>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object>({
    @required TResult initial(),
    @required TResult picked(FileModel file),
    @required TResult uploading(double progress),
    @required TResult success(FileModel file),
    @required TResult failed(String msg),
  }) {
    assert(initial != null);
    assert(picked != null);
    assert(uploading != null);
    assert(success != null);
    assert(failed != null);
    return uploading(progress);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>({
    TResult initial(),
    TResult picked(FileModel file),
    TResult uploading(double progress),
    TResult success(FileModel file),
    TResult failed(String msg),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (uploading != null) {
      return uploading(progress);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object>({
    @required TResult initial(_UploadInitial value),
    @required TResult picked(_UploadPicked value),
    @required TResult uploading(_Uploading value),
    @required TResult success(_UploadSuccess value),
    @required TResult failed(_UploadFailed value),
  }) {
    assert(initial != null);
    assert(picked != null);
    assert(uploading != null);
    assert(success != null);
    assert(failed != null);
    return uploading(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult initial(_UploadInitial value),
    TResult picked(_UploadPicked value),
    TResult uploading(_Uploading value),
    TResult success(_UploadSuccess value),
    TResult failed(_UploadFailed value),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (uploading != null) {
      return uploading(this);
    }
    return orElse();
  }
}

abstract class _Uploading implements UploadState {
  const factory _Uploading(double progress) = _$_Uploading;

  double get progress;
  @JsonKey(ignore: true)
  _$UploadingCopyWith<_Uploading> get copyWith;
}

/// @nodoc
abstract class _$UploadSuccessCopyWith<$Res> {
  factory _$UploadSuccessCopyWith(
          _UploadSuccess value, $Res Function(_UploadSuccess) then) =
      __$UploadSuccessCopyWithImpl<$Res>;
  $Res call({FileModel file});
}

/// @nodoc
class __$UploadSuccessCopyWithImpl<$Res> extends _$UploadStateCopyWithImpl<$Res>
    implements _$UploadSuccessCopyWith<$Res> {
  __$UploadSuccessCopyWithImpl(
      _UploadSuccess _value, $Res Function(_UploadSuccess) _then)
      : super(_value, (v) => _then(v as _UploadSuccess));

  @override
  _UploadSuccess get _value => super._value as _UploadSuccess;

  @override
  $Res call({
    Object file = freezed,
  }) {
    return _then(_UploadSuccess(
      file == freezed ? _value.file : file as FileModel,
    ));
  }
}

/// @nodoc
class _$_UploadSuccess implements _UploadSuccess {
  const _$_UploadSuccess(this.file) : assert(file != null);

  @override
  final FileModel file;

  @override
  String toString() {
    return 'UploadState.success(file: $file)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _UploadSuccess &&
            (identical(other.file, file) ||
                const DeepCollectionEquality().equals(other.file, file)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(file);

  @JsonKey(ignore: true)
  @override
  _$UploadSuccessCopyWith<_UploadSuccess> get copyWith =>
      __$UploadSuccessCopyWithImpl<_UploadSuccess>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object>({
    @required TResult initial(),
    @required TResult picked(FileModel file),
    @required TResult uploading(double progress),
    @required TResult success(FileModel file),
    @required TResult failed(String msg),
  }) {
    assert(initial != null);
    assert(picked != null);
    assert(uploading != null);
    assert(success != null);
    assert(failed != null);
    return success(file);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>({
    TResult initial(),
    TResult picked(FileModel file),
    TResult uploading(double progress),
    TResult success(FileModel file),
    TResult failed(String msg),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (success != null) {
      return success(file);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object>({
    @required TResult initial(_UploadInitial value),
    @required TResult picked(_UploadPicked value),
    @required TResult uploading(_Uploading value),
    @required TResult success(_UploadSuccess value),
    @required TResult failed(_UploadFailed value),
  }) {
    assert(initial != null);
    assert(picked != null);
    assert(uploading != null);
    assert(success != null);
    assert(failed != null);
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult initial(_UploadInitial value),
    TResult picked(_UploadPicked value),
    TResult uploading(_Uploading value),
    TResult success(_UploadSuccess value),
    TResult failed(_UploadFailed value),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (success != null) {
      return success(this);
    }
    return orElse();
  }
}

abstract class _UploadSuccess implements UploadState {
  const factory _UploadSuccess(FileModel file) = _$_UploadSuccess;

  FileModel get file;
  @JsonKey(ignore: true)
  _$UploadSuccessCopyWith<_UploadSuccess> get copyWith;
}

/// @nodoc
abstract class _$UploadFailedCopyWith<$Res> {
  factory _$UploadFailedCopyWith(
          _UploadFailed value, $Res Function(_UploadFailed) then) =
      __$UploadFailedCopyWithImpl<$Res>;
  $Res call({String msg});
}

/// @nodoc
class __$UploadFailedCopyWithImpl<$Res> extends _$UploadStateCopyWithImpl<$Res>
    implements _$UploadFailedCopyWith<$Res> {
  __$UploadFailedCopyWithImpl(
      _UploadFailed _value, $Res Function(_UploadFailed) _then)
      : super(_value, (v) => _then(v as _UploadFailed));

  @override
  _UploadFailed get _value => super._value as _UploadFailed;

  @override
  $Res call({
    Object msg = freezed,
  }) {
    return _then(_UploadFailed(
      msg == freezed ? _value.msg : msg as String,
    ));
  }
}

/// @nodoc
class _$_UploadFailed implements _UploadFailed {
  const _$_UploadFailed(this.msg) : assert(msg != null);

  @override
  final String msg;

  @override
  String toString() {
    return 'UploadState.failed(msg: $msg)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _UploadFailed &&
            (identical(other.msg, msg) ||
                const DeepCollectionEquality().equals(other.msg, msg)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ const DeepCollectionEquality().hash(msg);

  @JsonKey(ignore: true)
  @override
  _$UploadFailedCopyWith<_UploadFailed> get copyWith =>
      __$UploadFailedCopyWithImpl<_UploadFailed>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object>({
    @required TResult initial(),
    @required TResult picked(FileModel file),
    @required TResult uploading(double progress),
    @required TResult success(FileModel file),
    @required TResult failed(String msg),
  }) {
    assert(initial != null);
    assert(picked != null);
    assert(uploading != null);
    assert(success != null);
    assert(failed != null);
    return failed(msg);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object>({
    TResult initial(),
    TResult picked(FileModel file),
    TResult uploading(double progress),
    TResult success(FileModel file),
    TResult failed(String msg),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (failed != null) {
      return failed(msg);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object>({
    @required TResult initial(_UploadInitial value),
    @required TResult picked(_UploadPicked value),
    @required TResult uploading(_Uploading value),
    @required TResult success(_UploadSuccess value),
    @required TResult failed(_UploadFailed value),
  }) {
    assert(initial != null);
    assert(picked != null);
    assert(uploading != null);
    assert(success != null);
    assert(failed != null);
    return failed(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object>({
    TResult initial(_UploadInitial value),
    TResult picked(_UploadPicked value),
    TResult uploading(_Uploading value),
    TResult success(_UploadSuccess value),
    TResult failed(_UploadFailed value),
    @required TResult orElse(),
  }) {
    assert(orElse != null);
    if (failed != null) {
      return failed(this);
    }
    return orElse();
  }
}

abstract class _UploadFailed implements UploadState {
  const factory _UploadFailed(String msg) = _$_UploadFailed;

  String get msg;
  @JsonKey(ignore: true)
  _$UploadFailedCopyWith<_UploadFailed> get copyWith;
}
