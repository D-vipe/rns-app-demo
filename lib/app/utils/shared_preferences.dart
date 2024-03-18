import 'package:shared_preferences/shared_preferences.dart';

enum PreferenceKey {
  bearerToken,
}

class SharedStorageService {
  static late final SharedPreferences _prefs;

  static Future<SharedPreferences> init() async {
    _prefs = await SharedPreferences.getInstance();
    return _prefs;
  }

  static Future<bool> setString(PreferenceKey key, String value) async {
    return await _prefs.setString(key.toString(), value);
  }

  static Future<bool> setInt(PreferenceKey key, int value) async {
    return await _prefs.setInt(key.toString(), value);
  }

  static Future<bool> setBool(PreferenceKey key, bool value) async {
    return await _prefs.setBool(key.toString(), value);
  }

  static String getString(PreferenceKey key, [String defValue = '']) {
    return _prefs.getString(key.toString()) ?? defValue;
  }

  static int? getInt(PreferenceKey key) {
    return _prefs.getInt(key.toString());
  }

  static bool? getBool(PreferenceKey key) {
    return _prefs.getBool(key.toString());
  }

  static Future<bool> clear() async {
    return await _prefs.clear();
  }

  static Future<bool> remove(PreferenceKey key) async {
    return await _prefs.remove(key.toString());
  }
}
