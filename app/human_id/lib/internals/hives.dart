import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:human_id/l10n/localizations.dart';

class Hives {
  const Hives._();

  static Future<HiveCipher> _getHiveCipher() async {
    const storage = FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
    );
    const storeKey = 'hive-secure-key';
    String? key = await storage.read(key: storeKey);
    if (key == null) {
      key = base64Url.encode(Hive.generateSecureKey());
      await storage.write(key: storeKey, value: key);
    }
    return HiveAesCipher(base64Url.decode(key));
  }

  static const _settingsKey = 'core-settings';

  static late StateNotifierProvider<SettingsNotifier, Settings>
      settingsProvider;

  static Future<void> init() async {
    final cipher = await _getHiveCipher();
    final appDir = await getApplicationDocumentsDirectory();
    final collection = await BoxCollection.open(
      'humanid-core',
      {
        _settingsKey,
      },
      path: path.join(appDir.path, "hive-in-humanid"),
      key: cipher,
    );
    final settingsBox = await collection.openBox<String>(_settingsKey);
    final settings = await Settings._new(settingsBox);
    settingsProvider = StateNotifierProvider<SettingsNotifier, Settings>((ref) {
      return SettingsNotifier(settings);
    });
  }
}

class Settings {
  Settings._(
    this._box,
    this._themeMode,
    this._locale,
    this._showGuide,
  );

  static Future<Settings> _new(CollectionBox<String> box) async {
    final mode = await box.get("theme-mode");
    final themeMode =
        ThemeMode.values.firstWhereOrNull((e) => e.name == mode) ??
            ThemeMode.system;

    String? lang = await box.get("lang");
    final Locale locale;
    if (lang == null) {
      final currentLang = Intl.shortLocale(Platform.localeName);
      locale = HumanIDLocalizations.supportedLocales.firstWhereOrNull(
            (Locale e) => e.languageCode == currentLang,
          ) ??
          HumanIDLocalizations.supportedLocales.first;
    } else {
      locale = Locale(lang);
    }
    String? showGuide = await box.get("show-guide");
    return Settings._(
      box,
      themeMode,
      locale,
      showGuide == null,
    );
  }

  final CollectionBox<String> _box;
  ThemeMode _themeMode;
  Locale _locale;
  bool _showGuide;

  ThemeMode get themeMode => _themeMode;

  set themeMode(ThemeMode mode) {
    _themeMode = mode;
    _box.put("theme-mode", mode.name);
  }

  Locale get locale => _locale;

  set locale(Locale locale) {
    _locale = locale;
    _box.put("lang", locale.languageCode);
  }

  bool get showGuide => _showGuide;

  set showGuide(bool value) {
    _showGuide = value;
    _box.put("show-guide", value.toString());
  }
}

class SettingsNotifier extends StateNotifier<Settings> {
  SettingsNotifier(super.state);

  set locale(Locale locale) {
    if (locale == state.locale) {
      return;
    }
    state = state..locale = locale;
  }

  set themeMode(ThemeMode mode) {
    if (mode == state.themeMode) {
      return;
    }
    state = state..themeMode = mode;
  }

  set showGuide(bool value) {
    state = state..showGuide = value;
  }

  @override
  bool updateShouldNotify(Settings old, Settings current) {
    return true;
  }

  Locale get locale => state.locale;

  ThemeMode get themeMode => state.themeMode;

  bool get showGuide => state.showGuide;
}
