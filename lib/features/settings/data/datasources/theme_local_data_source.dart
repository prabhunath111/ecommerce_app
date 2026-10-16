import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/storage_service.dart';

abstract class ThemeLocalDataSource {
  ThemeMode getThemeMode();
  Future<void> cacheThemeMode(ThemeMode mode);
}

class ThemeLocalDataSourceImpl implements ThemeLocalDataSource {
  final StorageService storageService;

  ThemeLocalDataSourceImpl({required this.storageService});

  @override
  ThemeMode getThemeMode() {
    final cached = storageService.getString(AppConstants.themeKey);
    if (cached == 'dark') return ThemeMode.dark;
    if (cached == 'light') return ThemeMode.light;
    return ThemeMode.system;
  }

  @override
  Future<void> cacheThemeMode(ThemeMode mode) async {
    String value = 'system';
    if (mode == ThemeMode.dark) value = 'dark';
    if (mode == ThemeMode.light) value = 'light';
    await storageService.setString(AppConstants.themeKey, value);
  }
}
