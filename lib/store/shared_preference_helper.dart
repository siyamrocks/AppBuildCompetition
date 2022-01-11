import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper {
  Future<SharedPreferences> _sharedPreference;

  SharedPreferenceHelper() {
    _sharedPreference = SharedPreferences.getInstance();
  }

  // Password
  Future<void> setPassword(String value) {
    return _sharedPreference.then((prefs) {
      return prefs.setString("password", value);
    });
  }

  //gets the current password stored in sharedpreferences.
  Future<String> get getPassword {
    return _sharedPreference.then((prefs) {
      return prefs.getString("password");
    });
  }

  //Theme

  //Sets the theme to a new value and stores in sharedpreferences
  Future<void> changeTheme(String value) {
    return _sharedPreference.then((prefs) {
      return prefs.setString("theme", value);
    });
  }

  //gets the current theme stored in sharedpreferences.
  //If no theme returns 'system'
  Future<String> get getCurrentTheme {
    return _sharedPreference.then((prefs) {
      String currentTheme = prefs.getString("theme") ?? 'system';
      return currentTheme;
    });
  }

  //Language

  //Sets the language to a new value and stores in sharedpreferences
  Future<void> changeLanguage(String value) {
    return _sharedPreference.then((prefs) {
      return prefs.setString("lang", value);
    });
  }

  //gets the current language stored in sharedpreferences.
  Future<String> get appCurrentLanguage {
    return _sharedPreference.then((prefs) {
      return prefs.getString("lang");
    });
  }
}
