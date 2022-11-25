import 'dart:io';

import 'package:path_provider/path_provider.dart';

class CacheManager {
  const CacheManager._();

  static const int kb = 1024;
  static const int mb = 1024 * kb;
  static const int gb = 1024 * mb;

  static Future<Directory> getCacheDir() => getTemporaryDirectory();

  static Future<void> clearCache() async {
    final Directory dir = await getCacheDir();
    await Future.wait(
      <Future<void>>[
        for (final FileSystemEntity f in dir.listSync())
          f.delete(recursive: true),
      ],
    );
  }

  static Future<int> getCacheSize() async {
    final Directory dir = await getCacheDir();
    final List<FileSystemEntity> listSync = dir.listSync(recursive: true);
    int size = 0;
    for (final FileSystemEntity file in listSync) {
      size += file.statSync().size;
    }
    return size;
  }

  static Future<String> getFormatCacheSize() async {
    final int size = await getCacheSize();
    if (size >= gb) {
      return '${(size / gb).toStringAsFixed(2)} GB';
    }
    if (size >= mb) {
      return '${(size / mb).toStringAsFixed(2)} MB';
    }
    if (size >= kb) {
      return '${(size / kb).toStringAsFixed(2)} KB';
    }
    return '$size B';
  }
}
