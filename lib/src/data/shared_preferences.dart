import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart' as shared;

@Singleton()
class SharedPreferences {
  SharedPreferences() {
    _init();
  }

  static const String tokenKey = "tokenKey";

  late final shared.SharedPreferences prefs;

  Future<void> _init() async {
    prefs = await shared.SharedPreferences.getInstance();
  }

  String? getToken() => prefs.getString(tokenKey);

  void saveToken(String token) => prefs.setString(tokenKey, token);

  void removeToken() => prefs.remove(tokenKey);
}
