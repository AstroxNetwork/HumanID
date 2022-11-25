import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:human_id/internals/hives.dart';
import 'package:human_id/ui/pages/index.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initDependencies();
  runApp(const ProviderScope(child: HumanID()));
}

Future<void> _initDependencies() async {
  await Hives.init();
  if (Platform.isAndroid) {
    FlutterDisplayMode.setHighRefreshRate().catchError((e, s) {
      e.error(stackTrace: s);
    });
  }
}
