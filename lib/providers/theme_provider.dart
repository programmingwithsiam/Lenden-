import 'package:flutter/material.dart';
import '../core/constants/app_constants.dart';
import '../core/services/local_db_service.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;

  ThemeProvider() {
    _isDarkMode = LocalDbService.settingsBox.get(AppConstants.prefIsDarkMode, defaultValue: false);
  }

  bool get isDarkMode => _isDarkMode;
  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  Future<void> toggleDarkMode(bool value) async {
    _isDarkMode = value;
    await LocalDbService.settingsBox.put(AppConstants.prefIsDarkMode, value);
    notifyListeners();
  }
}
