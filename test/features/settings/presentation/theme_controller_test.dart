import 'package:ecommerce_app/features/settings/data/datasources/theme_local_data_source.dart';
import 'package:ecommerce_app/features/settings/presentation/controllers/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockThemeLocalDataSource extends Mock implements ThemeLocalDataSource {}

void main() {
  late ThemeController controller;
  late MockThemeLocalDataSource mockDataSource;

  setUpAll(() {
    registerFallbackValue(ThemeMode.light);
  });

  setUp(() {
    mockDataSource = MockThemeLocalDataSource();
    when(() => mockDataSource.getThemeMode()).thenReturn(ThemeMode.light);
    when(() => mockDataSource.cacheThemeMode(any())).thenAnswer((_) async {});

    controller = ThemeController(themeLocalDataSource: mockDataSource);
  });

  test('should initialize with cached theme mode', () {
    controller.onInit();
    expect(controller.themeMode, ThemeMode.light);
    expect(controller.isDarkMode, false);
    verify(() => mockDataSource.getThemeMode()).called(1);
  });

  test('toggleTheme(true) should switch to dark mode and cache', () async {
    controller.onInit();

    await controller.toggleTheme(true);

    expect(controller.themeMode, ThemeMode.dark);
    expect(controller.isDarkMode, true);
    verify(() => mockDataSource.cacheThemeMode(ThemeMode.dark)).called(1);
  });

  test('setThemeMode should update theme mode and cache', () async {
    controller.onInit();

    await controller.setThemeMode(ThemeMode.system);

    expect(controller.themeMode, ThemeMode.system);
    verify(() => mockDataSource.cacheThemeMode(ThemeMode.system)).called(1);
  });
}
