import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/get_builder_ids.dart';
import '../../data/datasources/theme_local_data_source.dart';

class ThemeController extends GetxController {
  final ThemeLocalDataSource themeLocalDataSource;

  ThemeController({required this.themeLocalDataSource});

  late ThemeMode _themeMode;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  @override
  void onInit() {
    super.onInit();
    _themeMode = themeLocalDataSource.getThemeMode();
  }

  Future<void> toggleTheme(bool isDark) async {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    await themeLocalDataSource.cacheThemeMode(_themeMode);
    // Explicitly update only widgets listening to appTheme and settingsToggles
    update([GetBuilderIds.appTheme, GetBuilderIds.settingsToggles]);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await themeLocalDataSource.cacheThemeMode(_themeMode);
    update([GetBuilderIds.appTheme, GetBuilderIds.settingsToggles]);
  }
}
