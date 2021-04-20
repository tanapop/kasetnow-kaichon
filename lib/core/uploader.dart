import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:equatable/equatable.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as p;

import '../components/picker.dart';
import '../imports.dart';
import 'models/upload.dart';

class AppUploader with EquatableMixin {
  static final uploaders = <AppUploader>[];
  static AppUploader find(String path) => uploaders.firstWhere(
        (e) => e.picked?.path == path,
        orElse: () => null,
      );

  FileModel picked;
  FileModel uploaded;
  String path([String or]) => state.maybeWhen(
        orElse: () => picked?.path ?? or ?? '',
      );

  final _state = UploadState.initial().obs;
  UploadState get state => _state();

  bool get isPicked => state.maybeMap(orElse: () => picked != null);
  bool get isUploading =>
      state.maybeMap(uploading: (_) => true, orElse: () => false);

  Future<void> pick(BuildContext context, [bool showVideoPicker]) async {
    picked = await pickFile(context, showVideoPicker);
    if (picked == null) return;
    _state(UploadState.picked(picked));
    if (find(picked.path) != null) return;
    uploaders.add(this);
  }

  Future<void> upload(
    Reference ref, {
    String filename,
    ValueChanged<FileModel> onSuccess,
    ValueChanged<String> onFailed,
  }) async {
    try {
      if (!isPicked) throw Exception('No File Picked');
      final url = await uploadFile(
        path(),
        ref,
        (v) => _state(UploadState.uploading(v)),
        filename,
      );

      uploaded = await picked.when(
        image: (v) async {
          final img = await ImageModel.create(v.path);
          return img.copyWith(path: url);
        },
      );
      if (uploaded != null) {
        _state(UploadState.success(uploaded));
        onSuccess?.call(uploaded);
        clear();
      }
    } catch (e, s) {
      logError(e, '', s);
      _state(UploadState.failed('$e'));
      onFailed?.call('$e');
    }
  }

  static Future<String> uploadFile(
    String path,
    Reference ref,
    ValueChanged<double> onProgress, [
    String filename,
  ]) async {
    final file = File(path);
    if (!file.existsSync()) {
      throw Exception(t.CannotFindFile);
    }

    final basename =
        '${authProvider.user?.username ?? ''}-${filename ?? ''}-${DateTime.now().millisecondsSinceEpoch}${p.extension(path)}';
    final snap = ref.child(basename).putFile(file).snapshotEvents;
    await for (final e in snap) {
      onProgress((e.bytesTransferred / e.totalBytes).toPrecision(2));
      if (e.state == TaskState.success) {
        return e.ref.getDownloadURL();
      }
    }

    throw Exception('Oops, something went wrong');
  }

  void reset() {
    _state(UploadState.initial());
    clear();
  }

  void clear() {
    AppUploader.uploaders.remove(this);
    picked = null;
  }

  void setAsUploaded(FileModel file) {
    if (file == null) return;
    uploaded = file;
    _state(UploadState.success(file));
  }

  void setAsPicked(FileModel file) {
    if (file == null) return;
    picked = file;
    _state(UploadState.picked(file));
    if (find(picked.path) != null) return;
    uploaders.add(this);
  }

  @override
  List<Object> get props => [path];
  @override
  bool get stringify => true;
}
