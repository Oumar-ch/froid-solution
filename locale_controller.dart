import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Contrôleur global pour la langue de l'application avec persistance.
class LocaleController {
  static final ValueNotifier<Locale> locale = ValueNotifier(const Locale('fr'));

  static const String _key = 'selected_locale';

  /// Initialise la langue depuis le stockage persistant.
  static Future<void> loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_key);
    if (code != null) {
      locale.value = Locale(code);
    }
  }

  /// Sauvegarde la langue sélectionnée.
  static Future<void> saveLocale(Locale localeToSave) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, localeToSave.languageCode);
  }

  /// Change la langue et la sauvegarde.
  static void setLocale(Locale newLocale) {
    locale.value = newLocale;
    saveLocale(newLocale);
  }
}
