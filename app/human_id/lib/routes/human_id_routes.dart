// GENERATED CODE - DO NOT MODIFY MANUALLY
// **************************************************************************
// Auto generated by https://github.com/fluttercandies/ff_annotation_route
// **************************************************************************
// fast mode: true
// version: 10.0.6
// **************************************************************************
// ignore_for_file: prefer_const_literals_to_create_immutables,unused_local_variable,unused_import,unnecessary_import,unused_shown_name,implementation_imports,duplicate_import
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:live_detection_plugin/live_detection.dart';
import 'package:mlkit_scan_plugin/mlkit_scan_plugin.dart';

import '../ui/pages/scan.dart';

const List<String> routeNames = <String>[
  '/failed',
  '/guide',
  '/home',
  '/scan',
  '/scan/file',
  '/splash',
  '/verified',
  '/verifying',
];

class Routes {
  const Routes._();

  /// '/failed'
  ///
  /// [name] : '/failed'
  ///
  /// [constructors] :
  ///
  /// Failed : [String(required) scope, Key? key]
  static const _Failed failed = _Failed();

  /// '/guide'
  ///
  /// [name] : '/guide'
  ///
  /// [constructors] :
  ///
  /// Guide : [Key? key]
  static const _Guide guide = _Guide();

  /// '/home'
  ///
  /// [name] : '/home'
  ///
  /// [constructors] :
  ///
  /// Home : [Key? key]
  static const _Home home = _Home();

  /// '/scan'
  ///
  /// [name] : '/scan'
  ///
  /// [constructors] :
  ///
  /// QRScan : [Key? key, ScanManager(required) manager]
  static const _Scan scan = _Scan();

  /// '/scan/file'
  ///
  /// [name] : '/scan/file'
  ///
  /// [constructors] :
  ///
  /// AnalyzingQR : [Key? key, XFile(required) xFile, List<Barcode>(required) barcodes]
  static const _ScanFile scanFile = _ScanFile();

  /// '/splash'
  ///
  /// [name] : '/splash'
  ///
  /// [constructors] :
  ///
  /// Splash : [Key? key]
  static const _Splash splash = _Splash();

  /// '/verified'
  ///
  /// [name] : '/verified'
  ///
  /// [constructors] :
  ///
  /// Verified : [Key? key]
  static const _Verified verified = _Verified();

  /// '/verifying'
  ///
  /// [name] : '/verifying'
  ///
  /// [constructors] :
  ///
  /// Verifying : [Key? key, List<LiveAction>(required) actions, String(required) scope]
  static const _Verifying verifying = _Verifying();
}

class _Failed {
  const _Failed();

  String get name => '/failed';

  Map<String, dynamic> d(
    String scope, {
    Key? key,
  }) =>
      <String, dynamic>{
        'scope': scope,
        'key': key,
      };

  @override
  String toString() => name;
}

class _Guide {
  const _Guide();

  String get name => '/guide';

  Map<String, dynamic> d({
    Key? key,
  }) =>
      <String, dynamic>{
        'key': key,
      };

  @override
  String toString() => name;
}

class _Home {
  const _Home();

  String get name => '/home';

  Map<String, dynamic> d({
    Key? key,
  }) =>
      <String, dynamic>{
        'key': key,
      };

  @override
  String toString() => name;
}

class _Scan {
  const _Scan();

  String get name => '/scan';

  Map<String, dynamic> d({
    Key? key,
    required ScanManager manager,
  }) =>
      <String, dynamic>{
        'key': key,
        'manager': manager,
      };

  @override
  String toString() => name;
}

class _ScanFile {
  const _ScanFile();

  String get name => '/scan/file';

  Map<String, dynamic> d({
    Key? key,
    required XFile xFile,
    required List<Barcode> barcodes,
  }) =>
      <String, dynamic>{
        'key': key,
        'xFile': xFile,
        'barcodes': barcodes,
      };

  @override
  String toString() => name;
}

class _Splash {
  const _Splash();

  String get name => '/splash';

  Map<String, dynamic> d({
    Key? key,
  }) =>
      <String, dynamic>{
        'key': key,
      };

  @override
  String toString() => name;
}

class _Verified {
  const _Verified();

  String get name => '/verified';

  Map<String, dynamic> d({
    Key? key,
  }) =>
      <String, dynamic>{
        'key': key,
      };

  @override
  String toString() => name;
}

class _Verifying {
  const _Verifying();

  String get name => '/verifying';

  Map<String, dynamic> d({
    Key? key,
    required List<LiveAction> actions,
    required String scope,
  }) =>
      <String, dynamic>{
        'key': key,
        'actions': actions,
        'scope': scope,
      };

  @override
  String toString() => name;
}
