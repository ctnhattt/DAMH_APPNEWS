import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FontTextProvider extends ChangeNotifier {
  String _selectedFont = 'Inter'; // Font mặc định là Inter
  double _fontSize = 16; // Kích thước chữ mặc định là 16
  final double _minFontSize = 14; // Giới hạn tối thiểu của kích thước chữ
  final double _maxFontSize = 30; // Giới hạn tối đa của kích thước chữ
  bool checkBookmark = false;
  String get selectedFont => _selectedFont;
  double get fontSize => _fontSize;

  late SharedPreferences _storage;

  void changeFont(String newFont) {
    _selectedFont = newFont;
    _storage.setString('selectedFont', newFont);
    notifyListeners();
  }

  void increaseFontSize() {
    if (_fontSize < _maxFontSize) {
      _fontSize += 2; // Tăng kích thước chữ lên 2 đơn vị
      if (_fontSize > _maxFontSize) {
        _fontSize =
            _maxFontSize; // Đảm bảo kích thước chữ không vượt quá giới hạn tối đa
      }
      _storage.setDouble('fontSize', _fontSize);
      notifyListeners();
    }
  }

  void decreaseFontSize() {
    if (_fontSize > _minFontSize) {
      _fontSize -=
          2; // Giảm kích thước chữ đi 2 đơn vị, nhưng không nhỏ hơn giới hạn tối thiểu
      if (_fontSize < _minFontSize) {
        _fontSize =
            _minFontSize; // Đảm bảo kích thước chữ không nhỏ hơn giới hạn tối thiểu
      }
      _storage.setDouble('fontSize', _fontSize);
      notifyListeners();
    }
  }

  Future<void> init() async {
    _storage = await SharedPreferences.getInstance();
    _selectedFont = _storage.getString('selectedFont') ?? 'Inter';
    _fontSize = _storage.getDouble('fontSize') ?? 16;
    notifyListeners();
  }
}
