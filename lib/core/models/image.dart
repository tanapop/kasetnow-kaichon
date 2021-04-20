import 'package:flutter/foundation.dart';

import 'package:equatable/equatable.dart';
import 'package:guard/guard.dart';

import '../blurhash.dart';
import 'file.dart';

class ImageModel extends FileModel with EquatableMixin {
  final String blurhash;
  final double height;
  final double width;
  const ImageModel(
    String path, {
    this.blurhash,
    this.height = 300,
    this.width = 300,
    int size,
  }) : super(
          path: path,
          size: size,
        );

  @override
  bool get isImage => true;

  bool get hasBlurHash => blurhash?.isNotEmpty == true;

  double get ratio => width / height;

  static Future<ImageModel> create(String path) async {
    final image = await asyncGuard(
      () => compute(ImageUtils.decodeImage, path),
    );
    final blurhash = await asyncGuard(
      () => compute(ImageUtils.blurHashEncodeImage, image),
    );
    return ImageModel(
      path,
      blurhash: blurhash ?? '',
      height: image.height.toDouble(),
      width: image.width.toDouble(),
      size: (image.length / 1024 / 1024).floor(),
    );
  }

  factory ImageModel.fromMap(Map<String, dynamic> map) {
    if (map?.isNotEmpty != true) return null;
    return ImageModel(
      map['path'] as String ?? '',
      blurhash: map['blurhash'] as String ?? '',
      height: map['height'] as double ?? 0.0,
      width: map['width'] as double ?? 0.0,
      size: map['size']?.toInt() as int ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'path': path,
      'blurhash': blurhash,
      'height': height,
      'width': width,
      'size': size,
    };
  }

  @override
  bool get stringify => true;
  @override
  List<Object> get props {
    return [
      path,
      blurhash,
      height,
      width,
      size,
    ];
  }

  ImageModel copyWith({
    String path,
    String blurhash,
    double height,
    double width,
    int size,
  }) {
    return ImageModel(
      path ?? this.path,
      blurhash: blurhash ?? this.blurhash,
      height: height ?? this.height,
      width: width ?? this.width,
      size: size ?? this.size,
    );
  }
}
