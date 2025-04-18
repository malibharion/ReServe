import 'package:flutter/material.dart';

class ChnageColor with ChangeNotifier {
  int selectedIndex = 0;

  void changeColor(int index) {
    selectedIndex = index;
    notifyListeners();
  }
}
