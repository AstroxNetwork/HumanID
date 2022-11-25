import 'dart:async';
import 'dart:collection';
import 'dart:math' as math;

import 'package:flutter/services.dart';
import 'package:human_id/exports.dart';
import 'package:permission_handler/permission_handler.dart';

//region BuildContext extensions
const lightSystemUiOverlayStyle = SystemUiOverlayStyle(
  systemNavigationBarColor: Colors.transparent,
  systemNavigationBarDividerColor: Colors.transparent,
  statusBarColor: Colors.transparent,
  systemNavigationBarIconBrightness: Brightness.light,
  statusBarIconBrightness: Brightness.light,
  statusBarBrightness: Brightness.dark,
);

const darkSystemUiOverlayStyle = SystemUiOverlayStyle(
  systemNavigationBarColor: Colors.transparent,
  systemNavigationBarDividerColor: Colors.transparent,
  statusBarColor: Colors.transparent,
  systemNavigationBarIconBrightness: Brightness.dark,
  statusBarIconBrightness: Brightness.dark,
  statusBarBrightness: Brightness.light,
);

extension BuildContextExtension on BuildContext {
  SystemUiOverlayStyle get fitSystemUiOverlayStyle {
    final isDark = Theme.of(this).brightness == Brightness.dark;
    return isDark ? lightSystemUiOverlayStyle : darkSystemUiOverlayStyle;
  }

  ThemeData get theme => Theme.of(this);

  HumanIDLocalizations get l10n => HumanIDLocalizations.of(this)!;

  void rebuildAll() {
    void rebuild(Element el) {
      el.markNeedsBuild();
      el.visitChildren(rebuild);
    }

    (this as Element).visitChildren(rebuild);
  }
}

extension ThemeDataExtension on ThemeData {
  bool get isDark => brightness == Brightness.dark;
}
//endregion

//region Permission
extension PermissionsExtensions on List<Permission> {
  Future<bool> isGranted() async {
    try {
      final status = await request();
      return status.values.every((PermissionStatus p) => p.isGranted);
    } catch (e, s) {
      e.error(stackTrace: s);
      return false;
    }
  }
}
//endregion

//region Color extensions
/// https://stackoverflow.com/a/50081214/10064463
extension HexColorExtension on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}

extension BrightnessColorExtension on Color {
  static Color lightRandom() {
    return HSLColor.fromAHSL(
      1,
      math.Random().nextDouble() * 360,
      0.5,
      0.75,
    ).toColor();
  }

  Color darken([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }

  Color lighten([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final hslLight =
        hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));
    return hslLight.toColor();
  }
}

extension ColorExtension on Color {
  bool get isDark {
    return computeLuminance() < 0.5;
  }
}
//endregion

//region State extensions
extension StateExtension on State {
  /// Future's [cb] is not allowed.
  void safeSetState(VoidCallback cb) {
    if (mounted) {
      // ignore: invalid_use_of_protected_member
      setState(cb);
    }
  }
}
//endregion

//region Collections extensions
extension IterableExtension<T> on Iterable<T>? {
  bool get isNullOrEmpty => this == null || this!.isEmpty;

  bool get isNotEmpty => !isNullOrEmpty;

  T? getOrNull(final int index) {
    if (isNullOrEmpty) return null;
    return this!.elementAt(index);
  }
}

extension ListExtension<T> on List<T>? {
  bool get isNullOrEmpty => this == null || this!.isEmpty;

  bool get isNotEmpty => !isNullOrEmpty;

  T? getOrNull(final int index) {
    if (isNullOrEmpty) return null;
    return this![index];
  }
}

extension MapExtension<K, V> on Map<K, V>? {
  bool get isNullOrEmpty => this == null || this!.isEmpty;

  bool get isNotEmpty => !isNullOrEmpty;
}
//endregion

//region Primitive type extension
extension BoolExtension on bool {
  bool get inv => !this;
}

extension NullableStringExtension on String? {
  bool get isNullOrBlank => this == null || this!.isBlank;

  bool get isNullOrEmpty => this == null || this!.isEmpty;

  bool get isNotBlank => this != null && !this!.isBlank;
}

extension StringExtension on String {
  bool get isBlank {
    if (length == 0) {
      return true;
    }
    for (int value in runes) {
      if (!_isWhitespace(value)) {
        return false;
      }
    }
    return true;
  }

  bool _isWhitespace(int rune) =>
      (rune >= 0x0009 && rune <= 0x000D) ||
      rune == 0x0020 ||
      rune == 0x0085 ||
      rune == 0x00A0 ||
      rune == 0x1680 ||
      rune == 0x180E ||
      (rune >= 0x2000 && rune <= 0x200A) ||
      rune == 0x2028 ||
      rune == 0x2029 ||
      rune == 0x202F ||
      rune == 0x205F ||
      rune == 0x3000 ||
      rune == 0xFEFF;

  String fillChar(String value, String char) {
    int offset = value.length - length;
    String newVal = this;
    if (offset > 0) {
      for (int i = 0; i < offset; i++) {
        newVal = char + newVal;
      }
    }
    return newVal;
  }
}
//endregion

//region Locale Extensions
extension LocaleExtension on Locale {
  static final Map<String, String> locale2lang = <String, String>{
    'en': 'English',
    'zh': '简体中文',
    'ja': '日本語',
  };

  String get languageName {
    return locale2lang[languageCode]!;
  }
}
//endregion

//region Future
extension IterableFuture<T> on Iterable<Future<T>> {
  Future<List<AsyncSnapshot<T>>> allSettled({
    int parallel = 0,
    void Function(int index, T value)? onSuccess,
    void Function(int index, Object error, StackTrace stackTrace)? onError,
    void Function(int index, AsyncSnapshot<T> snapshot)? onComplete,
  }) {
    final len = length;
    if (len == 0) {
      return Future.value(<AsyncSnapshot<T>>[]);
    }
    final completer = Completer<List<AsyncSnapshot<T>>>();
    int remaining = len;
    final list = List<AsyncSnapshot<T>?>.filled(len, null);
    if (parallel <= 0) {
      void handleFuture(int index, Future<T> future) {
        future.then((value) {
          final snapshot = AsyncSnapshot.withData(ConnectionState.done, value);
          list[index] = snapshot;
          onSuccess?.call(index, value);
          onComplete?.call(index, snapshot);
        }).catchError((e, s) {
          final snapshot =
              AsyncSnapshot<T>.withError(ConnectionState.done, e, s);
          list[index] = snapshot;
          onError?.call(index, e, s);
          onComplete?.call(index, snapshot);
        }).whenComplete(() {
          if (--remaining == 0) {
            completer.complete(List.unmodifiable(list.cast()));
          }
        });
      }

      for (int i = 0; i < len; i++) {
        handleFuture(i, elementAt(i));
      }
    } else {
      int running = 0;
      int index = 0;
      final queue = Queue<Future<T>>.from(this);
      void exec() {
        void handleFuture(int index, Future<T> future) {
          future.then((value) {
            final snapshot =
                AsyncSnapshot.withData(ConnectionState.done, value);
            list[index] = snapshot;
            onSuccess?.call(index, value);
            onComplete?.call(index, snapshot);
          }).catchError((e, s) {
            final snapshot =
                AsyncSnapshot<T>.withError(ConnectionState.done, e, s);
            list[index] = snapshot;
            onError?.call(index, e, s);
            onComplete?.call(index, snapshot);
          }).whenComplete(() {
            if (--remaining == 0) {
              completer.complete(List.unmodifiable(list.cast()));
            }
            running--;
            exec();
          });
        }

        while (queue.isNotEmpty && running < parallel) {
          running++;
          final future = queue.removeFirst();
          handleFuture(index++, future);
        }
      }

      exec();
    }
    return completer.future;
  }
}

extension IterableAsyncSnapshot<T> on Iterable<AsyncSnapshot<T>> {
  bool get hasError => any((e) => e.hasError);
}

class Mutex {
  Completer<void>? _completer;

  Future<void> lock() async {
    while (_completer != null) {
      await _completer!.future;
    }
    _completer = Completer<void>();
  }

  /// Notice: [unlock] must be called after the [lock] method is called
  /// to prevent any deadlocks.
  /// ```dart
  /// final mutex = Mutex();
  /// // ...
  /// Future<void> doSth() async {
  ///   try {
  ///     await mutex.lock();
  ///     // do something...
  ///   } finally {
  ///     mutex.unlock();
  ///   }
  /// }
  /// ```
  void unlock() {
    final completer = _completer;
    _completer = null;
    completer?.complete();
  }

  Future<T> withLock<T>(FutureOr<T> Function() block) async {
    try {
      await lock();
      return await block();
    } finally {
      unlock();
    }
  }
}

extension NeverCatchExtension<T> on Future<T> {
  Future<NeverCatch<T>> noc() => noCatch(this);
}

Future<NeverCatch<T>> noCatch<T>(Future<T> future) {
  return future.then<NeverCatch<T>>((T value) {
    return NeverCatch.val(value);
  }).catchError((error, stackTrace) {
    return NeverCatch.cat<T>(error, stackTrace);
  });
}

class NeverCatch<T> {
  NeverCatch._({this.value, this.error, this.stackTrace});

  static NeverCatch<T> val<T>(T value) {
    return NeverCatch._(value: value);
  }

  static NeverCatch<T> cat<T>(Object? error, [StackTrace? stackTrace]) {
    return NeverCatch._(error: error, stackTrace: stackTrace);
  }

  final T? value;
  final Object? error;
  final StackTrace? stackTrace;

  bool get hasErr => error != null;

  @override
  String toString() {
    return 'NeverCatch(value: $value, error: $error, stackTrace: $stackTrace)';
  }
}
//endregion
