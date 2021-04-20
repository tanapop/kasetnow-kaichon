import 'dart:io';
import 'dart:typed_data';

import 'package:blurhash_dart/blurhash_dart.dart';
import 'package:guard/guard.dart';
import 'package:image/image.dart' as img;

class ImageUtils {
  static Uint8List readFile(String path) =>
      guard(() => File(path).readAsBytesSync());

  static img.Image decodeImage(String path) {
    final data = readFile(path);
    if (data == null) return null;
    return img.decodeImage(data);
  }

  static String blurHashEncodeImage(img.Image image) {
    if (image == null) return '';
    return BlurHash.encode(image).hash;
  }

  static String blurHashEncodePath(String path) =>
      blurHashEncodeImage(decodeImage(path));
}
