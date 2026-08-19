import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Persists the language-toggle choice from the Profile screens
/// (project_spec.md §10.2 Profile "language toggle"; §11: "English
/// populated now, Urdu addable later without code changes"). `null` means
/// "follow the system locale" — `MaterialApp.router(locale: null)`'s
/// default — and is only overridden once a student/teacher explicitly picks
/// a language.
///
/// Hand-written `Notifier` + manually declared provider per CLAUDE.md §2
/// (no `riverpod_generator` in this project).
class LocaleController extends Notifier<Locale?> {
  static const _localeKey = 'app_locale_code';

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  @override
  Locale? build() {
    _restore();
    return null;
  }

  Future<void> _restore() async {
    final code = await _storage.read(key: _localeKey);
    if (code != null) {
      state = Locale(code);
    }
  }

  /// Sets the active locale (persisted) or `null` to follow the system
  /// locale again.
  Future<void> setLocale(Locale? locale) async {
    state = locale;
    if (locale == null) {
      await _storage.delete(key: _localeKey);
    } else {
      await _storage.write(key: _localeKey, value: locale.languageCode);
    }
  }
}

final localeProvider = NotifierProvider<LocaleController, Locale?>(
  LocaleController.new,
);
