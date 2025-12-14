import 'dart:convert';

import 'package:asisten_buku_kebun/data/model/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSharedPreferences {

  static const String userModelKey = 'user_model';

  // crud operations for shared preferences, to easily manage app preferences
  static Future<SharedPreferences> get _instance async =>
      await SharedPreferences.getInstance();

  static Future<UserModel?> getUserModel() async {
    final prefs = await _instance;
    try{
      debugPrint("getusermodel");
      final userModelJson = jsonDecode(prefs.getString(userModelKey).toString() ?? '');
      if (userModelJson != null) {
        UserModel model =  UserModel.fromJson(userModelJson as Map<String, dynamic>);
        // debugPrint("User Model Preferences : "+ model.toString());
        return model;
      }
      return null;
    }catch(e){
      debugPrint("Error getting user model: $e");
      return null;
    }

  }

  static Future<bool> setUserModel(UserModel userModel) async {
    final prefs = await _instance;
    return prefs.setString(userModelKey,  jsonEncode(userModel.toJson()));
  }

  static Future<bool> clearPreferences() async {
    final prefs = await _instance;
    return prefs.clear();
  }

  static Future<bool> removeKey(String key) async {
    final prefs = await _instance;
    return prefs.remove(key);
  }

  static Future<bool> containsKey(String key) async {
    final prefs = await _instance;
    return prefs.containsKey(key);
  }

  static Future<Map<String, dynamic>> getAllPreferences() async {
    final prefs = await _instance;
    return prefs.getKeys().fold<Map<String, dynamic>>({}, (map, key) {
      map[key] = prefs.get(key);
      return map;
    });
  }

  static Future<void> setAllPreferences(
      Map<String, dynamic> preferences) async {
    final prefs = await _instance;
    for (var entry in preferences.entries) {
      if (entry.value is String) {
        await prefs.setString(entry.key, entry.value as String);
      } else if (entry.value is bool) {
        await prefs.setBool(entry.key, entry.value as bool);
      } else if (entry.value is int) {
        await prefs.setInt(entry.key, entry.value as int);
      } else if (entry.value is double) {
        await prefs.setDouble(entry.key, entry.value as double);
      }
    }
  }
}
