import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sun_position/model/path_step.dart';

class SharedPreferencesHelper {
  SharedPreferencesHelper._();

  static final instance = SharedPreferencesHelper._();

  void save(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is List) {
      prefs.setString(key, value.map((e) => e.toJson()).toList().toString());
    } else {
      prefs.setString(key, value.toJson());
    }
  }

  dynamic read(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return json.decode(prefs.getString(key));
  }

  dynamic loadPathSteps(String currentChar) async {
    final List<dynamic> jsonList = await read(currentChar);
    return jsonList.map((e) => PathStep.fromJson(e)).toList();
  }
}
