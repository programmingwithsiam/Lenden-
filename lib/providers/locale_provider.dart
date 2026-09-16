import 'package:flutter/material.dart';
import '../core/constants/app_constants.dart';
import '../core/services/local_db_service.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('bn');

  LocaleProvider() {
    final savedLanguage = LocalDbService.settingsBox.get(
      AppConstants.prefLanguage,
      defaultValue: 'bn',
    );

    _locale = Locale(savedLanguage == 'en' ? 'en' : 'bn');
  }

  Locale get locale => _locale;

  bool get isBangla => _locale.languageCode == 'bn';

  Future<void> setLanguage(String languageCode) async {
    final code = languageCode == 'en' ? 'en' : 'bn';

    _locale = Locale(code);

    await LocalDbService.settingsBox.put(
      AppConstants.prefLanguage,
      code,
    );

    notifyListeners();
  }
}
