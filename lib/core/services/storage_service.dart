import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// OOP Contract for Local Storage / Persistence
abstract class StorageService {
  /// Must be called once at startup to warm up the in-memory cache.
  Future<void> init();

  Future<bool> setString(String key, String value);

  /// Sync read from in-memory cache. Returns null if the key doesn't exist.
  String? getString(String key);

  Future<bool> setBool(String key, bool value);

  /// Sync read from in-memory cache.
  bool? getBool(String key);

  Future<bool> setStringList(String key, List<String> value);

  /// Sync read from in-memory cache.
  List<String>? getStringList(String key);

  Future<bool> remove(String key);
  Future<bool> clear();
}

/// flutter_secure_storage implementation of [StorageService].
///
/// All values are stored encrypted on-device (Keychain on iOS/macOS,
/// Keystore on Android, libsecret on Linux, Credential Locker on Windows).
/// An in-memory cache mirrors every value after [init] is called so that
/// synchronous getters remain fast without blocking the UI thread.
class FlutterSecureStorageService implements StorageService {
  final FlutterSecureStorage _storage;

  /// In-memory mirror of the secure store, populated on [init].
  final Map<String, String> _cache = {};

  FlutterSecureStorageService({FlutterSecureStorage? storage})
      : _storage = storage ??
            const FlutterSecureStorage(
              // v11+: AndroidOptions uses Android Keystore + AES/GCM by default.
              aOptions: AndroidOptions(),
              iOptions: IOSOptions(
                accessibility: KeychainAccessibility.first_unlock,
              ),
            );

  // ─────────────────────────────────────────────────────────
  // Lifecycle
  // ─────────────────────────────────────────────────────────

  @override
  Future<void> init() async {
    final allValues = await _storage.readAll();
    _cache
      ..clear()
      ..addAll(allValues);
  }

  // ─────────────────────────────────────────────────────────
  // String
  // ─────────────────────────────────────────────────────────

  @override
  Future<bool> setString(String key, String value) async {
    await _storage.write(key: key, value: value);
    _cache[key] = value;
    return true;
  }

  @override
  String? getString(String key) => _cache[key];

  // ─────────────────────────────────────────────────────────
  // Bool  (stored as "true" / "false" strings)
  // ─────────────────────────────────────────────────────────

  @override
  Future<bool> setBool(String key, bool value) async {
    final encoded = value.toString(); // "true" or "false"
    await _storage.write(key: key, value: encoded);
    _cache[key] = encoded;
    return true;
  }

  @override
  bool? getBool(String key) {
    final raw = _cache[key];
    if (raw == null) return null;
    return raw == 'true';
  }

  // ─────────────────────────────────────────────────────────
  // StringList  (stored as JSON array)
  // ─────────────────────────────────────────────────────────

  @override
  Future<bool> setStringList(String key, List<String> value) async {
    final encoded = jsonEncode(value);
    await _storage.write(key: key, value: encoded);
    _cache[key] = encoded;
    return true;
  }

  @override
  List<String>? getStringList(String key) {
    final raw = _cache[key];
    if (raw == null) return null;
    try {
      final decoded = jsonDecode(raw) as List;
      return decoded.cast<String>();
    } catch (_) {
      return null;
    }
  }

  // ─────────────────────────────────────────────────────────
  // Remove / Clear
  // ─────────────────────────────────────────────────────────

  @override
  Future<bool> remove(String key) async {
    await _storage.delete(key: key);
    _cache.remove(key);
    return true;
  }

  @override
  Future<bool> clear() async {
    await _storage.deleteAll();
    _cache.clear();
    return true;
  }
}
