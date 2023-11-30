import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SecureStorage {
  static FlutterSecureStorage _storage = const FlutterSecureStorage();
  static SharedPreferences? _prefs;

  Map<String, String> _allValues = {};

  static Future<SecureStorage> getInstance() async {
    WidgetsFlutterBinding.ensureInitialized();
    _prefs ??= await SharedPreferences.getInstance();
    SecureStorage secureStorage = SecureStorage();
    return await secureStorage._getInstance();
  }

  Future<SecureStorage> _getInstance() async {
    _allValues = await _storage.readAll();
    return this;
  }

  bool? getBool(String key) {
    return _prefs!.getBool(key);
  }

  Future<bool> setBool(String key, bool value) async {
    return _prefs!.setBool(key, value);
  }

  String? getString(String key) {
    return _allValues[key];
  }

  Future<bool> setString(String key, String value) async {
    return _initStorageAction("WRITE", key: key, value: value);
  }

  Future<bool> remove(String key) async {
    return _initStorageAction("DELETE", key: key);
  }

  Future<bool> reload(String key) async {
    return _initStorageAction("RELOAD");
  }

  Future<bool> clearMemory() async {
    return _initStorageAction("DELETE_ALL");
  }

  Future<bool> _initStorageAction(String method,
      {String? key, String? value}) async {
    bool isSuccessful = true;
    switch (method.toUpperCase()) {
      case 'WRITE':
        await _storage.write(key: key ?? "_", value: value);
        break;
      case 'DELETE':
        await _prefs!.remove(key ?? "_");
        await _storage.delete(key: key ?? "_");
        break;
      case 'DELETE_ALL':
        await _storage.deleteAll();
        isSuccessful = await _prefs!.clear();
        break;
      default:
        if (method.toUpperCase() != 'RELOAD') isSuccessful = false;
        break;
    }
    await _getInstance();
    return isSuccessful;
  }
}
