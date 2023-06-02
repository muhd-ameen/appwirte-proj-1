import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  static late SharedPreferences prefs;

  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  static Future<bool> setSessionId(String value) async {
    return prefs.setString('session', value);
  }

  static void removeSessionId() {
    prefs.remove('session');
  }

  static String getSessionId() {
    return prefs.getString('session') ?? '';
  }
}
