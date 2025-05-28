import 'package:flutter/material.dart';

class LocalizationProvider with ChangeNotifier {
  Locale _locale = Locale('en', '');

  Locale get locale => _locale;

  void toggleLanguage() {
    if (_locale.languageCode == 'en') {
      _locale = Locale('ur', '');
    } else {
      _locale = Locale('en', '');
    }
    notifyListeners();
  }

  void setLocale(Locale locale) {
    _locale = locale;
    notifyListeners();
  }
}
