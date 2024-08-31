import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;
  late SharedPreferences storage;

  final darkTheme = ThemeData(
    primaryColor: Colors.black,
    brightness: Brightness.dark,
    primaryColorDark: Colors.black,
  );
  final lightTheme = ThemeData(
    primaryColor: Colors.white,
    brightness: Brightness.light,
    primaryColorDark: Colors.white,
  );
  // void toggleTheme() {
  //   _isDarkMode = !_isDarkMode;
  //   notifyListeners();
  // }

  changeTheme() {
    _isDarkMode = !_isDarkMode;
    storage.setBool("isDarkMode", _isDarkMode);
    notifyListeners();
  }

  init() async {
    storage = await SharedPreferences.getInstance();
    _isDarkMode = storage.getBool("isDarkMode") ?? false;
    notifyListeners();
  }
}
