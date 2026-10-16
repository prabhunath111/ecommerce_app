import 'package:shared_preferences/shared_preferences.dart';

/// OOP Contract for Local Storage / Persistence
abstract class StorageService {
  Future<void> init();
  Future<bool> setString(String key, String value);
  String? getString(String key);
  Future<bool> setBool(String key, bool value);
  bool? getBool(String key);
  Future<bool> setStringList(String key, List<String> value);
  List<String>? getStringList(String key);
  Future<bool> remove(String key);
  Future<bool> clear();
}

/// SharedPreferences concrete implementation of StorageService
class SharedPreferencesStorageService implements StorageService {
  final SharedPreferences _prefs;

  SharedPreferencesStorageService(this._prefs);

  @override
  Future<void> init() async {}

  @override
  Future<bool> setString(String key, String value) => _prefs.setString(key, value);

  @override
  String? getString(String key) => _prefs.getString(key);

  @override
  Future<bool> setBool(String key, bool value) => _prefs.setBool(key, value);

  @override
  bool? getBool(String key) => _prefs.getBool(key);

  @override
  Future<bool> setStringList(String key, List<String> value) =>
      _prefs.setStringList(key, value);

  @override
  List<String>? getStringList(String key) => _prefs.getStringList(key);

  @override
  Future<bool> remove(String key) => _prefs.remove(key);

  @override
  Future<bool> clear() => _prefs.clear();
}
