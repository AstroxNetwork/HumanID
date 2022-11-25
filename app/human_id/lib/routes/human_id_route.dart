// GENERATED CODE - DO NOT MODIFY MANUALLY
// **************************************************************************
// Auto generated by https://github.com/fluttercandies/ff_annotation_route
// **************************************************************************
// fast mode: true
// version: 10.0.6
// **************************************************************************
// ignore_for_file: prefer_const_literals_to_create_immutables,unused_local_variable,unused_import,unnecessary_import,unused_shown_name,implementation_imports,duplicate_import
import 'package:ff_annotation_route_library/ff_annotation_route_library.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:live_detection_plugin/live_detection.dart';
import 'package:mlkit_scan_plugin/mlkit_scan_plugin.dart';

import '../ui/pages/failed.dart';
import '../ui/pages/guide.dart';
import '../ui/pages/home.dart';
import '../ui/pages/index.dart';
import '../ui/pages/scan.dart';
import '../ui/pages/verified.dart';
import '../ui/pages/verifying.dart';

FFRouteSettings getRouteSettings({
  required String name,
  Map<String, dynamic>? arguments,
  PageBuilder? notFoundPageBuilder,
}) {
  final Map<String, dynamic> safeArguments =
      arguments ?? const <String, dynamic>{};
  switch (name) {
    case '/failed':
      return FFRouteSettings(
        name: name,
        arguments: arguments,
        builder: () => Failed(
          asT<String>(
            safeArguments['scope'],
          )!,
          key: asT<Key?>(
            safeArguments['key'],
          ),
        ),
      );
    case '/guide':
      return FFRouteSettings(
        name: name,
        arguments: arguments,
        builder: () => Guide(
          key: asT<Key?>(
            safeArguments['key'],
          ),
        ),
      );
    case '/home':
      return FFRouteSettings(
        name: name,
        arguments: arguments,
        builder: () => Home(
          key: asT<Key?>(
            safeArguments['key'],
          ),
        ),
      );
    case '/scan':
      return FFRouteSettings(
        name: name,
        arguments: arguments,
        builder: () => QRScan(
          key: asT<Key?>(
            safeArguments['key'],
          ),
          manager: asT<ScanManager>(
            safeArguments['manager'],
          )!,
        ),
      );
    case '/scan/file':
      return FFRouteSettings(
        name: name,
        arguments: arguments,
        builder: () => AnalyzingQR(
          key: asT<Key?>(
            safeArguments['key'],
          ),
          xFile: asT<XFile>(
            safeArguments['xFile'],
          )!,
          barcodes: asT<List<Barcode>>(
            safeArguments['barcodes'],
          )!,
        ),
      );
    case '/splash':
      return FFRouteSettings(
        name: name,
        arguments: arguments,
        builder: () => Splash(
          key: asT<Key?>(
            safeArguments['key'],
          ),
        ),
      );
    case '/verified':
      return FFRouteSettings(
        name: name,
        arguments: arguments,
        builder: () => Verified(
          key: asT<Key?>(
            safeArguments['key'],
          ),
        ),
      );
    case '/verifying':
      return FFRouteSettings(
        name: name,
        arguments: arguments,
        builder: () => Verifying(
          key: asT<Key?>(
            safeArguments['key'],
          ),
          actions: asT<List<LiveAction>>(
            safeArguments['actions'],
          )!,
          scope: asT<String>(
            safeArguments['scope'],
          )!,
        ),
      );
    default:
      return FFRouteSettings(
        name: FFRoute.notFoundName,
        routeName: FFRoute.notFoundRouteName,
        builder: notFoundPageBuilder ?? () => Container(),
      );
  }
}