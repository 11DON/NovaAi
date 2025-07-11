import 'package:flutter/material.dart';

class NavigationProvider with ChangeNotifier {
  int _currnetIndex = 0;

  int get currnetIndex => _currnetIndex;

  void setIndex(int index) {
    _currnetIndex = index;
    notifyListeners();
  }
}
