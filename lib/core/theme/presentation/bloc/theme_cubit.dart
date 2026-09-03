import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.system) {
    _loadSavedTheme();
  }

  static const _prefsKey = 'isDarkMode';

  Future<void> _loadSavedTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final savedValue = prefs.getBool(_prefsKey);

    // null = user never toggled it — keep following system setting.
    if (savedValue == null) return;

    emit(savedValue ? ThemeMode.dark : ThemeMode.light);
  }

  Future<void> toggleTheme(bool isDarkMode) async {
    emit(isDarkMode ? ThemeMode.dark : ThemeMode.light);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefsKey, isDarkMode);
  }
}
